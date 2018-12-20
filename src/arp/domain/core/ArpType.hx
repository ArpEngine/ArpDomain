package arp.domain.core;

abstract ArpType(String) {
	inline public function new(value:String) {
		this = value;
	}
	@:from inline public static function fromArpTypeInfo(arpTypeInfo:ArpTypeInfo):ArpType {
		return arpTypeInfo.arpType;
	}
	@:from inline public static function fromClass<T:IArpObject>(klass:Class<T>):ArpType {
		return Reflect.field(klass, "_arpTypeInfo").arpType;
	}
	@:to inline public function toString():String {
		return this;
	}
}
