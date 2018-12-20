package arp.errors;

class ArpRuntimeError extends ArpError {
	override private function get_recoverInfo():String {
		return "ArpRuntimeError: Arp objects are in invalid state.";
	}

	public function new(message:String, cause:ArpError = null) {
		super(message, cause);
	}
}
