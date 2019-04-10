package arp.domain;

import arp.domain.ArpUntypedSlot;
import arp.domain.core.ArpDid;
import arp.domain.core.ArpSid;
import arp.domain.core.ArpType;
import arp.domain.query.ArpDirectoryQuery;
import arp.domain.query.ArpObjectQuery;
import arp.ds.impl.StdMap;

class ArpDirectory {

	inline public static var PATH_DELIMITER:String = "/";
	inline public static var PATH_CURRENT:String = "@";

	public var domain(default, null):ArpDomain;
	public var did(default, null):ArpDid;
	private var parent:ArpDirectory;
	private var children:StdMap<String, ArpDirectory>;
	private var slots:Map<String, ArpUntypedSlot>;
	private var refCount:Int = 0;

	@:allow(arp.domain.ArpDomain)
	private function new(domain:ArpDomain, did:ArpDid) {
		this.domain = domain;
		this.did = did;
		this.children = new StdMap<String, ArpDirectory>();
		this.slots = new Map();
	}

	@:allow(arp.domain.ArpUntypedSlot)
	inline private function addReference():ArpDirectory {
		this.refCount++;
		return this;
	}

	@:allow(arp.domain.ArpUntypedSlot)
	inline private function delReference():ArpDirectory {
		if (--this.refCount <= 0) this.free();
		return this;
	}

	private function free():Void {
		if (this.parent != null) {
			this.parent.children.remove(this);
			this.parent.delReference();
		}
	}

	public function getOrCreateSlot(type:ArpType):ArpUntypedSlot {
		if (this.slots.exists(type)) return this.slots.get(type);
		var slot:ArpUntypedSlot = this.domain.allocSlot(ArpSid.build(this.did, type));
		this.slots.set(type, slot);
		slot.addDirectory(this);
		return slot;
	}

	public function setSlot(type:ArpType, slot:ArpUntypedSlot):ArpUntypedSlot {
		this.slots.set(type, slot);
		slot.addDirectory(this);
		return slot;
	}

	public function getValue(type:ArpType):IArpObject {
		return this.getOrCreateSlot(type).value;
	}

	public function allocObject<T:IArpObject>(klass:Class<T>, args:Array<Dynamic> = null):T {
		if (args == null) args = [];
		return this.addObject(Type.createInstance(klass, args));
	}

	public function addOrphanObject<T:IArpObject>(arpObj:T):T {
		return this.addObject(arpObj);
	}

	private function addObject<T:IArpObject>(arpObj:T):T {
		var slot:ArpSlot<T> = this.getOrCreateSlot(arpObj.arpType);
		slot.value = arpObj;
		arpObj.__arp_init(slot);
		return arpObj;
	}

	public function child(name:String):ArpDirectory {
		if (this.children.hasKey(name)) return this.children.get(name);
		var child:ArpDirectory = this.domain.allocDir(ArpDid.build(this.did, name));
		this.children.set(name, child);
		child.parent = this.addReference();
		return child;
	}

	inline public function dir(path:String = null):ArpDirectory {
		return new ArpDirectoryQuery(this, path).directory();
	}

	inline public function obj<T:IArpObject>(path:String, type:Class<T>):T {
		return new ArpObjectQuery<T>(this, path, type).obj();
	}

	inline public function query<T:IArpObject>(path:String = null, type:ArpType = null):ArpObjectQuery<T> {
		return new ArpObjectQuery(this, path, type);
	}

	inline public function toString():String return '[${this.did}]';
}
