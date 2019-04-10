package arp.domain;

import arp.persistable.IPersistInput;
import arp.domain.core.ArpType;
import arp.persistable.IPersistOutput;

abstract ArpDomainPersist(ArpDomain) {

	inline public function new(value:ArpDomain) this = value;

	public function readSelf(input:IPersistInput):Void {
		readPartial(input, this.allArpTypes);
	}

	inline public function readPartial(input:IPersistInput, arpTypes:Array<ArpType>):Void {
		for (arpType in arpTypes) readType(input, arpType);
	}

	public function readType(input:IPersistInput, arpType:ArpType):Void {
		throw "ArpDomainPersist.readType(): TODO";
	}

	public function writeSelf(output:IPersistOutput):Void {
		writePartial(output, this.allArpTypes);
	}

	inline public function writePartial(output:IPersistOutput, arpTypes:Array<ArpType>):Void {
		for (arpType in arpTypes) writeType(output, arpType);
	}

	public function writeType(output:IPersistOutput, arpType:ArpType):Void {
		throw "ArpDomainPersist.writeType(): TODO";
	}
}
