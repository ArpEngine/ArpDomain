package arp.domain;

import arp.domain.ArpUntypedSlot;
import arp.domain.core.ArpType;
import arp.persistable.IPersistable;
import arp.seed.ArpSeed;

#if !macro
@:autoBuild(arp.ArpDomainMacros.autoBuildObject())
#end
interface IArpObject extends IPersistable /* extends IArpObjectImpl */ {

	var arpDomain(get, never):ArpDomain;
	var arpType(get, never):ArpType;
	var arpTypeInfo(get, never):ArpTypeInfo;
	var arpSlot(get, never):ArpUntypedSlot;
	var arpHeat(get, never):ArpHeat;

	function arpInit(slot:ArpUntypedSlot, seed:ArpSeed = null):IArpObject;
	function arpDispose():Void;
	function arpClone():IArpObject;
	function arpCopyFrom(source:IArpObject):IArpObject;

	function arpHeatLater():Void;
	function arpHeatUp():Bool;
	function arpHeatDown():Bool;
}
