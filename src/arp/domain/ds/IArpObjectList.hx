package arp.domain.ds;

import arp.ds.IList;
import arp.persistable.IPersistable;

interface IArpObjectList<V:IArpObject> extends IList<V> extends IPersistable {
	var slotList(get, never):IList<ArpSlot<V>>;
}
