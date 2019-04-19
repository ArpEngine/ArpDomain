package arp.domain.dump;

import arp.domain.ArpUntypedSlot;
import arp.domain.core.ArpType;
import arp.ds.impl.StdMap;

@:access(arp.domain.ArpDomain)
class ArpDomainDirectoryScanner<T> {

	private var domain:ArpDomain;
	private var typeFilter:ArpType -> Bool;

	public function new(domain:ArpDomain, typeFilter:ArpType -> Bool) {
		if (typeFilter == null) typeFilter = ArpDomainDump.defaultTypeFilter;
		this.domain = domain;
		this.typeFilter = typeFilter;
	}

	public function scan(visitor:IArpDomainDirectoryVisitor<T>):Void {
		this.scanRoot(visitor, this.domain.root);
	}

	private function scanRoot(visitor:IArpDomainDirectoryVisitor<T>, dir:ArpDirectory):Void {
		var parent:T = visitor.visitRoot(dir);
		var visitedSlotIds:Map<String, Bool> = new Map<String, Bool>();

		scanDirectoryChildren(visitor, parent, dir, visitedSlotIds);

		var namesOrphan:Array<String> = [];
		for (child in this.domain.slots) {
			if (child.value != null && !typeFilter(child.value.arpType)) continue;
			if (!visitedSlotIds.exists(child.sid.toString())) {
				namesOrphan.push(child.sid.toString());
			}
		}
		namesOrphan.sort(ArpDomainDump.compareString);
		for (name in namesOrphan) {
			visitor.visitAnonymousSlot(name, domain.slots.get(name));
		}
	}

	private function scanDirectory(visitor:IArpDomainDirectoryVisitor<T>, parent:T, dir:ArpDirectory, label:String, visitedSlotIds:Map<String, Bool>):Void {
		parent = visitor.visitDirectory(parent, dir, label);
		scanDirectoryChildren(visitor, parent, dir, visitedSlotIds);
	}

	@:access(arp.domain.ArpDirectory)
	private function scanDirectoryChildren(visitor:IArpDomainDirectoryVisitor<T>, parent:T, dir:ArpDirectory, visitedSlotIds:Map<String, Bool>):Void {
		var children:StdMap<String, ArpDirectory> = dir.children;
		var slotNames:Array<String> = [for (key in children.keys()) key];
		slotNames.sort(ArpDomainDump.compareString);
		for (name in slotNames) {
			scanDirectory(visitor, parent, children.get(name), name, visitedSlotIds);
		}

		var namesToVisit:Array<String> = [];
		var slots:Map<String, ArpUntypedSlot> = dir.slots;
		for (name in slots.keys()) {
			if (!typeFilter(new ArpType(name))) continue;
			var slot:ArpUntypedSlot = slots.get(name);
			visitedSlotIds.set(slot.sid.toString(), true);
			namesToVisit.push(name);
		}
		if (namesToVisit.length > 0) {
			namesToVisit.sort(ArpDomainDump.compareString);
			for (name in namesToVisit) {
				visitor.visitBoundSlot(parent, dir, name, slots.get(name));
			}
		}
	}
}

interface IArpDomainDirectoryVisitor<T> {
	function visitRoot(dir:ArpDirectory):T;
	function visitDirectory(parent:T, dir:ArpDirectory, label:String):T;
	function visitBoundSlot(parent:T, dir:ArpDirectory, label:String, slot:ArpUntypedSlot):Void;
	function visitAnonymousSlot(label:String, slot:ArpUntypedSlot):Void;
}
