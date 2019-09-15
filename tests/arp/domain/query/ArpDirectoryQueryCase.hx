package arp.domain.query;

import arp.domain.core.ArpType;
import arp.domain.mocks.MockArpObject;
import picotest.PicoAssert.*;

class ArpDirectoryQueryCase {

	private var domain:ArpDomain;
	private var child:ArpDirectory;
	private var dir:ArpDirectory;
	private var arpObject:IArpObject;
	private var arpType:ArpType;

	public function setup():Void {
		domain = new ArpDomain();
		child = domain.root.child("path");
		dir = child.child("to").child("dir");
		arpObject = new MockArpObject();
		arpType = arpObject.arpType;
		dir.addOrphanObject(arpObject);
	}

	public function testAbsoluteDirectoryFromRoot():Void {
		var query:ArpDirectoryQuery = new ArpDirectoryQuery(domain.root, "/path/to/dir");
		var actual:ArpDirectory = query.directory();
		assertEquals(dir, actual);
	}

	public function testRelativeDirectoryFromRoot():Void {
		var query:ArpDirectoryQuery = new ArpDirectoryQuery(domain.root, "path/to/dir");
		var actual:ArpDirectory = query.directory();
		assertEquals(dir, actual);
	}

	public function testAbsoluteDirectory():Void {
		var query:ArpDirectoryQuery = new ArpDirectoryQuery(child, "/path/to/dir");
		var actual:ArpDirectory = query.directory();
		assertEquals(dir, actual);
	}

	public function testRelativeDirectory():Void {
		var query:ArpDirectoryQuery = new ArpDirectoryQuery(child, "to/dir");
		var actual:ArpDirectory = query.directory();
		assertEquals(dir, actual);
	}

	public function testEmptyQuery():Void {
		var query:ArpDirectoryQuery = new ArpDirectoryQuery(child, "");
		var actual:ArpDirectory = query.directory();
		assertEquals(child, actual);
	}

	public function testTerseQuery():Void {
		var query:ArpDirectoryQuery = new ArpDirectoryQuery(child, "///path///to///dir//");
		var actual:ArpDirectory = query.directory();
		assertEquals(dir, actual);
	}

	public function testParentQuery():Void {
		var query:ArpDirectoryQuery = new ArpDirectoryQuery(dir, "../..");
		var actual:ArpDirectory = query.directory();
		assertEquals(child, actual);
	}

}
