package arp.macro;

#if macro

import arp.domain.reflect.ArpClassInfo;
import arp.macro.defs.MacroArpClassDefinition;

class MacroArpObject {

	public var classDef(default, null):MacroArpClassDefinition;

	public var arpFields(default, null):Array<IMacroArpField> = [];
	public var mergedArpFields(default, null):Array<IMacroArpField> = [];

	public var classInfo(default, null):ArpClassInfo;

	public function new(classDef:MacroArpClassDefinition, classInfo:ArpClassInfo) {
		this.classDef = classDef;
		this.classInfo = classInfo;
	}

	// must be called in expression macro
	public function populateReflectFields():Void {
		for (arpField in this.arpFields) {
			this.classInfo.fields.push(arpField.toFieldInfo());
		}
	}

	// must be called in onAfterGenerate, to ensure all base classes are loaded
	public function populateBaseFields():Void {
		this.mergedArpFields = this.arpFields.copy();
		for (baseClass in this.classDef.baseClasses) {
			var baseClassFqn:String = MacroArpUtil.getFqnOfBaseType(baseClass);
			var baseObject:MacroArpObject = MacroArpObjectRegistry.getMacroArpObject(baseClassFqn);
			if (baseObject != null) {
				for (macroField in baseObject.arpFields) this.mergedArpFields.push(macroField);
				for (reflectField in baseObject.classInfo.fields) this.classInfo.fields.push(reflectField);
			}
		}
	}
}

#end
