package arp.domain.cloneMappers;

class ShallowCloneMapper implements IArpCloneMapper {

	public function new() return;

	public function addMapping(src:ArpUntypedSlot, dest:ArpUntypedSlot):Void return;

	public function resolve(src:ArpUntypedSlot, owner:Bool):ArpUntypedSlot {
		return src;
	}

	public function addMappingObj<T:IArpObject>(src:T, dest:T):Void CloneMapperTools.addMappingObj(this, src, dest);
	public function resolveObj<T:IArpObject>(src:T, owner:Bool):T return CloneMapperTools.resolveObj(this, src, owner);
}
