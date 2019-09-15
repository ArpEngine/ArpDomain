package arp.errors;

class ArpQueryError extends ArpError {
	public function new(message:String, cause:ArpError = null) {
		super(message, cause);
	}
}
