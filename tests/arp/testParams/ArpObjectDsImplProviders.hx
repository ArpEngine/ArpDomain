package arp.testParams;

import arp.domain.ArpDomain;
import arp.domain.ds.ArpObjectList;
import arp.domain.ds.ArpObjectMap;
import arp.domain.ds.ArpObjectOmap;
import arp.domain.ds.ArpObjectSet;
import arp.domain.IArpObject;
import arp.domain.mocks.MockArpObject;
import arp.ds.IList;
import arp.ds.IMap;
import arp.ds.IOmap;
import arp.ds.ISet;
import arp.testFixtures.ArpDsTestDomain;
import arp.testFixtures.ArpSupportFixtures.DsStringFixture;

class ArpObjectDsImplProviders {

	public static function arpObjectSetProvider():Iterable<Array<Dynamic>> {
		var domain1:ArpDomain = new ArpDsTestDomain(false);
		var domain2:ArpDomain = new ArpDsTestDomain(true);
		return [
			[new ArpObjectSetProvider<MockArpObject>(domain1), domain1],
			[new ArpObjectSetProvider<MockArpObject>(domain2), domain2]
		];
	}

	public static function arpObjectListProvider():Iterable<Array<Dynamic>> {
		var domain1:ArpDomain = new ArpDsTestDomain(false);
		var domain2:ArpDomain = new ArpDsTestDomain(true);
		return [
			[new ArpObjectListProvider<MockArpObject>(domain1), domain1],
			[new ArpObjectListProvider<MockArpObject>(domain2), domain2]
		];
	}

	public static function arpObjectMapProvider():Iterable<Array<Dynamic>> {
		var domain1:ArpDomain = new ArpDsTestDomain(false);
		var domain2:ArpDomain = new ArpDsTestDomain(true);
		return [
			[new ArpObjectMapProvider<String, MockArpObject>(domain1), new DsStringFixture(), domain1],
			[new ArpObjectMapProvider<String, MockArpObject>(domain2), new DsStringFixture(), domain2]
		];
	}

	public static function arpObjectOmapProvider():Iterable<Array<Dynamic>> {
		var domain1:ArpDomain = new ArpDsTestDomain(false);
		var domain2:ArpDomain = new ArpDsTestDomain(true);
		return [
			[new ArpObjectOmapProvider<String, MockArpObject>(domain1), new DsStringFixture(), domain2],
			[new ArpObjectOmapProvider<String, MockArpObject>(domain2), new DsStringFixture(), domain2]
		];
	}
}

typedef IArpObjectDsImplProvider<T> = {
	function create():T;
}

@:generic @:remove
class ArpObjectSetProvider<V:IArpObject> {
	private var domain:ArpDomain;
	public function new(domain:ArpDomain) this.domain = domain;
	public function create():ISet<V> return new ArpObjectSet<V>(this.domain);
	public function isStrictToString():Bool return false;
}

@:generic @:remove
class ArpObjectListProvider<V:IArpObject> {
	private var domain:ArpDomain;
	public function new(domain:ArpDomain) this.domain = domain;
	public function create():IList<V> return new ArpObjectList<V>(this.domain);
	public function isStrictToString():Bool return false;
}

@:generic @:remove
class ArpObjectMapProvider<K, V:IArpObject> {
	private var domain:ArpDomain;
	public function new(domain:ArpDomain) this.domain = domain;
	public function create():IMap<K, V> return new ArpObjectMap<K, V>(this.domain);
	public function isStrictToString():Bool return false;
}

@:generic @:remove
class ArpObjectOmapProvider<K, V:IArpObject> {
	private var domain:ArpDomain;
	public function new(domain:ArpDomain) this.domain = domain;
	public function create():IOmap<K, V> return new ArpObjectOmap<K, V>(this.domain);
	public function isStrictToString():Bool return false;
}
