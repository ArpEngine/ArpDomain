package arp.domain.core;

abstract ArpSid(String) {
	inline public function new(value:String) {
		this = value;
	}
	inline public static function build(did:ArpDid, type:ArpType):ArpSid {
		return new ArpSid('${did.toString()}:${type.toString()}');
	}
	inline public function toString():String {
		return this;
	}
}
