package arp.domain;

import arp.domain.cloneMappers.DeepCloneMapper;
import arp.domain.cloneMappers.SerializeCloneMapper;
import arp.domain.cloneMappers.ShallowCloneMapper;

class ArpCloneMappers {

	public static function shallow():IArpCloneMapper return new ShallowCloneMapper();

	public static function deep():IArpCloneMapper return new DeepCloneMapper();

	public static function serialize():IArpCloneMapper return new SerializeCloneMapper();
}
