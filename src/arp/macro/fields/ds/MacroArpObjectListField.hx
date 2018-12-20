package arp.macro.fields.ds;

#if macro

import arp.domain.reflect.ArpFieldDs;
import arp.macro.defs.MacroArpFieldDefinition;
import arp.macro.fields.base.MacroArpObjectCollectionFieldBase;
import arp.macro.stubs.ds.MacroArpSwitchBlock;
import haxe.macro.Expr;

class MacroArpObjectListField extends MacroArpObjectCollectionFieldBase implements IMacroArpField {

	override private function get_arpFieldDs():ArpFieldDs return ArpFieldDs.DsIList;

	private var _nativeType:ComplexType;
	override private function get_nativeType():ComplexType return _nativeType;

	// use impl, because we have to directly get/set slots
	private function coerce(nativeType:ComplexType):ComplexType {
		switch (nativeType) {
			case ComplexType.TPath(t):
				return ComplexType.TPath({
					pack: "arp.domain.ds".split("."),
					name: "ArpObjectList",
					params: t.params
				});
			case _:
		}
		return nativeType;
	}

	override private function guessConcreteNativeType():ComplexType {
		var contentNativeType:ComplexType = this.contentNativeType;
		return macro:arp.domain.ds.ArpObjectList<$contentNativeType>;
	}

	public function new(fieldDef:MacroArpFieldDefinition, contentNativeType:ComplexType, concreteDs:Bool) {
		super(fieldDef, contentNativeType, concreteDs);
		if (!concreteDs) _nativeType = coerce(super.nativeType);
	}

	public function buildHeatLaterBlock(heatLaterBlock:Array<Expr>):Void {
		if (!this.arpHasBarrier) return;
		heatLaterBlock.push(macro @:pos(this.nativePos) { for (slot in this.$i_nativeName.slotList) this._arpDomain.heatLater(slot, $v{arpBarrierRequired}); });
	}

	public function buildHeatUpBlock(heatUpBlock:Array<Expr>):Void {
		if (!this.arpHasBarrier) return;
		heatUpBlock.push(macro @:pos(this.nativePos) { if (this.$i_nativeName.heat != arp.domain.ArpHeat.Warm) return false; });
	}

	public function buildHeatDownBlock(heatDownBlock:Array<Expr>):Void {
		heatDownBlock.push(macro @:pos(this.nativePos) { null; });
	}

	public function buildDisposeBlock(disposeBlock:Array<Expr>):Void {
		disposeBlock.push(macro @:pos(this.nativePos) { for (slot in this.$i_nativeName.slotList) slot.delReference(); });
	}

	public function buildConsumeSeedElementBlock(cases:MacroArpSwitchBlock):Void {
		if (this.isSeedableAsGroup) {
			var caseBlock:Array<Expr> = [];
			cases.pushCase(this.eGroupName, this.nativePos, caseBlock);
			caseBlock.push(macro @:pos(this.nativePos) {
				for (e in element) this.$i_nativeName.slotList.push(this._arpDomain.loadSeed(e, ${this.eArpType}).addReference());
			});
		}

		if (this.isSeedableAsElement) {
			var caseBlock:Array<Expr> = [];
			cases.pushCase(this.eElementName, this.nativePos, caseBlock, -1);
			caseBlock.push(macro @:pos(this.nativePos) {
				this.$i_nativeName.slotList.push(this._arpDomain.loadSeed(element, ${this.eArpType}).addReference());
			});
		}
	}

	public function buildReadSelfBlock(fieldBlock:Array<Expr>):Void {
		fieldBlock.push(macro @:pos(this.nativePos) {
			input.readPersistable(${this.eGroupName}, this.$i_nativeName);
		});
	}

	public function buildWriteSelfBlock(fieldBlock:Array<Expr>):Void {
		fieldBlock.push(macro @:pos(this.nativePos) {
			output.writePersistable(${this.eGroupName}, this.$i_nativeName);
		});
	}

	public function buildCopyFromBlock(copyFromBlock:Array<Expr>):Void {
		copyFromBlock.push(macro @:pos(this.nativePos) {
			this.$i_nativeName.clear();
			for (v in src.$i_nativeName) this.$i_nativeName.push(v);
		});
	}
}

#end
