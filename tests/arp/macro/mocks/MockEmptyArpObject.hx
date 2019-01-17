package arp.macro.mocks;

import arp.domain.IArpObject;

@:arpType("mock", "empty")
class MockEmptyArpObject implements IArpObject {
	public function new() return;
}
