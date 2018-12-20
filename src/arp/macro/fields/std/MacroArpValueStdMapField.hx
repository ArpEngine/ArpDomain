package arp.macro.fields.std;

#if macro

import arp.domain.reflect.ArpFieldDs;
import arp.macro.defs.MacroArpFieldDefinition;
import arp.macro.fields.base.MacroArpValueCollectionFieldBase;
import arp.macro.stubs.ds.MacroArpSwitchBlock;
import haxe.macro.Expr;

class MacroArpValueStdMapField extends MacroArpValueCollectionFieldBase implements IMacroArpField {

	override private function get_arpFieldDs():ArpFieldDs return ArpFieldDs.StdMap;

	override private function guessConcreteNativeType():ComplexType {
		return macro:Map;
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
		initBlock.push(macro @:pos(this.nativePos) { null; } );
	}

	public function buildConsumeSeedElementBlock(cases:MacroArpSwitchBlock):Void {
		if (this.isSeedableAsGroup) {
			var caseBlock:Array<Expr> = [];
			cases.pushCase(this.eGroupName, this.nativePos, caseBlock);
			caseBlock.push(macro @:pos(this.nativePos) {
				for (e in element) this.$i_nativeName.set(element.key, ${this.type.createSeedElement(this.nativePos, macro e)});
			});
		}
		if (this.isSeedableAsElement) {
			var caseBlock:Array<Expr> = [];
			cases.pushCase(this.eElementName, this.nativePos, caseBlock, -1);
			caseBlock.push(macro @:pos(this.nativePos) {
				this.$i_nativeName.set(element.key, ${this.type.createSeedElement(this.nativePos, macro element)});
			});
		}
	}

	public function buildReadSelfBlock(fieldBlock:Array<Expr>):Void {
		// intentionally serialized
		fieldBlock.push(macro @:pos(this.nativePos) {
			this.$i_nativeName = haxe.Unserializer.run(input.readUtf($v{i_nativeName}));
		});
	}

	public function buildWriteSelfBlock(fieldBlock:Array<Expr>):Void {
		// intentionally serialized
		fieldBlock.push(macro @:pos(this.nativePos) {
			output.writeUtf($v{i_nativeName}, haxe.Serializer.run(this.$i_nativeName));
		});
	}

	public function buildCopyFromBlock(copyFromBlock:Array<Expr>):Void {
		copyFromBlock.push(macro @:pos(this.nativePos) {
			this.$i_nativeName = new Map();
			for (k in src.$i_nativeName.keys()) this.$i_nativeName.set(k, src.$i_nativeName.get(k));
		});
	}
}

#end
