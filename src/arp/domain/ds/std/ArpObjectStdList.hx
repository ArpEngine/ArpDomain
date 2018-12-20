package arp.domain.ds.std;

class ArpObjectStdList<T:IArpObject> extends List<T> {

	private var domain:ArpDomain;

	public var heat(get, never):ArpHeat;
	private function get_heat():ArpHeat {
		var result:ArpHeat = ArpHeat.Max;
		for (obj in this) {
			var h = obj.arpSlot.heat;
			if (result > h) result = h;
		}
		return result;
	}

	public function new(domain:ArpDomain) {
		super();
		this.domain = domain;
	}

	override public function add(item:T) {
		item.arpSlot.addReference();
		super.add(item);
	}

	override public function push(item:T) {
		item.arpSlot.addReference();
		super.push(item);
	}

	override public function pop():Null<T> {
		var item:T = super.pop();
		if (item != null) item.arpSlot.delReference();
		return item;
	}

	override public function clear():Void {
		for (item in this) item.arpSlot.delReference();
		super.clear();
	}

	override public function remove(v:T):Bool {
		v.arpSlot.delReference();
		return super.remove(v);
	}

}
