package arp.macro.mocks;

@:arpType("mock", "macroDerived")
class MockMacroDerivedArpObject extends MockMacroArpObject {

	@:arpField public var intField2:Int = 0;
	@:arpField public var stringField2:String = null;
	@:arpBarrier @:arpField public var refField2:MockMacroDerivedArpObject;

	public function new() {
		super();
	}
}
