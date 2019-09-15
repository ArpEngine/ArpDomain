package arp.domain.ds;

import arp.ds.IOmap;
import arp.persistable.IPersistable;

interface IArpObjectOmap<K, V:IArpObject> extends IOmap<K, V> extends IPersistable {
	var slotOmap(get, never):IOmap<K, ArpSlot<V>>;
}
