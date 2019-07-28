package arp.domain.cloneMappers;

class ShallowCloneMapper implements IArpCloneMapper {

	public function new() return;

	public function addMapping(src:ArpUntypedSlot, dest:ArpUntypedSlot):Void return;

	public function resolve(src:ArpUntypedSlot):ArpUntypedSlot {
		return src;
	}

	public function addMappingObj(src:IArpObject, dest:IArpObject):Void CloneMapperTools.addMappingObj(this, src, dest);
	public function resolveObj(src:IArpObject):IArpObject return CloneMapperTools.resolveObj(this, src);
}
