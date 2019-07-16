package arp.domain.prepare;

import arp.domain.dump.ArpDomainDirectoryScanner;
import arp.domain.dump.ArpDomainDirectoryScanner.IArpDomainDirectoryVisitor;
import arp.domain.ArpDomain;

class ArpHeatUpkeepScanner extends ArpDomainDirectoryScanner<Bool> {

	public function new(domain:ArpDomain) super(domain);

	public static function execute(domain:ArpDomain):Bool {
		var visitor:ArpHeatUpkeepVisitor = new ArpHeatUpkeepVisitor();
		new ArpHeatUpkeepScanner(domain).scan(visitor);
		return visitor.isPending;
	}
}

private class ArpHeatUpkeepVisitor implements IArpDomainDirectoryVisitor<Bool> {

	public var isPending(default, null):Bool = false;

	public function new() return;

	public function visitRoot(dir:ArpDirectory):Bool return false;
	public function visitDirectory(parent:Bool, dir:ArpDirectory, label:String):Bool return false;

	public function visitBoundSlot(parent:Bool, dir:ArpDirectory, label:String, slot:ArpUntypedSlot):Void {
		visitSlot(slot);
	}

	public function visitAnonymousSlot(label:String, slot:ArpUntypedSlot):Void {
		visitSlot(slot);
	}

	private function visitSlot(slot:ArpUntypedSlot):Void {
		switch (slot.heat) {
			case ArpHeat.Warming | ArpHeat.Warm:
				var value:IArpObject = slot.value;
				if (value.__arp_heatUpNow()) return;
				@:privateAccess value.arpDomain.prepareQueue.prepareLater(slot, false);
				isPending = true;
			case _:
		}
	}
}
