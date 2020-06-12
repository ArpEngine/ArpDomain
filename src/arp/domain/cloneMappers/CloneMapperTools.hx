package arp.domain.cloneMappers;

import arp.domain.IArpCloneMapper;

class CloneMapperTools {
	inline public static function addMappingObj<T:IArpObject>(cloneMapper:IArpCloneMapper, src:T, dest:T):Void {
		cloneMapper.addMapping(src.arpSlot, dest.arpSlot);
	}

	inline public static function resolveObj<T:IArpObject>(cloneMapper:IArpCloneMapper, src:Null<T>, preferDeepCopy:Bool):T {
		if (src == null) return null;
		return cast cloneMapper.resolve(src.arpSlot, preferDeepCopy).value;
	}
}
