package arp.macro;

#if macro

import arp.macro.defs.MacroArpClassDefinition;
import arp.macro.expr.ds.MacroArpFieldArray;
import arp.macro.MacroArpFieldBuilder;
import arp.macro.stubs.MacroArpObjectSkeleton;
import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;

class MacroArpObjectBuilder extends MacroArpObjectSkeleton {

	public function new() super();

	public function run(classDef:MacroArpClassDefinition):Array<Field> {
		if (classDef.metaGen) return null;
		if (classDef.arpTemplateName == null) return null;

		var macroObj:MacroArpObject = MacroArpObject.fromClassDef(classDef);
		MacroArpObjectRegistry.registerObjectInfo(classDef.nativeFqn, macroObj);

		if (classDef.metaNoGen) return null;

		Compiler.addMetadata("@:arpGen", classDef.nativeFqn);

		var outFields:MacroArpFieldArray = MacroArpFieldArray.empty();

		for (fieldDef in classDef.fieldDefs) {
			switch (MacroArpFieldBuilder.fromDefinition(fieldDef)) {
				case MacroArpFieldBuilderResult.Unmanaged:
					outFields.add(fieldDef.nativeField);
					if (fieldDef.metaArpInit != null) {
						outFields.merge(this.genVoidCallbackField("arpSelfInit", fieldDef.metaArpInit));
					}
					if (fieldDef.metaArpLoadSeed != null) {
						outFields.merge(this.genSeedCallbackField("arpSelfLoadSeed", fieldDef.metaArpLoadSeed));
					}
					if (fieldDef.metaArpHeatUp != null) {
						outFields.merge(this.genBoolCallbackField("arpSelfHeatUp", fieldDef.metaArpHeatUp));
					}
					if (fieldDef.metaArpHeatDown != null) {
						outFields.merge(this.genBoolCallbackField("arpSelfHeatDown", fieldDef.metaArpHeatDown));
					}
					if (fieldDef.metaArpDispose != null) {
						outFields.merge(this.genVoidCallbackField("arpSelfDispose", fieldDef.metaArpDispose));
					}
				case MacroArpFieldBuilderResult.Impl(implTypePath, concreteTypePath):
					if (classDef.isDerived) {
						outFields.merge(this.genDerivedImplFields(concreteTypePath));
					} else {
						outFields.merge(this.genImplFields(implTypePath, concreteTypePath));
					}
					// TODO we also want the class to implement impl interface
					//throw "not implemented";
				case MacroArpFieldBuilderResult.ArpField(arpField):
					this.arpFields.push(arpField);
					arpField.buildField(outFields);
				case MacroArpFieldBuilderResult.Constructor(func):
					outFields.merge(this.genConstructorField(fieldDef.nativeField, func));
			}
		}
		if (classDef.metaHasImpl && !classDef.hasImpl) {
			Context.warning('Not supported in this backend', classDef.nativePos);
		}

		if (classDef.isDerived) {
			outFields.overwrite(this.genDerivedTypeFields());
		} else {
			outFields.overwrite(this.genTypeFields());
			outFields.merge(this.genDefaultTypeFields());
		}

		var mergedOutFields:Array<Field> = [];
		for (outField in outFields) {
			if (!classDef.mergedBaseFields.exists(outField.name)) {
				// statics not included in mergedBaseFields
				mergedOutFields.push(outField);
				continue;
			}
			switch (outField.kind) {
				case FieldType.FFun(_):
					var access:Array<Access> = outField.access;
					if (access.indexOf(Access.AOverride) < 0) access.push(Access.AOverride);
					mergedOutFields.push(outField);
				case _:
			}
		}

		return mergedOutFields;
	}
}

#end
