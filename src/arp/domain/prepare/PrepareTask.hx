package arp.domain.prepare;

import arp.domain.ArpDomain;
import arp.domain.ArpUntypedSlot;
import arp.task.ITask;
import arp.task.TaskStatus;

class PrepareTask implements ITask {

	private var domain:ArpDomain;
	public var slot(default, null):ArpUntypedSlot;
	public var nonblocking(default, null):Bool;

	public var waiting:Bool;

	private var preparePropagated:Bool = false;

	public function new(domain:ArpDomain, slot:ArpUntypedSlot, nonblocking:Bool = false) {
		this.domain = domain;
		this.slot = slot;
		this.nonblocking = nonblocking;
	}

	public function run():TaskStatus {
		if (this.slot.value == null) {
			if (this.slot.refCount <= 0) {
				this.domain.log("arp_debug_prepare", 'PrepareTask.run(): ultimate unused and prepare canceled: ${this.slot}');
				return TaskStatus.Complete;
			} else {
				return TaskStatus.Stalled;
				var message = 'PrepareTask.run(): slot is required but was null: ${this.slot}';
				this.domain.log("arp_debug_prepare", message);
				return TaskStatus.Error(message);
			}
		}

		if (!this.preparePropagated) {
			// trigger dependency prepare
			this.slot.value.__arp_heatLaterDeps();
			this.preparePropagated = true;
		}

		// try to heat up myself
		if (!this.slot.value.arpHeatUpNow()) {
			this.domain.log("arp_debug_prepare", 'PrepareTask.run(): waiting depending prepares: ${this.slot}');
			return TaskStatus.Stalled;
		}
		if (this.waiting) {
			this.domain.log("arp_debug_prepare", 'PrepareTask.run(): waiting late prepare: ${this.slot}');
			return TaskStatus.Stalled;
		}
		this.domain.log("arp_debug_prepare", 'PrepareTask.run(): prepare complete: ${this.slot}');
		return TaskStatus.Complete;
	}
}
