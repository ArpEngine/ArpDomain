package arp.macro;

#if macro

import arp.macro.expr.ds.MacroArpFieldArray;
import arp.macro.defs.MacroArpClassDefinition;
import arp.macro.stubs.MacroArpObjectSkeleton;
import haxe.macro.Expr;

class MacroArpTemplateBuilder extends MacroArpObjectSkeleton {

	public function new() super();

	public function run(classDef:MacroArpClassDefinition):Array<Field> {
		if (classDef.arpTemplateName == null) return null;

		var macroObj:MacroArpObject = MacroArpObject.fromClassDef(classDef);
		MacroArpObjectRegistry.registerTemplateInfo(classDef.nativeFqn, macroObj);

		var outFields:MacroArpFieldArray = MacroArpFieldArray.empty();
		for (fieldDef in classDef.fieldDefs) {
			outFields.push(fieldDef.nativeField);
		}

		return outFields;
	}
}

#end
