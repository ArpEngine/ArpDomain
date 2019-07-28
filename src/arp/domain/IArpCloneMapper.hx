package arp.domain;

interface IArpCloneMapper {
	function addMapping(src:ArpUntypedSlot, dest:ArpUntypedSlot):Void;
	function addMappingObj(src:IArpObject, dest:IArpObject):Void;
	function resolve(src:ArpUntypedSlot):ArpUntypedSlot;
	function resolveObj(src:IArpObject):IArpObject;
}
