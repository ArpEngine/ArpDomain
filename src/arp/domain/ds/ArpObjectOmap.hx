package arp.domain.ds;

import arp.domain.core.ArpSid;
import arp.ds.access.IOmapAmend.IOmapAmendCursor;
import arp.ds.impl.StdOmap;
import arp.ds.IOmap;
import arp.ds.lambda.CollectionTools;
import arp.persistable.IPersistable;
import arp.persistable.IPersistInput;
import arp.persistable.IPersistOutput;

@:generic @:remove
class ArpObjectOmap<K, V:IArpObject> implements IOmap<K, V> implements IPersistable {

	private var domain:ArpDomain;
	inline private function slotOf(v:V):ArpSlot<V> return ArpSlot.of(v, domain);

	public var slotOmap(default, null):StdOmap<K, ArpSlot<V>>;

	public var heat(get, never):ArpHeat;
	private function get_heat():ArpHeat {
		var result:ArpHeat = ArpHeat.Max;
		for (slot in this.slotOmap) {
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
		this.slotOmap = new StdOmap<K, ArpSlot<V>>();
	}

	//read
	public function isEmpty():Bool return this.slotOmap.isEmpty();
	public function hasValue(v:V):Bool return this.slotOmap.hasValue(slotOf(v));
	inline public function iterator():Iterator<V> return new ArpObjectIterator(this.slotOmap.iterator());
	public function toString():String return CollectionTools.omapToStringImpl(this.slotOmap);
	public function get(k:K):Null<V> return this.slotOmap.hasKey(k) ? this.slotOmap.get(k).value : null;
	public function hasKey(k:K):Bool return this.slotOmap.hasKey(k);
	inline public function keys():Iterator<K> return this.slotOmap.keys();
	public var length(get, never):Int;
	public function get_length():Int return this.slotOmap.length;
	public function first():Null<V> return this.slotOmap.isEmpty() ? null : this.slotOmap.first().value;
	public function last():Null<V> return this.slotOmap.isEmpty() ? null : this.slotOmap.last().value;
	public function getAt(index:Int):Null<V> {
		var slot:ArpSlot<V> = this.slotOmap.getAt(index);
		return (slot == null) ? null : slot.value;
	}
	inline public function keyValueIterator():KeyValueIterator<K, V> return new ArpObjectKeyValueIterator(this.slotOmap.keyValueIterator());

	//resolve
	public function resolveKeyIndex(k:K):Int return this.slotOmap.resolveKeyIndex(k);
	public function resolveName(v:V):Null<K> return this.slotOmap.resolveName(slotOf(v));
	public function indexOf(v:V, ?fromIndex:Int):Int return this.slotOmap.indexOf(slotOf(v), fromIndex);
	public function lastIndexOf(v:V, ?fromIndex:Int):Int return this.slotOmap.lastIndexOf(slotOf(v), fromIndex);

	//write
	public function addPair(k:K, v:V):Void this.slotOmap.addPair(k, slotOf(v).addReference());
	public function insertPairAt(index:Int, k:K, v:V):Void this.slotOmap.insertPairAt(index, k, slotOf(v).addReference());

	// remove
	public function remove(v:V):Bool return this.slotOmap.remove(slotOf(v).delReference());
	public function removeKey(k:K):Bool {
		if (!this.slotOmap.hasKey(k)) return false;
		this.slotOmap.get(k).delReference();
		return this.slotOmap.removeKey(k);
	}
	public function removeAt(index:Int):Bool {
		var slot:ArpSlot<V> = this.slotOmap.getAt(index);
		if (slot == null) return false;
		slot.delReference();
		return this.slotOmap.removeAt(index);
	}
	public function pop():Null<V> return this.slotOmap.isEmpty() ? null : this.slotOmap.pop().delReference().value;
	public function shift():Null<V> return this.slotOmap.isEmpty() ? null : this.slotOmap.shift().delReference().value;
	public function clear():Void {
		for (slot in this.slotOmap) slot.delReference();
		this.slotOmap.clear();
	}

	// persist
	public function readSelf(input:IPersistInput):Void {
		var oldSlotOmap:IOmap<K, ArpSlot<V>> = this.slotOmap;
		this.slotOmap = new StdOmap<K, ArpSlot<V>>();
		var nameList:Array<String> = input.readNameList("keys");
		input.readEnter("values");
		for (name in nameList) {
			this.slotOmap.addPair(cast name, this.domain.getOrCreateSlot(new ArpSid(input.readUtf(name))).addReference());
		}
		input.readExit();

		for (item in oldSlotOmap) item.delReference();
	}

	public function writeSelf(output:IPersistOutput):Void {
		var nameList:Array<String> = [for (key in this.slotOmap.keys()) cast key];
		output.writeNameList("keys", nameList);
		output.writeEnter("values");
		for (name in nameList) {
			output.writeUtf(name, this.slotOmap.get(cast name).sid.toString());
		}
		output.writeExit();
	}

	// amend
	public function amend():Iterator<IOmapAmendCursor<K, V>> return CollectionTools.omapAmendImpl(this);
}
