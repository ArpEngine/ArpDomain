package arp.macro.fields.ds;

#if macro

import arp.domain.reflect.ArpFieldDs;
import arp.macro.defs.MacroArpFieldDefinition;
import arp.macro.fields.base.MacroArpValueCollectionFieldBase;
import arp.macro.stubs.ds.MacroArpSwitchBlock;
import haxe.macro.Expr;

class MacroArpValueSetField extends MacroArpValueCollectionFieldBase implements IMacroArpField {

	override private function get_arpFieldDs():ArpFieldDs return ArpFieldDs.DsISet;

	override private function guessConcreteNativeType():ComplexType {
		var contentNativeType:ComplexType = this.type.nativeType();
		return macro:arp.ds.impl.ArraySet<$contentNativeType>;
	}

	public function new(fieldDef:MacroArpFieldDefinition, type:IMacroArpValueType, concreteDs:Bool) {
		super(fieldDef, type, concreteDs);
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

	public function buildDisposeBlock(initBlock:Array<Expr>):Void {
		initBlock.push(macro @:pos(this.nativePos) { null; });
	}

	public function buildConsumeSeedElementBlock(cases:MacroArpSwitchBlock):Void {
		if (this.isSeedableAsGroup) {
			var caseBlock:Array<Expr> = [];
			cases.pushCase(this.eGroupName, this.nativePos, caseBlock);
			caseBlock.push(macro @:pos(this.nativePos) {
				for (e in element) this.$i_nativeName.add(${this.type.createSeedElement(this.nativePos, macro e)});
			});
		}
		if (this.isSeedableAsElement) {
			var caseBlock:Array<Expr> = [];
			cases.pushCase(this.eElementName, this.nativePos, caseBlock, -1);
			caseBlock.push(macro @:pos(this.nativePos) {
				this.$i_nativeName.add(${this.type.createSeedElement(this.nativePos, macro element)});
			});
		}
	}

	public function buildReadSelfBlock(fieldBlock:Array<Expr>):Void {
		fieldBlock.push(macro @:pos(this.nativePos) {
			collection = input.readEnter(${eGroupName});
			nameList = collection.readNameList("keys");
			values = input.readEnter("values");
			for (name in nameList) {
				this.$i_nativeName.add(${this.type.createAsPersistable(this.nativePos, macro name)});
			}
			values.readExit();
			collection.readExit();
		});
	}

	public function buildWriteSelfBlock(fieldBlock:Array<Expr>):Void {
		fieldBlock.push(macro @:pos(this.nativePos) {
			collection = output.writeEnter(${eGroupName});
			uniqId.reset();
			collection.writeNameList("keys", [for (value in this.$i_nativeName) uniqId.next()]);
			values = output.writeEnter("values");
			uniqId.reset();
			for (value in this.$i_nativeName) {
				${this.type.writeAsPersistable(this.nativePos, macro uniqId.next(), macro value)}
			}
			values.writeExit();
			collection.writeExit();
		});
	}

	public function buildCopyFromBlock(copyFromBlock:Array<Expr>):Void {
		copyFromBlock.push(macro @:pos(this.nativePos) {
			this.$i_nativeName.clear();
			for (v in src.$i_nativeName) this.$i_nativeName.add(v);
		});
	}
}

#end
