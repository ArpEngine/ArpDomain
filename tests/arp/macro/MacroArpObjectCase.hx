package arp.macro;

import arp.domain.ArpDomain;
import arp.domain.ArpSlot;
import arp.domain.core.ArpType;
import arp.macro.mocks.MockMacroArpObject;
import arp.seed.ArpSeed;
import arp.tests.ArpDomainTestUtil;
import picotest.PicoAssert.*;

class MacroArpObjectCase {

	private var domain:ArpDomain;
	private var slot:ArpSlot<MockMacroArpObject>;
	private var arpObj:MockMacroArpObject;
	private var xml:Xml;
	private var seed:ArpSeed;

	public function setup():Void {
		domain = new ArpDomain();
		domain.addTemplate(MockMacroArpObject, true);
		xml = Xml.parse('<mock name="name1" intField="42" floatField="3.14" boolField="true" stringField="stringValue" refField="/name1" />').firstElement();
		seed = ArpSeed.fromXml(xml);
	}

	public function testCreateEmpty():Void {
		arpObj = domain.allocObject(MockMacroArpObject);

		assertEquals(domain, arpObj.arpDomain);
		assertEquals(new ArpType("mock"), arpObj.arpType);

		assertEquals(1000000, arpObj.intField);
		assertEquals(1000000.0, arpObj.floatField);
		assertEquals(false, arpObj.boolField);
		assertEquals(null, arpObj.stringField);
		assertEquals(null, arpObj.refField);
	}

	public function testLoadSeed():Void {
		slot = domain.loadSeed(seed, new ArpType("mock"));
		arpObj = slot.value;

		assertEquals(domain, arpObj.arpDomain);
		assertEquals(new ArpType("mock"), arpObj.arpType);
		assertEquals(slot, arpObj.arpSlot);

		assertEquals(42, arpObj.intField);
		assertEquals(3.14, arpObj.floatField);
		assertEquals(true, arpObj.boolField);
		assertEquals("stringValue", arpObj.stringField);
		assertEquals(arpObj, arpObj.refField);
	}

	private function checkIsClone(original:MockMacroArpObject, clone:MockMacroArpObject):Void {
		assertEquals(original.arpDomain, clone.arpDomain);
		assertEquals(original.arpType, clone.arpType);
		assertNotEquals(original.arpSlot, clone.arpSlot);

		assertEquals(original.intField, clone.intField);
		assertEquals(original.floatField, clone.floatField);
		assertEquals(original.boolField, clone.boolField);
		assertEquals(original.stringField, clone.stringField);
		assertEquals(original.refField, clone.refField);
	}

	public function testPersistable():Void {
		slot = domain.loadSeed(seed, new ArpType("mock"));
		arpObj = slot.value;

		var clone:MockMacroArpObject = ArpDomainTestUtil.roundTrip(domain, arpObj, MockMacroArpObject);
		checkIsClone(arpObj, clone);
	}
}
