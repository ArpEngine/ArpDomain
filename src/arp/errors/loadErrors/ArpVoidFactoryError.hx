package arp.errors.loadErrors;

class ArpVoidFactoryError extends ArpLoadError {
	override private function get_recoverInfo():String {
		return "ArpVoidReferenceError: Please check the structure of your seed files.";
	}

	public function new(message:String, cause:ArpError = null) {
		super(message, cause);
	}
}
