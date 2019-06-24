package arp.macro;

import arp.domain.ArpHeat;
import arp.macro.mocks.MockEmptyArpObject;
import arp.macro.mocks.MockOwnerMacroArpObject;
import arp.domain.ArpDomain;
import arp.domain.ArpSlot;
import arp.domain.core.ArpType;
import arp.seed.ArpSeed;
import picotest.PicoAssert.*;

class MacroOwnerArpObjectCase {

	private var domain:ArpDomain;
	private var slot:ArpSlot<MockOwnerMacroArpObject>;
	private var arpObj:MockOwnerMacroArpObject;
	private var xml:Xml;
	private var seed:ArpSeed;

	inline private static var MOCK_TYPE = new ArpType("mock");

	public function setup():Void {
		domain = new ArpDomain();
		domain.addTemplate(MockEmptyArpObject);
		domain.addTemplate(MockOwnerMacroArpObject);
	}

	public function testLoadSeed():Void {
		xml = Xml.parse('<data>
	<mock name="value" class="owner">
		<optionalRefField class="empty" />
		<ownedOptionalRefField class="empty" />
		<requiredRefField class="empty" />
		<ownedRequiredRefField class="empty" />
	</mock>
</data>').firstElement();
		seed = ArpSeed.fromXml(xml);
		domain.loadSeed(seed);

		slot = domain.query("value", MockOwnerMacroArpObject).slot();
		arpObj = slot.value;

		assertEquals(ArpHeat.Cold, arpObj.arpHeat);
		assertEquals(ArpHeat.Cold, arpObj.optionalRefField.arpHeat);
		assertEquals(ArpHeat.Cold, arpObj.ownedOptionalRefField.arpHeat);
		assertEquals(ArpHeat.Cold, arpObj.requiredRefField.arpHeat);
		assertEquals(ArpHeat.Cold, arpObj.ownedRequiredRefField.arpHeat);

		domain.heatLater(slot);

		assertEquals(ArpHeat.Warming, arpObj.arpHeat);
		assertEquals(ArpHeat.Cold, arpObj.optionalRefField.arpHeat);
		assertEquals(ArpHeat.Cold, arpObj.ownedOptionalRefField.arpHeat);
		assertEquals(ArpHeat.Cold, arpObj.requiredRefField.arpHeat);
		assertEquals(ArpHeat.Cold, arpObj.ownedRequiredRefField.arpHeat);

		domain.rawTick.dispatch(1.0);

		assertEquals(ArpHeat.Warm, arpObj.arpHeat);
		assertEquals(ArpHeat.Warm, arpObj.optionalRefField.arpHeat);
		assertEquals(ArpHeat.Warm, arpObj.ownedOptionalRefField.arpHeat);
		assertEquals(ArpHeat.Warm, arpObj.requiredRefField.arpHeat);
		assertEquals(ArpHeat.Warm, arpObj.ownedRequiredRefField.arpHeat);

		domain.heatDown(slot);

		assertEquals(ArpHeat.Cold, arpObj.arpHeat);
		assertEquals(ArpHeat.Warm, arpObj.optionalRefField.arpHeat);
		assertEquals(ArpHeat.Cold, arpObj.ownedOptionalRefField.arpHeat);
		assertEquals(ArpHeat.Warm, arpObj.requiredRefField.arpHeat);
		assertEquals(ArpHeat.Cold, arpObj.ownedRequiredRefField.arpHeat);
	}
}
