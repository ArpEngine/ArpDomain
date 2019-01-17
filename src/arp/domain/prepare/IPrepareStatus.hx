package arp.domain.prepare;

import arp.events.ArpProgressEvent;
import arp.events.IArpSignalOut;

interface IPrepareStatus {

	var isPending(get, never):Bool;
	var tasksProcessed(get, never):Int;
	var tasksTotal(get, never):Int;
	var tasksWaiting(get, never):Int;

	var onComplete(get, never):IArpSignalOut<Int>;
	var onError(get, never):IArpSignalOut<Dynamic>;
	var onProgress(get, never):IArpSignalOut<ArpProgressEvent>;

	function toString():String;
}
