package arp;

#if macro

import arp.macro.defs.MacroArpStructDefinition;
import arp.macro.defs.MacroArpClassDefinition;
import arp.macro.MacroArpObjectBuilder;
import arp.macro.MacroArpObjectRegistry;
import arp.macro.MacroArpUtil;
import haxe.macro.Expr.Field;
import haxe.macro.Type.ClassType;

class ArpDomainMacros {

	public static function autoBuildObject():Array<Field> {
		var localClass:ClassType = MacroArpUtil.getLocalClass();
		if (localClass == null) return null;

		var classDef:MacroArpClassDefinition = new MacroArpClassDefinition(localClass);
		var builder:MacroArpObjectBuilder = new MacroArpObjectBuilder();
#if arp_macro_debug
		var arpTypeName:String = classDef.arpTypeName;
		var arpTemplateName:String = classDef.arpTemplateName;
		Sys.stdout().writeString(" ***** " + arpTypeName + ":" + arpTemplateName + " started\n");
		Sys.stdout().flush();
#end
		var fields = builder.run(classDef);
#if arp_macro_debug
		Sys.stdout().writeString(" ***** " + arpTypeName + ":" + arpTemplateName + " completed\n");
		Sys.stdout().flush();
#end
		return fields;
	}

	public static function autoBuildStruct():Array<Field> {
		var localClass:ClassType = MacroArpUtil.getLocalClass();
		if (localClass == null) return null;

		var structDef:MacroArpStructDefinition = new MacroArpStructDefinition(localClass);

		MacroArpObjectRegistry.registerStructInfo(
			structDef.arpTypeName,
			MacroArpUtil.getFqnOfBaseType(localClass),
			structDef.nativeDoc,
			structDef.metaArpStructStringPlaceholder,
			structDef.metaArpStructSeedPlaceholder
		);
		return null;
	}
}

#end
