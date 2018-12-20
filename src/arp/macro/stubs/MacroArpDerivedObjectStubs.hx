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
			return super.arpInit(slot, seed);
		}
	}

	macro public static function arpHeatLater(heatLaterBlock:Expr):Expr {
		@:macroReturn Bool;
		return macro @:mergeBlock {
			super.arpHeatLater();
			$e{ heatLaterBlock }
		}
	}

	macro public static function arpHeatUp(heatUpBlock:Expr):Expr {
		return macro @:mergeBlock {
			$e{ heatUpBlock }
			return super.arpHeatUp();
		}
	}

	macro public static function arpHeatDown(heatDownBlock:Expr):Expr {
		@:macroReturn Bool;
		return macro @:mergeBlock {
			// $e{ heatDownBlock }
			return super.arpHeatDown();
		}
	}

	macro public static function arpDispose(disposeBlock:Expr):Expr {
		return macro @:mergeBlock {
			$e{ disposeBlock }
			super.arpDispose();
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
			var collection:arp.persistable.IPersistInput;
			var nameList:Array<String>;
			var values:arp.persistable.IPersistInput;
			$e{ readSelfBlock }
		}
	}

	macro public static function writeSelf(writeSelfBlock:Expr):Expr {
		@:macroLocal var output:arp.persistable.IPersistOutput;
		return macro @:mergeBlock {
			super.writeSelf(output);
			var collection:arp.persistable.IPersistOutput;
			var nameList:Array<String>;
			var values:arp.persistable.IPersistOutput;
			var uniqId:arp.utils.ArpIdGenerator = new arp.utils.ArpIdGenerator();
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
