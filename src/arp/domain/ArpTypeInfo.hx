package arp.domain;

import arp.domain.core.ArpType;

class ArpTypeInfo {

	public var name(default, null):String;
	public var arpType(default, null):ArpType;

	public var fqn(default, null):String;

	public function new(name:String, arpType:ArpType) {
		this.name = name;
		this.arpType = arpType;
		this.fqn = '$name:$arpType';
	}

	public function toString():String {
		return '<$arpType class=$name>';
	}
}
