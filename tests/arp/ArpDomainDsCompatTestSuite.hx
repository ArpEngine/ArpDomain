package arp;

import arp.ds.ListCase;
import arp.ds.MapCase;
import arp.ds.OmapCase;
import arp.ds.SetCase;
import arp.testParams.ArpObjectDsImplProviders.*;
import picotest.PicoTestRunner;

class ArpDomainDsCompatTestSuite {
	public static function addTo(r:PicoTestRunner) {
		r.load(SetCase, arpObjectSetProvider());
		r.load(ListCase, arpObjectListProvider());
		r.load(MapCase, arpObjectMapProvider());
		r.load(OmapCase, arpObjectOmapProvider());
	}
}
