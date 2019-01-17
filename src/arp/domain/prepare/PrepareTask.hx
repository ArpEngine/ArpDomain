package arp.domain.prepare;

import arp.domain.ArpDomain;
import arp.domain.ArpUntypedSlot;
import arp.task.TaskStatus;

class PrepareTask implements IPrepareTask {

	public var slot(get, never):ArpUntypedSlot;
	private var _slot:ArpUntypedSlot;
	private function get_slot():ArpUntypedSlot return _slot;

	public var required:Bool;

	private var _blocking:Bool;
	public var blocking(get, never):Bool;
	private function get_blocking():Bool return _blocking;

	public var waiting(get, set):Bool;
	private var _waiting:Bool = false;
	private function get_waiting():Bool return _waiting;
	private function set_waiting(value:Bool):Bool return _waiting = value;

	private var domain:ArpDomain;

	private var preparePropagated:Bool = false;

	public function new(domain:ArpDomain, slot:ArpUntypedSlot, required:Bool = false, blocking:Bool = true) {
		this.domain = domain;
		this._slot = slot;
		this.required = required;
		this._blocking = blocking;
	}

	public function run():TaskStatus {
		if (this._slot.value == null) {
			if (this._slot.refCount <= 0) {
				this.domain.log("arp_debug_prepare", 'PrepareTask.run(): ultimate unused and prepare canceled: ${this._slot}');
				return TaskStatus.Complete;
			} else if (this.required) {
				var message = 'PrepareTask.run(): slot is required but was null: ${this._slot}';
				this.domain.log("arp_debug_prepare", message);
				return TaskStatus.Error(message);
			} else {
				this.domain.log("arp_debug_prepare", 'PrepareTask.run(): prepare complete (null): ${this._slot}');
				return TaskStatus.Complete;
			}
		}

		if (!this.preparePropagated) {
			// trigger dependency prepare
			this._slot.value.__arp_heatLaterDeps();
			this.preparePropagated = true;
		}

		// try to heat up myself
		if (!this._slot.value.__arp_heatUpNow()) {
			this.domain.log("arp_debug_prepare", 'PrepareTask.run(): waiting depending prepares: ${this._slot}');
			return TaskStatus.Stalled;
		}
		if (this._waiting) {
			this.domain.log("arp_debug_prepare", 'PrepareTask.run(): waiting late prepare: ${this._slot}');
			return TaskStatus.Stalled;
		}
		this.domain.log("arp_debug_prepare", 'PrepareTask.run(): prepare complete: ${this._slot}');
		return TaskStatus.Complete;
	}
}
