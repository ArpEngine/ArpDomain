package arp.macro.stubs;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

class MacroArpDerivedObjectStubs {

#if macro
	private static function genSelfTypePath():TypePath {
		var localClassRef:Null<Ref<ClassType>> = Context.getLocalClass();
		var localClass:ClassType = localClassRef.get();
		return {
			pack: localClass.pack,
			name: localClass.name
		}
	}

	private static function genSelfComplexType():ComplexType {
		return ComplexType.TPath(genSelfTypePath());
	}
#end

	macro public static function arpInit(initBlock:Expr):Expr {
		@:macroLocal var slot:arp.domain.ArpUntypedSlot;
		@:macroLocal var seed:arp.seed.ArpSeed = null;
		@:macroReturn arp.domain.IArpObject;

		// call populateReflectFields() via expression macro to take local imports
		MacroArpObjectRegistry.getLocalMacroArpObject().populateReflectFields();

		return macro @:mergeBlock {
			$e{ initBlock }
			return super.__arp_init(slot, seed);
		}
	}

	macro public static function arpHeatLaterDeps(heatLaterDepsBlock:Expr):Expr {
		@:macroReturn Bool;
		return macro @:mergeBlock {
			super.__arp_heatLaterDeps();
			$e{ heatLaterDepsBlock }
		}
	}

	macro public static function arpHeatUpNow(heatUpNowBlock:Expr):Expr {
		return macro @:mergeBlock {
			$e{ heatUpNowBlock }
			return super.__arp_heatUpNow();
		}
	}

	macro public static function arpHeatDownNow(heatDownNowBlock:Expr):Expr {
		@:macroReturn Bool;
		return macro @:mergeBlock {
			$e{ heatDownNowBlock }
			return super.__arp_heatDownNow();
		}
	}

	macro public static function arpDispose(disposeBlock:Expr):Expr {
		return macro @:mergeBlock {
			$e{ disposeBlock }
			super.__arp_dispose();
		}
	}

	macro public static function arpConsumeSeedElement(arpConsumeSeedElementBlock:Expr):Expr {
		@:noDoc @:noCompletion
		return macro @:mergeBlock {
			$e{ arpConsumeSeedElementBlock }
		}
	}

	macro public static function readSelf(readSelfBlock:Expr):Expr {
		@:macroLocal var input:arp.persistable.IPersistInput;
		return macro @:mergeBlock {
			super.readSelf(input);
			var c:Int;
			$e{ readSelfBlock }
		}
	}

	macro public static function writeSelf(writeSelfBlock:Expr):Expr {
		@:macroLocal var output:arp.persistable.IPersistOutput;
		return macro @:mergeBlock {
			super.writeSelf(output);
			var c:Int;
			$e{ writeSelfBlock }
		}
	}

	@:access(arp.domain.ArpDomain)
	macro public static function arpClone():Expr {
		@:macroReturn arp.domain.IArpObject;
		var selfComplexType:ComplexType = genSelfComplexType();
		var selfTypePath:TypePath = genSelfTypePath();
		return macro @:mergeBlock {
			var clone:$selfComplexType = this._arpDomain.addObject(new $selfTypePath());
			clone.arpCopyFrom(this);
			return clone;
		}
	}

	macro public static function arpCopyFrom(copyFromBlock:Expr):Expr {
		@:macroLocal var source:arp.domain.IArpObject;
		@:macroReturn arp.domain.IArpObject;
		var selfComplexType:ComplexType = genSelfComplexType();
		return macro @:mergeBlock {
			var src:$selfComplexType = cast source;
			$e{ copyFromBlock }
			return super.arpCopyFrom(source);
		}
	}
}
