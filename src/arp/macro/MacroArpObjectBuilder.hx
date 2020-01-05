package arp.macro;

#if macro

import arp.domain.core.ArpType;
import arp.domain.reflect.ArpClassInfo;
import arp.macro.defs.MacroArpClassDefinition;
import arp.macro.stubs.MacroArpObjectSkeleton;
import arp.macro.MacroArpFieldBuilder;
import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;

class MacroArpObjectBuilder extends MacroArpObjectSkeleton {

	public function new() super();

	private function merge(target:Array<Field>, source:Array<Field>):Array<Field> {
		for (field in source) {
			var hasField:Bool = false;
			for (t in target) {
				if (field.name == t.name) hasField = true;
			}
			if (!hasField) target.push(field);
		}
		return target;
	}

	public function run(classDef:MacroArpClassDefinition):Array<Field> {
		if (classDef.metaGen) return null;
		if (classDef.arpTemplateName == null) return null;

		var fqn:String = MacroArpUtil.getFqnOfType(Context.getLocalType());

		var templateInfo:ArpClassInfo = ArpClassInfo.reference(new ArpType(classDef.arpTypeName), classDef.arpTemplateName, fqn, [], classDef.nativeDoc);
		MacroArpObjectRegistry.registerTemplateInfo(fqn, new MacroArpObject(classDef, templateInfo));

		if (classDef.metaNoGen) return null;

		Compiler.addMetadata("@:arpGen", templateInfo.fqn);

		var outFields:Array<Field> = [];

		for (fieldDef in classDef.fieldDefs) {
			switch (MacroArpFieldBuilder.fromDefinition(fieldDef)) {
				case MacroArpFieldBuilderResult.Unmanaged:
					outFields.push(fieldDef.nativeField);
					if (fieldDef.metaArpInit != null) {
						outFields = outFields.concat(this.genVoidCallbackField("arpSelfInit", fieldDef.metaArpInit));
					}
					if (fieldDef.metaArpLoadSeed != null) {
						outFields = outFields.concat(this.genSeedCallbackField("arpSelfLoadSeed", fieldDef.metaArpLoadSeed));
					}
					if (fieldDef.metaArpHeatUp != null) {
						outFields = outFields.concat(this.genBoolCallbackField("arpSelfHeatUp", fieldDef.metaArpHeatUp));
					}
					if (fieldDef.metaArpHeatDown != null) {
						outFields = outFields.concat(this.genBoolCallbackField("arpSelfHeatDown", fieldDef.metaArpHeatDown));
					}
					if (fieldDef.metaArpDispose != null) {
						outFields = outFields.concat(this.genVoidCallbackField("arpSelfDispose", fieldDef.metaArpDispose));
					}
				case MacroArpFieldBuilderResult.Impl(implTypePath, concreteTypePath):
					if (classDef.isDerived) {
						outFields = outFields.concat(this.genDerivedImplFields(concreteTypePath));
					} else {
						outFields = outFields.concat(this.genImplFields(implTypePath, concreteTypePath));
					}
					// TODO we also want the class to implement impl interface
					//throw "not implemented";
				case MacroArpFieldBuilderResult.ArpField(arpField):
					this.arpFields.push(arpField);
					arpField.buildField(outFields);
				case MacroArpFieldBuilderResult.Constructor(func):
					outFields = outFields.concat(this.genConstructorField(fieldDef.nativeField, func));
			}
		}
		if (classDef.metaHasImpl && !classDef.hasImpl) {
			Context.warning('Not supported in this backend', classDef.nativePos);
		}

		if (classDef.isDerived) {
			outFields = merge(this.genDerivedTypeFields(), outFields);
		} else {
			outFields = merge(this.genTypeFields(), outFields);
			outFields = merge(outFields, this.genDefaultTypeFields());
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
