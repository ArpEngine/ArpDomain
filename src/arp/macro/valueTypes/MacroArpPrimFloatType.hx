package arp.macro.valueTypes;

#if macro

import haxe.macro.Expr;
import arp.domain.core.ArpType;
import arp.domain.reflect.ArpFieldKind;

class MacroArpPrimFloatType implements IMacroArpValueType {

	public function new() {
	}

	public function nativeType():ComplexType return macro:Float;
	public function arpFieldKind():ArpFieldKind return ArpFieldKind.PrimFloat;
	public function arpType():ArpType return new ArpType("Float");


	public function createEmptyVo(pos:Position):Expr {
		return macro @:pos(pos) { 0.0; };
	}

	public function createWithString(pos:Position, cValue:String):Expr {
		return macro @:pos(pos) $v{ arp.utils.ArpStringUtil.parseFloatDefault(cValue) };
	}

	public function createSeedElement(pos:Position, eElement:Expr):Expr {
		return macro @:pos(pos) { arp.utils.ArpSeedUtil.parseFloatDefault(${eElement}); };
	}

	public function readSeedElement(pos:Position, eElement:Expr, iFieldName:String):Expr {
		return macro @:pos(pos) { this.$iFieldName = arp.utils.ArpSeedUtil.parseFloatDefault(${eElement}); };
	}

	public function createAsPersistable(pos:Position, eName:Expr):Expr {
		return macro @:pos(pos) { input.readDouble(${eName}); };
	}

	public function readAsPersistable(pos:Position, eName:Expr, iFieldName:String):Expr {
		return macro @:pos(pos) { this.$iFieldName = input.readDouble(${eName}); };
	}

	public function writeAsPersistable(pos:Position, eName:Expr, eValue:Expr):Expr {
		return macro @:pos(pos) { output.writeDouble(${eName}, ${eValue}); };
	}

	public function copyFrom(pos:Position, iFieldName:String):Expr {
		return macro @:pos(pos) { this.$iFieldName = src.$iFieldName; };
	}
}

#end
