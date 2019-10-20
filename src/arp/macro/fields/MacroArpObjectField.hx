package arp.macro.fields;

#if macro

import arp.macro.defs.MacroArpFieldDefinition;
import arp.macro.defs.MacroArpMetaArpDefault;
import arp.macro.fields.base.MacroArpFieldBase;
import arp.macro.stubs.ds.MacroArpSwitchBlock;
import haxe.macro.Expr;

class MacroArpObjectField extends MacroArpFieldBase implements IMacroArpField {

	private var nativeSlotType(get, never):ComplexType;
	inline private function get_nativeSlotType():ComplexType {
		return ComplexType.TPath({
			pack: "arp.domain".split("."), name: "ArpSlot", params: [TypeParam.TPType(this.nativeType)]
		});
	}

	public function new(fieldDef:MacroArpFieldDefinition) {
		super(fieldDef);
		if (fieldDef.nativeDefault != null) {
			MacroArpUtil.error("can't inline initialize arp reference field", fieldDef.nativePos);
		}
	}

	public function buildField(outFields:Array<Field>):Void {
		var generated:Array<Field> = (macro class Generated {
			@:pos(this.nativePos)
			public var $iNativeSlot(default, null):$nativeSlotType;
			@:pos(this.nativePos) @:noDoc @:noCompletion
			private function $iGet_nativeName():$nativeType return this.$iNativeSlot.value;
			@:pos(this.nativePos) @:noDoc @:noCompletion
			private function $iSet_nativeName(value:$nativeType):$nativeType {
				this.$iNativeSlot = arp.domain.ArpSlot.of(value, this._arpDomain).takeReference(this.$iNativeSlot);
				return value;
			}
		}).fields;
		generated[0].access = this.nativeField.access;
		this.nativeField.kind = FieldType.FProp("get", this.fieldDef.metaArpReadOnly ? "never" : "set", nativeType, null);
		outFields.push(nativeField);
		for (g in generated) {
			if (g.name == iSet_nativeName && this.fieldDef.metaArpReadOnly) continue;
			outFields.push(g);
		}
	}

	public function buildInitBlock(initBlock:Array<Expr>):Void {
		switch (this.fieldDef.metaArpDefault) {
			case MacroArpMetaArpDefault.Zero:
				initBlock.push(macro @:pos(this.nativePos) { this.$iNativeSlot = slot.domain.nullSlot; });
			case MacroArpMetaArpDefault.Simple(s):
				// FIXME oooo
				initBlock.push(macro @:pos(this.nativePos) { this.$iNativeSlot = (if (slot.primaryDir != null) slot.primaryDir else slot.domain.root).query($v{s}, ${this.eArpType}).slot().addReference(); });
		}
	}

	public function buildHeatLaterDepsBlock(heatLaterDepsBlock:Array<Expr>):Void {
		if (!this.arpHasBarrier) return;
		heatLaterDepsBlock.push(macro @:pos(this.nativePos) { this._arpDomain.heatLater(this.$iNativeSlot, $v{arpBarrierRequired}); });
	}

	public function buildHeatUpNowBlock(heatUpNowBlock:Array<Expr>):Void {
		if (!this.arpHasBarrier) return;
		heatUpNowBlock.push(macro @:pos(this.nativePos) { if (this.$iNativeSlot.heat != arp.domain.ArpHeat.Warm) return false; });
	}

	public function buildHeatDownNowBlock(heatDownNowBlock:Array<Expr>):Void {
		if (!this.arpHasReverseBarrier) return;
		heatDownNowBlock.push(macro @:pos(this.nativePos) { this._arpDomain.heatDownNow(this.$iNativeSlot); });
	}

	public function buildDisposeBlock(disposeBlock:Array<Expr>):Void {
		disposeBlock.push(macro @:pos(this.nativePos) { this.$iNativeSlot.delReference(); this.$iNativeSlot = null; });
	}

	public function buildConsumeSeedElementBlock(cases:MacroArpSwitchBlock):Void {
		if (this.isSeedableAsGroup) {
			var caseBlock:Array<Expr> = [];
			cases.pushCase(this.eGroupName, this.nativePos, caseBlock);
			caseBlock.push(macro @:pos(this.nativePos) {
				this.$iNativeSlot = this._arpDomain.loadSeed(element, ${this.eArpType}).takeReference(this.$iNativeSlot);
			});
		}
		if (this.isSeedableAsElement) {
			var caseBlock:Array<Expr> = [];
			cases.pushCase(this.eElementName, this.nativePos, caseBlock, -2);
			caseBlock.push(macro @:pos(this.nativePos) {
				this.$iNativeSlot = this._arpDomain.loadSeed(element, ${this.eArpType}).takeReference(this.$iNativeSlot);
			});
		}
	}

	public function buildReadSelfBlock(fieldBlock:Array<Expr>):Void {
		fieldBlock.push(macro @:pos(this.nativePos) { this.$iNativeSlot = this._arpDomain.getOrCreateSlot(new arp.domain.core.ArpSid(input.readUtf(${this.eGroupName}))).takeReference(this.$iNativeSlot); });
	}

	public function buildWriteSelfBlock(fieldBlock:Array<Expr>):Void {
		fieldBlock.push(macro @:pos(this.nativePos) { output.writeUtf(${this.eGroupName}, this.$iNativeSlot.sid.toString()); });
	}

	public function buildCopyFromBlock(copyFromBlock:Array<Expr>):Void {
		copyFromBlock.push(macro @:pos(this.nativePos) { this.$iNativeSlot = cloneMapper.resolve(src.$iNativeSlot, ${this.eArpDeepCopy}).takeReference(this.$iNativeSlot); });
	}
}

#end
