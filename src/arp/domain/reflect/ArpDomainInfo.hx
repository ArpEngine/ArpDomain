package arp.domain.reflect;

import arp.domain.core.ArpType;

class ArpDomainInfo {

	public var classInfos(default, null):Array<ArpClassInfo>;
	public var structInfos(default, null):Array<ArpClassInfo>;
	public var templateInfos(default, null):Array<ArpClassInfo>;

	public function new() {
		this.classInfos = [];
		this.structInfos = [];
		this.templateInfos = [];
	}

	public function findStructInfo(arpType:ArpType):Null<ArpClassInfo> {
		for (structInfo in this.structInfos) {
			if (structInfo.arpType == arpType) return structInfo;
		}
		return null;
	}

	// FIXME @:followAbstracts
	public function groupByArpType():Map<String, Array<ArpClassInfo>> {
		var result:Map<String, Array<ArpClassInfo>> = new Map();
		for (classInfo in this.classInfos) {
			var arpType:String = classInfo.arpType;
			if (result.exists(arpType)) {
				result.get(arpType).push(classInfo);
			} else {
				result.set(arpType, [classInfo]);
			}
		}
		return result;
	}
}
