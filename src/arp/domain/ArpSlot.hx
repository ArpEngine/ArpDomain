package arp.domain;

import arp.domain.core.ArpSid;

/**
	Note typed ArpSlot is only typed in API level (enforced in framework logic).
**/
abstract ArpSlot<T:IArpObject>(ArpUntypedSlot) from ArpUntypedSlot to ArpUntypedSlot {

	private function new(value:ArpUntypedSlot) this = value;

	public var domain(get, never):ArpDomain;
	inline private function get_domain():ArpDomain return this.domain;

	public var sid(get, never):ArpSid;
	inline private function get_sid():ArpSid return this.sid;

	public var value(get, set):T;
	inline private function get_value():T return cast this.value; // FIXME
	inline private function set_value(value:T):T return cast(this.value = cast(value)); // FIXME

	public var primaryDir(get, never):Null<ArpDirectory>;
	inline private function get_primaryDir():Null<ArpDirectory> return this.primaryDir;

	public var refCount(get, never):Int;
	inline private function get_refCount():Int return this.refCount;

	inline public function addReference():ArpSlot<T> return this.addReference();
	inline public function delReference():ArpSlot<T> return this.delReference();
	inline public function takeReference(from:ArpSlot<T>):ArpSlot<T> return this.takeReference(from);
	inline public function eternalReference():ArpSlot<T> return this.eternalReference();

	// FIXME make setter friend access
	public var heat(get, set):ArpHeat;
	inline private function get_heat():ArpHeat return this.heat;
	inline private function set_heat(value:ArpHeat):ArpHeat return this.heat = value;

	inline public function toString():String return this.toString();
	inline public function describe():String return this.describe();

	@:noUsing
	public static function of<T:IArpObject>(arpObj:T, domain:ArpDomain):ArpSlot<T> {
		if (arpObj != null) return arpObj.arpSlot;
		return domain.nullSlot;
	}

	@:noUsing
	public static function get<T:IArpObject>(arpObj:T):ArpSlot<T> {
		if (arpObj != null) return arpObj.arpSlot;
		return null;
	}
}
