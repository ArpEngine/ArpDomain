package arp.domain.query;

import arp.domain.core.ArpType;
import arp.errors.queryErrors.ArpVoidReferenceError;

class ArpObjectQuery<T:IArpObject> extends ArpDirectoryQuery {

	private var type:ArpType;

	public function new(root:ArpDirectory, path:String = null, type:ArpType = null) {
		super(root, path);
		this.type = type;
	}

	inline public function slot():ArpSlot<T> {
		var target:ArpDirectory = this.directory();
		return target.getOrCreateSlot(this.type);
	}

	inline public function obj():T {
		var value = this.slot().value;
		return if (value != null) value else throw new ArpVoidReferenceError('Could not resolve $path of type $type from ArpDirectory ${root.did}.');
	}

	inline public function value():T {
		return this.slot().value;
	}

	inline public function heatLater():Void {
		this.root.domain.heatLater(this.slot());
	}
}
