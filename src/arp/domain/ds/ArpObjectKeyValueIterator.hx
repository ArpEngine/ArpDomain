package arp.domain.ds;

class ArpObjectKeyValueIterator<K, V:IArpObject> {

	private var iterator:KeyValueIterator<K, ArpSlot<V>>;

	inline public function new(iterator:KeyValueIterator<K, ArpSlot<V>>) {
		this.iterator = iterator;
	}

	inline public function hasNext():Bool return this.iterator.hasNext();
	inline public function next():{key:K, value:V} {
		var kv = iterator.next();
		return { key: kv.key, value: kv.value.value };
	}
}
