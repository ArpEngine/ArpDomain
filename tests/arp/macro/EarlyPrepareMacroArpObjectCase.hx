package arp.macro;

import arp.domain.ArpDomain;
import arp.domain.ArpHeat;
import arp.domain.ArpSlot;
import arp.domain.core.ArpType;
import arp.macro.mocks.MockEarlyPrepareMacroArpObject;
import arp.seed.ArpSeed;
import picotest.PicoAssert.*;

class EarlyPrepareMacroArpObjectCase {

	private var domain:ArpDomain;
	private var slot:ArpSlot<MockEarlyPrepareMacroArpObject>;
	private var arpObj:MockEarlyPrepareMacroArpObject;
	private var xml:Xml;
	private var seed:ArpSeed;

	public function setup():Void {
		domain = new ArpDomain();
		domain.addTemplate(MockEarlyPrepareMacroArpObject, true);
		xml = Xml.parse('<mock name="name1" />').firstElement();
		seed = ArpSeed.fromXml(xml);
		slot = domain.loadSeed(seed, new ArpType("mock"));
		arpObj = slot.value;
	}

	public function testHeatUpHeatDown():Void {
		assertFalse(domain.isPending);
		assertEquals(0, arpObj.volatileInt);
		assertEquals(ArpHeat.Cold, arpObj.arpSlot.heat);

		domain.heatLater(slot);
		domain.rawTick.dispatch(10.0);
		assertFalse(domain.isPending);
		assertEquals(1, arpObj.volatileInt);
		assertEquals(ArpHeat.Warm, arpObj.arpSlot.heat);

		domain.heatDown(slot);
		assertFalse(domain.isPending);
		assertEquals(0, arpObj.volatileInt);
		assertEquals(ArpHeat.Cold, arpObj.arpSlot.heat);
	}

	@:access(arp.macro.mocks.MockEarlyPrepareMacroArpObject)
	public function testEarlyPrepareDispose():Void {
		assertFalse(domain.isPending);
		assertEquals(0, arpObj.volatileInt);
		assertEquals(ArpHeat.Cold, arpObj.arpSlot.heat);

		arpObj.arpHeatUp();
		assertFalse(domain.isPending);
		assertEquals(1, arpObj.volatileInt);
		assertEquals(ArpHeat.Warm, arpObj.arpSlot.heat);

		arpObj.arpDispose();
		assertFalse(domain.isPending);
		assertEquals(0, arpObj.volatileInt);
		assertNull(arpObj._arpSlot);
		assertNull(arpObj._arpDomain);
	}

}
