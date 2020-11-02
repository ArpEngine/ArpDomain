package arp.macro.fields.ds;

#if macro

import arp.persistable.IPersistOutput;
import arp.persistable.IPersistInput;
import arp.domain.reflect.ArpFieldDs;
import arp.macro.defs.MacroArpFieldDefinition;
import arp.macro.fields.base.MacroArpValueCollectionFieldBase;
import arp.macro.stubs.ds.MacroArpSwitchBlock;
import haxe.macro.Expr;

class MacroArpValueOmapField extends MacroArpValueCollectionFieldBase implements IMacroArpField {

	override private function get_arpFieldDs():ArpFieldDs return ArpFieldDs.DsIOmap;

	override private function guessConcreteNativeType():ComplexType {
		var contentNativeType:ComplexType = this.type.nativeType();
		return macro:arp.ds.impl.StdOmap<String, $contentNativeType>;
	}

	public function new(fieldDef:MacroArpFieldDefinition, type:IMacroArpValueType, concreteDs:Bool) {
		super(fieldDef, type, concreteDs);
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
				for (e in element) this.$i_nativeName.addPair(element.keyOrAuto(autoKey), ${this.type.createSeedElement(this.nativePos, macro e)});
			});
		}
		if (this.isSeedableAsElement) {
			var caseBlock:Array<Expr> = [];
			cases.pushCase(this.eElementName, this.nativePos, caseBlock, -1);
			caseBlock.push(macro @:pos(this.nativePos) {
				this.$i_nativeName.addPair(element.keyOrAuto(autoKey), ${this.type.createSeedElement(this.nativePos, macro element)});
			});
		}
	}

	public function buildReadSelfBlock(fieldBlock:Array<Expr>):Void {
		var c:Int;
		var input:IPersistInput;
		fieldBlock.push(macro @:pos(this.nativePos) {
			input.readEnter(${eGroupName});
			c = input.readInt32("c");
			input.readListEnter("omap");
			for (i in 0...c) {
				input.nextEnter();
				this.$i_nativeName.addPair(input.readUtf("k"), ${this.type.createAsPersistable(this.nativePos, macro input.readUtf("v"))});
				input.readExit();
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
			output.writeListEnter("omap");
			for (key => value in this.$i_nativeName) {
				output.pushEnter();
				output.writeUtf("k", key);
				${this.type.writeAsPersistable(this.nativePos, macro "v", macro value)}
				output.writeExit();
			}
			output.writeExit();
			output.writeExit();
		});
	}

	public function buildCopyFromBlock(copyFromBlock:Array<Expr>):Void {
		copyFromBlock.push(macro @:pos(this.nativePos) {
			this.$i_nativeName.clear();
			for (k in src.$i_nativeName.keys()) this.$i_nativeName.addPair(k, src.$i_nativeName.get(k));
		});
	}
}

#end
