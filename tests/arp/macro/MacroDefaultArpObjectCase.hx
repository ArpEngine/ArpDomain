package arp.macro;

import arp.domain.ArpDomain;
import arp.domain.ArpSlot;
import arp.domain.core.ArpType;
import arp.macro.mocks.MockDefaultMacroArpObject;
import arp.seed.ArpSeed;
import arp.tests.ArpDomainTestUtil;
import picotest.PicoAssert.*;

class MacroDefaultArpObjectCase {

	private var domain:ArpDomain;
	private var slot:ArpSlot<MockDefaultMacroArpObject>;
	private var arpObj:MockDefaultMacroArpObject;
	private var xml:Xml;
	private var seed:ArpSeed;

	public function setup():Void {
		domain = new ArpDomain();
		domain.addTemplate(MockDefaultMacroArpObject, true);
		xml = Xml.parse('<mock name="name1" intField="78" floatField="1.41" boolField="false" stringField="stringValue3" refField="/name1" intSet="777" intList="888" refSet="/name1" refList="/name1" />').firstElement();
		seed = ArpSeed.fromXml(xml);
	}

	public function testCreateEmpty():Void {
		arpObj = domain.allocObject(MockDefaultMacroArpObject);

		assertEquals(domain, arpObj.arpDomain);
		assertEquals(new ArpType("mock"), arpObj.arpType);

		assertEquals(5678, arpObj.intField);
		assertEquals(6789.0, arpObj.floatField);
		assertEquals(true, arpObj.boolField);
		assertEquals("stringDefault3", arpObj.stringField);

		assertEquals(null, arpObj.refField);

		assertTrue(arpObj.intSet.hasValue(123));
		assertTrue(arpObj.intSet.hasValue(456));
		assertTrue(arpObj.intList.hasValue(234));
		assertTrue(arpObj.intList.hasValue(567));

		assertEquals(1, [for (x in arpObj.refSet) x].length);
		assertEquals(2, arpObj.refList.length);

		var refFieldDefault = domain.loadSeed(seed, new ArpType("mock")).value;
		assertEquals(refFieldDefault, arpObj.refField);
	}

	public function testLoadSeed():Void {
		slot = domain.loadSeed(seed, new ArpType("mock"));
		arpObj = slot.value;

		assertEquals(domain, arpObj.arpDomain);
		assertEquals(new ArpType("mock"), arpObj.arpType);
		assertEquals(slot, arpObj.arpSlot);

		assertEquals(78, arpObj.intField);
		assertEquals(1.41, arpObj.floatField);
		assertEquals(false, arpObj.boolField);
		assertEquals("stringValue3", arpObj.stringField);

		assertTrue(arpObj.intSet.hasValue(123));
		assertTrue(arpObj.intSet.hasValue(456));
		assertTrue(arpObj.intSet.hasValue(777));
		assertTrue(arpObj.intList.hasValue(234));
		assertTrue(arpObj.intList.hasValue(567));
		assertTrue(arpObj.intList.hasValue(888));

		assertEquals(1, [for (x in arpObj.refSet) x].length);
		assertEquals(3, arpObj.refList.length);
		assertTrue(arpObj.refSet.hasValue(arpObj));
		assertTrue(arpObj.refList.hasValue(arpObj));

		assertEquals(arpObj, arpObj.refField);
	}

	private function checkIsClone(original:MockDefaultMacroArpObject, clone:MockDefaultMacroArpObject):Void {
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

		var clone:MockDefaultMacroArpObject = ArpDomainTestUtil.roundTrip(domain, arpObj, MockDefaultMacroArpObject);
		checkIsClone(arpObj, clone);
	}

	public function testArpClone():Void {
		slot = domain.loadSeed(seed, new ArpType("mock"));
		arpObj = slot.value;

		var clone:MockDefaultMacroArpObject = cast arpObj.arpClone();
		checkIsClone(arpObj, clone);
	}
}
