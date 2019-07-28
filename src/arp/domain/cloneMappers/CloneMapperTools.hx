package arp.domain.cloneMappers;

import arp.domain.IArpCloneMapper;

class CloneMapperTools {
	inline public static function addMappingObj(cloneMapper:IArpCloneMapper, src:IArpObject, dest:IArpObject):Void {
		return cloneMapper.addMapping(src.arpSlot, dest.arpSlot);
	}

	inline public static function resolveObj(cloneMapper:IArpCloneMapper, src:IArpObject):IArpObject {
		return cloneMapper.resolve(src.arpSlot).value;
	}
}
