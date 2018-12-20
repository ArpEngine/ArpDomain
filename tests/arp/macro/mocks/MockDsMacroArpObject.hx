package arp.macro.mocks;

import arp.domain.IArpObject;
import arp.ds.IList;
import arp.ds.IMap;
import arp.ds.impl.ArraySet;
import arp.ds.IOmap;
import arp.ds.ISet;

@:arpType("mock", "stdMacro")
class MockDsMacroArpObject implements IArpObject {

	@:arpField public var intSet:ISet<Int>;
	@:arpField public var intList:IList<Int>;
	@:arpField public var intMap:IMap<String, Int>;
	@:arpField public var intOmap:IOmap<String, Int>;

	@:arpField public var refSet:ISet<MockDsMacroArpObject>;
	@:arpField public var refList:IList<MockDsMacroArpObject>;
	@:arpField public var refMap:IMap<String, MockDsMacroArpObject>;
	@:arpField public var refOmap:IOmap<String, MockDsMacroArpObject>;

	@:arpField public var intISet:ISet<Int> = new ArraySet<Int>();
	@:arpField public var intArraySet:ArraySet<Int> = new ArraySet<Int>();
	// @:arpField public var intStdMapSet:StdMapSet<Int>;
	// @:arpField public var refISet:ISet<MockDsMacroArpObject> = new ArpObjectSet<MockDsMacroArpObject>();
	// @:arpField public var refArpObjectSet:ArpObjectSet<MockDsMacroArpObject>;

	public function new() {
	}
}
