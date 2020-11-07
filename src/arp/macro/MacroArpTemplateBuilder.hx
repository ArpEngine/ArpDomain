package arp.macro;

#if macro

import arp.macro.defs.MacroArpClassDefinition;
import arp.macro.stubs.MacroArpObjectSkeleton;
import haxe.macro.Expr;

class MacroArpTemplateBuilder extends MacroArpObjectSkeleton {

	public function new() super();

	// FIXME: refactor MacroArpObjectBuilder
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
		if (classDef.arpTemplateName == null) return null;

		var macroObj:MacroArpObject = MacroArpObject.fromClassDef(classDef);
		MacroArpObjectRegistry.registerTemplateInfo(classDef.nativeFqn, macroObj);

		var outFields:Array<Field> = [];
		for (fieldDef in classDef.fieldDefs) {
			outFields.push(fieldDef.nativeField);
		}

		return outFields;
	}
}

#end
