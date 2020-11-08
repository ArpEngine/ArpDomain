package arp.macro.stubs;

import arp.macro.MacroArpObjectRegistry;
import arp.macro.expr.ds.MacroArpSwitchBlock;
import haxe.macro.Context;
import haxe.macro.Expr;

// this class is meant to be called from expression macro
@:noDoc @:noCompletion
class MacroArpObjectBlockStubs {

#if macro

	private static function getTemplate():MacroArpObject {
		return MacroArpObjectRegistry.getLocalMacroArpObject();
	}

	// TODO: refactor
	public static function buildBlock(iFieldName:String, forPersist:Bool = false):Expr {
		return macro arp.macro.stubs.MacroArpObjectBlockStubs.block($v{iFieldName}, $v{forPersist});
	}

	public static function buildInitBlock():Expr return buildBlock("buildInitBlock");
	public static function buildHeatLaterDepsBlock():Expr return buildBlock("buildHeatLaterDepsBlock");
	public static function buildHeatUpNowBlock():Expr return buildBlock("buildHeatUpNowBlock");
	public static function buildHeatDownNowBlock():Expr return buildBlock("buildHeatDownNowBlock");
	public static function buildDisposeBlock():Expr return buildBlock("buildDisposeBlock");
	public static function buildReadSelfBlock():Expr return buildBlock("buildReadSelfBlock", true);
	public static function buildWriteSelfBlock():Expr return buildBlock("buildWriteSelfBlock", true);
	public static function buildCopyFromBlock():Expr return buildBlock("buildCopyFromBlock");

	public static function buildArpConsumeSeedElementBlock():Expr {
		return macro arp.macro.stubs.MacroArpObjectBlockStubs.arpConsumeSeedElementBlock();
	}

#end

	macro public static function block(iFieldName:String, forPersist:Bool = false):Expr {
		var block:Array<Expr> = [];
		for (arpField in getTemplate().arpFields) {
			if (forPersist) {
				if (!arpField.isPersistable) continue;
			} else {
				macro null;
			}
			Reflect.callMethod(arpField, Reflect.field(arpField, iFieldName), [block]);
		}
		return macro @:mergeBlock $b{ block };
	}

	macro public static function arpConsumeSeedElementBlock():Expr {
		var cases:MacroArpSwitchBlock = new MacroArpSwitchBlock(macro element.seedName);

		if (getTemplate().classDef.isDerived) {
			cases.eDefault = macro { super.arpConsumeSeedElement(element, autoKey); }
		} else {
			cases.eDefault = macro if (element.seedName != "value") throw new arp.errors.loadErrors.ArpSeedFieldError(arpTypeInfo + " could not accept <" + element.seedName + ">");
		}

		for (arpField in getTemplate().arpFields) {
			arpField.buildConsumeSeedElementBlock(cases);
		}

		return cases.toExpr(Context.currentPos());
	}
}
