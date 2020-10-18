package arp.domain.factory;

import arp.domain.core.ArpOverwriteStrategy;
import arp.domain.core.ArpType;
import arp.seed.ArpSeed;

class ArpObjectFactory<T:IArpObject> {

	public var arpTypeInfo(default, null):ArpTypeInfo;

	private var arpTemplate:IArpTemplate<T>;
	private var isDefault:Bool;

	public var overwriteStrategy(default, null):ArpOverwriteStrategy = ArpOverwriteStrategy.Error;

	public var arpType(get, never):ArpType;
	private function get_arpType():ArpType return this.arpTypeInfo.arpType;
	private var className(get, never):String;
	private function get_className():String return this.arpTypeInfo.name;

	public function new(arpTemplate:IArpTemplate<T>, forceDefault:Null<Bool> = null) {
		this.arpTemplate = arpTemplate;
		this.arpTypeInfo = arpTemplate.arpTypeInfo();
		this.isDefault = (forceDefault != null) ? forceDefault : this.className == this.arpType.toString();
		this.overwriteStrategy = this.arpTypeInfo.overwriteStrategy;
	}

	public function matchSeed(seed:ArpSeed, type:ArpType, className:String):Float {
		if (type != this.arpType) return -1;
		if (className == this.className) return 100;
		if (className == null && isDefault) return 1;
		return -1;
	}

	public function arpInit(slot:ArpSlot<T>):T {
		var arpObject:T = this.arpTemplate.alloc();
		if (arpObject.__arp_init(slot) == null) return null;
		return arpObject;
	}

	public function arpLoadSeed(arpObject:T, seed:ArpSeed):T {
		var s:ArpSeed = this.arpTemplate.transformSeed(seed);
		arpObject.__arp_loadSeed(s);
		return arpObject;
	}
}
