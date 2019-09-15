package arp.domain.ds;

import arp.ds.IMap;
import arp.persistable.IPersistable;

interface IArpObjectMap<K, V:IArpObject> extends IMap<K, V> extends IPersistable {
	var slotMap(get, never):IMap<K, ArpSlot<V>>;
}
