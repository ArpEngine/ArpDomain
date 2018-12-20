package arp.domain.ds;

class ArpObjectIterator<V:IArpObject> {

	private var iterator:Iterator<ArpSlot<V>>;

	inline public function new(iterator:Iterator<ArpSlot<V>>) {
		this.iterator = iterator;
	}

	inline public function hasNext():Bool return this.iterator.hasNext();
	inline public function next():V return this.iterator.next().value;
}
