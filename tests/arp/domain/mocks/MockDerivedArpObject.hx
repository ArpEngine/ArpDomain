package arp.domain.mocks;

import arp.domain.ArpUntypedSlot;
import arp.domain.core.ArpSid;
import arp.domain.core.ArpType;
import arp.persistable.IPersistInput;
import arp.persistable.IPersistOutput;
import arp.seed.ArpSeed;

@:arpNoGen
class MockDerivedArpObject extends MockArpObject {

	public var intField2:Int = 0;

	public var refField2Slot(default, null):ArpSlot<MockArpObject>;
	public var refField2(get, set):MockArpObject;
	inline private function get_refField2():MockArpObject return refField2Slot.value;
	inline private function set_refField2(value:MockArpObject):MockArpObject { refField2Slot = value.arpSlot; return value; }

	public function new() {
		super();
	}

	public static var _arpTypeInfo(default, never):ArpTypeInfo = new ArpTypeInfo("derived", new ArpType("mock"));
	override private function get_arpTypeInfo():ArpTypeInfo return _arpTypeInfo;
	override private function get_arpType():ArpType return _arpTypeInfo.arpType;

	override public function __arp_init(slot:ArpUntypedSlot):IArpObject {
		this.refField2Slot = slot.domain.nullSlot;
		return super.__arp_init(slot);
	}

	override public function __arp_heatLaterDeps():Void {
		super.__arp_heatLaterDeps();
		this._arpDomain.heatLater(this.refField2Slot);
	}

	override public function __arp_dispose():Void {
		super.__arp_dispose();
	}

	override private function arpConsumeSeedElement(element:ArpSeed):Void {
		switch (element.seedName) {
			case "intField2":
				this.intField2 = Std.parseInt(element.value);
			case "refField2":
				this.refField2Slot = this._arpDomain.loadSeed(element, new ArpType("mock"));
			default:
				super.arpConsumeSeedElement(element);
		}
	}

	override public function readSelf(input:IPersistInput):Void {
		super.readSelf(input);
		this.intField2 = input.readInt32("intField2");
		this.refField2Slot = this._arpDomain.getOrCreateSlot(new ArpSid(input.readUtf("refField")));
	}

	override public function writeSelf(output:IPersistOutput):Void {
		super.writeSelf(output);
		output.writeInt32("intField2", this.intField2);
		output.writeUtf("refField2", this.refField2Slot.sid.toString());
	}

	override public function arpClone(cloneMapper:arp.domain.IArpCloneMapper = null):IArpObject {
		var clone:MockDerivedArpObject = new MockDerivedArpObject();
		this._arpDomain.addOrphanObject(clone);
		clone.arpCopyFrom(this);
		return clone;
	}

	override public function arpCopyFrom(source:IArpObject, cloneMapper:arp.domain.IArpCloneMapper = null):IArpObject {
		var src:MockDerivedArpObject = cast source;
		this.intField2 = src.intField2;
		this.refField2 = src.refField2;
		return super.arpCopyFrom(source);
	}

}
