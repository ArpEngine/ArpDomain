package arp.macro.stubs;

#if macro

import arp.macro.defs.MacroArpClassDefinition;
import arp.macro.defs.MacroArpImplClassDefinition;
import haxe.macro.Expr;

class MacroArpObjectSkeleton {

	private var _template:MacroArpObject;
	private var template(get, null):MacroArpObject;
	private function get_template():MacroArpObject return if (_template != null) _template else _template = MacroArpObjectRegistry.getLocalMacroArpObject();

	private var classDef(get, never):MacroArpClassDefinition;
	private function get_classDef():MacroArpClassDefinition return template.classDef;

	public function new() return;

	private function newArpTypeInfo():Expr {
		return macro new arp.domain.ArpTypeInfo(
			$v{this.classDef.arpTemplateName},
			new arp.domain.core.ArpType($v{this.classDef.arpTypeName}),
			$v{this.classDef.metaArpOverwrite}
		);
	}

	public function genTypeFields():Array<Field> {
		return (macro class Generated {
			@:noDoc @:noCompletion private var _arpDomain:arp.domain.ArpDomain;
			public var arpDomain(get, never):arp.domain.ArpDomain;
			@:noDoc @:noCompletion private function get_arpDomain():arp.domain.ArpDomain return this._arpDomain;

			public static var _arpTypeInfo(default, never):arp.domain.ArpTypeInfo = $e{ newArpTypeInfo() };
			public var arpTypeInfo(get, never):arp.domain.ArpTypeInfo;
			@:noDoc @:noCompletion private function get_arpTypeInfo():arp.domain.ArpTypeInfo return _arpTypeInfo;
			public var arpType(get, never):arp.domain.core.ArpType;
			@:noDoc @:noCompletion private function get_arpType():arp.domain.core.ArpType return _arpTypeInfo.arpType;

			@:noDoc @:noCompletion private var _arpSlot:arp.domain.ArpUntypedSlot;
			public var arpSlot(get, never):arp.domain.ArpUntypedSlot;
			@:noDoc @:noCompletion private function get_arpSlot():arp.domain.ArpUntypedSlot return this._arpSlot;

			public var arpHeat(get, never):arp.domain.ArpHeat;
			@:noDoc @:noCompletion private function get_arpHeat():arp.domain.ArpHeat return this._arpSlot.heat;

			@:noDoc @:noCompletion
			public function __arp_init(slot:arp.domain.ArpUntypedSlot):arp.domain.IArpObject {
				arp.macro.stubs.MacroArpObjectStubs.arpInit(
					$v{ this.classDef.hasImpl }
				);
			}

			@:noDoc @:noCompletion
			public function __arp_loadSeed(seed:arp.seed.ArpSeed):Void {
				var autoKeyGen:arp.utils.ArpIdGenerator = new arp.utils.ArpIdGenerator();
				for (element in seed) this.arpConsumeSeedElement(element, autoKeyGen.next());
				this.arpSelfLoadSeed(seed);
			}

			@:noDoc @:noCompletion
			public function __arp_heatLaterDeps():Void {
				arp.macro.stubs.MacroArpObjectStubs.arpHeatLaterDeps();
			}

			public function arpHeatUpNow():Bool {
				arp.macro.stubs.MacroArpObjectStubs.arpHeatUpNow(
					$v{ this.classDef.hasImpl }
				);
			}

			public function arpHeatDownNow():Bool {
				arp.macro.stubs.MacroArpObjectStubs.arpHeatDownNow(
					$v{ this.classDef.hasImpl }
				);
			}

			inline public function arpHeatLater(nonblocking:Bool = false):Bool return this._arpDomain.heatLater(this._arpSlot, nonblocking);

			@:noDoc @:noCompletion
			public function __arp_dispose():Void {
				arp.macro.stubs.MacroArpObjectStubs.arpDispose(
					$v{ this.classDef.hasImpl }
				);
			}

			@:noDoc @:noCompletion
			private function arpConsumeSeedElement(element:arp.seed.ArpSeed, autoKey:String):Void {
				arp.macro.stubs.MacroArpObjectStubs.arpConsumeSeedElement();
			}

			public function readSelf(input:arp.persistable.IPersistInput):Void {
				arp.macro.stubs.MacroArpObjectStubs.readSelf();
			}

			public function writeSelf(output:arp.persistable.IPersistOutput):Void {
				arp.macro.stubs.MacroArpObjectStubs.writeSelf();
			}

			@:access(arp.domain.ArpDomain)
			public function arpClone(cloneMapper:arp.domain.IArpCloneMapper = null):arp.domain.IArpObject {
				arp.macro.stubs.MacroArpObjectStubs.arpClone();
			}

			public function arpCopyFrom(source:arp.domain.IArpObject, cloneMapper:arp.domain.IArpCloneMapper = null):arp.domain.IArpObject {
				arp.macro.stubs.MacroArpObjectStubs.arpCopyFrom();
			}
		}).fields;
	}

	public function genDerivedTypeFields():Array<Field> {
		return (macro class Generated {
			public static var _arpTypeInfo(default, never):arp.domain.ArpTypeInfo = $e{ newArpTypeInfo() };
			override private function get_arpTypeInfo():arp.domain.ArpTypeInfo return _arpTypeInfo;
			@:noDoc @:noCompletion override private function get_arpType():arp.domain.core.ArpType return _arpTypeInfo.arpType;

			@:noDoc @:noCompletion
			override public function __arp_init(slot:arp.domain.ArpUntypedSlot):arp.domain.IArpObject {
				arp.macro.stubs.MacroArpDerivedObjectStubs.arpInit();
			}

			@:noDoc @:noCompletion
			override public function __arp_heatLaterDeps():Void {
				arp.macro.stubs.MacroArpDerivedObjectStubs.arpHeatLaterDeps();
			}

			override public function arpHeatUpNow():Bool {
				arp.macro.stubs.MacroArpDerivedObjectStubs.arpHeatUpNow();
			}

			override public function arpHeatDownNow():Bool {
				arp.macro.stubs.MacroArpDerivedObjectStubs.arpHeatDownNow();
			}

			@:noDoc @:noCompletion
			override public function __arp_dispose():Void {
				arp.macro.stubs.MacroArpDerivedObjectStubs.arpDispose();
			}

			@:noDoc @:noCompletion
			override private function arpConsumeSeedElement(element:arp.seed.ArpSeed, autoKey:String):Void {
				arp.macro.stubs.MacroArpDerivedObjectStubs.arpConsumeSeedElement();
			}

			override public function readSelf(input:arp.persistable.IPersistInput):Void {
				arp.macro.stubs.MacroArpDerivedObjectStubs.readSelf();
			}

			override public function writeSelf(output:arp.persistable.IPersistOutput):Void {
				arp.macro.stubs.MacroArpDerivedObjectStubs.writeSelf();
			}

			@:access(arp.domain.ArpDomain)
			override public function arpClone(cloneMapper:arp.domain.IArpCloneMapper = null):arp.domain.IArpObject {
				arp.macro.stubs.MacroArpDerivedObjectStubs.arpClone();
			}

			override public function arpCopyFrom(source:arp.domain.IArpObject, cloneMapper:arp.domain.IArpCloneMapper = null):arp.domain.IArpObject {
				arp.macro.stubs.MacroArpDerivedObjectStubs.arpCopyFrom();
			}
		}).fields;
	}

	public function genDefaultTypeFields():Array<Field> {
		return (macro class Generated {
			@:noDoc @:noCompletion private function arpSelfInit():Void return;
			@:noDoc @:noCompletion private function arpSelfLoadSeed(seed:arp.seed.ArpSeed = null):Void return;
			@:noDoc @:noCompletion private function arpSelfHeatUp():Bool return true;
			@:noDoc @:noCompletion private function arpSelfHeatDown():Bool return true;
			@:noDoc @:noCompletion private function arpSelfDispose():Void return;
		}).fields;
	}

	public function genVoidCallbackField(fun:String, callback:String):Array<Field> {
		return (macro class Generated {
			@:noDoc @:noCompletion
			private function $fun():Void {
				this.$callback();
			}
		}).fields;
	}

	public function genBoolCallbackField(fun:String, callback:String):Array<Field> {
		return (macro class Generated {
			@:noDoc @:noCompletion
			private function $fun():Bool {
				return this.$callback();
			}
		}).fields;
	}

	public function genSeedCallbackField(fun:String, callback:String):Array<Field> {
		return (macro class Generated {
			@:noDoc @:noCompletion
			private function $fun(seed:arp.seed.ArpSeed = null):Void {
				this.$callback(seed);
			}
		}).fields;
	}

	public function genImplFields(implTypePath:TypePath, concreteTypePath:TypePath):Array<Field> {
		var implType:ComplexType = ComplexType.TPath(implTypePath);
		var implClassDef:MacroArpImplClassDefinition = new MacroArpImplClassDefinition(implType);
		var concreteType:ComplexType = ComplexType.TPath(concreteTypePath);
		var concreteClassDef:MacroArpImplClassDefinition = new MacroArpImplClassDefinition(concreteType);

		// generate arpImpl
		var fields:Array<Field> = (macro class Generated {
			@:noDoc @:noCompletion
			private var arpImpl:$implType;

			@:noDoc @:noCompletion
			private function createImpl():$implType return ${
				if (concreteClassDef.isInterface) {
					// can not instantiate interfaces
					macro null;
				} else {
					// can instantiate
					macro new $concreteTypePath(this);
				}
			};
		}).fields;

		// and populate delegate methods
		fields = fields.concat(implClassDef.fields);
		return fields;
	}

	public function genDerivedImplFields(concreteTypePath:TypePath):Array<Field> {
		var implType = ComplexType.TPath(concreteTypePath);
		var concreteType:ComplexType = ComplexType.TPath(concreteTypePath);
		var concreteClassDef:MacroArpImplClassDefinition = new MacroArpImplClassDefinition(concreteType);
		return (macro class Generated {
			@:noDoc @:noCompletion
			override private function createImpl() return ${
				if (concreteClassDef.isInterface) {
					// in case of unsupported backend for target platform
					macro null;
				} else {
					// can instantiate
					macro new $concreteTypePath(this);
				}
			};
		}).fields;
	}

	private function prependFunctionBody(nativeField:Field, expr:Expr):Field {
		var nativeFunc:Function;
		switch (nativeField.kind) {
			case FieldType.FFun(func):
				nativeFunc = func;
			case _:
				MacroArpUtil.error("Internal error: field is not a function", nativeField.pos);
		}
		return {
			name: nativeField.name,
			doc: nativeField.doc,
			access: nativeField.access,
			kind: FieldType.FFun({
				args:nativeFunc.args,
				ret:nativeFunc.ret,
				expr: macro @:mergeBlock {
					${expr}
					${nativeFunc.expr}
				},
				params: nativeFunc.params
			}),
			pos: nativeField.pos,
			meta:nativeField.meta
		};
	}

	public function genConstructorField(nativeField:Field, nativeFunc:Function):Array<Field> {
		return [nativeField];
	}

}

#end
