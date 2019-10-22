package arp.macro;

import arp.domain.ArpDomain;
import arp.domain.ArpSlot;
import arp.domain.core.ArpType;
import arp.macro.mocks.MockStdDsMacroArpObject;
import arp.seed.ArpSeed;
import arp.tests.ArpDomainTestUtil;
import picotest.PicoAssert.*;
using Lambda;
class StdDsMacroArpObjectCase {

	private var domain:ArpDomain;
	private var slot:ArpSlot<MockStdDsMacroArpObject>;
	private var arpObj:MockStdDsMacroArpObject;
	private var xml:Xml;
	private var seed:ArpSeed;

	public function setup():Void {
		domain = new ArpDomain();
		domain.addTemplate(MockStdDsMacroArpObject, true);
		xml = Xml.parse('
<mock name="name1">
	<intStdArray value="112" />
	<intStdArray value="134" />
	<floatStdArray value="2.23" />
	<floatStdArray value="2.45" />
	<boolStdArray value="true" />
	<boolStdArray value="true" />
	<stringStdArray value="stdFoo" />
	<stringStdArray value="stdBar" />
	<intStdList value="112" />
	<intStdList value="134" />
	<floatStdList value="2.23" />
	<floatStdList value="2.45" />
	<boolStdList value="true" />
	<boolStdList value="true" />
	<stringStdList value="stdFoo" />
	<stringStdList value="stdBar" />
	<intStdMap key="key1" value="312" />
	<intStdMap key="key2" value="334" />
	<floatStdMap key="key3" value="4.23" />
	<floatStdMap key="key4" value="4.45" />
	<boolStdMap key="key5" value="true" />
	<boolStdMap key="key6" value="false" />
	<stringStdMap key="key7" value="stdMapFoo" />
	<stringStdMap key="key8" value="stdMapBar" />
	<refStdMap key="key9" ref="name1" />
	<refStdMap key="key0" ref="name1" />
</mock>
		').firstElement();
		seed = ArpSeed.fromXml(xml);
	}

	public function testCreateEmpty():Void {
		arpObj = domain.allocObject(MockStdDsMacroArpObject);

		assertEquals(domain, arpObj.arpDomain);
		assertEquals(new ArpType("mock"), arpObj.arpType);
	}

	public function testLoadSeed():Void {
		slot = domain.loadSeed(seed, new ArpType("mock"));
		arpObj = slot.value;

		assertEquals(domain, arpObj.arpDomain);
		assertEquals(new ArpType("mock"), arpObj.arpType);
		assertEquals(slot, arpObj.arpSlot);

		assertMatch([112, 134], arpObj.intStdArray);
		assertMatch([2.23, 2.45], arpObj.floatStdArray);
		assertMatch([true, true], arpObj.boolStdArray);
		assertMatch(["stdFoo", "stdBar"], arpObj.stringStdArray);
		assertMatch([112, 134], arpObj.intStdList.array());
		assertMatch([2.23, 2.45], arpObj.floatStdList.array());
		assertMatch([true, true], arpObj.boolStdList.array());
		assertMatch(["stdFoo", "stdBar"], arpObj.stringStdList.array());
		assertEquals(312, arpObj.intStdMap.get("key1"));
		assertEquals(334, arpObj.intStdMap.get("key2"));
		assertEquals(4.23, arpObj.floatStdMap.get("key3"));
		assertEquals(4.45, arpObj.floatStdMap.get("key4"));
		assertEquals(true, arpObj.boolStdMap.get("key5"));
		assertEquals(false, arpObj.boolStdMap.get("key6"));
		assertEquals("stdMapFoo", arpObj.stringStdMap.get("key7"));
		assertEquals("stdMapBar", arpObj.stringStdMap.get("key8"));
		assertEquals(arpObj, arpObj.refStdMap.get("key9"));
		assertEquals(arpObj, arpObj.refStdMap.get("key0"));
		assertEquals(2, arpObj.arpSlot.refCount);
		assertEquals(1, arpObj.arpSlot.primaryDir.refCount);
		assertEquals(1, domain.root.refCount);
	}

	private function checkIsClone(original:MockStdDsMacroArpObject, clone:MockStdDsMacroArpObject):Void {
		assertEquals(original.arpDomain, clone.arpDomain);
		assertEquals(original.arpType, clone.arpType);
		assertNotEquals(original.arpSlot, clone.arpSlot);

		assertMatch(original.intStdArray, clone.intStdArray);
		assertMatch(original.floatStdArray, clone.floatStdArray);
		assertMatch(original.boolStdArray, clone.boolStdArray);
		assertMatch(original.stringStdArray, clone.stringStdArray);

		assertMatch(original.floatStdList.array(), clone.floatStdList.array());
		assertMatch(original.boolStdList.array(), clone.boolStdList.array());
		assertMatch(original.stringStdList.array(), clone.stringStdList.array());
		assertEquals(original.intStdMap.get("key1"), clone.intStdMap.get("key1"));
		assertEquals(original.intStdMap.get("key2"), clone.intStdMap.get("key2"));
		assertEquals(original.floatStdMap.get("key3"), clone.floatStdMap.get("key3"));
		assertEquals(original.floatStdMap.get("key4"), clone.floatStdMap.get("key4"));
		assertEquals(original.boolStdMap.get("key5"), clone.boolStdMap.get("key5"));
		assertEquals(original.boolStdMap.get("key6"), clone.boolStdMap.get("key6"));
		assertEquals(original.stringStdMap.get("key7"), clone.stringStdMap.get("key7"));
		assertEquals(original.stringStdMap.get("key8"), clone.stringStdMap.get("key8"));
		assertEquals(original.refStdMap.get("key9"), clone.refStdMap.get("key9"));
		assertEquals(original.refStdMap.get("key0"), clone.refStdMap.get("key0"));
	}

	public function testPersistable():Void {
		slot = domain.loadSeed(seed, new ArpType("mock"));
		arpObj = slot.value;

		var clone:MockStdDsMacroArpObject = ArpDomainTestUtil.roundTrip(domain, arpObj, MockStdDsMacroArpObject);
		checkIsClone(arpObj, clone);
	}

	public function testArpClone():Void {
		slot = domain.loadSeed(seed, new ArpType("mock"));
		arpObj = slot.value;

		var clone:MockStdDsMacroArpObject = cast arpObj.arpClone();
		checkIsClone(arpObj, clone);
	}
}
