package arp.errors;

class ArpLoadError extends ArpError {
	override private function get_recoverInfo():String {
		return "ArpLoadError: Please check the structure of your seed files.";
	}

	public function new(message:String, cause:ArpError = null) {
		super(message, cause);
	}
}
