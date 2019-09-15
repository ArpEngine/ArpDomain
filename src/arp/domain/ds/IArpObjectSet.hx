package arp.domain.ds;

import arp.ds.ISet;
import arp.persistable.IPersistable;

interface IArpObjectSet<V:IArpObject> extends ISet<V> extends IPersistable {
	var slotSet(get, never):ISet<ArpSlot<V>>;
}
