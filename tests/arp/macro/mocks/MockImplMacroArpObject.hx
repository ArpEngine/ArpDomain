package arp.macro.mocks;

import arp.domain.ArpHeat;
import arp.domain.IArpObject;

@:arpType("mock", "impl")
class MockImplMacroArpObject implements IArpObject {

	@:arpField public var map:Map<String, Int>;
	@:arpImpl public var impl:MockImpl;
	public var native:String;

	public function new() {
		this.native = "nativeValue";
	}
}

class MockImpl {
	public var obj:MockImplMacroArpObject;
	public var map:Map<String, Int>;
	public var mapCount:Int;
	public var native:String;
	public var initialHeat:ArpHeat = cast -1;
	public var currentHeat:ArpHeat = cast -1;

	public function new(obj:MockImplMacroArpObject) {
		this.obj = obj;
		this.map = obj.map;
		this.mapCount = if (this.map == null) -1 else [for (x in this.map.iterator()) x].length;
		this.native = obj.native;
		this.initialHeat = this.currentHeat;
	}

	public function arpHeatUpNow():Bool {
		currentHeat = ArpHeat.Warm;
		return true;
	}
	public function arpHeatDownNow():Bool {
		currentHeat = ArpHeat.Cold;
		return true;
	}
	public function __arp_dispose():Void return;
}
