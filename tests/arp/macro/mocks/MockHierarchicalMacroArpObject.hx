package arp.macro.mocks;

import arp.domain.IArpObject;

@:arpType("mock", "reference")
class MockHierarchicalMacroArpObject implements IArpObject {

	@:arpField public var refField:MockHierarchicalMacroArpObject;
	@:arpField @:arpDefault("default") public var defaultRefField:MockHierarchicalMacroArpObject;
	@:arpField @:arpDefault("bogus") public var bogusRefField:MockHierarchicalMacroArpObject;

	public function new() {
	}
}
