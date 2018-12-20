package arp.macro.mocks;

import arp.domain.IArpObject;

@:arpType("mock", "hookMacro")
class MockHookMacroArpObject implements IArpObject {

	public var volatileInt:Int = 0;

	@:arpField public var refField:MockHookMacroArpObject;

	public function new() {
	}

	@:arpInit
	public function init():Void {
		this.volatileInt = 1;
	}

	@:arpDispose
	public function dispose():Void {
		this.volatileInt = 0;
	}

}
