package arp.domain.dump;

import arp.ds.tree.ITreePrinter;
import arp.ds.Tree;

class ArpDumpStringPrinter implements ITreePrinter<ArpDump, String> {

	public function new() {
	}

	public function format(tree:Tree<ArpDump>, depth:Int = -1, level:Int = 0):String {
		var item:ArpDump = tree.value;
		var indent:String = StringTools.lpad("", " ", level * 2);
		var result = "";
		var entry:String;
		if (item.isDir) {
			entry = '${item.status} $indent';
			if (item.hashKey != null) {
				entry += '${item.hashKey}: ';
			}
			entry += '${item.id}';
			if (depth != 0 && tree.hasChildren) {
				result += '$entry {\n';
				for (item in tree.children) {
					result += format(item, depth - 1, level + 1);
				}
				result += '$indent  }\n';
			} else {
				result += '$entry\n';
			}
		} else {
			entry = '${item.status} $indent';
			if (item.hashKey != null) {
				entry += '${item.hashKey}: ';
			}
			entry += '${item.id} [${item.refCount}]';
			result += '$entry\n';
		}
		return result;
	}
}
