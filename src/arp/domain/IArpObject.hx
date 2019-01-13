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

	@:noDoc @:noCompletion function arpInit(slot:ArpUntypedSlot, seed:ArpSeed = null):IArpObject;
	@:noDoc @:noCompletion function arpDispose():Void;
	function arpClone():IArpObject;
	function arpCopyFrom(source:IArpObject):IArpObject;

	@:noDoc @:noCompletion function arpHeatLater():Void;
	@:noDoc @:noCompletion function arpHeatUp():Bool;
	@:noDoc @:noCompletion function arpHeatDown():Bool;
}
