package arp.domain.reflect;

import arp.domain.core.ArpType;

class ArpFieldInfo {

	public var groupName(default, null):String;
	public var elementName(default, null):String;
	public var arpType(default, null):ArpType;
	public var fieldKind(default, null):ArpFieldKind;
	public var fieldDs(default, null):ArpFieldDs;
	public var nativeName(default, null):String;
	public var barrier(default, null):Bool;
	public var doc(default, null):String;

	public var isCollection(get, never):Bool;
	private function get_isCollection() {
		return switch (this.fieldDs) {
			case ArpFieldDs.Scalar: false;
			case _: true;
		}
	}

	public function new(groupName:String, elementName:String, arpType:ArpType, fieldType:ArpFieldKind, fieldDs:ArpFieldDs, nativeName:String, barrier:Bool, doc:String) {
		this.groupName = groupName;
		this.elementName = elementName;
		this.arpType = arpType;
		this.fieldKind = fieldType;
		this.fieldDs = fieldDs;
		this.nativeName = nativeName;
		this.barrier = barrier;
		this.doc = doc;
	}

}
