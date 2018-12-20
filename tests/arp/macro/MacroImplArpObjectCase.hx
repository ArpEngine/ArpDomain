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
		xml = Xml.parse('<mock name="name1"><map value="1" /><map value="2" /></mock>').firstElement();
		seed = ArpSeed.fromXml(xml);
		slot = domain.loadSeed(seed, new ArpType("mock"));
		arpObj = slot.value;
	}

	@:access(arp.macro.mocks.MockImplMacroArpObject.arpImpl)
	public function testImplCanAccessObjFieldsInConstructor():Void {
		assertNotNull(arpObj.arpImpl);
		assertNotNull(arpObj.map);
		assertNotNull(arpObj.native);
		assertNotNull(arpObj.arpImpl.map);
		assertEquals(2, arpObj.arpImpl.mapCount);
		assertNotNull(arpObj.arpImpl.obj);
		assertNotNull(arpObj.arpImpl.native);
		assertMatch(-1, arpObj.arpImpl.initialHeat);
	}
}
