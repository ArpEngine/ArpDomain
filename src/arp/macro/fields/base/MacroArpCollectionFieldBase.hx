package arp.macro.fields.base;

#if macro

import arp.macro.defs.MacroArpFieldDefinition;
import haxe.macro.Expr;
import haxe.macro.Printer;

class MacroArpCollectionFieldBase extends MacroArpFieldBase {

	private var concreteDs:Bool;

	private var _nativeType:ComplexType;
	override private function get_nativeType():ComplexType {
		return if (_nativeType != null) _nativeType else _nativeType = if (concreteDs) super.nativeType else guessConcreteNativeType();
	}

	private function new(fieldDef:MacroArpFieldDefinition, concreteDs:Bool) {
		super(fieldDef);
		this.concreteDs = concreteDs;
	}

	public function buildField(outFields:Array<Field>):Void {
		var generated:Array<Field> = (macro class Generated {
			@:pos(this.nativePos)
			private var $i_nativeName:$nativeType = ${this.fieldDef.nativeDefault};
			@:pos(this.nativePos) @:noDoc @:noCompletion
			private function $iGet_nativeName():$nativeType return this.$i_nativeName;
		}).fields;
		this.nativeField.kind = FieldType.FProp("get", "never", nativeType, null);

		outFields.push(this.nativeField);
		for (g in generated) outFields.push(g);
	}

	public function buildInitBlock(initBlock:Array<Expr>):Void {
		if (this.fieldDef.nativeDefault == null) {
			initBlock.push(macro @:pos(this.nativePos) { this.$i_nativeName = ${this.createEmptyDs(this.concreteNativeTypePath())}; } );
		}
	}

	private function createEmptyDs(concreteNativeTypePath:TypePath):Expr {
		return macro new $concreteNativeTypePath();
	}

	private function concreteNativeTypePath():TypePath {
		var concreteNativeType:ComplexType = this.nativeType;
		return switch (concreteNativeType) {
			case ComplexType.TPath(p):
				p;
			case _:
				MacroArpUtil.fatal("error", this.nativePos);
		}
	}

	private function guessConcreteNativeType():ComplexType {
		return MacroArpUtil.fatal(new Printer().printComplexType(super.nativeType) + "is not constructable", this.nativePos);
	}
}

#end
