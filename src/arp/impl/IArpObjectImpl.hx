package arp.impl;

interface IArpObjectImpl {
	function arpHeatUpNow():Bool;
	function arpHeatDownNow():Bool;

	@:noDoc @:noCompletion function __arp_dispose():Void;
}
