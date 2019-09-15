package arp.domain;

import arp.errors.loadErrors.ArpOccupiedReferenceError;
import arp.domain.prepare.ArpDomainGcScanner;
import arp.domain.prepare.ArpHeatUpkeepScanner;
import arp.data.DataGroup;
import arp.domain.ArpSlot;
import arp.domain.core.ArpDid;
import arp.domain.core.ArpSid;
import arp.domain.core.ArpType;
import arp.domain.dump.ArpDomainDump;
import arp.domain.events.ArpLogEvent;
import arp.domain.factory.ArpObjectFactoryRegistry;
import arp.domain.prepare.IPrepareStatus;
import arp.domain.prepare.PrepareQueue;
import arp.domain.query.ArpObjectQuery;
import arp.errors.ArpError;
import arp.events.ArpProgressEvent;
import arp.events.ArpSignal;
import arp.events.IArpSignalIn;
import arp.events.IArpSignalOut;
import arp.seed.ArpSeed;
import arp.seed.ArpSeedValueKind;
import arp.seed.SeedObject;
import arp.utils.ArpIdGenerator;

#if macro
import haxe.macro.Expr;
import arp.macro.MacroArpObjectRegistry;
#end

class ArpDomain {

	public var root(default, null):ArpDirectory;

	@:noDoc
	public var currentDir(get, never):ArpDirectory;
	private var currentDirStack:Array<ArpDirectory>;
	private function get_currentDir():ArpDirectory return currentDirStack[currentDirStack.length - 1];

	private var slots:Map<String, ArpUntypedSlot>;
	public var nullSlot(default, null):ArpUntypedSlot;

	private var prepareQueue:PrepareQueue;

	private var registry:ArpObjectFactoryRegistry;

	private var _did:ArpIdGenerator = new ArpIdGenerator();

	private var _rawTick:ArpSignal<Float>;
	public var rawTick(get, never):IArpSignalIn<Float>;
	inline private function get_rawTick():IArpSignalIn<Float> return this._rawTick;

	private var _prepareTick:ArpSignal<Float>;

	private var _tick:ArpSignal<Float>;
	public var tick(get, never):IArpSignalOut<Float>;
	inline private function get_tick():IArpSignalOut<Float> return this._tick;

	private var _onLog:ArpSignal<ArpLogEvent>;
	public var onLog(get, never):IArpSignalOut<ArpLogEvent>;
	inline private function get_onLog():IArpSignalOut<ArpLogEvent> return this._onLog;

	public var prepareStatus(get, never):IPrepareStatus;
	inline private function get_prepareStatus():IPrepareStatus return this.prepareQueue;

	public function new() {
		this._rawTick = new ArpSignal<Float>();
		this._prepareTick = new ArpSignal<Float>();
		this._tick = new ArpSignal<Float>();
		this._onLog = new ArpSignal<ArpLogEvent>();

		this.root = new ArpDirectory(this, ArpDid.rootDir());
		this.currentDirStack = [this.root];
		this.slots = new Map();
		this.nullSlot = this.allocSlot(ArpSid.nullSlot()).eternalReference();
		this.registry = new ArpObjectFactoryRegistry();
		this.prepareQueue = new PrepareQueue(this, this._rawTick);

		this._rawTick.push(this.onRawTick);

		this.addTemplate(DataGroup);
		this.addTemplate(SeedObject);
	}

	private function onRawTick(v:Float):Void {
		if (this.prepareQueue.isPending) {
			this._prepareTick.dispatch(v);
		} else {
			this._tick.dispatch(v);
		}
	}

	inline private function allocSlot(sid:ArpSid, dir:ArpDirectory = null):ArpUntypedSlot {
		var slot:ArpUntypedSlot = new ArpUntypedSlot(this, sid, dir);
		this.slots.set(sid.toString(), slot);
		return slot;
	}

	@:allow(arp.domain.ArpDirectory.getOrCreateSlot)
	private function createBoundSlot(dir:ArpDirectory, arpType:ArpType):ArpUntypedSlot {
		var sid:ArpSid = ArpSid.build(dir.did, arpType);
		return this.allocSlot(sid, dir);
	}

	inline private function createAnonymousSlot(arpType:ArpType):ArpUntypedSlot {
		var sid = ArpSid.build(new ArpDid(_did.next()), arpType);
		return this.allocSlot(sid, null);
	}

	@:allow(arp.domain.ArpUntypedSlot.delReference)
	private function freeSlot(slot:ArpUntypedSlot):Void {
		this.slots.remove(slot.sid.toString());
	}

	public function getSlot<T:IArpObject>(sid:ArpSid):ArpSlot<T> {
		return this.slots.get(sid.toString());
	}

	public function getOrCreateSlot<T:IArpObject>(sid:ArpSid):ArpSlot<T> {
		var slot:ArpSlot<T> = this.slots.get(sid.toString());
		if (slot != null) return slot;
		return allocSlot(sid);
	}

	inline public function dir(path:String = null):ArpDirectory {
		return this.root.dir(path);
	}

	inline public function obj<T:IArpObject>(path:String, type:Class<T>):T {
		return this.root.obj(path, type);
	}

	inline public function query<T:IArpObject>(path:String = null, type:ArpType = null):ArpObjectQuery<T> {
		return this.root.query(path, type);
	}

	public var allArpTypes(get, never):Array<ArpType>;
	public function get_allArpTypes():Array<ArpType> return this.registry.allArpTypes();

	public function addTemplate<T:IArpObject>(klass:Class<T>, forceDefault:Null<Bool> = null):Void {
		this.registry.addTemplate(klass, forceDefault);
	}

	public function autoAddTemplates():Void {
		return macroAutoAddTemplates();
	}

	macro private static function macroAutoAddTemplates():Expr {
		return MacroArpObjectRegistry.toAutoAddTemplates(macro this);
	}

	public function loadSeed<T:IArpObject>(seed:ArpSeed, lexicalType:ArpType = null):Null<ArpSlot<T>> {
		var arpType:ArpType = (lexicalType != null) ? lexicalType : new ArpType(seed.seedName);
		var slot:ArpSlot<T>;
		var name:String = seed.name;
		switch (seed.valueKind) {
			case ArpSeedValueKind.Reference, ArpSeedValueKind.Ambigious if (seed.value != null):
				slot = this.root.query(seed.value, arpType).slot();
			case _:
				var dir:ArpDirectory = null;
				if (name == null) {
					slot = this.createAnonymousSlot(arpType);
				} else {
					dir = this.currentDir.dir(name);
					slot = dir.getOrCreateSlot(arpType);
				}
				if (slot.value != null) {
					throw new ArpOccupiedReferenceError('Slot ${slot.sid} at dir ${dir.did} is already occupied');
				}
				if (dir != null) this.currentDirStack.push(dir);
				var arpObj:T = this.registry.resolveWithSeed(seed, arpType).arpInit(slot, seed);
				if (dir != null) this.currentDirStack.pop();
				if (arpObj != null) {
					slot.value = arpObj;
					switch (ArpHeat.fromName(seed.heat)) {
						case ArpHeat.Cold:
						case ArpHeat.Warming, ArpHeat.Warm: this.heatLater(slot);
					}
				}
		}
		return slot;
	}

	public function allocObject<T:IArpObject>(klass:Class<T>, args:Array<Dynamic> = null, dir:ArpDirectory = null):T {
		if (args == null) args = [];
		return this.addObject(Type.createInstance(klass, args), dir);
	}

	inline public function addOrphanObject<T:IArpObject>(arpObj:T, dir:ArpDirectory = null):T {
		return this.addObject(arpObj, dir);
	}

	private function addObject<T:IArpObject>(arpObj:T, dir:ArpDirectory = null):T {
		var slot:ArpSlot<T>;
		if (dir == null) {
			slot = this.createAnonymousSlot(arpObj.arpType);
		} else {
			slot = dir.getOrCreateSlot(arpObj.arpType);
		}
		slot.value = arpObj;
		arpObj.__arp_init(slot);
		return arpObj;
	}

	public function flush():Void {
		throw new ArpError("ArpDomain.flush() is not implemented");
	}

	public function gc():Void {
		ArpDomainGcScanner.execute(this);
		for (kv in this.slots.keyValueIterator()) {
			var v = kv.value;
			if (v.refCount < 0 && v != this.nullSlot) {
				this.slots.remove(kv.key);
			}
		}
		return;
	}

	public function log(category:String, message:String):Void {
		this._onLog.dispatch(new ArpLogEvent(category, message));
	}

	public function heatLater(slot:ArpUntypedSlot, nonblocking:Bool = false):Bool {
		switch (slot.heat) {
			case ArpHeat.Warm: return true;
			case ArpHeat.Warming: return false;
			case ArpHeat.Cold: this.prepareQueue.prepareLater(slot, nonblocking); return false;
		}
	}

	inline public function heatUpNow(slot:ArpUntypedSlot):Bool {
		if (slot.value == null) return true;
		return slot.value.arpHeatUpNow();

	}
	inline public function heatDownNow(slot:ArpUntypedSlot):Bool {
		if (slot.value == null) return true;
		return slot.value.arpHeatDownNow();
	}

	@:deprecated("heatDown() is renamed to heatDownNow()")
	inline public function heatDown(slot:ArpUntypedSlot):Void slot.value.arpHeatDownNow();

	inline public function heatUpkeep():Void ArpHeatUpkeepScanner.execute(this);

	public var isPending(get, never):Bool;
	inline public function get_isPending():Bool return this.prepareQueue.isPending;

	public var tasksProcessed(get, never):Int;
	inline private function get_tasksProcessed():Int return this.prepareQueue.tasksProcessed;

	public var tasksTotal(get, never):Int;
	inline private function get_tasksTotal():Int return this.prepareQueue.tasksTotal;

	public var tasksWaiting(get, never):Int;
	inline private function get_tasksWaiting():Int return this.prepareQueue.tasksWaiting;

	public var onPrepareComplete(get, never):IArpSignalOut<Int>;
	inline private function get_onPrepareComplete():IArpSignalOut<Int> return this.prepareQueue.onComplete;

	public var onPrepareError(get, never):IArpSignalOut<Dynamic>;
	inline private function get_onPrepareError():IArpSignalOut<Dynamic> return this.prepareQueue.onError;

	public var onPrepareProgress(get, never):IArpSignalOut<ArpProgressEvent>;
	inline private function get_onPrepareProgress():IArpSignalOut<ArpProgressEvent> return this.prepareQueue.onProgress;

	public function dumpEntries(typeFilter:ArpType->Bool = null):String {
		return ArpDomainDump.printer.format(new ArpDomainDump(this, typeFilter).dumpSlotStatus());
	}

	public function dumpEntriesByName(typeFilter:ArpType->Bool = null):String {
		return ArpDomainDump.printer.format(new ArpDomainDump(this, typeFilter).dumpSlotStatusByName());
	}

	public function waitFor(obj:IArpObject):Void this.prepareQueue.waitBySlot(obj.arpSlot);

	public function notifyFor(obj:IArpObject):Void this.prepareQueue.notifyBySlot(obj.arpSlot);
}
