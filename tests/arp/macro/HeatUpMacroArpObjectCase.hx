package arp.macro;

import arp.domain.ArpDomain;
import arp.domain.ArpHeat;
import arp.domain.ArpSlot;
import arp.domain.core.ArpType;
import arp.macro.mocks.MockMacroArpObject;
import arp.seed.ArpSeed;
import picotest.PicoAssert.*;

class HeatUpMacroArpObjectCase {

	private var domain:ArpDomain;
	private var slot:ArpSlot<MockMacroArpObject>;
	private var arpObj:MockMacroArpObject;
	private var xml:Xml;
	private var seed:ArpSeed;

	public function setup():Void {
		domain = new ArpDomain();
		domain.addTemplate(MockMacroArpObject, true);
		xml = Xml.parse('<data>
		<mock name="name1" intField="42" floatField="3.14" boolField="true" stringField="stringValue" refField="" />
		<mock name="name2" refField="/name1" />
		<mock name="name3" />
		<mock name="name4" heat="warm" />
		</data>
		').firstElement();
		seed = ArpSeed.fromXml(xml);
		domain.loadSeed(seed, new ArpType("data"));
	}

	public function testHeatUp():Void {
		var query = domain.query("name1", new ArpType("mock"));
		assertEquals(ArpHeat.Cold, query.slot().heat);
		query.heatLater();
		assertEquals(ArpHeat.Warming, query.slot().heat);
		domain.rawTick.dispatch(1.0);
		assertEquals(ArpHeat.Warm, query.slot().heat);
	}

	public function testHeatUpDependent():Void {
		var query1 = domain.query("name1", new ArpType("mock"));
		var query2 = domain.query("name2", new ArpType("mock"));
		assertEquals(ArpHeat.Cold, query1.slot().heat);
		assertEquals(ArpHeat.Cold, query2.slot().heat);
		query2.heatLater();
		assertEquals(ArpHeat.Cold, query1.slot().heat);
		assertEquals(ArpHeat.Warming, query2.slot().heat);
		domain.rawTick.dispatch(1.0);
		assertEquals(ArpHeat.Warm, query1.slot().heat);
		assertEquals(ArpHeat.Warm, query2.slot().heat);
	}

	public function testAutoHeatUp():Void {
		var query = domain.query("name4", new ArpType("mock"));
		assertEquals(ArpHeat.Warming, query.slot().heat);
		domain.rawTick.dispatch(1.0);
		assertEquals(ArpHeat.Warm, query.slot().heat);
	}

}
