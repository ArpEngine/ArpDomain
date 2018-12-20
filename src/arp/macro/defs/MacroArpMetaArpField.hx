package arp.macro.defs;

#if macro

class MacroArpMetaArpField {
	public var groupName:MacroArpMetaArpFieldName = MacroArpMetaArpFieldName.Default;
	public var elementName:MacroArpMetaArpFieldName = MacroArpMetaArpFieldName.Anonymous;

	public function new() return;
}

enum MacroArpMetaArpFieldName {
	Anonymous;
	Default;
	Explicit(name:String);
}
#end
