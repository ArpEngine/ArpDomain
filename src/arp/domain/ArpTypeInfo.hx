package arp.domain;

import arp.domain.core.ArpType;

class ArpTypeInfo {

	public var name(default, null):String;
	public var arpType(default, null):ArpType;

	public function new(name:String, arpType:ArpType) {
		this.name = name;
		this.arpType = arpType;
	}

	public function toString():String {
		return '<$arpType class=$name>';
	}
}
