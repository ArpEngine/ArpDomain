package arp.domain;

import arp.seed.ArpSeed;

class ArpTemplate<T:IArpObject> implements IArpTemplate<T> {

	private var nativeClass:Class<T>;

	public var arpTypeInfo(get, never):ArpTypeInfo;
	private function get_arpTypeInfo():ArpTypeInfo return this.alloc().arpTypeInfo;

	public function new(nativeClass:Class<T>) this.nativeClass = nativeClass;

	public function alloc():T return Type.createInstance(nativeClass, []);
	public function transformSeed(seed:ArpSeed):ArpSeed return seed;
}
