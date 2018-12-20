package arp.macro.fields;

#if macro

import arp.domain.reflect.ArpFieldKind;
import arp.macro.defs.MacroArpFieldDefinition;
import arp.macro.defs.MacroArpMetaArpDefault;
import arp.macro.fields.base.MacroArpFieldBase;
import arp.macro.stubs.ds.MacroArpSwitchBlock;
import haxe.macro.Expr;

class MacroArpValueField extends MacroArpFieldBase implements IMacroArpField {

	public var type(default, null):IMacroArpValueType;
	override private function get_arpFieldKind():ArpFieldKind return this.type.arpFieldKind();

	public function new(fieldDef:MacroArpFieldDefinition, type:IMacroArpValueType) {
		super(fieldDef);
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

	public function buildInitBlock(initBlock:Array<Expr>):Void {
		switch (this.fieldDef.metaArpDefault) {
			case MacroArpMetaArpDefault.Zero:
				if (this.fieldDef.nativeDefault == null) {
					initBlock.push(macro @:pos(this.nativePos) { this.$i_nativeName = ${this.type.createEmptyVo(this.nativePos)}; });
				}
			case MacroArpMetaArpDefault.Simple(s):
				initBlock.push(macro @:pos(this.nativePos) { this.$i_nativeName = ${this.type.createWithString(this.nativePos, s)}; });
		}
	}

	public function buildHeatLaterBlock(heatLaterBlock:Array<Expr>):Void {
		heatLaterBlock.push(macro @:pos(this.nativePos) { null; });
	}

	public function buildHeatUpBlock(heatUpBlock:Array<Expr>):Void {
		heatUpBlock.push(macro @:pos(this.nativePos) { null; });
	}

	public function buildHeatDownBlock(heatDownBlock:Array<Expr>):Void {
		heatDownBlock.push(macro @:pos(this.nativePos) { null; });
	}

	public function buildDisposeBlock(disposeBlock:Array<Expr>):Void {
		disposeBlock.push(macro @:pos(this.nativePos) { null; });
	}

	public function buildConsumeSeedElementBlock(cases:MacroArpSwitchBlock):Void {
		if (this.isSeedableAsGroup) {
			var caseBlock:Array<Expr> = [];
			cases.pushCase(this.eGroupName, this.nativePos, caseBlock);
			caseBlock.push(macro @:pos(this.nativePos) {
				${this.type.readSeedElement(this.nativePos, macro element, this.i_nativeName)};
			});
		}
		if (this.isSeedableAsElement) {
			var caseBlock:Array<Expr> = [];
			cases.pushCase(this.eElementName, this.nativePos, caseBlock, -2);
			caseBlock.push(macro @:pos(this.nativePos) {
				${this.type.readSeedElement(this.nativePos, macro element, this.i_nativeName)};
			});
		}
	}

	public function buildReadSelfBlock(fieldBlock:Array<Expr>):Void {
		fieldBlock.push(macro @:pos(this.nativePos) { ${this.type.readAsPersistable(this.nativePos, this.eGroupName, this.i_nativeName)}; });
	}

	public function buildWriteSelfBlock(fieldBlock:Array<Expr>):Void {
		var eField:Expr = macro @:pos(this.nativePos) this.$i_nativeName;
		fieldBlock.push(macro @:pos(this.nativePos) { ${this.type.writeAsPersistable(this.nativePos, this.eGroupName, eField)}; });
	}

	public function buildCopyFromBlock(copyFromBlock:Array<Expr>):Void {
		copyFromBlock.push(macro @:pos(this.nativePos) { ${this.type.copyFrom(this.nativePos, this.i_nativeName)}; });
	}
}

#end
