package arp.domain.prepare;

import arp.domain.ArpDomain;
import arp.domain.dump.ArpDomainDirectoryScanner;

class ArpDomainGcScanner extends ArpDomainDirectoryScanner<Bool> {

	public function new(domain:ArpDomain) super(domain);

	public static function execute(domain:ArpDomain):Void {
		var visitor:ArpDomainGcVisitor = new ArpDomainGcVisitor();
		new ArpDomainGcScanner(domain).scan(visitor);
	}
}

private class ArpDomainGcVisitor implements IArpDomainDirectoryVisitor<Bool> {

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
		if (slot.refCount == 0) slot.delReference();
	}
}
