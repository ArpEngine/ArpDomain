package arp.macro.mocks;

import arp.domain.IArpObject;

@:arpType("mock", "stdDsMacro")
class MockStdDsMacroArpObject implements IArpObject {

	@:arpField public var intStdArray:Array<Int>;
	@:arpField public var intStdList:List<Int>;
	@:arpField public var intStdMap:Map<String, Int>;
	@:arpField public var floatStdArray:Array<Float>;
	@:arpField public var floatStdList:List<Float>;
	@:arpField public var floatStdMap:Map<String, Float>;
	@:arpField public var boolStdArray:Array<Bool>;
	@:arpField public var boolStdList:List<Bool>;
	@:arpField public var boolStdMap:Map<String, Bool>;
	@:arpField public var stringStdArray:Array<String>;
	@:arpField public var stringStdList:List<String>;
	@:arpField public var stringStdMap:Map<String, String>;

	// @:arpField public var refStdArray:Array<MockStdDsMacroArpObject>;
	// @:arpField public var refStdList:List<MockStdDsMacroArpObject>;
	@:arpField public var refStdMap:Map<String, MockStdDsMacroArpObject>;

	public function new() {
	}
}
