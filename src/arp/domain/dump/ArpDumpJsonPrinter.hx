package arp.domain.dump;

import haxe.Json;
import arp.ds.Tree;

class ArpDumpJsonPrinter {

	public function new() {
	}

	public function format(tree:Tree<ArpDump>):String {
		return Json.stringify(new ArpDumpAnonPrinter().format(tree));
	}
}
