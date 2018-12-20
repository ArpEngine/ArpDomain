package arp.domain.dump;

import haxe.extern.EitherType;

typedef ArpDumpAnon = EitherType<ArpDirAnon, ArpSlotAnon>;

typedef ArpDirAnon = {
	var name:String;
	var arpDid:String;
	@:optional var children:Array<ArpDumpAnon>;
}

typedef ArpSlotAnon = {
	var name:String;
	var arpSid:String;
	var arpTemplateName:String;
	var status:String;
	var refCount:Int;
}
