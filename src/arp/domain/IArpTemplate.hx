package arp.domain;

import arp.seed.ArpSeed;

interface IArpTemplate<T:IArpObject> {

	var arpTypeInfo(get, never):ArpTypeInfo;

	function alloc():T;
	function transformSeed(seed:ArpSeed):ArpSeed;
}
