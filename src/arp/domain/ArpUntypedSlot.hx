package arp.domain;

import arp.domain.core.ArpType;
import arp.errors.ArpError;
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

	private var _primaryDir:ArpDirectory;

	public var primaryDir(get, never):ArpDirectory;
	inline public function get_primaryDir():ArpDirectory return _primaryDir;

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
			if (this._primaryDir != null) this._primaryDir.delReference();
		}
		return this;
	}
	inline public function takeReference(from:ArpUntypedSlot):ArpUntypedSlot {
		this.addReference();
		from.delReference();
		return this;
	}

	private var _heat:ArpHeat = ArpHeat.Cold;
	public var heat(get, set):ArpHeat;
	inline private function get_heat():ArpHeat { return this._heat; }
	inline private function set_heat(value:ArpHeat):ArpHeat { return this._heat = value; }

	private function new(domain:ArpDomain, sid:ArpSid, dir:ArpDirectory = null) {
		this.domain = domain;
		this._primaryDir = dir;
		this.sid = sid;
	}

	@:allow(arp.domain.ArpDomain)
	private static function createBound(domain:ArpDomain, dir:ArpDirectory, type:ArpType) {
		return new ArpUntypedSlot(domain, ArpSid.build(dir.did, type), dir);
	}

	@:allow(arp.domain.ArpDomain)
	private static function createUnbound(domain:ArpDomain, sid:ArpSid) {
		return new ArpUntypedSlot(domain, sid, null);
	}

	public function toString():String return '<$sid>';
	public function describe():String return '[ArpUntypedSlot <$sid> = $value[$refCount]]';
}
