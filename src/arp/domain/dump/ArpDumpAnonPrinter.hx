package arp.domain.dump;

import arp.domain.dump.ArpDumpAnon;
import arp.ds.tree.ITreePrinter;
import arp.ds.Tree;

class ArpDumpAnonPrinter implements ITreePrinter<ArpDump, ArpDumpAnon> {

	public function new() {
	}

	public function format(tree:Tree<ArpDump>, depth:Int = -1, level:Int = 0):ArpDumpAnon {
		var item:ArpDump = tree.value;
		if (item.isDir) {
			var dir:ArpDirAnon = {
				name: item.hashKey,
				arpDid: item.id
			};
			if (depth != 0 && tree.hasChildren) {
				dir.children = tree.children.map(function(child:Tree<ArpDump>):ArpDumpAnon {
					return format(child, depth - 1, level + 1);
				});
			}
			return dir;
		} else {
			var slot:ArpSlotAnon = {
				name: item.hashKey,
				arpSid: item.id,
				arpTemplateName: "slot.arpTemplateName",
				status: item.status,
				refCount: item.refCount
			};
			return slot;
		}
	}
}
