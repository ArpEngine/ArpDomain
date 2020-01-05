package arp.domain;

import arp.domain.ArpSlot;
import arp.domain.core.ArpType;
import arp.domain.mocks.MockArpObject;
import arp.domain.mocks.MockDerivedArpObject;
import arp.seed.ArpSeed;
import arp.tests.ArpDomainTestUtil;
import picotest.PicoAssert.*;

class MockDerivedArpObjectCase {

	private var domain:ArpDomain;
	private var slot:ArpSlot<MockArpObject>;
	private var arpObj:MockDerivedArpObject;
	private var xml:Xml;
	private var seed:ArpSeed;

	public function setup():Void {
		domain = new ArpDomain();
		domain.addTemplate(MockDerivedArpObject, true);
		xml = Xml.parse('<mock name="name1" intField="42" intField2="168" floatField="3.14" boolField="true" stringField="stringValue" refField="/name1" refField2="/name1" />').firstElement();
		seed = ArpSeed.fromXml(xml);
	}

	public function testBuildObject():Void {
		slot = domain.dir("name1").getOrCreateSlot(new ArpType("mock"));
		arpObj = new MockDerivedArpObject();
		arpObj.__arp_init(slot);
		arpObj.__arp_loadSeed(seed);

		assertEquals(domain, arpObj.arpDomain);
		assertEquals(new ArpType("mock"), arpObj.arpType);
		assertEquals(slot, arpObj.arpSlot);

		assertEquals(42, arpObj.intField);
		assertEquals(168, arpObj.intField2);
		assertEquals(3.14, arpObj.floatField);
		assertEquals(true, arpObj.boolField);
		assertEquals("stringValue", arpObj.stringField);
		assertEquals(null, arpObj.refField);
		assertEquals(null, arpObj.refField2);

		slot.value = arpObj;
		assertMatch(arpObj, arpObj.refField);
	}

	public function testCreateEmpty():Void {
		arpObj = domain.allocObject(MockDerivedArpObject);

		assertEquals(domain, arpObj.arpDomain);
		assertEquals(new ArpType("mock"), arpObj.arpType);

		assertEquals(arpObj.intField, 0);
		assertEquals(arpObj.intField2, 0);
		assertEquals(arpObj.floatField, 0.0);
		assertEquals(arpObj.boolField, false);
		assertEquals(arpObj.stringField, "stringDefault");
		assertEquals(arpObj.refField, null);
		assertEquals(arpObj.refField2, null);
	}

	public function testLoadSeed():Void {
		slot = domain.loadSeed(seed, new ArpType("mock"));
		arpObj = cast slot.value;

		assertEquals(42, arpObj.intField);
		assertEquals(168, arpObj.intField2);
		assertEquals(3.14, arpObj.floatField);
		assertEquals(true, arpObj.boolField);
		assertEquals("stringValue", arpObj.stringField);
		assertMatch(arpObj, arpObj.refField);
		assertMatch(arpObj, arpObj.refField2);
	}

	private function checkIsClone(original:MockDerivedArpObject, clone:MockDerivedArpObject):Void {
		assertEquals(original.arpDomain, clone.arpDomain);
		assertEquals(original.arpType, clone.arpType);
		assertNotEquals(original.arpSlot, clone.arpSlot);

		assertEquals(original.intField, clone.intField);
		assertEquals(original.intField2, clone.intField2);
		assertEquals(original.floatField, clone.floatField);
		assertEquals(original.boolField, clone.boolField);
		assertEquals(original.stringField, clone.stringField);
		assertMatch(original.refField, clone.refField);
		assertMatch(original.refField2, clone.refField2);
	}

	public function testPersistable():Void {
		slot = domain.loadSeed(seed, new ArpType("mock"));
		arpObj = cast slot.value;

		var clone:MockDerivedArpObject = ArpDomainTestUtil.roundTrip(domain, arpObj, MockDerivedArpObject);
		checkIsClone(arpObj, clone);
	}

	public function testArpClone():Void {
		slot = domain.loadSeed(seed, new ArpType("mock"));
		arpObj = cast slot.value;

		var clone:MockDerivedArpObject = cast arpObj.arpClone();
		checkIsClone(arpObj, clone);
	}
}
