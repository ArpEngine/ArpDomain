package arp.seed;

import arp.domain.ArpDirectory;
import arp.domain.ArpDomain;
import arp.domain.ArpHeat;
import arp.domain.ArpSlot;
import arp.domain.ArpTypeInfo;
import arp.domain.ArpUntypedSlot;
import arp.domain.core.ArpType;
import arp.domain.IArpObject;
import arp.errors.ArpError;
import arp.persistable.IPersistInput;
import arp.persistable.IPersistOutput;
import arp.seed.ArpSeed;

@:arpType("seed", "seed")
@:arpNoGen
class SeedObject implements IArpObject {

	private var seeds:Array<ArpSeed>;

	public function new(children:Array<ArpUntypedSlot> = null) {
		this.seeds = [];
	}

	private var _arpDomain:ArpDomain;
	public var arpDomain(get, never):ArpDomain;
	inline private function get_arpDomain():ArpDomain return this._arpDomain;

	public static var _arpTypeInfo(default, never):ArpTypeInfo = new ArpTypeInfo("seed", new ArpType("seed"));
	public var arpTypeInfo(get, never):ArpTypeInfo;
	private function get_arpTypeInfo():ArpTypeInfo return _arpTypeInfo;

	public var arpType(get, never):ArpType;
	private function get_arpType():ArpType return _arpTypeInfo.arpType;

	private var _arpSlot:ArpSlot<SeedObject>;
	public var arpSlot(get, never):ArpSlot<SeedObject>;
	inline private function get_arpSlot():ArpSlot<SeedObject> return this._arpSlot;

	public var arpHeat(get, never):ArpHeat;
	inline private function get_arpHeat():ArpHeat return this._arpSlot.heat;

	public function __arp_init(slot:ArpUntypedSlot):IArpObject {
		this._arpDomain = slot.domain;
		this._arpSlot = slot;
		return this;
	}

	public function __arp_loadSeed(seed:ArpSeed):Void {
		for (element in seed) this.arpConsumeSeedElement(element);
	}

	public function __arp_heatLaterDeps():Void {
	}

	public function arpHeatUpNow():Bool {
		return true;
	}

	public function arpHeatDownNow():Bool {
		return true;
	}

	inline public function arpHeatLater(nonblocking:Bool = false):Bool return this._arpDomain.heatLater(this._arpSlot, nonblocking);

	public function __arp_dispose():Void {
		this._arpSlot = null;
		this._arpDomain = null;
	}

	private function arpConsumeSeedElement(element:ArpSeed):Void {
		// NOTE seed iterates through value, which we must ignore
		if (element.seedName == "value") return;

		this.seeds.push(element);
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

	public function loadSeed<T:IArpObject>(path:String = null):Null<ArpSlot<T>> {
		var dir:ArpDirectory = if (path == null) null else this.arpDomain.dir(path);
		var result = null;

		if (dir != null) @:privateAccess this.arpDomain.currentDirStack.push(dir);
		for (seed in this.seeds) result = this.arpDomain.loadSeed(seed);
		if (dir != null) @:privateAccess this.arpDomain.currentDirStack.pop();

		return result;
	}

	@:access(arp.domain.ArpDomain._did)
	public function instantiate<T:IArpObject>(namePrefix:String = null):T {
		return loadSeed(this.arpDomain._did.next(namePrefix)).value;
	}
}
