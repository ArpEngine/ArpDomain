package arp.macro.mocks;

import arp.domain.IArpObject;

@:arpType("mock", "default")
class MockDefaultMacroArpObject implements IArpObject {

	@:arpField @:arpDefault("5678") public var intField:Int = 1234;
	@:arpField @:arpDefault("6789") public var floatField:Float = 2345;
	@:arpField @:arpDefault("true") public var boolField:Bool = false;
	@:arpField @:arpDefault("stringDefault3") public var stringField:String = null;

	@:arpField @:arpDefault("/name1") public var refField:MockDefaultMacroArpObject;

	public function new() {
	}
}
