package arp.domain.prepare;

import arp.domain.ArpDomain;
import arp.domain.ArpUntypedSlot;
import arp.domain.IArpObject;
import arp.errors.ArpError;
import arp.events.ArpProgressEvent;
import arp.events.ArpSignal;
import arp.events.IArpSignalOut;
import arp.task.TaskRunner;

class PrepareQueue implements IPrepareStatus {

	public var isPending(get, never):Bool;
	inline private function get_isPending():Bool return !this.taskRunner.isCompleted;

	public var tasksProcessed(get, never):Int;
	inline private function get_tasksProcessed():Int return this.taskRunner.tasksProcessed;

	public var tasksTotal(get, never):Int;
	inline private function get_tasksTotal():Int return this.taskRunner.tasksTotal;

	public var tasksWaiting(get, never):Int;
	inline private function get_tasksWaiting():Int return this.taskRunner.tasksWaiting;

	public var taskStatus(get, never):String;
	private function get_taskStatus():String {
		return "[" + Std.string(this.tasksProcessed + 1) + "/" + Std.string(this.tasksTotal) + "]";
	}

	private var _onComplete:ArpSignal<Int>;
	public var onComplete(get, never):IArpSignalOut<Int>;
	inline private function get_onComplete():IArpSignalOut<Int> return _onComplete;

	private var _onError:ArpSignal<Dynamic>;
	public var onError(get, never):IArpSignalOut<Dynamic>;
	inline private function get_onError():IArpSignalOut<Dynamic> return _onError;

	private var _onProgress:ArpSignal<ArpProgressEvent>;
	public var onProgress(get, never):IArpSignalOut<ArpProgressEvent>;
	inline private function get_onProgress():IArpSignalOut<ArpProgressEvent> return _onProgress;

	private var domain:ArpDomain;
	private var tasksBySlots:Map<ArpUntypedSlot, IPrepareTask>;
	private var taskRunner:TaskRunner<IPrepareTask>;

	public function new(domain:ArpDomain, rawTick:IArpSignalOut<Float>) {
		this.domain = domain;
		this._onProgress = new ArpSignal<ArpProgressEvent>();
		this._onError = new ArpSignal<Dynamic>();
		this._onComplete = new ArpSignal<Int>();
		this.tasksBySlots = new Map();
		this.taskRunner = new TaskRunner(rawTick, true);
		this.taskRunner.onComplete.push(this.onTaskRunnerComplete);
		this.taskRunner.onError.push(this.onTaskRunnerError);
		this.taskRunner.onDeadlock.push(this.onTaskRunnerDeadlock);
		this.taskRunner.onProgress.push(this.onTaskRunnerProgress);
		this.taskRunner.onCompleteTask.push(this.onCompleteTask);
		//this.taskRunner.start();
	}

	private function onTaskRunnerComplete(i:Int):Void {
		this.domain.log("arp_debug_prepare", 'PrepareQueue.onTaskRunnerComplete()');
		_onComplete.dispatch(i);
	}

	private function onTaskRunnerDeadlock(i:Int):Void {
		this.onTaskRunnerError("Arp prepare error: Task runner deadlock.");
	}

	private function onTaskRunnerProgress(progress:ArpProgressEvent):Void {
		this.domain.log("arp_debug_prepare", 'PrepareQueue.onTaskRunnerProgress(): [prepare task cycle ${progress.progress}/${progress.total}]');
		_onProgress.dispatch(progress);
	}

	private function onTaskRunnerError(error:Dynamic):Void {
		this.domain.log("arp", 'PrepareQueue.onTaskRunnerError() ${error}');
		for (task in this.tasksBySlots) {
			// var waitsFor:Array<Dynamic> = task.slot.waitsFor(task.heat).map(this.arpSlotToString);
			// TODO
			this.domain.log("arp", 'PrepareQueue.onTaskRunnerError() ${task.slot} ${task.slot.heat}');
			// this.domain.log("arp", 'PrepareQueue.onTaskRunnerError() waits for ${waitsFor.length} slots');
			// this.domain.log("arp", 'PrepareQueue.onTaskRunnerError() ${waitsFor}');
		}
		if (_onError.willTrigger()) {
			_onError.dispatch(error);
		} else {
			throw error;
		}
	}

	private function onCompleteTask(task:IPrepareTask):Void {
		task.slot.heat = ArpHeat.Warm;
		this.tasksBySlots.remove(task.slot);
	}

	private function arpSlotToString(object:IArpObject, index:Int, array:Array<Dynamic>):String {
		return (object != null) ? Std.string(object.arpSlot) : "<invalid reference>";
	}

	public function prepareLater(slot:ArpUntypedSlot, required:Bool = false):Void {
		if (this.tasksBySlots.exists(slot)) return;
		var task:PrepareTask = new PrepareTask(this.domain, slot, required);
		this.tasksBySlots.set(slot, task);
		this.taskRunner.append(task);
		task.slot.heat = ArpHeat.Warming;
		this.domain.log("arp_debug_prepare", 'PrepareQueue.prepareLater(): prepare later ${slot} ${if (required) "(required)" else ""}');
	}

	public function prepareChildLater(slot:ArpUntypedSlot, name:String, childSlot:ArpUntypedSlot):Void {
		if (this.tasksBySlots.exists(slot)) return;
		throw new ArpError("PrepareQueue.prepareChildLater() will not be implemented"); // TODO delete this!
		// var task:IPrepareTask = new PrepareChildTask(this.domain, slot, name, childSlot);
		// this.tasksBySlots.set(slot, task);
		// this.taskRunner.append(task);
		// task.slot.heat = ArpHeat.Warming;
	}

	public function waitBySlot(slot:ArpUntypedSlot):Void {
		if (this.tasksBySlots.exists(slot)) {
			var task:IPrepareTask = this.tasksBySlots.get(slot);
			task.waiting = true;
			this.taskRunner.wait(task);
		}
	}

	public function notifyBySlot(slot:ArpUntypedSlot):Void {
		if (this.tasksBySlots.exists(slot)) {
			var task:IPrepareTask = this.tasksBySlots.get(slot);
			task.waiting = false;
			this.taskRunner.notify(task);
		}
	}
}
