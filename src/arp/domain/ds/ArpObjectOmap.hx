package arp.domain.ds;

import arp.domain.core.ArpSid;
import arp.ds.access.IOmapAmend.IOmapAmendCursor;
import arp.ds.impl.StdOmap;
import arp.ds.IOmap;
import arp.ds.lambda.CollectionTools;
import arp.persistable.IPersistInput;
import arp.persistable.IPersistOutput;

@:generic @:remove
class ArpObjectOmap<K, V:IArpObject> implements IArpObjectOmap<K, V> {

	private var domain:ArpDomain;
	inline private function slotOf(v:V):ArpSlot<V> return ArpSlot.of(v, domain);

	private var _slotOmap(default, null):StdOmap<K, ArpSlot<V>>;
	public var slotOmap(get, never):IOmap<K, ArpSlot<V>>;
	inline private function get_slotOmap():IOmap<K, ArpSlot<V>> return _slotOmap;

	public var heat(get, never):ArpHeat;
	private function get_heat():ArpHeat {
		var result:ArpHeat = ArpHeat.Max;
		for (slot in this._slotOmap) {
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
		this._slotOmap = new StdOmap<K, ArpSlot<V>>();
	}

	//read
	public function isEmpty():Bool return this._slotOmap.isEmpty();
	public function hasValue(v:V):Bool return this._slotOmap.hasValue(slotOf(v));
	inline public function iterator():Iterator<V> return new ArpObjectIterator(this._slotOmap.iterator());
	public function toString():String return CollectionTools.omapToStringImpl(this._slotOmap);
	public function get(k:K):Null<V> return this._slotOmap.hasKey(k) ? this._slotOmap.get(k).value : null;
	public function hasKey(k:K):Bool return this._slotOmap.hasKey(k);
	inline public function keys():Iterator<K> return this._slotOmap.keys();
	public var length(get, never):Int;
	public function get_length():Int return this._slotOmap.length;
	public function first():Null<V> return this._slotOmap.isEmpty() ? null : this._slotOmap.first().value;
	public function last():Null<V> return this._slotOmap.isEmpty() ? null : this._slotOmap.last().value;
	public function getAt(index:Int):Null<V> {
		var slot:ArpSlot<V> = this._slotOmap.getAt(index);
		return (slot == null) ? null : slot.value;
	}
	inline public function keyValueIterator():KeyValueIterator<K, V> return new ArpObjectKeyValueIterator(this._slotOmap.keyValueIterator());

	//resolve
	public function resolveKeyIndex(k:K):Int return this._slotOmap.resolveKeyIndex(k);
	public function resolveKeyAt(index:Int):Null<K> return this._slotOmap.resolveKeyAt(index);
	public function keyOf(v:V):Null<K> return this._slotOmap.keyOf(slotOf(v));
	public function indexOf(v:V, ?fromIndex:Int):Int return this._slotOmap.indexOf(slotOf(v), fromIndex);
	public function lastIndexOf(v:V, ?fromIndex:Int):Int return this._slotOmap.lastIndexOf(slotOf(v), fromIndex);

	//write
	public function addPair(k:K, v:V):Void this._slotOmap.addPair(k, slotOf(v).addReference());
	public function insertPairAt(index:Int, k:K, v:V):Void this._slotOmap.insertPairAt(index, k, slotOf(v).addReference());

	// remove
	public function remove(v:V):Bool return this._slotOmap.remove(slotOf(v).delReference());
	public function removeKey(k:K):Bool {
		if (!this._slotOmap.hasKey(k)) return false;
		this._slotOmap.get(k).delReference();
		return this._slotOmap.removeKey(k);
	}
	public function removeAt(index:Int):Bool {
		var slot:ArpSlot<V> = this._slotOmap.getAt(index);
		if (slot == null) return false;
		slot.delReference();
		return this._slotOmap.removeAt(index);
	}
	public function pop():Null<V> return this._slotOmap.isEmpty() ? null : this._slotOmap.pop().delReference().value;
	public function shift():Null<V> return this._slotOmap.isEmpty() ? null : this._slotOmap.shift().delReference().value;
	public function clear():Void {
		for (slot in this._slotOmap) slot.delReference();
		this._slotOmap.clear();
	}

	// persist
	public function readSelf(input:IPersistInput):Void {
		var oldSlotOmap:IOmap<K, ArpSlot<V>> = this._slotOmap;
		this._slotOmap = new StdOmap<K, ArpSlot<V>>();
		var c:Int = input.readInt32("c");
		input.readListEnter("omap");
		for (i in 0...c) {
			input.nextEnter();
			var name:String = input.readUtf("k");
			this._slotOmap.addPair(cast name, this.domain.getOrCreateSlot(new ArpSid(input.readUtf("v"))).addReference());
			input.readExit();
		}
		input.readExit();

		for (item in oldSlotOmap) item.delReference();
	}

	public function writeSelf(output:IPersistOutput):Void {
		var values:Array<String> = [for (key in this._slotOmap.keys()) cast key];
		output.writeInt32("c", values.length);
		output.writeListEnter("omap");
		for (value in values) {
			output.pushEnter();
			output.writeUtf("k", value);
			output.writeUtf("v", this._slotOmap.get(cast value).sid.toString());
			output.writeExit();
		}
		output.writeExit();
	}

	// amend
	public function amend():Iterator<IOmapAmendCursor<K, V>> return CollectionTools.omapAmendImpl(this);
}
