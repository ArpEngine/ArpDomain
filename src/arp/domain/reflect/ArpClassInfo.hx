package arp.domain.reflect;

import arp.domain.core.ArpType;

class ArpClassInfo {

	public var fieldKind(default, null):ArpFieldKind;
	public var arpType(default, null):ArpType;
	public var fqn(default, null):String;
	public var className(default, null):String;
	public var fields(default, null):Array<ArpFieldInfo>;
	public var doc(default, null):String;
	public var stringPlaceholder(default, null):String;
	public var seedPlaceholder(default, null):Dynamic;

	private function new(fieldKind:ArpFieldKind, arpType:ArpType, className:String, fqn:String, fields:Array<ArpFieldInfo>, doc:String) {
		this.fieldKind = fieldKind;
		this.arpType = arpType;
		this.className = className;
		this.fqn = fqn;
		this.fields = fields;
		this.doc = doc;
	}

	public static function reference(arpType:ArpType, className:String, fqn:String, fields:Array<ArpFieldInfo>, doc:String) {
		return new ArpClassInfo(ArpFieldKind.ReferenceKind, arpType, className, fqn, fields, doc);
	}

	public static function struct(arpType:ArpType, fqn:String, doc:String, stringPlaceholder:String, seedPlaceholder:Dynamic) {
		var result:ArpClassInfo =  new ArpClassInfo(ArpFieldKind.StructKind, arpType, null, fqn, null, doc);
		result.stringPlaceholder = stringPlaceholder;
		result.seedPlaceholder = seedPlaceholder;
		return result;
	}

	public static function primitive(fieldKind:ArpFieldKind, arpType:ArpType, fqn:String, doc:String) {
		return new ArpClassInfo(fieldKind, arpType, null, fqn, null, doc);
	}
}
