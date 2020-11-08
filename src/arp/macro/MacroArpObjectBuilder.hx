package arp.macro;

#if macro

import arp.macro.defs.MacroArpClassDefinition;
import arp.macro.expr.ds.MacroArpFieldList;
import arp.macro.MacroArpFieldBuilder;
import arp.macro.stubs.MacroArpObjectSkeleton;
import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;

class MacroArpObjectBuilder {

	private var skeleton:MacroArpObjectSkeleton;

	public function new() skeleton = new MacroArpObjectSkeleton();

	public function run(classDef:MacroArpClassDefinition):Array<Field> {
		if (classDef.metaGen) return null;
		if (classDef.arpTemplateName == null) return null;

		var macroObj:MacroArpObject = MacroArpObject.fromClassDef(classDef);
		MacroArpObjectRegistry.registerObjectInfo(classDef.nativeFqn, macroObj);

		if (classDef.metaNoGen) return null;

		Compiler.addMetadata("@:arpGen", classDef.nativeFqn);

		var outFields:MacroArpFieldList = MacroArpFieldList.empty();

		for (fieldDef in classDef.fieldDefs) {
			switch (MacroArpFieldBuilder.fromDefinition(fieldDef)) {
				case MacroArpFieldBuilderResult.Unmanaged:
					outFields.add(fieldDef.nativeField);
					if (fieldDef.metaArpInit != null) {
						outFields.merge(skeleton.genVoidCallbackField("arpSelfInit", fieldDef.metaArpInit));
					}
					if (fieldDef.metaArpLoadSeed != null) {
						outFields.merge(skeleton.genSeedCallbackField("arpSelfLoadSeed", fieldDef.metaArpLoadSeed));
					}
					if (fieldDef.metaArpHeatUp != null) {
						outFields.merge(skeleton.genBoolCallbackField("arpSelfHeatUp", fieldDef.metaArpHeatUp));
					}
					if (fieldDef.metaArpHeatDown != null) {
						outFields.merge(skeleton.genBoolCallbackField("arpSelfHeatDown", fieldDef.metaArpHeatDown));
					}
					if (fieldDef.metaArpDispose != null) {
						outFields.merge(skeleton.genVoidCallbackField("arpSelfDispose", fieldDef.metaArpDispose));
					}
				case MacroArpFieldBuilderResult.Impl(implTypePath, concreteTypePath):
					if (classDef.isDerived) {
						outFields.merge(skeleton.genDerivedImplFields(concreteTypePath));
					} else {
						outFields.merge(skeleton.genImplFields(implTypePath, concreteTypePath));
					}
					// TODO we also want the class to implement impl interface
					//throw "not implemented";
				case MacroArpFieldBuilderResult.ArpField(arpField):
					macroObj.arpFields.push(arpField);
					arpField.buildField(outFields);
				case MacroArpFieldBuilderResult.Constructor(func):
					outFields.merge(skeleton.genConstructorField(fieldDef.nativeField, func));
			}
		}
		if (classDef.metaHasImpl && !classDef.hasImpl) {
			Context.warning('Not supported in this backend', classDef.nativePos);
		}

		if (classDef.isDerived) {
			outFields.overwrite(skeleton.genDerivedTypeFields());
		} else {
			outFields.overwrite(skeleton.genTypeFields());
			outFields.merge(skeleton.genDefaultTypeFields());
		}

		outFields.markOverrides(classDef);
		return outFields.toArray();
	}
}

#end
