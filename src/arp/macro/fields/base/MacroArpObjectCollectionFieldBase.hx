package arp.macro.fields.base;

#if macro

import arp.macro.defs.MacroArpFieldDefinition;
import haxe.macro.Expr;

class MacroArpObjectCollectionFieldBase extends MacroArpCollectionFieldBase {

	private var contentNativeType:ComplexType;

	override private function get_arpType():String return MacroArpObjectRegistry.arpTypeOf(contentNativeType).toString();

	override private function createEmptyDs(concreteNativeTypePath:TypePath):Expr {
		return macro new $concreteNativeTypePath(slot.domain);
	}

	private function new(fieldDef:MacroArpFieldDefinition, contentNativeType:ComplexType, concreteDs:Bool) {
		super(fieldDef, concreteDs);
		this.contentNativeType = contentNativeType;
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
}

#end
