package arp.domain.factory;

import arp.domain.core.ArpOverwriteStrategy;
import arp.domain.core.ArpType;
import arp.seed.ArpSeed;

class ArpObjectFactory<T:IArpObject> {

	public var arpTypeInfo(default, null):ArpTypeInfo;

	private var nativeClass:Class<T>;
	private var isDefault:Bool;

	public var overwriteStrategy(default, null):ArpOverwriteStrategy = ArpOverwriteStrategy.Error;

	public var arpType(get, never):ArpType;
	private function get_arpType():ArpType return this.arpTypeInfo.arpType;
	private var className(get, never):String;
	private function get_className():String return this.arpTypeInfo.name;

	public function new(nativeClass:Class<T>, forceDefault:Null<Bool> = null) {
		this.nativeClass = nativeClass;
		this.arpTypeInfo = Type.createEmptyInstance(nativeClass).arpTypeInfo;
		this.isDefault = (forceDefault != null) ? forceDefault : this.className == this.arpType.toString();
		this.overwriteStrategy = this.arpTypeInfo.overwriteStrategy;
	}

	public function matchSeed(seed:ArpSeed, type:ArpType, className:String):Float {
		if (type != this.arpType) return -1;
		if (className == this.className) return 100;
		if (className == null && isDefault) return 1;
		return -1;
	}

	inline private function alloc():T {
		return Type.createInstance(nativeClass, []);
	}

	public function arpInit(slot:ArpSlot<T>):T {
		var arpObject:T = alloc();
		if (arpObject.__arp_init(slot) == null) return null;
		return arpObject;
	}
}
