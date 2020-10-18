package arp.domain;

import arp.seed.ArpSeed;

interface IArpTemplate<T:IArpObject> {

	function arpTypeInfo():ArpTypeInfo;
	function alloc():T;
	function transformSeed(seed:ArpSeed):ArpSeed;
}
