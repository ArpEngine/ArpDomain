package arp.macro;

import arp.domain.ArpDomain;
import arp.domain.ArpSlot;
import arp.domain.core.ArpType;
import arp.macro.mocks.MockColumnMacroArpObject;
import arp.seed.ArpSeed;
import arp.tests.ArpDomainTestUtil;
import picotest.PicoAssert.*;

class MacroColumnArpObjectCase {

	private var domain:ArpDomain;
	private var slot:ArpSlot<MockColumnMacroArpObject>;
	private var arpObj:MockColumnMacroArpObject;
	private var xml:Xml;
	private var seed:ArpSeed;

	public function setup():Void {
		domain = new ArpDomain();
		domain.addTemplate(MockColumnMacroArpObject, true);
		xml = Xml.parse('<mock name="name1" if="42" ff="3.14" bf="true" sf="stringValue" rf="/name1" />').firstElement();
		seed = ArpSeed.fromXml(xml);
	}

	public function testCreateEmpty():Void {
		arpObj = domain.allocObject(MockColumnMacroArpObject);

		assertEquals(domain, arpObj.arpDomain);
		assertEquals(new ArpType("mock"), arpObj.arpType);

		assertEquals(arpObj.intField, 0);
		assertEquals(arpObj.floatField, 0.0);
		assertEquals(arpObj.boolField, false);
		assertEquals(arpObj.stringField, null);
		assertEquals(arpObj.refField, null);
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

	private function checkIsClone(original:MockColumnMacroArpObject, clone:MockColumnMacroArpObject):Void {
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

		var clone:MockColumnMacroArpObject = ArpDomainTestUtil.roundTrip(domain, arpObj, MockColumnMacroArpObject);
		checkIsClone(arpObj, clone);
	}

	public function testArpClone():Void {
		slot = domain.loadSeed(seed, new ArpType("mock"));
		arpObj = slot.value;

		var clone:MockColumnMacroArpObject = cast arpObj.arpClone();
		checkIsClone(arpObj, clone);
	}
}
