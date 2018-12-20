package arp.macro.fields.base;

#if macro

import arp.domain.reflect.ArpFieldKind;
import arp.macro.defs.MacroArpFieldDefinition;
import arp.macro.IMacroArpValueType;
import haxe.macro.Expr;

class MacroArpValueCollectionFieldBase extends MacroArpCollectionFieldBase {

	private var type:IMacroArpValueType;

	override private function get_arpType():String return MacroArpObjectRegistry.arpTypeOf(this.type.nativeType()).toString();
	override private function get_arpFieldKind():ArpFieldKind return this.type.arpFieldKind();

	private function new(fieldDef:MacroArpFieldDefinition, type:IMacroArpValueType, concreteDs:Bool) {
		super(fieldDef, concreteDs);
		this.type = type;
	}

	public function buildField(outFields:Array<Field>):Void {
		var generated:Array<Field> = (macro class Generated {
			@:pos(this.nativePos)
			private var $i_nativeName:$nativeType = ${this.fieldDef.nativeDefault};
			@:pos(this.nativePos) @:noDoc @:noCompletion
			private function $iGet_nativeName():$nativeType return this.$i_nativeName;
			@:pos(this.nativePos) @:noDoc @:noCompletion
			private function $iSet_nativeName(value:$nativeType):$nativeType return this.$i_nativeName = value;
		}).fields;
		this.nativeField.kind = FieldType.FProp("get", this.fieldDef.metaArpReadOnly ? "never" : "set", nativeType, null);
		outFields.push(this.nativeField);
		for (g in generated) {
			if (g.name == iSet_nativeName && this.fieldDef.metaArpReadOnly) continue;
			outFields.push(g);
		}
	}
}

#end
