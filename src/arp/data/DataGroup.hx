package arp.data;

import arp.domain.ArpDirectory;
import arp.domain.ArpDomain;
import arp.domain.ArpHeat;
import arp.domain.ArpSlot;
import arp.domain.ArpTypeInfo;
import arp.domain.ArpUntypedSlot;
import arp.domain.core.ArpOverwriteStrategy;
import arp.domain.core.ArpType;
import arp.domain.IArpObject;
import arp.errors.ArpError;
import arp.persistable.IPersistInput;
import arp.persistable.IPersistOutput;
import arp.seed.ArpSeed;

@:arpOverwrite(Merge)
@:arpType("data", "data")
@:arpNoGen
class DataGroup implements IArpObject {

	// ISSUE can we omit creating anonymous DataGroup at all?

	private var name:String;
	private var children:Array<ArpUntypedSlot>;

	public function new(children:Array<ArpUntypedSlot> = null) {
		if (children == null) children = [];
		this.children = children;
	}

	private var _arpDomain:ArpDomain;
	public var arpDomain(get, never):ArpDomain;
	inline private function get_arpDomain():ArpDomain return this._arpDomain;

	public static var _arpTypeInfo(default, never):ArpTypeInfo = new ArpTypeInfo("data", new ArpType("data"), ArpOverwriteStrategy.Merge);
	public var arpTypeInfo(get, never):ArpTypeInfo;
	private function get_arpTypeInfo():ArpTypeInfo return _arpTypeInfo;

	public var arpType(get, never):ArpType;
	private function get_arpType():ArpType return _arpTypeInfo.arpType;

	private var _arpSlot:ArpSlot<DataGroup>;
	public var arpSlot(get, never):ArpSlot<DataGroup>;
	inline private function get_arpSlot():ArpSlot<DataGroup> return this._arpSlot;

	public var arpHeat(get, never):ArpHeat;
	inline private function get_arpHeat():ArpHeat return this._arpSlot.heat;

	public function __arp_init(slot:ArpUntypedSlot):IArpObject {
		this._arpDomain = slot.domain;
		this._arpSlot = slot;
		return this;
	}

	public function __arp_loadSeed(seed:ArpSeed):Void {
		this.name = seed.name;
		if (this.name != null && this.children == null) {
			this.children = [];
			this.arpSlot.eternalReference();
		}
		for (element in seed) this.arpConsumeSeedElement(element);
	}

	public function __arp_heatLaterDeps():Void {
		for (slot in this.children) this.arpDomain.heatLater(slot);
	}

	public function arpHeatUpNow():Bool {
		return true;
	}

	public function arpHeatDownNow():Bool {
		return true;
	}

	inline public function arpHeatLater(nonblocking:Bool = false):Bool return this._arpDomain.heatLater(this._arpSlot, nonblocking);

	public function __arp_dispose():Void {
		for (slot in this.children) slot.delReference();
		this._arpSlot = null;
		this._arpDomain = null;
	}

	private function arpConsumeSeedElement(element:ArpSeed):Void {
		// NOTE seed iterates through value, which we must ignore
		if (element.seedName == "value") return;

		var slot = this.arpDomain.loadSeed(element).addReference();
		if (slot != null) {
			if (this.name != null) {
				this.children.push(slot);
			} else {
				slot.eternalReference();
			}
		}
	}

	public function readSelf(input:IPersistInput):Void {
	}

	public function writeSelf(output:IPersistOutput):Void {
	}

	public function arpClone(cloneMapper:arp.domain.IArpCloneMapper = null):IArpObject {
		throw new ArpError("not supported");
	}

	public function arpCopyFrom(source:IArpObject, cloneMapper:arp.domain.IArpCloneMapper = null):IArpObject {
		throw new ArpError("not supported");
	}

	public function add(slot:ArpUntypedSlot):Void {
		this.children.push(slot);
	}

	public function allocObject<T:IArpObject>(klass:Class<T>, args:Array<Dynamic> = null, dir:ArpDirectory = null):T {
		var obj:T = this.arpDomain.allocObject(klass, args, dir);
		this.children.push(obj.arpSlot);
		return obj;
	}

	public function addOrphanObject<T:IArpObject>(arpObj:T, dir:ArpDirectory = null):T {
		var obj:T = this.arpDomain.addOrphanObject(arpObj, dir);
		this.children.push(obj.arpSlot);
		return obj;
	}
}
