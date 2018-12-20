package arp.domain.dump;

import arp.domain.ArpUntypedSlot;
import arp.domain.core.ArpType;
import arp.ds.impl.StdMap;
import arp.ds.Tree;

@:access(arp.domain.ArpDomain)
class ArpDomainDump {

	private var domain:ArpDomain;
	private var typeFilter:ArpType -> Bool;

	private function defaultTypeFilter(type:ArpType):Bool return true;

	public function new(domain:ArpDomain, typeFilter:ArpType -> Bool) {
		this.domain = domain;
		if (typeFilter == null) typeFilter = this.defaultTypeFilter;
		this.typeFilter = typeFilter;
	}

	public function dumpSlotStatus():Tree<ArpDump> {
		var result:Tree<ArpDump> = ArpDump.ofDir(null, null);
		for (slot in domain.slots) {
			result.children.push(ArpDump.ofSlot(slot, null));
		}
		result.children.sort(ArpDump.compareTreeId);
		return result;
	}

	public function dumpSlotStatusByName():Tree<ArpDump> {
		return this._dumpSlotStatusByName(this.domain.root, "<<dir>>", new Map());
	}

	@:access(arp.domain.ArpDirectory)
	private function _dumpSlotStatusByName(dir:ArpDirectory, hashKey:String, visitedSlotIds:Map<String, Bool>):Tree<ArpDump> {
		var result:Tree<ArpDump> = ArpDump.ofDir(dir, hashKey);

		var children:StdMap<String, ArpDirectory> = dir.children;
		var slotNames:Array<String> = [for (key in children.keys()) key];
		slotNames.sort(compareString);
		for (name in slotNames) {
			var childrenDump:Tree<ArpDump> = _dumpSlotStatusByName(children.get(name), name, visitedSlotIds);
			if (childrenDump.children.length > 0) result.children.push(childrenDump);
		}

		var namesToVisit:Array<String> = [];
		var namesToIndex:Array<String> = [];
		var slots:Map<String, ArpUntypedSlot> = dir.slots;
		for (name in slots.keys()) {
			if (!typeFilter(new ArpType(name))) continue;
			var slot:ArpUntypedSlot = slots.get(name);
			if (visitedSlotIds.exists(slot.sid.toString())) {
				namesToIndex.push(name);
			} else {
				visitedSlotIds.set(slot.sid.toString(), true);
				namesToVisit.push(name);
			}
		}
		if (namesToVisit.length > 0) {
			namesToVisit.sort(compareString);
			for (name in namesToVisit) {
				result.children.push(ArpDump.ofSlot(slots.get(name), '<$name>'));
			}
		}
		if (namesToIndex.length > 0) {
			namesToIndex.sort(compareString);
			for (name in namesToIndex) {
				result.children.push(ArpDump.ofSlot(slots.get(name), '<$name>'));
			}
		}
		if (dir == this.domain.root) {
			var namesOrphan:Array<String> = [];
			for (child in this.domain.slots) {
				if (child.value != null && !typeFilter(child.value.arpType)) continue;
				if (!visitedSlotIds.exists(child.sid.toString())) {
					namesOrphan.push(child.sid.toString());
				}
			}
			namesOrphan.sort(compareString);
			for (name in namesOrphan) {
				result.children.push(ArpDump.ofSlot(domain.slots.get(name), '<<anonymous>>'));
			}
		}
		return result;
	}

	public static function compareString(a:String, b:String):Int {
		if (a > b) return 1;
		if (a < b) return -1;
		return 0;
	}

	public static var printer(get, never):ArpDumpStringPrinter;
	inline private static function get_printer():ArpDumpStringPrinter return new ArpDumpStringPrinter();

	public static var anonPrinter(get, never):ArpDumpAnonPrinter;
	inline private static function get_anonPrinter():ArpDumpAnonPrinter return new ArpDumpAnonPrinter();

	public static var jsonPrinter(get, never):ArpDumpJsonPrinter;
	inline private static function get_jsonPrinter():ArpDumpJsonPrinter return new ArpDumpJsonPrinter();
}
