package arp.domain.cloneMappers;

class OwnerCloneMapper implements IArpCloneMapper {

	private var map:Map<ArpUntypedSlot, ArpUntypedSlot>;

	public function new() {
		this.map = new Map<ArpUntypedSlot, ArpUntypedSlot>();
	}

	public function addMapping(src:ArpUntypedSlot, dest:ArpUntypedSlot):Void {
		this.map.set(src, dest);
	}

	public function resolve(src:ArpUntypedSlot, owner:Bool):ArpUntypedSlot {
		if (!owner) return src;
		if (this.map.exists(src)) return this.map.get(src);
		var value:IArpObject = src.value;
		if (value == null) return src;
		var slot:ArpUntypedSlot = value.arpClone().arpSlot;
		this.map.set(src, slot);
		return slot;
	}

	public function addMappingObj<T:IArpObject>(src:T, dest:T):Void CloneMapperTools.addMappingObj(this, src, dest);
	public function resolveObj<T:IArpObject>(src:T, owner:Bool):T return CloneMapperTools.resolveObj(this, src, owner);
}
