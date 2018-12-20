package arp.macro.stubs.ds;

#if macro

import haxe.macro.Context;
import haxe.macro.ExprTools;
import haxe.macro.Expr;

class MacroArpSwitchBlock {

	private var e:Expr;
	private var cases:Map<String, MacroArpSwitchCase>;
	public var eDefault:Expr;

	public function new(e:Expr) {
		this.e = e;
		this.cases = [];
	}

	public function pushCase(eValue:ExprOf<String>, pos:Position, caseBlock:Array<Expr>, priority:Int = 0):Void {
		var value:String = ExprTools.getValue(eValue);
		if (this.cases.exists(value)) {
			var other:MacroArpSwitchCase = this.cases.get(value);
			if (priority >= -1) Context.warning("ambigious arp field " + value, pos);
			if (other.priority >= priority) return;
		}

		this.cases.set(value, {
			eValue: eValue,
			pos: pos,
			caseBlock: caseBlock,
			priority: priority
		});
	}

	public function toExpr(pos:Position):Expr {
		return { pos: pos, expr: ExprDef.ESwitch(this.e, this.toCases(), this.eDefault) };
	}

	private function toCases():Array<Case> {
		return [for (v in this.cases) v.toCase()];
	}
}

@:structInit
class MacroArpSwitchCase {

	public var eValue(default, null):ExprOf<String>;
	public var pos(default, null):Position;
	public var caseBlock(default, null):Array<Expr>;
	public var priority:Int = 0;

	public function toCase():Case {
		return {
			values: [eValue],
			expr: { pos: pos, expr: ExprDef.EBlock(caseBlock)}
		}
	}
}

#end
