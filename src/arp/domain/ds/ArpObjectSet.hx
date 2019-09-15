package arp.domain.ds;

import arp.domain.core.ArpSid;
import arp.ds.access.ISetAmend.ISetAmendCursor;
import arp.ds.impl.ArraySet;
import arp.ds.ISet;
import arp.ds.lambda.CollectionTools;
import arp.persistable.IPersistInput;
import arp.persistable.IPersistOutput;

class ArpObjectSet<V:IArpObject> implements IArpObjectSet<V> {

	private var domain:ArpDomain;
	inline private function slotOf(v:V):ArpSlot<V> return ArpSlot.of(v, this.domain);

	private var _slotSet:ArraySet<ArpSlot<V>>;
	public var slotSet(get, never):ISet<ArpSlot<V>>;
	inline private function get_slotSet():ISet<ArpSlot<V>> return _slotSet;

	public var heat(get, never):ArpHeat;
	private function get_heat():ArpHeat {
		var result:ArpHeat = ArpHeat.Max;
		for (slot in this._slotSet) {
			var h = slot.heat;
			if (result > h) result = h;
		}
		return result;
	}

	public var isUniqueValue(get, never):Bool;
	public function get_isUniqueValue():Bool return true;

	public function new(domain:ArpDomain) {
		this.domain = domain;
		this._slotSet = new ArraySet();
	}

	// read
	public function isEmpty():Bool return this._slotSet.isEmpty();
	public function hasValue(v:V):Bool return this._slotSet.hasValue(slotOf(v));
	inline public function iterator():Iterator<V> return new ArpObjectIterator(this._slotSet.iterator());
	public function toString():String return CollectionTools.setToStringImpl(this._slotSet);

	// write
	public function add(v:V):Void this._slotSet.add(slotOf(v).addReference());

	// remove
	public function remove(v:V):Bool return this._slotSet.remove(slotOf(v).delReference());
	public function clear():Void {
		for (slot in this._slotSet) slot.delReference();
		this._slotSet.clear();
	}

	// persist
	public function readSelf(input:IPersistInput):Void {
		var oldSlotList:ISet<ArpSlot<V>> = this._slotSet;
		this._slotSet = new ArraySet();
		var c:Int = input.readInt32("c");
		input.readListEnter("set");
		for (i in 0...c) {
			this._slotSet.add(this.domain.getOrCreateSlot(new ArpSid(input.nextUtf())).addReference());
		}
		input.readExit();

		for (item in oldSlotList) item.delReference();
	}

	public function writeSelf(output:IPersistOutput):Void {
		var values:Array<String> = [for (slot in this._slotSet) slot.sid.toString()];
		output.writeInt32("c", values.length);
		output.writeListEnter("set");
		for (value in values) output.pushUtf(value);
		output.writeExit();
	}

	// amend
	public function amend():Iterator<ISetAmendCursor<V>> return CollectionTools.setAmendImpl(this);
}
