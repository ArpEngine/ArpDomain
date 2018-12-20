package arp.domain.events;

class ArpLogEvent {

	public var category(default, null):String;
	public var message(default, null):String;

	public function new(category:String, message:String) {
		this.category = category;
		this.message = message;
	}

}
