package arp.errors;

class ArpError {

	public var message(default, null):String;
	public var cause(default, null):ArpError;

	public var recoverInfo(get, never):String;
	private function get_recoverInfo():String {
		return "ArpError: Internal engine error. This error cannot be recovered.";
	}

	public function new(message:String, cause:ArpError = null) {
		this.message = message;
		this.cause = cause;
	}

	public function toString():String {
		var indent:Int = 0;
		var result:Array<String> = [];
		var me:ArpError = this;
		while (me != null) {
			result.push(StringTools.lpad("", " ", indent) + me.message);
			me = me.cause;
			indent += 2;
		}
		result.push(this.recoverInfo);
		return result.join("\n");
	}
}
