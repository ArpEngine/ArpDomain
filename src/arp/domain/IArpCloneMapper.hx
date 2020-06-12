package arp.domain;

interface IArpCloneMapper {
	function addMapping(src:ArpUntypedSlot, dest:ArpUntypedSlot):Void;
	function resolve(src:ArpUntypedSlot, preferDeepCopy:Bool):ArpUntypedSlot;

	function addMappingObj<T:IArpObject>(src:T, dest:T):Void;
	function resolveObj<T:IArpObject>(src:Null<T>, preferDeepCopy:Bool):T;
}
