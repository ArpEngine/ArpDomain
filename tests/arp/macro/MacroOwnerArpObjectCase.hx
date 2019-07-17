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
	private var otherSlot:ArpSlot<MockOwnerMacroArpObject>;
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

		domain.heatDownNow(slot);

		assertEquals(ArpHeat.Cold, arpObj.arpHeat);
		assertEquals(ArpHeat.Warm, arpObj.optionalRefField.arpHeat);
		assertEquals(ArpHeat.Cold, arpObj.ownedOptionalRefField.arpHeat);
		assertEquals(ArpHeat.Warm, arpObj.requiredRefField.arpHeat);
		assertEquals(ArpHeat.Cold, arpObj.ownedRequiredRefField.arpHeat);

		assertEquals(ArpHeat.Cold, arpObj.arpHeat);
		assertEquals(ArpHeat.Warm, arpObj.optionalRefField.arpHeat);
		assertEquals(ArpHeat.Cold, arpObj.ownedOptionalRefField.arpHeat);
		assertEquals(ArpHeat.Warm, arpObj.requiredRefField.arpHeat);
		assertEquals(ArpHeat.Cold, arpObj.ownedRequiredRefField.arpHeat);
	}


	public function testHeatUpkeep():Void {
		xml = Xml.parse('<data>
	<mock name="optionalRef" class="empty" />
	<mock name="ownedOptionalRef" class="empty" />
	<mock name="requiredRef" class="empty" />
	<mock name="ownedRequiredRef" class="empty" />
	<mock name="value" class="owner" heat="warm">
		<optionalRefField ref="optionalRef" />
		<ownedOptionalRefField ref="ownedOptionalRef" />
		<requiredRefField ref="requiredRef" />
		<ownedRequiredRefField ref="ownedRequiredRef" />
	</mock>
	<mock name="otherValue" class="owner" heat="warm">
		<optionalRefField ref="optionalRef" />
		<ownedOptionalRefField ref="ownedOptionalRef" />
		<requiredRefField ref="requiredRef" />
		<ownedRequiredRefField ref="ownedRequiredRef" />
	</mock>
</data>').firstElement();
		seed = ArpSeed.fromXml(xml);
		domain.loadSeed(seed);
		domain.rawTick.dispatch(1.0);

		slot = domain.query("value", MockOwnerMacroArpObject).slot();
		otherSlot = domain.query("otherValue", MockOwnerMacroArpObject).slot();
		arpObj = slot.value;

		domain.heatDownNow(slot);

		assertEquals(ArpHeat.Warm, otherSlot.heat);
		assertEquals(ArpHeat.Cold, arpObj.arpHeat);
		assertEquals(ArpHeat.Warm, arpObj.optionalRefField.arpHeat);
		assertEquals(ArpHeat.Cold, arpObj.ownedOptionalRefField.arpHeat);
		assertEquals(ArpHeat.Warm, arpObj.requiredRefField.arpHeat);
		assertEquals(ArpHeat.Cold, arpObj.ownedRequiredRefField.arpHeat);

		domain.heatUpkeep();

		assertEquals(ArpHeat.Warming, otherSlot.heat);
		assertEquals(ArpHeat.Cold, arpObj.arpHeat);
		assertEquals(ArpHeat.Warm, arpObj.optionalRefField.arpHeat);
		assertEquals(ArpHeat.Cold, arpObj.ownedOptionalRefField.arpHeat);
		assertEquals(ArpHeat.Warm, arpObj.requiredRefField.arpHeat);
		assertEquals(ArpHeat.Cold, arpObj.ownedRequiredRefField.arpHeat);

		domain.rawTick.dispatch(1.0);

		assertEquals(ArpHeat.Warm, otherSlot.heat);
		assertEquals(ArpHeat.Cold, arpObj.arpHeat);
		assertEquals(ArpHeat.Warm, arpObj.optionalRefField.arpHeat);
		assertEquals(ArpHeat.Warm, arpObj.ownedOptionalRefField.arpHeat);
		assertEquals(ArpHeat.Warm, arpObj.requiredRefField.arpHeat);
		assertEquals(ArpHeat.Warm, arpObj.ownedRequiredRefField.arpHeat);
	}
}
