package arp.domain;

interface IArpCloneMapper {
	function addMapping(src:ArpUntypedSlot, dest:ArpUntypedSlot):Void;
	function resolve(src:ArpUntypedSlot):ArpUntypedSlot;

	function addMappingObj<T:IArpObject>(src:T, dest:T):Void;
	function resolveObj<T:IArpObject>(src:T):T;
}
