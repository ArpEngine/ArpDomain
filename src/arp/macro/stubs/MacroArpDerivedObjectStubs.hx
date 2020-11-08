package arp.macro.stubs;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

// this class is meant to be called from expression macro
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

	macro public static function arpInit():Expr {
		var initBlock:Expr = MacroArpObjectBlockStubs.buildInitBlock();

		@:macroLocal var slot:arp.domain.ArpUntypedSlot;
		@:macroReturn arp.domain.IArpObject;

		// call populateReflectFields() via expression macro to take local imports
		MacroArpObjectRegistry.getLocalMacroArpObject().populateReflectFields();

		return macro @:mergeBlock {
			$e{ initBlock }
			return super.__arp_init(slot);
		}
	}

	macro public static function arpHeatLaterDeps():Expr {
		var heatLaterDepsBlock:Expr = MacroArpObjectBlockStubs.buildHeatLaterDepsBlock();

		@:macroReturn Bool;
		return macro @:mergeBlock {
			super.__arp_heatLaterDeps();
			$e{ heatLaterDepsBlock }
		}
	}

	macro public static function arpHeatUpNow():Expr {
		var heatUpNowBlock:Expr = MacroArpObjectBlockStubs.buildHeatUpNowBlock();

		return macro @:mergeBlock {
			$e{ heatUpNowBlock }
			return super.arpHeatUpNow();
		}
	}

	macro public static function arpHeatDownNow():Expr {
		var heatDownNowBlock:Expr = MacroArpObjectBlockStubs.buildHeatDownNowBlock();

		@:macroReturn Bool;
		return macro @:mergeBlock {
			$e{ heatDownNowBlock }
			return super.arpHeatDownNow();
		}
	}

	macro public static function arpDispose():Expr {
		var disposeBlock:Expr = MacroArpObjectBlockStubs.buildDisposeBlock();

		return macro @:mergeBlock {
			$e{ disposeBlock }
			super.__arp_dispose();
		}
	}

	macro public static function arpConsumeSeedElement():Expr {
		var arpConsumeSeedElementBlock:Expr = MacroArpObjectBlockStubs.buildArpConsumeSeedElementBlock();

		@:noDoc @:noCompletion
		return macro @:mergeBlock {
			$e{ arpConsumeSeedElementBlock }
		}
	}

	macro public static function readSelf():Expr {
		var readSelfBlock:Expr = MacroArpObjectBlockStubs.buildReadSelfBlock();

		@:macroLocal var input:arp.persistable.IPersistInput;
		return macro @:mergeBlock {
			super.readSelf(input);
			var c:Int;
			$e{ readSelfBlock }
		}
	}

	macro public static function writeSelf():Expr {
		var writeSelfBlock:Expr = MacroArpObjectBlockStubs.buildWriteSelfBlock();

		@:macroLocal var output:arp.persistable.IPersistOutput;
		return macro @:mergeBlock {
			super.writeSelf(output);
			var c:Int;
			$e{ writeSelfBlock }
		}
	}

	@:access(arp.domain.ArpDomain)
	macro public static function arpClone():Expr {
		@:macroLocal var cloneMapper:arp.domain.IArpCloneMapper;
		@:macroReturn arp.domain.IArpObject;
		var selfComplexType:ComplexType = genSelfComplexType();
		var selfTypePath:TypePath = genSelfTypePath();
		return macro @:mergeBlock {
			cloneMapper = arp.domain.ArpCloneMappers.valueOrDefault(cloneMapper);
			var clone:$selfComplexType = this._arpDomain.addObject(new $selfTypePath());
			cloneMapper.addMappingObj(this, clone);
			clone.arpCopyFrom(this, cloneMapper);
			return clone;
		}
	}

	macro public static function arpCopyFrom():Expr {
		var copyFromBlock:Expr = MacroArpObjectBlockStubs.buildCopyFromBlock();

		@:macroLocal var source:arp.domain.IArpObject;
		@:macroLocal var cloneMapper:arp.domain.IArpCloneMapper;
		@:macroReturn arp.domain.IArpObject;
		var selfComplexType:ComplexType = genSelfComplexType();
		return macro @:mergeBlock {
			cloneMapper = arp.domain.ArpCloneMappers.valueOrDefault(cloneMapper);
			var src:$selfComplexType = cast source;
			$e{ copyFromBlock }
			return super.arpCopyFrom(source);
		}
	}
}
