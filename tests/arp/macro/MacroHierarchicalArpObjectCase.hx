package arp.macro;

import arp.domain.ArpDomain;
import arp.domain.ArpSlot;
import arp.domain.core.ArpType;
import arp.macro.mocks.MockHierarchicalMacroArpObject;
import arp.seed.ArpSeed;
import picotest.PicoAssert.*;

class MacroHierarchicalArpObjectCase {

	private var domain:ArpDomain;
	private var slot:ArpSlot<MockHierarchicalMacroArpObject>;
	private var arpObj:MockHierarchicalMacroArpObject;
	private var xml:Xml;
	private var seed:ArpSeed;

	inline private static var MOCK_TYPE = new ArpType("mock");

	public function setup():Void {
		domain = new ArpDomain();
		domain.addTemplate(MockHierarchicalMacroArpObject, true);
		xml = Xml.parse('<data>
	<mock name="default" />
	<mock name="value" />
	<data name="inner">
		<mock name="innerValue" />
		<mock name="fromInner" refField="value" />
	</data>
	<mock name="explicit" refField="value" />
	<mock name="toInner" refField="inner/innerValue" />
	<mock name="selfRef" refField="selfRef" />
</data>').firstElement();
		seed = ArpSeed.fromXml(xml);
	}

	public function testCreateEmpty():Void {
		arpObj = domain.allocObject(MockHierarchicalMacroArpObject);

		assertEquals(domain, arpObj.arpDomain);
		assertEquals(MOCK_TYPE, arpObj.arpType);

		assertEquals(null, arpObj.refField);
		assertEquals(null, arpObj.defaultRefField);
		assertEquals(null, arpObj.bogusRefField);

		domain.loadSeed(seed);
		var refFieldDefault = domain.query("default", MOCK_TYPE).obj();
		assertEquals(refFieldDefault, arpObj.defaultRefField);
	}

	public function testLoadSeed():Void {
		domain.loadSeed(seed);

		var value = domain.query("value", MOCK_TYPE).value();
		var innerValue = domain.query("inner/innerValue", MOCK_TYPE).value();

		assertNotNull(value);
		assertNotNull(innerValue);

		var explicit:MockHierarchicalMacroArpObject = domain.query("explicit", MOCK_TYPE).value();
		var toInner:MockHierarchicalMacroArpObject = domain.query("toInner", MOCK_TYPE).value();
		var fromInner:MockHierarchicalMacroArpObject = domain.query("inner/fromInner", MOCK_TYPE).value();
		var selfRef:MockHierarchicalMacroArpObject = domain.query("selfRef", MOCK_TYPE).value();

		assertEquals(value, explicit.refField);
		assertEquals(innerValue, toInner.refField);
		assertEquals(value, fromInner.refField);
		assertEquals(selfRef, selfRef.refField);
	}
}
