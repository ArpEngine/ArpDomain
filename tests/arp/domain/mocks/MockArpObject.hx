package arp.domain.mocks;

import arp.domain.ArpTypeInfo;
import arp.domain.ArpUntypedSlot;
import arp.domain.core.ArpSid;
import arp.domain.core.ArpType;
import arp.persistable.IPersistInput;
import arp.persistable.IPersistOutput;
import arp.seed.ArpSeed;

@:arpNoGen
class MockArpObject implements IArpObject {

	public var intField:Int = 0;
	public var floatField:Float = 0;
	public var boolField:Bool = false;
	public var stringField:String = null;

	public var refFieldSlot(default, null):ArpSlot<MockArpObject>;
	public var refField(get, set):MockArpObject;
	inline private function get_refField():MockArpObject return refFieldSlot.value;
	inline private function set_refField(value:MockArpObject):MockArpObject { refFieldSlot = value.arpSlot; return value; }

	public function new() {
	}

	private var _arpDomain:ArpDomain;
	public var arpDomain(get, never):ArpDomain;
	private function get_arpDomain():ArpDomain return this._arpDomain;

	public static var _arpTypeInfo(default, never):ArpTypeInfo = new ArpTypeInfo("mock", new ArpType("mock"));
	public var arpTypeInfo(get, never):ArpTypeInfo;
	private function get_arpTypeInfo():ArpTypeInfo return _arpTypeInfo;
	public var arpType(get, never):ArpType;
	private function get_arpType():ArpType return _arpTypeInfo.arpType;

	private var _arpSlot:ArpSlot<MockArpObject>;
	public var arpSlot(get, never):ArpSlot<MockArpObject>;
	private function get_arpSlot():ArpSlot<MockArpObject> return this._arpSlot;

	public function arpInit(slot:ArpUntypedSlot, seed:ArpSeed = null):IArpObject {
		this._arpDomain = slot.domain;
		this._arpSlot = slot;
		this.refFieldSlot = slot.domain.nullSlot;
		if (seed != null) for (element in seed) this.arpConsumeSeedElement(element);
		this.init();
		return this;
	}

	public function init():Void {

	}

	public function arpHeatLater():Void {
		this._arpDomain.heatLater(this.refFieldSlot);
	}

	public function arpHeatUp():Bool {
		return this.heatUp();
	}

	public function heatUp():Bool {
		return true;
	}

	public function arpHeatDown():Bool {
		return this.heatDown();
	}

	public function heatDown():Bool {
		return true;
	}

	public function arpDispose():Void {
		this.dispose();
		this._arpSlot = null;
		this._arpDomain = null;
	}

	public function dispose():Void {

	}

	private function arpConsumeSeedElement(element:ArpSeed):Void {
		switch (element.seedName) {
			case "intField":
				this.intField = Std.parseInt(element.value);
			case "floatField":
				this.floatField = Std.parseFloat(element.value);
			case "boolField":
				this.boolField = element.value == "true";
			case "stringField":
				this.stringField = element.value;
			case "refField":
				this.refFieldSlot = this._arpDomain.loadSeed(element, new ArpType("mock"));
		}
	}

	public function readSelf(input:IPersistInput):Void {
		this.intField = input.readInt32("intField");
		this.floatField = input.readDouble("floatField");
		this.boolField = input.readBool("boolField");
		this.stringField = input.readUtf("stringField");
		this.refFieldSlot = this._arpDomain.getOrCreateSlot(new ArpSid(input.readUtf("refField")));
	}

	public function writeSelf(output:IPersistOutput):Void {
		output.writeInt32("intField", this.intField);
		output.writeDouble("floatField", this.floatField);
		output.writeBool("boolField", this.boolField);
		output.writeUtf("stringField", this.stringField);
		output.writeUtf("refField", this.refFieldSlot.sid.toString());
	}

	@:access(arp.domain.ArpDomain)
	public function arpClone():IArpObject {
		var clone:MockArpObject = new MockArpObject();
		clone.arpInit(this._arpDomain.allocSlot());
		clone.arpCopyFrom(this);
		return clone;
	}

	public function arpCopyFrom(source:IArpObject):IArpObject {
		var src:MockArpObject = cast source;
		this.intField = src.intField;
		this.floatField = src.floatField;
		this.boolField = src.boolField;
		this.stringField = src.stringField;
		this.refField = src.refField;
		return this;
	}

	public function toString() return '[mock ${this.arpSlot.sid}]';
}
