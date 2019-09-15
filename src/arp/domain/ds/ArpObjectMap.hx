package arp.domain.ds;

import arp.domain.ArpSlot;
import arp.domain.core.ArpSid;
import arp.ds.access.IMapAmend.IMapAmendCursor;
import arp.ds.IMap;
import arp.ds.impl.StdMap;
import arp.ds.lambda.CollectionTools;
import arp.persistable.IPersistInput;
import arp.persistable.IPersistOutput;

@:generic @:remove
class ArpObjectMap<K, V:IArpObject> implements IArpObjectMap<K, V> {

	private var domain:ArpDomain;
	inline private function slotOf(v:V):ArpSlot<V> return ArpSlot.of(v, domain);

	private var _slotMap:StdMap<K, ArpSlot<V>>;
	public var slotMap(get, never):IMap<K, ArpSlot<V>>;
	inline private function get_slotMap():IMap<K, ArpSlot<V>> return _slotMap;

	public var heat(get, never):ArpHeat;
	private function get_heat():ArpHeat {
		var result:ArpHeat = ArpHeat.Max;
		for (slot in this._slotMap) {
			var h = slot.heat;
			if (result > h) result = h;
		}
		return result;
	}

	public var isUniqueKey(get, never):Bool;
	public function get_isUniqueKey():Bool return true;
	public var isUniqueValue(get, never):Bool;
	public function get_isUniqueValue():Bool return false;

	public function new(domain:ArpDomain) {
		this.domain = domain;
		this._slotMap = new StdMap<K, ArpSlot<V>>();
	}

	//read
	public function isEmpty():Bool return this._slotMap.isEmpty();
	public function hasValue(v:V):Bool return this._slotMap.hasValue(slotOf(v));
	inline public function iterator():Iterator<V> return new ArpObjectIterator(this._slotMap.iterator());
	public function toString():String return CollectionTools.mapToStringImpl(this._slotMap);
	public function get(k:K):Null<V> return this._slotMap.hasKey(k) ? this._slotMap.get(k).value : null;
	public function hasKey(k:K):Bool return this._slotMap.hasKey(k);
	inline public function keys():Iterator<K> return this._slotMap.keys();
	inline public function keyValueIterator():KeyValueIterator<K, V> return new ArpObjectKeyValueIterator(this._slotMap.keyValueIterator());

	//resolve
	public function resolveName(v:V):Null<K> return this._slotMap.resolveName(slotOf(v));

	//write
	public function set(k:K, v:V):Void {
		this._slotMap.set(k, slotOf(v).addReference());
	}

	//remove
	public function remove(v:V):Bool return this._slotMap.remove(slotOf(v).delReference());
	public function removeKey(k:K):Bool {
		if (!this._slotMap.hasKey(k)) return false;
		this._slotMap.get(k).delReference();
		return this._slotMap.removeKey(k);
	}
	public function clear():Void {
		for (slot in this._slotMap) slot.delReference();
		this._slotMap.clear();
	}

	// persist
	public function readSelf(input:IPersistInput):Void {
		var oldSlotMap:IMap<K, ArpSlot<V>> = this._slotMap;
		this._slotMap = new StdMap<K, ArpSlot<V>>();
		var c:Int = input.readInt32("c");
		input.readListEnter("map");
		for (i in 0...c) {
			input.nextEnter();
			var name:String = input.readUtf("k");
			this._slotMap.set(cast name, this.domain.getOrCreateSlot(new ArpSid(input.readUtf("v"))).addReference());
			input.readExit();
		}
		input.readExit();

		for (item in oldSlotMap) item.delReference();
	}

	public function writeSelf(output:IPersistOutput):Void {
		var values:Array<String> = [for (key in this._slotMap.keys()) cast key];
		output.writeInt32("c", values.length);
		output.writeListEnter("map");
		for (value in values) {
			output.pushEnter();
			output.writeUtf("k", value);
			output.writeUtf("v", this._slotMap.get(cast value).sid.toString());
			output.writeExit();
		}
		output.writeExit();
	}

	// amend
	public function amend():Iterator<IMapAmendCursor<K, V>> return CollectionTools.mapAmendImpl(this);
}
