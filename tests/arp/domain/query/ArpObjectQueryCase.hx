package arp.domain.query;

import arp.domain.core.ArpType;
import arp.domain.mocks.MockArpObject;
import picotest.PicoAssert.*;

class ArpObjectQueryCase {

	private var domain:ArpDomain;
	private var dir:ArpDirectory;
	private var arpObject:IArpObject;
	private var arpType:ArpType;

	public function setup():Void {
		domain = new ArpDomain();
		dir = domain.root.child("path").child("to").child("dir");
		arpObject = new MockArpObject();
		arpType = arpObject.arpType;
		dir.addOrphanObject(arpObject);
	}

	public function testSlot():Void {
		var query:ArpObjectQuery<IArpObject> = new ArpObjectQuery<IArpObject>(domain.root, "path/to/dir", arpType);
		var actual:ArpSlot<IArpObject> = query.slot();
		assertEquals(dir.getOrCreateSlot(arpType), actual);
	}

	public function testValue():Void {
		var query:ArpObjectQuery<IArpObject> = new ArpObjectQuery<IArpObject>(domain.root, "path/to/dir", arpType);
		var actual:IArpObject = query.value();
		assertEquals(arpObject, actual);
	}

}
