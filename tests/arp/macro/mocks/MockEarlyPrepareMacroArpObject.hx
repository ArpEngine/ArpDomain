package arp.macro.mocks;

import arp.domain.IArpObject;

@:arpType("mock", "earlyPrepare")
class MockEarlyPrepareMacroArpObject implements IArpObject {

	public var volatileInt:Int = 0;

	public function new() {
	}

	@:arpHeatUp
	public function heatUp():Bool {
		this.volatileInt = 1;
		return true;
	}

	@:arpHeatDown
	public function heatDown():Bool {
		this.volatileInt = 0;
		return true;
	}

}
