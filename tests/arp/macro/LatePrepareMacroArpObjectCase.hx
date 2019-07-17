package arp.macro;

import arp.domain.ArpDomain;
import arp.domain.ArpHeat;
import arp.domain.ArpSlot;
import arp.domain.core.ArpType;
import arp.macro.mocks.MockLatePrepareMacroArpObject;
import arp.seed.ArpSeed;
import picotest.PicoAssert.*;
import picotest.PicoTestAsync.*;

class LatePrepareMacroArpObjectCase {

	private var domain:ArpDomain;
	private var slot:ArpSlot<MockLatePrepareMacroArpObject>;
	private var arpObj:MockLatePrepareMacroArpObject;
	private var xml:Xml;
	private var seed:ArpSeed;

	public function setup():Void {
		domain = new ArpDomain();
		domain.addTemplate(MockLatePrepareMacroArpObject, true);
		xml = Xml.parse('<mock name="name1" />').firstElement();
		seed = ArpSeed.fromXml(xml);
		slot = domain.loadSeed(seed, new ArpType("mock"));
		arpObj = slot.value;
	}

	public function testHeatUpHeatDown():Void {
		assertFalse(domain.isPending);
		assertEquals(0, arpObj.volatileInt);
		assertEquals(ArpHeat.Cold, arpObj.arpHeat);

		domain.heatLater(slot);
		domain.rawTick.dispatch(10.0);
		assertTrue(domain.isPending);
		assertEquals(0, arpObj.volatileInt);
		assertEquals(ArpHeat.Warming, arpObj.arpHeat);

		assertLater(function():Void {
			assertTrue(domain.isPending);
			assertEquals(1, arpObj.volatileInt);
			assertEquals(ArpHeat.Warming, arpObj.arpHeat);

			domain.rawTick.dispatch(10.0);
			assertFalse(domain.isPending);
			assertEquals(1, arpObj.volatileInt);
			assertEquals(ArpHeat.Warm, arpObj.arpHeat);

			domain.heatDownNow(slot);
			assertFalse(domain.isPending);
			assertEquals(0, arpObj.volatileInt);
			assertEquals(ArpHeat.Cold, arpObj.arpHeat);
		}, 1200);
	}

	@:access(arp.macro.mocks.MockLatePrepareMacroArpObject)
	public function testHeatUpDispose():Void {
		assertFalse(domain.isPending);
		assertEquals(0, arpObj.volatileInt);
		assertEquals(ArpHeat.Cold, arpObj.arpHeat);

		domain.heatLater(slot);
		domain.rawTick.dispatch(10.0);
		assertTrue(domain.isPending);
		assertEquals(0, arpObj.volatileInt);
		assertEquals(ArpHeat.Warming, arpObj.arpHeat);

		assertLater(function():Void {
			assertTrue(domain.isPending);
			assertEquals(1, arpObj.volatileInt);
			assertEquals(ArpHeat.Warming, arpObj.arpHeat);

			domain.rawTick.dispatch(10.0);
			assertFalse(domain.isPending);
			assertEquals(1, arpObj.volatileInt);
			assertEquals(ArpHeat.Warm, arpObj.arpHeat);

			arpObj.__arp_dispose();
			assertFalse(domain.isPending);
			assertEquals(0, arpObj.volatileInt);
			assertNull(arpObj._arpSlot);
			assertNull(arpObj._arpDomain);
		}, 1200);
	}

}
