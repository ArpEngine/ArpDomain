package arp.macro.mocks;

import arp.ds.IList;
import arp.ds.ISet;
import arp.domain.IArpObject;

@:arpType("mock", "default")
class MockDefaultMacroArpObject implements IArpObject {

	@:arpField @:arpDefault("5678") public var intField:Int = 1234;
	@:arpField @:arpDefault("6789") public var floatField:Float = 2345;
	@:arpField @:arpDefault("true") public var boolField:Bool = false;
	@:arpField @:arpDefault("stringDefault3") public var stringField:String = null;

	@:arpField @:arpDefault("/name1") public var refField:MockDefaultMacroArpObject;

	@:arpField @:arpDefault("123", "456") public var intSet:ISet<Int>;
	@:arpField @:arpDefault("234", "567") public var intList:IList<Int>;

	@:arpField @:arpDefault("/name1", "/name1") public var refSet:ISet<MockDefaultMacroArpObject>;
	@:arpField @:arpDefault("/name1", "/name1") public var refList:IList<MockDefaultMacroArpObject>;

	public function new() {
	}
}
