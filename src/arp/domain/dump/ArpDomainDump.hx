package arp.domain.dump;

import arp.domain.dump.ArpDomainDirectoryScanner.IArpDomainDirectoryVisitor;
import arp.domain.ArpUntypedSlot;
import arp.domain.core.ArpType;
import arp.ds.Tree;

@:access(arp.domain.ArpDomain)
class ArpDomainDump implements IArpDomainDirectoryVisitor<Tree<ArpDump>> {

	private var domain:ArpDomain;
	private var typeFilter:ArpType -> Bool;
	private var result:Tree<ArpDump>;

	public static function defaultTypeFilter(type:ArpType):Bool return true;

	public function new(domain:ArpDomain, typeFilter:ArpType -> Bool) {
		if (typeFilter == null) typeFilter = defaultTypeFilter;
		this.domain = domain;
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
		new ArpDomainDirectoryScanner(this.domain, this.typeFilter).scan(this);
		return this.result;
	}

	public function visitRoot(dir:ArpDirectory):Tree<ArpDump> {
		var tree:Tree<ArpDump> = ArpDump.ofDir(dir, "<<dir>>");
		this.result = tree;
		return tree;
	}

	public function visitDirectory(parent:Tree<ArpDump>, dir:ArpDirectory, label:String):Tree<ArpDump> {
		var tree:Tree<ArpDump> = ArpDump.ofDir(dir, label);
		parent.children.push(tree);
		return tree;
	}

	public function visitBoundSlot(parent:Tree<ArpDump>, dir:ArpDirectory, label:String, slot:ArpUntypedSlot):Void {
		parent.children.push(ArpDump.ofSlot(slot, '<$label>'));
	}

	public function visitAnonymousSlot(label:String, slot:ArpUntypedSlot):Void {
		this.result.children.push(ArpDump.ofSlot(slot, '<<anonymous>>'));
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
