package arp.domain;

import arp.domain.cloneMappers.DeepCloneMapper;
import arp.domain.cloneMappers.SelectiveCloneMapper;
import arp.domain.cloneMappers.SerializeCloneMapper;
import arp.domain.cloneMappers.ShallowCloneMapper;

class ArpCloneMappers {

	inline public static function valueOrDefault(cloneMapper:Null<IArpCloneMapper>):IArpCloneMapper {
		return if (cloneMapper != null) cloneMapper else selective();
	}

	inline public static function shallow():IArpCloneMapper return new ShallowCloneMapper();

	inline public static function selective():IArpCloneMapper return new SelectiveCloneMapper();

	inline public static function deep():IArpCloneMapper return new DeepCloneMapper();

	inline public static function serialize():IArpCloneMapper return new SerializeCloneMapper();
}
