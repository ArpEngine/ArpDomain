package arp.macro.expr.ds;

#if macro

import haxe.macro.Expr.Field;

abstract MacroArpFieldList(Array<Field>) {

	inline public static function empty():MacroArpFieldList return new MacroArpFieldList([]);

	inline public function new(value:Array<Field>) this = value;

	inline public function toArray():Array<Field> return this;

	inline public function add(field:Field):MacroArpFieldList {
		var hasField:Bool = Lambda.exists(this, (t:Field) -> (field.name == t.name));
		if (!hasField) this.push(field);
		return new MacroArpFieldList(this);
	}

	inline public function merge(source:Array<Field>):MacroArpFieldList {
		for (field in source) add(field);
		return new MacroArpFieldList(this);
	}

	inline public function overwrite(source:Array<Field>):MacroArpFieldList {
		this = new MacroArpFieldList(source.copy()).merge(this).toArray();
		return new MacroArpFieldList(this);
	}
}
#end
