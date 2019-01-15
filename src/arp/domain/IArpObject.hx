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

	@:noDoc @:noCompletion function __arp_init(slot:ArpUntypedSlot, seed:ArpSeed = null):IArpObject;
	@:noDoc @:noCompletion function __arp_dispose():Void;
	function arpClone():IArpObject;
	function arpCopyFrom(source:IArpObject):IArpObject;

	@:noDoc @:noCompletion function __arp_heatLaterDeps():Void;
	@:noDoc @:noCompletion function __arp_heatUpNow():Bool;
	@:noDoc @:noCompletion function __arp_heatDownNow():Bool;
}
