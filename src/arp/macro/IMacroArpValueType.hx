package arp.macro;

#if macro

import haxe.macro.Expr;
import arp.domain.core.ArpType;
import arp.domain.reflect.ArpFieldKind;

interface IMacroArpValueType {

	function nativeType():ComplexType;
	function arpFieldKind():ArpFieldKind;
	function arpType():ArpType;
	function createEmptyVo(pos:Position):Expr;
	function createWithString(pos:Position, cValue:String):Expr;
	function createSeedElement(pos:Position, eElement:Expr):Expr;
	function readSeedElement(pos:Position, eElement:Expr, iFieldName:String):Expr;
	function createAsPersistable(pos:Position, eName:Expr):Expr;
	function readAsPersistable(pos:Position, eName:Expr, iFieldName:String):Expr;
	function writeAsPersistable(pos:Position, eName:Expr, eValue:Expr):Expr;
	function copyFrom(pos:Position, iFieldName:String):Expr;

}

#end
