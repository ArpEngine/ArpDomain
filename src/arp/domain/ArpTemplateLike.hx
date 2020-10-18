package arp.domain;

abstract ArpTemplateLike<T:IArpObject>(ArpTemplate<T>) from ArpTemplate<T> to ArpTemplate<T> {

	public function new(template:ArpTemplate<T>) this = template;

	@:from
	inline public static function concrete<T:IArpObject>(klass:Class<T>):ArpTemplateLike<T> return new ArpTemplate(klass);
}
