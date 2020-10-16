package arp.domain;

import arp.seed.ArpSeed;

class ArpTemplate<T:IArpObject> {

	private var nativeClass:Class<T>;

	public var arpTypeInfo(get, never):ArpTypeInfo;
	private var _arpTypeInfo:ArpTypeInfo;
	private function get_arpTypeInfo():ArpTypeInfo {
		return if (this._arpTypeInfo != null) this._arpTypeInfo else this._arpTypeInfo = this.alloc().arpTypeInfo;
	}

	public function new(nativeClass:Class<T>) this.nativeClass = nativeClass;

	public function alloc():T return Type.createInstance(nativeClass, []);
	public function transformSeed(seed:ArpSeed):ArpSeed return seed;
}
