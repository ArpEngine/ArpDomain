package arp.macro;

#if macro

import arp.macro.expr.ds.MacroArpFieldList;
import arp.macro.defs.MacroArpClassDefinition;
import arp.macro.stubs.MacroArpObjectSkeleton;
import haxe.macro.Expr;

class MacroArpTemplateBuilder {

	public function new() return;

	public function run(classDef:MacroArpClassDefinition):Array<Field> {
		if (classDef.arpTemplateName == null) return null;
		if (classDef.metaGen) return null;

		var macroObj:MacroArpObject = MacroArpObject.fromClassDef(classDef);
		MacroArpObjectRegistry.registerTemplateInfo(classDef.nativeFqn, macroObj);

		if (classDef.metaNoGen) return null;

		var outFields:MacroArpFieldList = MacroArpFieldList.empty();
		for (fieldDef in classDef.fieldDefs) outFields.add(fieldDef.nativeField);
		outFields.overwrite(new MacroArpObjectSkeleton(macroObj).genTemplateFields());

		return outFields.toArray();
	}
}

#end
