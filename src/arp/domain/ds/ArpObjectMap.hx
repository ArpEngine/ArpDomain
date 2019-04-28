package arp.domain.ds;

import arp.domain.ArpSlot;
import arp.domain.core.ArpSid;
import arp.ds.access.IMapAmend.IMapAmendCursor;
import arp.ds.IMap;
import arp.ds.impl.StdMap;
import arp.ds.lambda.CollectionTools;
import arp.persistable.IPersistable;
import arp.persistable.IPersistInput;
import arp.persistable.IPersistOutput;

@:generic @:remove
class ArpObjectMap<K, V:IArpObject> implements IMap<K, V> implements IPersistable {

	private var domain:ArpDomain;
	inline private function slotOf(v:V):ArpSlot<V> return ArpSlot.of(v, domain);

	public var slotMap(default, null):StdMap<K, ArpSlot<V>>;

	public var heat(get, never):ArpHeat;
	private function get_heat():ArpHeat {
		var result:ArpHeat = ArpHeat.Max;
		for (slot in this.slotMap) {
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
		this.slotMap = new StdMap<K, ArpSlot<V>>();
	}

	//read
	public function isEmpty():Bool return this.slotMap.isEmpty();
	public function hasValue(v:V):Bool return this.slotMap.hasValue(slotOf(v));
	inline public function iterator():Iterator<V> return new ArpObjectIterator(this.slotMap.iterator());
	public function toString():String return CollectionTools.mapToStringImpl(this.slotMap);
	public function get(k:K):Null<V> return this.slotMap.hasKey(k) ? this.slotMap.get(k).value : null;
	public function hasKey(k:K):Bool return this.slotMap.hasKey(k);
	inline public function keys():Iterator<K> return this.slotMap.keys();
	inline public function keyValueIterator():KeyValueIterator<K, V> return new ArpObjectKeyValueIterator(this.slotMap.keyValueIterator());

	//resolve
	public function resolveName(v:V):Null<K> return this.slotMap.resolveName(slotOf(v));

	//write
	public function set(k:K, v:V):Void {
		this.slotMap.set(k, slotOf(v).addReference());
	}

	//remove
	public function remove(v:V):Bool return this.slotMap.remove(slotOf(v).delReference());
	public function removeKey(k:K):Bool {
		if (!this.slotMap.hasKey(k)) return false;
		this.slotMap.get(k).delReference();
		return this.slotMap.removeKey(k);
	}
	public function clear():Void {
		for (slot in this.slotMap) slot.delReference();
		this.slotMap.clear();
	}

	// persist
	public function readSelf(input:IPersistInput):Void {
		var oldSlotMap:IMap<K, ArpSlot<V>> = this.slotMap;
		this.slotMap = new StdMap<K, ArpSlot<V>>();
		var c:Int = input.readInt32("c");
		input.readListEnter("map");
		for (i in 0...c) {
			input.nextEnter();
			var name:String = input.readUtf("k");
			this.slotMap.set(cast name, this.domain.getOrCreateSlot(new ArpSid(input.readUtf("v"))).addReference());
			input.readExit();
		}
		input.readExit();

		for (item in oldSlotMap) item.delReference();
	}

	public function writeSelf(output:IPersistOutput):Void {
		var values:Array<String> = [for (key in this.slotMap.keys()) cast key];
		output.writeInt32("c", values.length);
		output.writeListEnter("map");
		for (value in values) {
			output.pushEnter();
			output.writeUtf("k", value);
			output.writeUtf("v", this.slotMap.get(cast value).sid.toString());
			output.writeExit();
		}
		output.writeExit();
	}

	// amend
	public function amend():Iterator<IMapAmendCursor<K, V>> return CollectionTools.mapAmendImpl(this);
}
