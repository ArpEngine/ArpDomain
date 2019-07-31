package arp.domain.cloneMappers;

class SerializeCloneMapper implements IArpCloneMapper {

	public function new() return;

	public function addMapping(src:ArpUntypedSlot, dest:ArpUntypedSlot):Void return;

	public function resolve(src:ArpUntypedSlot, preferDeepCopy:Bool):ArpUntypedSlot {
		var value:IArpObject = src.value;
		if (value == null) return src;
		return value.arpClone().arpSlot;
	}

	public function addMappingObj<T:IArpObject>(src:T, dest:T):Void CloneMapperTools.addMappingObj(this, src, dest);
	public function resolveObj<T:IArpObject>(src:T, preferDeepCopy:Bool):T return CloneMapperTools.resolveObj(this, src, preferDeepCopy);
}
