package arp.macro;

#if macro

import haxe.macro.Expr;
import arp.domain.reflect.ArpFieldInfo;
import arp.macro.stubs.ds.MacroArpSwitchBlock;

interface IMacroArpField {
	public var isSeedableAsGroup(get, never):Bool;
	public var isSeedableAsElement(get, never):Bool;
	public var isPersistable(get, never):Bool;

	public function buildField(outFields:Array<Field>):Void;
	public function buildInitBlock(initBlock:Array<Expr>):Void;
	public function buildHeatLaterBlock(heatLaterBlock:Array<Expr>):Void;
	public function buildHeatUpBlock(heatUpBlock:Array<Expr>):Void;
	public function buildHeatDownBlock(heatDownBlock:Array<Expr>):Void;
	public function buildDisposeBlock(initBlock:Array<Expr>):Void;
	public function buildConsumeSeedElementBlock(cases:MacroArpSwitchBlock):Void;
	public function buildReadSelfBlock(fieldBlock:Array<Expr>):Void;
	public function buildWriteSelfBlock(fieldBlock:Array<Expr>):Void;
	public function buildCopyFromBlock(copyFromBlock:Array<Expr>):Void;

	public function toFieldInfo():ArpFieldInfo;
}

#end
