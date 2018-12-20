package arp.domain;

import arp.persistable.IPersistable;

#if !macro
@:autoBuild(arp.ArpDomainMacros.autoBuildStruct())
#end
interface IArpStruct extends IPersistable {
}
