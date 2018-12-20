package arp.errors;

class ArpTemplateError extends ArpError {
	override private function get_recoverInfo():String {
		return "ArpTemplateError: The template implementation contains incorrect settings.";
	}

	public function new(message:String, cause:ArpError = null) {
		super(message, cause);
	}
}
