package arp.domain;

abstract ArpTemplateLike<T:IArpObject>(IArpTemplate<T>) from IArpTemplate<T> to IArpTemplate<T> {

	public function new(template:IArpTemplate<T>) this = template;

	@:from
	inline public static function concrete<T:IArpObject>(klass:Class<T>):ArpTemplateLike<T> return new ArpTemplate(klass);

	@:from
	inline public static function fromClass<T:IArpObject>(klass:Class<ArpTemplateLike<T>>):ArpTemplateLike<T> return Type.createInstance(klass, []);
}
