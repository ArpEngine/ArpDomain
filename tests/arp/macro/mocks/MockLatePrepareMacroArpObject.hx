package arp.macro.mocks;

import arp.domain.IArpObject;
import picotest.PicoTestAsync.*;

@:arpType("mock", "latePrepare")
class MockLatePrepareMacroArpObject implements IArpObject {

	public var volatileInt:Int = 0;
	private var warming:Bool;

	public function new() {
	}

	@:arpHeatUp
	public function heatUp():Bool {
		if (this.volatileInt == 1) return true;
		if (!this.warming) {
			this.arpDomain.waitFor(this);
			this.warming = true;
			createCallback(
				function():Void return,
				1000,
				function():Void {
					this.warming = false;
					this.volatileInt = 1;
					this.arpDomain.notifyFor(this);
				}
			);
		}
		return !this.warming;
	}

	@:arpHeatDown
	public function heatDown():Bool {
		this.volatileInt = 0;
		this.warming = false;
		return true;
	}

}
