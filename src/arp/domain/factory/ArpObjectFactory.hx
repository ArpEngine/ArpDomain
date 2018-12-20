package arp.domain.factory;

import arp.domain.core.ArpType;
import arp.seed.ArpSeed;

class ArpObjectFactory<T:IArpObject> {

	private var nativeClass:Class<T>;
	private var arpTypeInfo:ArpTypeInfo;
	private var isDefault:Bool;

	public var arpType(get, never):ArpType;
	private function get_arpType():ArpType return this.arpTypeInfo.arpType;
	private var className(get, never):String;
	private function get_className():String return this.arpTypeInfo.name;

	public function new(nativeClass:Class<T>, forceDefault:Null<Bool> = null) {
		this.nativeClass = nativeClass;
		this.arpTypeInfo = Type.createEmptyInstance(nativeClass).arpTypeInfo;
		this.isDefault = (forceDefault != null) ? forceDefault : this.className == this.arpType.toString();
	}

	public function matchSeed(seed:ArpSeed, type:ArpType, className:String):Float {
		if (type != this.arpType) return -1;
		if (className == this.className) return 100;
		if (isDefault) return 1;
		return -1;
	}

	inline private function alloc(seed:ArpSeed):T {
		return Type.createInstance(nativeClass, []);
	}

	public function arpInit(slot:ArpSlot<T>, seed:ArpSeed):T {
		var arpObject:T = alloc(seed);
		if (arpObject.arpInit(slot, seed) == null) return null;
		return arpObject;
	}
}
