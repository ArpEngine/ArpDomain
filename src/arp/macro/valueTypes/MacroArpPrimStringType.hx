package arp.macro.valueTypes;

#if macro

import haxe.macro.Expr;
import arp.domain.core.ArpType;
import arp.domain.reflect.ArpFieldKind;
class MacroArpPrimStringType implements IMacroArpValueType {

	public function new() {
	}

	public function nativeType():ComplexType return macro:String;
	public function arpFieldKind():ArpFieldKind return ArpFieldKind.PrimString;
	public function arpType():ArpType return new ArpType("String");

	public function createEmptyVo(pos:Position):Expr {
		return macro @:pos(pos) { null; };
	}

	public function createWithString(pos:Position, cValue:String):Expr {
		return macro @:pos(pos) $v{cValue};
	}

	public function createSeedElement(pos:Position, eElement:Expr):Expr {
		return macro @:pos(pos) { ${eElement}.value; };
	}

	public function readSeedElement(pos:Position, eElement:Expr, iFieldName:String):Expr {
		return macro @:pos(pos) { this.$iFieldName = ${eElement}.value; };
	}

	public function createAsPersistable(pos:Position, eName:Expr):Expr {
		// if (nonNull)
		// return macro @:pos(pos) { input.readUtf(${eName}); };
		return macro @:pos(pos) { arp.persistable.PersistableTool.readNullableUtf(input, ${eName}); };
	}

	public function readAsPersistable(pos:Position, eName:Expr, iFieldName:String):Expr {
		// if (nonNull)
		// return macro @:pos(pos) { this.$iFieldName = input.readUtf(${eName}); };
		return macro @:pos(pos) { this.$iFieldName = arp.persistable.PersistableTool.readNullableUtf(input, ${eName}); };

	}

	public function writeAsPersistable(pos:Position, eName:Expr, eValue:Expr):Expr {
		// if (nonNull)
		// return macro @:pos(pos) { output.writeUtf($v{iFieldName}, ${eValue}); };
		return macro @:pos(pos) { arp.persistable.PersistableTool.writeNullableUtf(output, ${eName}, ${eValue}); };
	}

	public function createNextAsPersistable(pos:Position):Expr {
		// if (nonNull)
		// return macro @:pos(pos) { input.nextUtf(); };
		return macro @:pos(pos) { arp.persistable.PersistableTool.nextNullableUtf(input); };
	}

	public function nextAsPersistable(pos:Position, iFieldName:String):Expr {
		// if (nonNull)
		// return macro @:pos(pos) { this.$iFieldName = input.nextUtf(); };
		return macro @:pos(pos) { this.$iFieldName = arp.persistable.PersistableTool.nextNullableUtf(input); };
	}

	public function pushAsPersistable(pos:Position, eValue:Expr):Expr {
		// if (nonNull)
		// return macro @:pos(pos) { output.pushUtf($v{iFieldName}); };
		return macro @:pos(pos) { arp.persistable.PersistableTool.pushNullableUtf(output, ${eValue}); };
	}

	public function copyFrom(pos:Position, iFieldName:String):Expr {
		return macro @:pos(pos) { this.$iFieldName = src.$iFieldName; };
	}
}

#end
