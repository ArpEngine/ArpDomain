package arp.domain;

import arp.domain.core.ArpOverwriteStrategy;
import arp.domain.core.ArpType;

class ArpTypeInfo {

	public var name(default, null):String;
	public var arpType(default, null):ArpType;
	public var overwriteStrategy(default, null):ArpOverwriteStrategy;

	public var fqn(default, null):String;

	public function new(name:String, arpType:ArpType, overwriteStrategy:ArpOverwriteStrategy = ArpOverwriteStrategy.Error) {
		this.name = name;
		this.arpType = arpType;
		this.overwriteStrategy = overwriteStrategy;
		this.fqn = '$name:$arpType';
	}

	public function toString():String {
		return '<$arpType class=$name>';
	}
}
