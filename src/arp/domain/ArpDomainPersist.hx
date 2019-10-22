package arp.domain;

import arp.domain.core.ArpDid;
import arp.domain.dump.ArpDomainDirectoryScanner;
import arp.domain.dump.ArpDomainDirectoryScanner.IArpDomainDirectoryVisitor;
import arp.domain.core.ArpSid;
import arp.domain.core.ArpType;
import arp.persistable.IPersistInput;
import arp.persistable.IPersistOutput;

abstract ArpDomainPersist(ArpDomain) {

	inline public function new(value:ArpDomain) this = value;

	public function readSelf(input:IPersistInput):Void {
		readPartial(input, null);
	}

	public function readPartial(input:IPersistInput, typeFilter:ArpType -> Bool):Void {
		// TODO discard old objects
		var ic:Int = input.readInt32("numDirs");
		input.readListEnter("dirs");
		for (i in 0...ic) {
			input.nextEnter();
			var jc:Int = input.readInt32("numSlots");
			var dir:String = input.readUtf("path");
			input.readListEnter("slots");
			for (j in 0...jc) {
				var arpType:String = input.nextUtf();
				var arpSlot:ArpUntypedSlot = this.getOrCreateSlot(new ArpSid(input.nextUtf()));
				@:privateAccess this.dir(dir).slots.set(arpType, arpSlot);
			}
			input.readExit();
			input.readExit();
		}
		input.readExit();

		var sc:Int = input.readInt32("numSlots");
		input.readListEnter("slots");
		for (i in 0...sc) {
			readObject(input);
		}
		input.readExit();
	}

	private function readObject<T:IArpObject>(input:IPersistInput):Void {
		input.nextEnter();
		var className:String = input.readUtf("class");
		var heat:ArpHeat = ArpHeat.fromName(input.readUtf("heat"));
		var arpSlot:ArpSlot<T> = this.getOrCreateSlot(new ArpSid(input.readUtf("name")));
		if (className != "$null") {
			var arpObj:T = @:privateAccess this.registry.resolveWithFqn(className).arpInit(arpSlot, null);
			arpSlot.value = arpObj;
			arpObj.readSelf(input);
			switch (heat) {
				case ArpHeat.Cold:
				case ArpHeat.Warming | ArpHeat.Warm:
					this.heatLater(arpSlot);
			}
		}
		input.readExit();
	}

	public function writeSelf(output:IPersistOutput):Void {
		writePartial(output, null);
	}

	public function writePartial(output:IPersistOutput, typeFilter:ArpType -> Bool):Void {
		var dirs:Array<String> = [];
		new ArpDirectoryCollector(this, typeFilter, (path, slot) -> dirs.push(path));
		output.writeInt32("numDirs", dirs.length);
		output.writeListEnter("dirs");
		new ArpDirectoryCollector(this, typeFilter, (path:String, dir:ArpDirectory) -> {
			output.pushEnter();
			var arpTypes:Array<String> = @:privateAccess [for (arpType in dir.slots.keys()) arpType];
			output.writeInt32("numSlots", arpTypes.length);
			output.writeUtf("path", path);
			output.writeListEnter("slots");
			for (arpType in arpTypes) {
				output.pushUtf(arpType);
				var arpSlot = @:privateAccess dir.slots.get(arpType);
				output.pushUtf(arpSlot.sid.toString());
			}
			output.writeExit();
			output.writeExit();
		});
		output.writeExit();

		var slots:Map<String, ArpUntypedSlot> = @:privateAccess this.slots;
		output.writeInt32("numSlots", Lambda.count(slots));
		output.writeListEnter("slots");
		for (arpSlot in slots) {
			writeObject(output, arpSlot);
		}
		output.writeExit();
	}

	private function writeObject<T:IArpObject>(output:IPersistOutput, arpSlot:ArpSlot<T>):Void {
		output.pushEnter();
		var arpObj:T = arpSlot.value;
		if (arpObj == null) {
			output.writeUtf("class", "$null");
			output.writeUtf("heat", arpSlot.heat.toName());
			output.writeUtf("name", arpSlot.sid.toString());
			output.writeExit();
			return;
		}
		output.writeUtf("class", arpObj.arpTypeInfo.fqn);
		output.writeUtf("heat", arpSlot.heat.toName());
		output.writeUtf("name", arpSlot.sid.toString());
		arpObj.writeSelf(output);
		output.writeExit();
	}
}

private class ArpDirectoryCollector extends ArpDomainDirectoryScanner<String> implements IArpDomainDirectoryVisitor<String> {

	public dynamic function callback(path:String, dir:ArpDirectory):Void return;

	public function new(domain:ArpDomain, typeFilter:ArpType -> Bool, callback:(path:String, dir:ArpDirectory)->Void) {
		super(domain, typeFilter);
		this.callback = callback;
		this.scan(this);
	}

	public function visitRoot(dir:ArpDirectory):String return "";

	public function visitDirectory(parent:String, dir:ArpDirectory, label:String):String {
		var path:String = ArpDid.build(new ArpDid(parent), label).toString();
		this.callback(path, dir);
		return path;
	}

	public function visitBoundSlot(parent:String, dir:ArpDirectory, label:String, slot:ArpUntypedSlot):Void return;

	public function visitAnonymousSlot(label:String, slot:ArpUntypedSlot):Void return;
}
