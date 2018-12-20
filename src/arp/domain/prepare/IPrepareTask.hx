package arp.domain.prepare;

import arp.domain.ArpUntypedSlot;
import arp.task.ITask;

interface IPrepareTask extends ITask {

	var waiting(get, set):Bool;
	var slot(get, never):ArpUntypedSlot;

}
