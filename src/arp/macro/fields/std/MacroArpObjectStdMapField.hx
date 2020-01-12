package arp.macro.fields.std;

#if macro

import arp.domain.reflect.ArpFieldDs;
import arp.macro.defs.MacroArpFieldDefinition;
import arp.macro.fields.base.MacroArpObjectCollectionFieldBase;
import arp.macro.stubs.ds.MacroArpSwitchBlock;
import haxe.macro.Expr;

class MacroArpObjectStdMapField extends MacroArpObjectCollectionFieldBase implements IMacroArpField {

	override private function get_arpFieldDs():ArpFieldDs return ArpFieldDs.StdMap;

	override private function guessConcreteNativeType():ComplexType {
		var contentNativeType:ComplexType = this.contentNativeType;
		return macro:arp.domain.ds.std.ArpObjectStdMap<$contentNativeType>;
	}

	public function new(fieldDef:MacroArpFieldDefinition, contentNativeType:ComplexType, concreteDs:Bool) {
		super(fieldDef, contentNativeType, concreteDs);
		if (fieldDef.nativeDefault != null) {
			MacroArpUtil.error("can't inline initialize arp reference field", fieldDef.nativePos);
		}
	}

	public function buildHeatLaterDepsBlock(heatLaterDepsBlock:Array<Expr>):Void {
		if (!this.arpHasBarrier) return;
		heatLaterDepsBlock.push(macro @:pos(this.nativePos) { for (slot in this.$i_nativeName.slots) this._arpDomain.heatLater(slot, $v{arpBarrierRequired}); });
	}

	public function buildHeatUpNowBlock(heatUpNowBlock:Array<Expr>):Void {
		if (!this.arpHasBarrier) return;
		heatUpNowBlock.push(macro @:pos(this.nativePos) { if (this.$i_nativeName.heat != arp.domain.ArpHeat.Warm) return false; });
	}

	public function buildHeatDownNowBlock(heatDownNowBlock:Array<Expr>):Void {
	}

	public function buildDisposeBlock(disposeBlock:Array<Expr>):Void {
		disposeBlock.push(macro @:pos(this.nativePos) { for (slot in this.$i_nativeName.slots) slot.delReference(); });
	}

	public function buildConsumeSeedElementBlock(cases:MacroArpSwitchBlock):Void {
		if (this.isSeedableAsGroup) {
			var caseBlock:Array<Expr> = [];
			cases.pushCase(this.eGroupName, this.nativePos, caseBlock);
			caseBlock.push(macro @:pos(this.nativePos) {
				for (e in element) this.$i_nativeName.slots.set(element.key, this._arpDomain.loadSeed(e, ${this.eArpType}).addReference());
			});
		}
		if (this.isSeedableAsElement) {
			var caseBlock:Array<Expr> = [];
			cases.pushCase(this.eElementName, this.nativePos, caseBlock, -1);
			caseBlock.push(macro @:pos(this.nativePos) {
				this.$i_nativeName.slots.set(element.key, this._arpDomain.loadSeed(element, ${this.eArpType}).addReference());
			});
		}
	}

	public function buildReadSelfBlock(fieldBlock:Array<Expr>):Void {
		fieldBlock.push(macro @:pos(this.nativePos) { input.readPersistable(${this.eGroupName}, this.$i_nativeName); });
	}

	public function buildWriteSelfBlock(fieldBlock:Array<Expr>):Void {
		fieldBlock.push(macro @:pos(this.nativePos) { output.writePersistable(${this.eGroupName}, this.$i_nativeName); });
	}

	public function buildCopyFromBlock(copyFromBlock:Array<Expr>):Void {
		copyFromBlock.push(macro @:pos(this.nativePos) {
			for (k in this.$i_nativeName.keys()) this.$i_nativeName.remove(k);
			for (k in src.$i_nativeName.keys()) this.$i_nativeName.set(k, cloneMapper.resolveObj(src.$i_nativeName.get(k), ${this.eArpDeepCopy}));
		});
	}
}

#end
