package arp.macro.mocks;

import arp.domain.IArpObject;

@:arpType("mock", "macro")
class MockMacroArpObject implements IArpObject {

	@:arpField public var intField:Int = 1000000;
	@:arpField public var floatField:Float = 1000000;
	@:arpField public var boolField:Bool = false;
	@:arpField public var stringField:String = null;

	public var stringField2(get, set):String;
	private function get_stringField2():String return "stringField2";
	private function set_stringField2(value:String):String return value;

	@:arpField @:arpDefault("5678") public var intField3:Int = 1234;
	@:arpField @:arpDefault("6789") public var floatField3:Float = 2345;
	@:arpField @:arpDefault("true") public var boolField3:Bool = false;
	@:arpField @:arpDefault("stringDefault3") public var stringField3:String = null;

	@:arpBarrier @:arpField public var refField:MockMacroArpObject;

	@:arpField @:arpDefault("/name1") public var refField3:MockMacroArpObject;

	public function new() {
	}
}
