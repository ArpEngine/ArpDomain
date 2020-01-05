package arp.macro;

import arp.domain.ArpDomain;
import arp.domain.ArpSlot;
import arp.domain.core.ArpType;
import arp.macro.mocks.MockImplMacroArpObject;
import arp.seed.ArpSeed;
import picotest.PicoAssert.*;

class MacroImplArpObjectCase {

	private var domain:ArpDomain;
	private var slot:ArpSlot<MockImplMacroArpObject>;
	private var arpObj:MockImplMacroArpObject;
	private var xml:Xml;
	private var seed:ArpSeed;

	public function setup():Void {
		domain = new ArpDomain();
		domain.addTemplate(MockImplMacroArpObject, true);
		xml = Xml.parse('<mock field="seedValue" name="name1"><map value="1" /><map value="2" /></mock>').firstElement();
		seed = ArpSeed.fromXml(xml);
		slot = domain.loadSeed(seed, new ArpType("mock"));
		arpObj = slot.value;
	}

	@:access(arp.macro.mocks.MockImplMacroArpObject.arpImpl)
	public function testImplCanAccessObjDefaultsInConstructor():Void {
		assertNotNull(arpObj.arpImpl);
		assertNotNull(arpObj.map);
		assertEquals("nativeValue", arpObj.native);
		assertEquals("seedValue", arpObj.field);
		assertNotNull(arpObj.arpImpl.map);
		assertEquals(0, arpObj.arpImpl.mapCount);
		assertNotNull(arpObj.arpImpl.obj);
		assertEquals("nativeValue", arpObj.arpImpl.native);
		assertEquals("fieldValue", arpObj.arpImpl.objField);
		assertMatch(-1, arpObj.arpImpl.initialHeat);
	}
}
