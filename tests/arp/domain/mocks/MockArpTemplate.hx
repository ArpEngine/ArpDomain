package arp.domain.mocks;

import arp.domain.core.ArpOverwriteStrategy;
import arp.domain.core.ArpType;
import arp.domain.ArpTypeInfo;
import arp.seed.ArpSeed;

class MockArpTemplate implements IArpTemplate<MockArpObject> {

	public var arpTypeInfo(get, never):ArpTypeInfo;
	private var _arpTypeInfo:ArpTypeInfo;
	public function get_arpTypeInfo():ArpTypeInfo return new ArpTypeInfo("override", new ArpType("mock"), ArpOverwriteStrategy.Error);

	public function alloc():MockArpObject return new MockArpObject();
	public function transformSeed(seed:ArpSeed):ArpSeed return seed;

	public function new() return;
}
