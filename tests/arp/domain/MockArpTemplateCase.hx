package arp.domain;

import arp.domain.mocks.MockArpTemplate;
import arp.domain.ArpSlot;
import arp.domain.core.ArpType;
import arp.domain.mocks.MockArpObject;
import arp.seed.ArpSeed;
import arp.tests.ArpDomainTestUtil;
import picotest.PicoAssert.*;

class MockArpTemplateCase {

	private var domain:ArpDomain;
	private var slot:ArpSlot<MockArpObject>;
	private var arpObj:MockArpObject;
	private var xml:Xml;
	private var seed:ArpSeed;

	public function setup():Void {
		domain = new ArpDomain();
		domain.addTemplate(MockArpTemplate, true);
		xml = Xml.parse('<mock class="override" name="name1" intField="42" floatField="3.14" boolField="true" stringField="stringValue" refField="/name1" />').firstElement();
		seed = ArpSeed.fromXml(xml);
	}

	public function testLoadSeed():Void {
		slot = domain.loadSeed(seed, new ArpType("mock"));
		arpObj = slot.value;

		assertEquals(42, arpObj.intField);
		assertEquals(3.14, arpObj.floatField);
		assertEquals(true, arpObj.boolField);
		assertEquals("overrideValue", arpObj.stringField);
		assertEquals(arpObj, arpObj.refField);
		assertEquals("mock", arpObj.arpTypeInfo.name);
	}

	private function checkIsClone(original:MockArpObject, clone:MockArpObject):Void {
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

		var clone:MockArpObject = ArpDomainTestUtil.roundTrip(domain, arpObj, MockArpObject);
		checkIsClone(arpObj, clone);
	}

	public function testClone():Void {
		slot = domain.loadSeed(seed, new ArpType("mock"));
		arpObj = slot.value;

		var clone:MockArpObject = cast arpObj.arpClone();
		checkIsClone(arpObj, clone);
	}
}
