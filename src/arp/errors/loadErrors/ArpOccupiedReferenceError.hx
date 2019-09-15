package arp.errors.loadErrors;

class ArpOccupiedReferenceError extends ArpLoadError {
	override private function get_recoverInfo():String {
		return "ArpOccupiedReferenceError: Please check the structure of your seed files.";
	}

	public function new(message:String, cause:ArpError = null) {
		super(message, cause);
	}
}
