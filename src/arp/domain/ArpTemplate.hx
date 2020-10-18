package arp.domain;

import arp.seed.ArpSeed;

class ArpTemplate<T:IArpObject> implements IArpTemplate<T> {

	private var nativeClass:Class<T>;
	private var _arpTypeInfo:ArpTypeInfo;

	public var arpTypeInfo(get, never):ArpTypeInfo;
	inline private function get_arpTypeInfo():ArpTypeInfo return _arpTypeInfo;

	public function new(nativeClass:Class<T>, overrideName:Null<String> = null) {
		this.nativeClass = nativeClass;
		var arpTypeInfo:ArpTypeInfo = this.alloc().arpTypeInfo;
		if (overrideName != null) {
			arpTypeInfo = new ArpTypeInfo(overrideName, arpTypeInfo.arpType, arpTypeInfo.overwriteStrategy);
		}
		this._arpTypeInfo = arpTypeInfo;
	}

	public function alloc():T return Type.createInstance(nativeClass, []);
	public function transformSeed(seed:ArpSeed):ArpSeed return seed;
}
