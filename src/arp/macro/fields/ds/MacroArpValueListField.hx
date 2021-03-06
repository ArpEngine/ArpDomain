package arp.macro.fields.ds;

#if macro

import arp.persistable.IPersistOutput;
import arp.persistable.IPersistInput;
import arp.domain.reflect.ArpFieldDs;
import arp.macro.defs.MacroArpFieldDefinition;
import arp.macro.fields.base.MacroArpValueCollectionFieldBase;
import arp.macro.expr.ds.MacroArpSwitchBlock;
import haxe.macro.Expr;

class MacroArpValueListField extends MacroArpValueCollectionFieldBase implements IMacroArpField {

	override private function get_arpFieldDs():ArpFieldDs return ArpFieldDs.DsIList;

	override private function guessConcreteNativeType():ComplexType {
		var contentNativeType:ComplexType = this.type.nativeType();
		return macro:arp.ds.impl.ArrayList<$contentNativeType>;
	}

	public function new(fieldDef:MacroArpFieldDefinition, type:IMacroArpValueType, concreteDs:Bool) {
		super(fieldDef, type, concreteDs);
	}

	override public function buildInitBlock(initBlock:Array<Expr>):Void {
		super.buildInitBlock(initBlock);
		for (s in this.fieldDef.metaArpDefault) {
			initBlock.push(macro @:pos(this.nativePos) { this.$i_nativeName.push(${this.type.createWithString(this.nativePos, s)}); });
		}
	}

	public function buildHeatLaterDepsBlock(heatLaterDepsBlock:Array<Expr>):Void {
	}

	public function buildHeatUpNowBlock(heatUpNowBlock:Array<Expr>):Void {
	}

	public function buildHeatDownNowBlock(heatDownNowBlock:Array<Expr>):Void {
	}

	public function buildDisposeBlock(initBlock:Array<Expr>):Void {
	}

	public function buildConsumeSeedElementBlock(cases:MacroArpSwitchBlock):Void {
		if (this.isSeedableAsGroup) {
			var caseBlock:Array<Expr> = [];
			cases.pushCase(this.eGroupName, this.nativePos, caseBlock);
			caseBlock.push(macro @:pos(this.nativePos) {
				for (e in element) this.$i_nativeName.push(${this.type.createSeedElement(this.nativePos, macro e)});
			});
		}
		if (this.isSeedableAsElement) {
			var caseBlock:Array<Expr> = [];
			cases.pushCase(this.eElementName, this.nativePos, caseBlock, -1);
			caseBlock.push(macro @:pos(this.nativePos) {
				this.$i_nativeName.push(${this.type.createSeedElement(this.nativePos, macro element)});
			});
		}
	}

	public function buildReadSelfBlock(fieldBlock:Array<Expr>):Void {
		var c:Int;
		var input:IPersistInput;
		fieldBlock.push(macro @:pos(this.nativePos) {
			input.readEnter(${eGroupName});
			c = input.readInt32("c");
			input.readListEnter("list");
			for (i in 0...c) {
				this.$i_nativeName.push(${this.type.createNextAsPersistable(this.nativePos)});
			}
			input.readExit();
			input.readExit();
		});
	}

	public function buildWriteSelfBlock(fieldBlock:Array<Expr>):Void {
		var c:Int;
		var output:IPersistOutput;
		fieldBlock.push(macro @:pos(this.nativePos) {
			output.writeEnter(${eGroupName});
			output.writeInt32("c", this.$i_nativeName.length);
			output.writeListEnter("set");
			for (value in this.$i_nativeName) {
				${this.type.pushAsPersistable(this.nativePos, macro value)}
			}
			output.writeExit();
			output.writeExit();
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
