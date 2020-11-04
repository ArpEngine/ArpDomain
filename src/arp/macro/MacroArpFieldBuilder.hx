package arp.macro;

#if macro

import haxe.macro.MacroStringTools;
import arp.domain.reflect.ArpClassInfo;
import arp.domain.reflect.ArpFieldKind;
import arp.macro.defs.MacroArpFieldDefinition;
import arp.macro.defs.MacroArpFieldDefinitionFamily;
import arp.macro.fields.ds.MacroArpObjectListField;
import arp.macro.fields.ds.MacroArpObjectMapField;
import arp.macro.fields.ds.MacroArpObjectOmapField;
import arp.macro.fields.ds.MacroArpObjectSetField;
import arp.macro.fields.ds.MacroArpValueListField;
import arp.macro.fields.ds.MacroArpValueMapField;
import arp.macro.fields.ds.MacroArpValueOmapField;
import arp.macro.fields.ds.MacroArpValueSetField;
import arp.macro.fields.MacroArpObjectField;
import arp.macro.fields.MacroArpValueField;
import arp.macro.fields.std.MacroArpObjectStdMapField;
import arp.macro.fields.std.MacroArpValueStdArrayField;
import arp.macro.fields.std.MacroArpValueStdListField;
import arp.macro.fields.std.MacroArpValueStdMapField;
import arp.macro.valueTypes.MacroArpPrimBoolType;
import arp.macro.valueTypes.MacroArpPrimFloatType;
import arp.macro.valueTypes.MacroArpPrimIntType;
import arp.macro.valueTypes.MacroArpPrimStringType;
import arp.macro.valueTypes.MacroArpStructType;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Printer;
import haxe.macro.Type;
import haxe.macro.TypeTools;

using haxe.macro.ComplexTypeTools;

class MacroArpFieldBuilder {

	private var fieldDef:MacroArpFieldDefinition;

	private var pos(get, never):Position;
	inline private function get_pos():Position return this.fieldDef.nativePos;

	private function new(fieldDef:MacroArpFieldDefinition) {
		this.fieldDef = fieldDef;
	}

	private function typePathParam(typePath:TypePath, index:Int = 0):ComplexType {
		try {
			if (typePath.params == null) throw "invalid type";
			var param:TypeParam = typePath.params[index];
			if (param == null) throw "invalid type";
			switch (param) {
				case TypeParam.TPType(tp):
					return tp;
				case _:
					throw "invalid type";
			}
		} catch (e:String) {
			return MacroArpUtil.fatal("invalid type " + new Printer().printTypePath(typePath), this.pos);
		}
	}

	private function typeParam(type:Type, index:Int = 0):Type {
		// TODO handle generic classes?
		try {
			switch (type) {
				case
					Type.TEnum(_, params),
					Type.TInst(_, params),
					Type.TType(_, params),
					Type.TAbstract(_, params):
					if (params.length <= index) {
						throw "invalid type";
					}
					return params[index];
				case _:
					throw "invalid type";
			}
		} catch (e:String) {
			return MacroArpUtil.fatal("invalid type " + new Printer().printComplexType(TypeTools.toComplexType(type)), this.pos);
		}
	}

	private function baseFqnToNativeFieldType(fqn:String, type:Type, isImpl:Bool):Null<MacroArpNativeFieldType> {
		this.log("fqn=" + fqn);
		switch (fqn) {
			case "Array":
				return MacroArpNativeFieldType.NativeStdArray(typeToNativeFieldType(typeParam(type)));
			case "List":
				return MacroArpNativeFieldType.NativeStdList(typeToNativeFieldType(typeParam(type)));
			case "haxe.IMap", "haxe.Constraints.IMap":
				return MacroArpNativeFieldType.NativeStdMap(typeToNativeFieldType(typeParam(type, 1)), isImpl);
			case "arp.ds.ISet":
				return MacroArpNativeFieldType.NativeDsISet(typeToNativeFieldType(typeParam(type)), isImpl);
			case "arp.ds.IList":
				return MacroArpNativeFieldType.NativeDsIList(typeToNativeFieldType(typeParam(type)), isImpl);
			case "arp.ds.IMap":
				return MacroArpNativeFieldType.NativeDsIMap(typeToNativeFieldType(typeParam(type, 1)), isImpl);
			case "arp.ds.IOmap":
				return MacroArpNativeFieldType.NativeDsIOmap(typeToNativeFieldType(typeParam(type, 1)), isImpl);
			case _:
				var classInfo:ArpClassInfo = MacroArpObjectRegistry.getClassInfo(fqn);
				if (classInfo == null) return null;
				switch (classInfo.fieldKind) {
					case ArpFieldKind.PrimInt:
						return MacroArpNativeFieldType.NativeValueType(new MacroArpPrimIntType());
					case ArpFieldKind.PrimFloat:
						return MacroArpNativeFieldType.NativeValueType(new MacroArpPrimFloatType());
					case ArpFieldKind.PrimBool:
						return MacroArpNativeFieldType.NativeValueType(new MacroArpPrimBoolType());
					case ArpFieldKind.PrimString:
						return MacroArpNativeFieldType.NativeValueType(new MacroArpPrimStringType());
					case ArpFieldKind.StructKind:
						return MacroArpNativeFieldType.NativeValueType(new MacroArpStructType(TypeTools.toComplexType(type), fieldDef.nativePos));
					case ArpFieldKind.ReferenceKind:
						return MacroArpNativeFieldType.NativeReferenceType(TypeTools.toComplexType(type));
				}
		}
	}

	private function baseTypeToNativeFieldType(type:Type, baseType:Type):Null<MacroArpNativeFieldType> {
		var result:MacroArpNativeFieldType = null;
		var fqn:String;
		switch (baseType) {
			case Type.TInst(classRef, params):
				var classType:ClassType = classRef.get();
				fqn = MacroArpUtil.getFqnOfBaseType(classType);
				result = baseFqnToNativeFieldType(fqn, type, !classType.isInterface);
				if (result != null) return result;
				// follow super class and interfaces
				if (classType.superClass != null) {
					var superClassType:Type = Type.TInst(classType.superClass.t, classType.superClass.params);
					this.log("extends=" + Std.string(superClassType));
					result = baseTypeToNativeFieldType(type, superClassType);
					if (result != null) return result;
				}
				for (intf in classType.interfaces) {
					var interfaceType:Type = Type.TInst(intf.t, intf.params);
					this.log("implements=" + Std.string(interfaceType));
					result = baseTypeToNativeFieldType(type, interfaceType);
					if (result != null) return result;
				}
			case Type.TAbstract(abstractRef, params):
				var abstractType:AbstractType = abstractRef.get();
				fqn = MacroArpUtil.getFqnOfBaseType(abstractType);
				result = baseFqnToNativeFieldType(fqn, type, true);
				if (result != null) return result;
				// follow underlying type
				this.log("underlying=" + Std.string(abstractType.type));
				result = baseTypeToNativeFieldType(type, abstractType.type);
				if (result != null) return result;
			case Type.TType(defTypeRef, params):
				var defType:DefType = defTypeRef.get();
				// follow underlying type
				this.log("resolve=" + Std.string(defType.type));
				result = baseTypeToNativeFieldType(type, defType.type);
				if (result != null) return result;
			case _:
		}
		return null;
	}

	private function typeToNativeFieldType(type:Type):MacroArpNativeFieldType {
		this.log("Type=" + Std.string(type));
		var result = baseTypeToNativeFieldType(type, type);
		if (result != null) return result;
		return MacroArpNativeFieldType.NativeInvalid;
	}

	private function complexTypeToNativeFieldType(complexType:ComplexType):MacroArpNativeFieldType {
#if arp_macro_debug
		Sys.stdout().writeString(this.fieldDef.nativeName + " : " + new Printer().printComplexType(complexType) + " @@@ " + '${Context.getLocalModule()}' + "\n");
		Sys.stdout().flush();
#end

		// hard code well-known ComplexTypes to avoid Context.resolveType() issue in Haxe 3.4
		// https://github.com/HaxeFoundation/haxe/issues/5918
		switch (complexType) {
			case ComplexType.TPath(typePath):
				var fqnStr:String = MacroArpUtil.getFqnOfTypePath(typePath);
				switch (fqnStr) {
					case "Array":
						return MacroArpNativeFieldType.NativeStdArray(complexTypeToNativeFieldType(typePathParam(typePath)));
					case "List":
						return MacroArpNativeFieldType.NativeStdList(complexTypeToNativeFieldType(typePathParam(typePath)));
					case "haxe.IMap", "haxe.Constraints.IMap":
						return MacroArpNativeFieldType.NativeStdMap(complexTypeToNativeFieldType(typePathParam(typePath, 1)), false);
					case "arp.ds.ISet", "ISet":
						return MacroArpNativeFieldType.NativeDsISet(complexTypeToNativeFieldType(typePathParam(typePath, 0)), false);
					case "arp.ds.IList", "IList":
						return MacroArpNativeFieldType.NativeDsIList(complexTypeToNativeFieldType(typePathParam(typePath, 0)), false);
					case "arp.ds.IMap", "IMap":
						return MacroArpNativeFieldType.NativeDsIMap(complexTypeToNativeFieldType(typePathParam(typePath, 1)), false);
					case "arp.ds.IOmap", "IOmap":
						return MacroArpNativeFieldType.NativeDsIOmap(complexTypeToNativeFieldType(typePathParam(typePath, 1)), false);
					case _:
						var classInfo:ArpClassInfo = MacroArpObjectRegistry.getClassInfo(fqnStr);
						if (classInfo != null) {
							switch (classInfo.fieldKind) {
								case ArpFieldKind.PrimInt:
									return MacroArpNativeFieldType.NativeValueType(new MacroArpPrimIntType());
								case ArpFieldKind.PrimFloat:
									return MacroArpNativeFieldType.NativeValueType(new MacroArpPrimFloatType());
								case ArpFieldKind.PrimBool:
									return MacroArpNativeFieldType.NativeValueType(new MacroArpPrimBoolType());
								case ArpFieldKind.PrimString:
									return MacroArpNativeFieldType.NativeValueType(new MacroArpPrimStringType());
								case ArpFieldKind.StructKind:
									return MacroArpNativeFieldType.NativeValueType(new MacroArpStructType(complexType, fieldDef.nativePos));
								case ArpFieldKind.ReferenceKind:
									return MacroArpNativeFieldType.NativeReferenceType(complexType);
							}
						}
				}
			case _:
		}

		// we have to follow types in typed universe
		var type:Type = Context.resolveType(complexType, this.pos);
		return typeToNativeFieldType(type);
	}

	private function doRun():IMacroArpField {
		this.log("ComplexType=" + new Printer().printComplexType(this.fieldDef.nativeType));

		var complexType:ComplexType = this.fieldDef.nativeType;

		var nativeFieldType:MacroArpNativeFieldType = MacroArpNativeFieldType.NativeInvalid;
		if (complexType != null) nativeFieldType = complexTypeToNativeFieldType(complexType);

		this.log("NativeType=" + Std.string(nativeFieldType));

		switch (nativeFieldType) {
			case MacroArpNativeFieldType.NativeValueType(p):
				if (this.fieldDef.arpFieldIsForValue()) {
					return new MacroArpValueField(this.fieldDef, p);
				}
			case MacroArpNativeFieldType.NativeReferenceType(p):
				if (this.fieldDef.arpFieldIsForReference()) {
					return new MacroArpObjectField(this.fieldDef);
				}
			case MacroArpNativeFieldType.NativeStdArray(MacroArpNativeFieldType.NativeValueType(p)):
				if (this.fieldDef.arpFieldIsForValue()) {
					return new MacroArpValueStdArrayField(this.fieldDef, p);
				}
			case MacroArpNativeFieldType.NativeStdList(MacroArpNativeFieldType.NativeValueType(p)):
				if (this.fieldDef.arpFieldIsForValue()) {
					return new MacroArpValueStdListField(this.fieldDef, p);
				}
			case MacroArpNativeFieldType.NativeStdMap(MacroArpNativeFieldType.NativeValueType(p), isImpl):
				if (this.fieldDef.arpFieldIsForValue()) {
					return new MacroArpValueStdMapField(this.fieldDef, p, isImpl);
				}
			case MacroArpNativeFieldType.NativeStdMap(MacroArpNativeFieldType.NativeReferenceType(p), isImpl):
				if (this.fieldDef.arpFieldIsForReference()) {
					return new MacroArpObjectStdMapField(this.fieldDef, p, isImpl);
				}
			case MacroArpNativeFieldType.NativeDsISet(MacroArpNativeFieldType.NativeValueType(p), isImpl):
				if (this.fieldDef.arpFieldIsForValue()) {
					return new MacroArpValueSetField(this.fieldDef, p, isImpl);
				}
			case MacroArpNativeFieldType.NativeDsISet(MacroArpNativeFieldType.NativeReferenceType(p), isImpl):
				if (this.fieldDef.arpFieldIsForReference()) {
					return new MacroArpObjectSetField(this.fieldDef, p, isImpl);
				}
			case MacroArpNativeFieldType.NativeDsIList(MacroArpNativeFieldType.NativeValueType(p), isImpl):
				if (this.fieldDef.arpFieldIsForValue()) {
					return new MacroArpValueListField(this.fieldDef, p, isImpl);
				}
			case MacroArpNativeFieldType.NativeDsIList(MacroArpNativeFieldType.NativeReferenceType(p), isImpl):
				if (this.fieldDef.arpFieldIsForReference()) {
					return new MacroArpObjectListField(this.fieldDef, p, isImpl);
				}
			case MacroArpNativeFieldType.NativeDsIMap(MacroArpNativeFieldType.NativeValueType(p), isImpl):
				if (this.fieldDef.arpFieldIsForValue()) {
					return new MacroArpValueMapField(this.fieldDef, p, isImpl);
				}
			case MacroArpNativeFieldType.NativeDsIMap(MacroArpNativeFieldType.NativeReferenceType(p), isImpl):
				if (this.fieldDef.arpFieldIsForReference()) {
					return new MacroArpObjectMapField(this.fieldDef, p, isImpl);
				}
			case MacroArpNativeFieldType.NativeDsIOmap(MacroArpNativeFieldType.NativeValueType(p), isImpl):
				if (this.fieldDef.arpFieldIsForValue()) {
					return new MacroArpValueOmapField(this.fieldDef, p, isImpl);
				}
			case MacroArpNativeFieldType.NativeDsIOmap(MacroArpNativeFieldType.NativeReferenceType(p), isImpl):
				if (this.fieldDef.arpFieldIsForReference()) {
					return new MacroArpObjectOmapField(this.fieldDef, p, isImpl);
				}
			case MacroArpNativeFieldType.NativeInvalid:
			case _:
		}
		Context.error("field type too complex: " + complexType.toString(), this.pos);
		return null;
	}

	private function run():MacroArpFieldBuilderResult {
		this.log("field: " + fieldDef.nativeName);
		switch (fieldDef.family) {
			case MacroArpFieldDefinitionFamily.Impl(typePath):
				this.log("done: " + fieldDef.nativeName);
				return MacroArpFieldBuilderResult.Impl(typePath, typePath);
			case MacroArpFieldDefinitionFamily.Impl2(implTypePath, concreteTypePath):
				this.log("done: " + fieldDef.nativeName);
				return MacroArpFieldBuilderResult.Impl(implTypePath, concreteTypePath);
			case MacroArpFieldDefinitionFamily.ImplicitUnmanaged, MacroArpFieldDefinitionFamily.Unmanaged:
				this.log("done: " + fieldDef.nativeName);
				return MacroArpFieldBuilderResult.Unmanaged;
			case MacroArpFieldDefinitionFamily.ArpField:
				var result = doRun();
				this.log("done: " + fieldDef.nativeName);
				return MacroArpFieldBuilderResult.ArpField(result);
			case MacroArpFieldDefinitionFamily.Constructor(func):
				return MacroArpFieldBuilderResult.Constructor(func);
		}
	}

	public static function fromDefinition(fieldDef:MacroArpFieldDefinition):MacroArpFieldBuilderResult {
		return new MacroArpFieldBuilder(fieldDef).run();
	}

	inline private function log(message:String):Void {
		#if arp_macro_verbose
		Context.warning(message, this.pos);
		#end
	}
}

enum MacroArpFieldBuilderResult {
	Unmanaged;
	Impl(implTypePath:TypePath, concreteTypePath:TypePath);
	ArpField(value:IMacroArpField);
	Constructor(func:Function);
}

private enum MacroArpNativeFieldType {
	NativeInvalid;
	NativeValueType(type:IMacroArpValueType);
	NativeReferenceType(contentNativeType:ComplexType);
	NativeStdArray(param:MacroArpNativeFieldType);
	NativeStdList(param:MacroArpNativeFieldType);
	NativeStdMap(param:MacroArpNativeFieldType, isImpl:Bool);
	NativeDsISet(param:MacroArpNativeFieldType, isImpl:Bool);
	NativeDsIList(param:MacroArpNativeFieldType, isImpl:Bool);
	NativeDsIMap(param:MacroArpNativeFieldType, isImpl:Bool);
	NativeDsIOmap(param:MacroArpNativeFieldType, isImpl:Bool);
}

#end
