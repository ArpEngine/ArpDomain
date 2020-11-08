package arp;

#if macro

import arp.macro.defs.MacroArpClassDefinition;
import arp.macro.defs.MacroArpStructDefinition;
import arp.macro.MacroArpObjectBuilder;
import arp.macro.MacroArpObjectRegistry;
import arp.macro.MacroArpTemplateBuilder;
import arp.macro.MacroArpUtil;
import haxe.macro.Expr.Field;
import haxe.macro.Type.ClassType;

class ArpDomainMacros {

	inline private static function logClassDef(classDef:MacroArpClassDefinition, message:String):Void {
		var arpTypeName:String = classDef.arpTypeName;
		var arpTemplateName:String = classDef.arpTemplateName;
		Sys.stdout().writeString(" ***** " + arpTypeName + ":" + arpTemplateName + " " + message + "\n");
		Sys.stdout().flush();
	}

	public static function autoBuildObject():Array<Field> {
		var localClass:ClassType = MacroArpUtil.getLocalClass();
		if (localClass == null) return null;

		var classDef:MacroArpClassDefinition = new MacroArpClassDefinition(localClass);
		var builder:MacroArpObjectBuilder = new MacroArpObjectBuilder();
		#if arp_macro_debug logClassDef(classDef, "started"); #end
		var fields = builder.run(classDef);
		#if arp_macro_debug logClassDef(classDef, "completed"); #end
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

	public static function autoBuildTemplate():Array<Field> {
		var localClass:ClassType = MacroArpUtil.getLocalClass();
		if (localClass == null) return null;

		var classDef:MacroArpClassDefinition = new MacroArpClassDefinition(localClass);
		var builder:MacroArpTemplateBuilder = new MacroArpTemplateBuilder();
		#if arp_macro_debug logClassDef(classDef, "started template"); #end
		var fields = builder.run(classDef);
		#if arp_macro_debug logClassDef(classDef, "completed template"); #end
		return fields;
	}
}

#end
