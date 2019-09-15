package arp.domain.ds;

import arp.domain.core.ArpSid;
import arp.ds.access.IListAmend.IListAmendCursor;
import arp.ds.IList;
import arp.ds.impl.ArrayList;
import arp.ds.lambda.CollectionTools;
import arp.persistable.IPersistInput;
import arp.persistable.IPersistOutput;

class ArpObjectList<V:IArpObject> implements IArpObjectList<V> {

	private var domain:ArpDomain;
	inline private function slotOf(v:V):ArpSlot<V> return ArpSlot.of(v, domain);

	private var _slotList:ArrayList<ArpSlot<V>>;
	public var slotList(get, never):IList<ArpSlot<V>>;
	inline private function get_slotList():IList<ArpSlot<V>> return _slotList;

	public var heat(get, never):ArpHeat;
	private function get_heat():ArpHeat {
		var result:ArpHeat = ArpHeat.Max;
		for (slot in this._slotList) {
			var h = slot.heat;
			if (result > h) result = h;
		}
		return result;
	}

	public var isUniqueValue(get, never):Bool;
	public function get_isUniqueValue():Bool return false;

	public function new(domain:ArpDomain) {
		this.domain = domain;
		this._slotList = new ArrayList();
	}

	//read
	public function isEmpty():Bool return this._slotList.isEmpty();
	public function hasValue(v:V):Bool return this._slotList.hasValue(slotOf(v));
	inline public function iterator():Iterator<V> return new ArpObjectIterator(this._slotList.iterator());
	public function toString():String return CollectionTools.listToStringImpl(this._slotList);
	public var length(get, never):Int;
	public function get_length():Int return this._slotList.length;
	public function first():Null<V> return this._slotList.isEmpty() ? null : this._slotList.first().value;
	public function last():Null<V> return this._slotList.isEmpty() ? null : this._slotList.last().value;
	public function getAt(index:Int):Null<V> {
		var slot:ArpSlot<V> = this._slotList.getAt(index);
		return (slot == null) ? null : slot.value;
	}

	//resolve
	public function indexOf(v:V, ?fromIndex:Int):Int return this._slotList.indexOf(slotOf(v), fromIndex);
	public function lastIndexOf(v:V, ?fromIndex:Int):Int return this._slotList.lastIndexOf(slotOf(v), fromIndex);

	//write
	public function push(v:V):Int return this._slotList.push(slotOf(v).addReference());
	public function unshift(v:V):Void this._slotList.unshift(slotOf(v).addReference());
	public function insertAt(index:Int, v:V):Void this._slotList.insertAt(index, slotOf(v).addReference());

	//remove
	public function pop():Null<V> return this._slotList.isEmpty() ? null : this._slotList.pop().delReference().value;
	public function shift():Null<V> return this._slotList.isEmpty() ? null : this._slotList.shift().delReference().value;
	public function remove(v:V):Bool return this._slotList.remove(slotOf(v).delReference());
	public function removeAt(index:Int):Bool {
		var slot:ArpSlot<V> = this._slotList.getAt(index);
		if (slot == null) return false;
		slot.delReference();
		return this._slotList.removeAt(index);
	}
	public function clear():Void {
		for (slot in this._slotList) slot.delReference();
		this._slotList.clear();
	}

	// persist
	public function readSelf(input:IPersistInput):Void {
		var oldSlotList:IList<ArpSlot<V>> = this._slotList;
		this._slotList = new ArrayList();
		var c:Int = input.readInt32("c");
		input.readListEnter("list");
		for (i in 0...c) {
			this._slotList.push(this.domain.getOrCreateSlot(new ArpSid(input.nextUtf())).addReference());
		}
		input.readExit();

		for (item in oldSlotList) item.delReference();
	}

	public function writeSelf(output:IPersistOutput):Void {
		var values:Array<String> = [for (slot in this._slotList) slot.sid.toString()];
		output.writeInt32("c", values.length);
		output.writeListEnter("list");
		for (value in values) output.pushUtf(value);
		output.writeExit();
	}

	// amend
	public function amend():Iterator<IListAmendCursor<V>> return CollectionTools.listAmendImpl(this);
	inline public function keyValueIterator():KeyValueIterator<Int, V> return new ArpObjectKeyValueIterator(this._slotList.keyValueIterator());
}
