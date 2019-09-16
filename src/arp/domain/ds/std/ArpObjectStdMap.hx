package arp.domain.ds.std;

import haxe.Constraints.IMap;
import arp.domain.core.ArpSid;
import arp.persistable.IPersistable;
import arp.persistable.IPersistInput;
import arp.persistable.IPersistOutput;

@:access(arp.domain.ArpDomain)
class ArpObjectStdMap<V:IArpObject> implements IMap<String, V> implements IPersistable {

	private var domain:ArpDomain;
	public var slots(default, null):Map<String, ArpSlot<V>>;

	public var heat(get, never):ArpHeat;
	private function get_heat():ArpHeat {
		var result:ArpHeat = ArpHeat.Max;
		for (slot in this.slots) {
			var h = slot.heat;
			if (result > h) result = h;
		}
		return result;
	}

	public function new(domain:ArpDomain) {
		this.domain = domain;
		this.slots = new Map();
	}

	public function get(k:String):Null<V> {
		var slot:ArpSlot<V> = this.slots.get(k);
		return (slot != null) ? slot.value : null;
	}

	public function set(k:String, v:V):Void {
		this.slots.set(k, ArpSlot.of(v, domain).addReference());
	}

	public function exists(k:String):Bool {
		return this.slots.exists(k);
	}

	public function remove(k:String):Bool {
		if (this.slots.exists(k)) this.slots.get(k).delReference();
		return this.slots.remove(k);
	}

	public function clear():Void {
		for (slot in this.slots) slot.delReference();
		this.slots.clear();
	}

	public function keys():Iterator<String> {
		return this.slots.keys();
	}

	public function iterator():Iterator<V> {
		return new ArpObjectStdMapIterator(this.slots);
	}

	public function keyValueIterator():KeyValueIterator<String, V> {
		return new ArpObjectStdMapKeyValueIterator(this.slots);
	}

	public function copy():IMap<String, V> {
		var result = new ArpObjectStdMap<V>(this.domain);
		for (k in this.keys()) result.set(k, this.get(k));
		return result;
	}

	public function toString():String {
		return this.slots.toString();
	}

	public function readSelf(input:IPersistInput):Void {
		var oldSlots:Map<String, ArpSlot<V>> = this.slots;
		this.slots = new Map();
		var c:Int = input.readInt32("c");
		input.readListEnter("map");
		for (i in 0...c) {
			input.nextEnter();
			var name:String = input.readUtf("k");
			this.slots.set(cast name, this.domain.getOrCreateSlot(new ArpSid(input.readUtf("v"))).addReference());
			input.readExit();
		}
		input.readExit();

		for (item in oldSlots) item.delReference();
	}

	public function writeSelf(output:IPersistOutput):Void {
		var values:Array<String> = [for (name in this.slots.keys()) name];
		output.writeInt32("c", values.length);
		output.writeListEnter("map");
		for (value in values) {
			output.pushEnter();
			output.writeUtf("k", value);
			output.writeUtf("v", this.slots.get(cast value).sid.toString());
			output.writeExit();
		}
		output.writeExit();
	}
}

class ArpObjectStdMapIterator<V:IArpObject> {

	private var slots:Map<String, ArpSlot<V>>;
	private var keyIter:Iterator<String>;

	public function new(slots:Map<String, ArpSlot<V>>) {
		this.slots = slots;
		this.keyIter = slots.keys();
	}

	public function hasNext():Bool {
		return this.keyIter.hasNext();
	}

	public function next():V {
		var key = this.keyIter.next();
		return this.slots.get(key).value;
	}
}

class ArpObjectStdMapKeyValueIterator<V:IArpObject> {

	private var slots:Map<String, ArpSlot<V>>;
	private var keyIter:Iterator<String>;

	public function new(slots:Map<String, ArpSlot<V>>) {
		this.slots = slots;
		this.keyIter = slots.keys();
	}

	public function hasNext():Bool {
		return this.keyIter.hasNext();
	}

	public function next():{key:String, value:V} {
		var key = this.keyIter.next();
		return { key:key, value: this.slots.get(key).value };
	}
}
