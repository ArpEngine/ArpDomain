package arp.macro.fields;

#if macro

import arp.domain.reflect.ArpFieldKind;
import arp.macro.defs.MacroArpFieldDefinition;
import arp.macro.expr.ds.MacroArpFieldList;
import arp.macro.expr.ds.MacroArpSwitchBlock;
import arp.macro.fields.base.MacroArpFieldBase;
import haxe.macro.Expr;

class MacroArpValueField extends MacroArpFieldBase implements IMacroArpField {

	public var type(default, null):IMacroArpValueType;
	override private function get_arpFieldKind():ArpFieldKind return this.type.arpFieldKind();

	public function new(fieldDef:MacroArpFieldDefinition, type:IMacroArpValueType) {
		super(fieldDef);
		this.type = type;
	}

	public function buildField(outFields:MacroArpFieldList):Void {
		var generated:Array<Field> = (macro class Generated {
			@:pos(this.nativePos)
			private var $i_nativeName:$nativeType = ${this.fieldDef.nativeDefault};
			@:pos(this.nativePos) @:noDoc @:noCompletion
			private function $iGet_nativeName():$nativeType return this.$i_nativeName;
			@:pos(this.nativePos) @:noDoc @:noCompletion
			private function $iSet_nativeName(value:$nativeType):$nativeType return this.$i_nativeName = value;
		}).fields;
		this.nativeField.kind = FieldType.FProp("get", this.fieldDef.metaArpReadOnly ? "never" : "set", nativeType, null);
		outFields.add(this.nativeField);
		for (g in generated) {
			if (g.name == iSet_nativeName && this.fieldDef.metaArpReadOnly) continue;
			outFields.add(g);
		}
	}

	public function buildInitBlock(initBlock:Array<Expr>):Void {
		var defaults:Array<String> = this.fieldDef.metaArpDefault;
		if (defaults.length == 0) {
			if (this.fieldDef.nativeDefault == null) {
				initBlock.push(macro @:pos(this.nativePos) { this.$i_nativeName = ${this.type.createEmptyVo(this.nativePos)}; });
			}
		} else {
			for (s in defaults) {
				initBlock.push(macro @:pos(this.nativePos) { this.$i_nativeName = ${this.type.createWithString(this.nativePos, s)}; });
			}
		}
	}

	public function buildHeatLaterDepsBlock(heatLaterDepsBlock:Array<Expr>):Void {
	}

	public function buildHeatUpNowBlock(heatUpNowBlock:Array<Expr>):Void {
	}

	public function buildHeatDownNowBlock(heatDownNowBlock:Array<Expr>):Void {
	}

	public function buildDisposeBlock(disposeBlock:Array<Expr>):Void {
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
