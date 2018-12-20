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

	private var _primaryDir:ArpDirectory;
	private var _dirs:Array<ArpDirectory>;

	public var primaryDir(get, never):ArpDirectory;
	inline public function get_primaryDir():ArpDirectory return _primaryDir;

	@:allow(arp.domain.ArpDirectory)
	inline private function addDirectory(dir:ArpDirectory):Void {
		dir.addReference();
		if (this._primaryDir == null) {
			this._primaryDir = dir;
		} else {
			if (_dirs == null) _dirs = [];
			_dirs.push(_primaryDir);
		}
	}

	private var _refCount:Int = 0;
	public var refCount(get, never):Int;
	inline private function get_refCount():Int { return this._refCount; }

	inline public function addReference():ArpUntypedSlot { this._refCount++; return this; }
	/* inline */ public function delReference():ArpUntypedSlot {
		if (--this._refCount <= 0) {
			if (this._value != null) {
				this._value.arpDispose();
				this._value = null;
			}
			this._domain.freeSlot(this);
			if (this._primaryDir != null) this._primaryDir.delReference();
			if (this._dirs != null) {
				for (dir in this._dirs) dir.delReference();
			}
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

	@:allow(arp.domain.ArpDomain)
	private function new(domain:ArpDomain, sid:ArpSid) {
		this.domain = domain;
		this.sid = sid;
	}

	public function toString():String return '<$sid>';
	public function describe():String return '[ArpUntypedSlot <$sid> = $value[$refCount]]';
}
