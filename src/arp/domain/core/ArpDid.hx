package arp.domain.core;

abstract ArpDid(String) {

	inline public function new(value:String) this = value;

	inline public static function rootDir():ArpDid return new ArpDid("");

	inline public static function build(did:ArpDid, name:String):ArpDid {
		return new ArpDid('${did.toString()}${ArpDirectory.PATH_DELIMITER}$name');
	}

	inline public function toString():String return this;
}
