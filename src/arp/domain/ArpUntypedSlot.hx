package arp.domain;

import arp.domain.core.ArpSid;

@:allow(arp.domain.ArpSlot)
class ArpUntypedSlot {

	private var _domain:ArpDomain = null;
	public var domain(get, set):ArpDomain;
	inline private function get_domain():ArpDomain return this._domain;
	inline private function set_domain(value:ArpDomain):ArpDomain {
		return this._domain = value;
	}

	public var sid(default, null):ArpSid;

	private var _value:IArpObject = null;
	public var value(get, set):IArpObject;
	inline private function get_value():IArpObject return this._value;
	inline private function set_value(value:IArpObject):IArpObject {
		return this._value = value;
	}

	private var _primaryDir:Null<ArpDirectory>;

	public var primaryDir(get, never):Null<ArpDirectory>;
	inline public function get_primaryDir():Null<ArpDirectory> return _primaryDir;

	private var _refCount:Int = 0;
	public var refCount(get, never):Int;
	inline private function get_refCount():Int { return this._refCount; }

	inline public function addReference():ArpUntypedSlot { this._refCount++; return this; }
	/* inline */ public function delReference():ArpUntypedSlot {
		if (--this._refCount <= 0) {
			if (this._value != null) {
				this._value.__arp_dispose();
				this._value = null;
			}
			this._domain.freeSlot(this);
			this._primaryDir.delReference();
		}
		return this;
	}
	inline public function takeReference(from:ArpUntypedSlot):ArpUntypedSlot {
		this.addReference();
		from.delReference();
		return this;
	}

	inline public function eternalReference():ArpUntypedSlot return this.addReference();

	public var heat(default, null):ArpHeat = ArpHeat.Cold;

	inline public function heatUpNow():Bool return this._value.arpHeatUpNow();
	inline public function heatDownNow():Bool return this._value.arpHeatDownNow();
	inline public function heatLater(nonblocking:Bool = false):Bool return this._domain.heatLater(this, nonblocking);

	@:allow(arp.domain.ArpDomain.allocSlot)
	private function new(domain:ArpDomain, sid:ArpSid, dir:ArpDirectory) {
		this.domain = domain;
		this.sid = sid;
		this._primaryDir = dir;
		dir.addReference();
	}

	public function toString():String return '<$sid>';
	public function describe():String return '[ArpUntypedSlot <$sid> = $value[$refCount]]';
}
