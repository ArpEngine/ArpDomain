package arp.errors;

class ArpVoidReferenceError extends ArpError {
	override private function get_recoverInfo():String {
		return "ArpVoidReferenceError: Arp object not found.";
	}

	public function new(message:String, cause:ArpError = null) {
		super(message, cause);
	}
}
