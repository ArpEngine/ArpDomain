package arp.domain.cloneMappers;

import arp.domain.IArpCloneMapper;

class CloneMapperTools {
	inline public static function addMappingObj<T:IArpObject>(cloneMapper:IArpCloneMapper, src:T, dest:T):Void {
		cloneMapper.addMapping(src.arpSlot, dest.arpSlot);
	}

	inline public static function resolveObj<T:IArpObject>(cloneMapper:IArpCloneMapper, src:T):T {
		return cast cloneMapper.resolve(src.arpSlot).value;
	}
}
