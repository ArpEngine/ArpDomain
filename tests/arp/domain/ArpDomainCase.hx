package arp.domain;

import arp.domain.core.ArpType;
import arp.domain.events.ArpLogEvent;
import arp.domain.mocks.MockArpObject;
import arp.seed.ArpSeed;

import picotest.PicoAssert.*;
import org.hamcrest.Matchers.*;

class ArpDomainCase {

	private var domain:ArpDomain;
	private var xml:Xml;
	private var seed:ArpSeed;

	public function setup():Void {
		domain = new ArpDomain();
		domain.addTemplate(MockArpObject, true);
		xml = Xml.parse('<data>
		<mock name="name1" intField="42" floatField="3.14" boolField="true" stringField="stringValue" refField="/name1" />
		<mock name="name2" refField="/name1" />
		<mock name="name3" />
		</data>
		').firstElement();
		seed = ArpSeed.fromXml(xml);
		domain.loadSeed(seed, new ArpType("data"));
	}

	public function testAllArpTypes():Void {
		assertMatch(containsInAnyOrder("mock", "data", "seed"), domain.allArpTypes);
	}

	public function testDumpEntries():Void {
		var DUMP:String = '# <<slots>> {
-   $$0:data [0]
!   $$null [0]
-   /name1:mock [1]
-   /name2:mock [1]
-   /name3:mock [1]
  }
';
		var DUMP_BY_NAME:String = '% <<dir>>:  {
%   name1: /name1 {
-     <mock>: /name1:mock [1]
    }
%   name2: /name2 {
-     <mock>: /name2:mock [1]
    }
%   name3: /name3 {
-     <mock>: /name3:mock [1]
    }
-   <<anonymous>>: $$0:data [0]
!   <<anonymous>>: $$null [0]
  }
';
		assertEquals(DUMP, domain.dumpEntries());
		assertEquals(DUMP_BY_NAME, domain.dumpEntriesByName());
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

	public function testLog():Void {
		var event:ArpLogEvent;
		domain.onLog.push(function(e:ArpLogEvent):Void {
			event = e;
		});
		domain.log("category1", "message2");
		assertEquals("category1", event.category);
		assertEquals("message2", event.message);
	}

	public function testGc():Void {
		var DUMP:String = '# <<slots>> {
-   $$0:data [0]
!   $$null [0]
-   /name2:mock [1]
-   /name3:mock [1]
  }
';
		var DUMP_BY_NAME:String = '% <<dir>>:  {
%   name2: /name2 {
-     <mock>: /name2:mock [1]
    }
%   name3: /name3 {
-     <mock>: /name3:mock [1]
    }
-   <<anonymous>>: $$0:data [0]
!   <<anonymous>>: $$null [0]
  }
';
		domain.query("name1", new ArpType("mock")).slot().delReference();
		//domain.gc();
		assertEquals(DUMP, domain.dumpEntries());
		assertEquals(DUMP_BY_NAME, domain.dumpEntriesByName());
	}

}
