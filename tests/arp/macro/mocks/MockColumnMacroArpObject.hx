package arp.macro.mocks;

import arp.domain.IArpObject;

@:arpType("mock", "columnMacro")
class MockColumnMacroArpObject implements IArpObject {

	@:arpField("if") public var intField:Int = 0;
	@:arpField("ff") public var floatField:Float = 0;
	@:arpField("bf") public var boolField:Bool = false;
	@:arpField("sf") public var stringField:String = null;

	@:arpBarrier @:arpField("rf") public var refField:MockColumnMacroArpObject;

	public function new() {
	}
}
