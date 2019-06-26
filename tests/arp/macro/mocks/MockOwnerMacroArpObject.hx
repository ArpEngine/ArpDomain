package arp.macro.mocks;

import arp.domain.IArpObject;

@:arpType("mock", "owner")
class MockOwnerMacroArpObject extends MockEmptyArpObject implements IArpObject {

	@:arpField @:arpBarrier(false) public var optionalRefField:MockEmptyArpObject;
	@:arpField @:arpBarrier(false, true) public var ownedOptionalRefField:MockEmptyArpObject;
	@:arpField @:arpBarrier(true) public var requiredRefField:MockEmptyArpObject;
	@:arpField @:arpBarrier(true, true) public var ownedRequiredRefField:MockEmptyArpObject;

	public function new() super();
}
