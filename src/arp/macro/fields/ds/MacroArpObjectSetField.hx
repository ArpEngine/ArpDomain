package arp.macro.fields.ds;

#if macro

import arp.domain.reflect.ArpFieldDs;
import arp.macro.defs.MacroArpFieldDefinition;
import arp.macro.fields.base.MacroArpObjectCollectionFieldBase;
import arp.macro.expr.ds.MacroArpSwitchBlock;
import haxe.macro.Expr;

class MacroArpObjectSetField extends MacroArpObjectCollectionFieldBase implements IMacroArpField {

	override private function get_arpFieldDs():ArpFieldDs return ArpFieldDs.DsISet;

	override private function guessConcreteNativeType():ComplexType {
		var contentNativeType:ComplexType = this.contentNativeType;
		return macro:arp.domain.ds.ArpObjectSet<$contentNativeType>;
	}

	public function new(fieldDef:MacroArpFieldDefinition, contentNativeType:ComplexType, concreteDs:Bool) {
		super(fieldDef, contentNativeType, concreteDs);
	}

	override public function buildInitBlock(initBlock:Array<Expr>):Void {
		super.buildInitBlock(initBlock);
		// FIXME oooo
		for (s in this.fieldDef.metaArpDefault) {
			initBlock.push(macro @:pos(this.nativePos) { this.$i_nativeName.slotSet.add((if (slot.primaryDir != null) slot.primaryDir else slot.domain.root).query($v{s}, ${this.eArpType}).slot().addReference()); });
		}
	}

	public function buildHeatLaterDepsBlock(heatLaterDepsBlock:Array<Expr>):Void {
		if (!this.arpHasBarrier) return;
		heatLaterDepsBlock.push(macro @:pos(this.nativePos) { for (slot in this.$i_nativeName.slotSet) this._arpDomain.heatLater(slot, $v{arpBarrierRequired}); });
	}

	public function buildHeatUpNowBlock(heatUpNowBlock:Array<Expr>):Void {
		if (!this.arpHasBarrier) return;
		heatUpNowBlock.push(macro @:pos(this.nativePos) { if (this.$i_nativeName.heat != arp.domain.ArpHeat.Warm) return false; });
	}

	public function buildHeatDownNowBlock(heatDownNowBlock:Array<Expr>):Void {
		if (!this.arpHasReverseBarrier) return;
		heatDownNowBlock.push(macro @:pos(this.nativePos) { for (slot in this.$i_nativeName.slotSet) this._arpDomain.heatDownNow(slot); });
	}

	public function buildDisposeBlock(disposeBlock:Array<Expr>):Void {
		disposeBlock.push(macro @:pos(this.nativePos) { for (slot in this.$i_nativeName.slotSet) slot.delReference(); });
	}

	public function buildConsumeSeedElementBlock(cases:MacroArpSwitchBlock):Void {
		if (this.isSeedableAsGroup) {
			var caseBlock:Array<Expr> = [];
			cases.pushCase(this.eGroupName, this.nativePos, caseBlock);
			caseBlock.push(macro @:pos(this.nativePos) {
				for (e in element) this.$i_nativeName.slotSet.add(this._arpDomain.loadSeed(e, ${this.eArpType}).addReference());
			});
		}
		if (this.isSeedableAsElement) {
			var caseBlock:Array<Expr> = [];
			cases.pushCase(this.eElementName, this.nativePos, caseBlock, -1);
			caseBlock.push(macro @:pos(this.nativePos) {
				this.$i_nativeName.slotSet.add(this._arpDomain.loadSeed(element, ${this.eArpType}).addReference());
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
			for (v in src.$i_nativeName) this.$i_nativeName.add(cloneMapper.resolveObj(v, ${this.eArpDeepCopy}));
		});
	}
}

#end
