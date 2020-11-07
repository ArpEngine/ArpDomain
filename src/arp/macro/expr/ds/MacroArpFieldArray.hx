package arp.macro.expr.ds;

#if macro

import haxe.macro.Expr.Field;

@:forward(iterator)
abstract MacroArpFieldArray(Array<Field>) from Array<Field> to Array<Field> {

	inline public static function empty():MacroArpFieldArray return new MacroArpFieldArray([]);

	inline public function new(value:Array<Field>) this = value;

	inline public function add(field:Field):MacroArpFieldArray {
		var hasField:Bool = Lambda.exists(this, (t:Field) -> (field.name == t.name));
		if (!hasField) this.push(field);
		return new MacroArpFieldArray(this);
	}

	inline public function merge(source:Array<Field>):MacroArpFieldArray {
		for (field in source) add(field);
		return new MacroArpFieldArray(this);
	}

	inline public function overwrite(source:Array<Field>):MacroArpFieldArray {
		return (this = new MacroArpFieldArray(source.copy()).merge(this));
	}
}
#end
