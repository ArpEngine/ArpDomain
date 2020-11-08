package arp.domain.mocks;

import arp.seed.ArpSeedEnv;
import arp.seed.ArpSeedBuilder;
import arp.domain.core.ArpOverwriteStrategy;
import arp.domain.core.ArpType;
import arp.domain.ArpTypeInfo;
import arp.seed.ArpSeed;

@:arpNoGen
@:arpType("mock", "override")
class MockArpTemplate implements IArpTemplate<MockArpObject> {

	public var arpTypeInfo(get, never):ArpTypeInfo;
	private var _arpTypeInfo:ArpTypeInfo;
	public function get_arpTypeInfo():ArpTypeInfo return new ArpTypeInfo("override", new ArpType("mock"), ArpOverwriteStrategy.Error);

	public function alloc():MockArpObject return new MockArpObject();
	public function transformSeed(seed:ArpSeed):ArpSeed {
		var builder:ArpSeedBuilder = ArpSeedBuilder.fromSeedCopy(seed.copy());
		var overrideValue:String = "overrideValue";
		if (builder.children != null) {
			builder.children.push(ArpSeed.createSimple("stringField", null, "overrideValue", ArpSeedEnv.empty()).withSource(seed.source));
		}
		return builder.toSeed();
	}

	public function new() return;
}
