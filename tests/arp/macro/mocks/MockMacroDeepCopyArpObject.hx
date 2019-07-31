package arp.macro.mocks;

import arp.domain.IArpObject;

@:arpType("mock", "macro")
class MockMacroDeepCopyArpObject implements IArpObject {

	@:arpField public var stringField:String = null;

	@:arpBarrier @:arpDeepCopy @:arpField public var refField:MockMacroDeepCopyArpObject;
	@:arpBarrier @:arpField public var refField2:MockMacroDeepCopyArpObject;

	public function new() return;
}
