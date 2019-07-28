package arp.domain.cloneMappers;

class DeepCloneMapper implements IArpCloneMapper {

	private var map:Map<ArpUntypedSlot, ArpUntypedSlot>;

	public function new() {
		this.map = new Map<ArpUntypedSlot, ArpUntypedSlot>();
	}

	public function addMapping(src:ArpUntypedSlot, dest:ArpUntypedSlot):Void {
		this.map.set(src, dest);
	}

	public function resolve(src:ArpUntypedSlot):ArpUntypedSlot {
		if (this.map.exists(src)) return this.map.get(src);
		var value:IArpObject = src.value;
		if (value == null) return src;
		var slot:ArpUntypedSlot = value.arpClone().arpSlot;
		this.map.set(src, slot);
		return slot;
	}

	public function addMappingObj(src:IArpObject, dest:IArpObject):Void CloneMapperTools.addMappingObj(this, src, dest);
	public function resolveObj(src:IArpObject):IArpObject return CloneMapperTools.resolveObj(this, src);
}
