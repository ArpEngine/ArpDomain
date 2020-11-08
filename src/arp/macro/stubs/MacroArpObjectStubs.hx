package arp.macro.stubs;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

// this class is meant to be called from expression macro
@:noDoc @:noCompletion
class MacroArpObjectStubs {

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

	macro public static function arpInit(hasImpl:Bool):Expr {
		@:macroReturn arp.domain.IArpObject;

		// call populateReflectFields() via expression macro to take local imports
		MacroArpObjectRegistry.getLocalMacroArpObject().populateReflectFields();

		return macro @:mergeBlock {
#if arp_debug
			if (this._arpSlot != null) throw new arp.errors.ArpError("ArpObject " + this.arpType + this._arpSlot + " is initialized");
#end
			this._arpDomain = slot.domain;
			this._arpSlot = slot;
			$e{ MacroArpObjectBlockStubs.buildInitBlock() }
			$e{
				if (hasImpl) {
					macro this.arpImpl = this.createImpl();
				} else {
					macro @:mergeBlock { };
				}
			}
			this.arpSelfInit();
			return this;
		}
	}

	macro public static function arpHeatLaterDeps():Expr {
		@:macroReturn Bool;
		return macro @:mergeBlock {
#if arp_debug
			if (this._arpSlot == null) throw new arp.errors.ArpError("ArpObject is not initialized");
#end
			$e{ MacroArpObjectBlockStubs.buildHeatLaterDepsBlock() }
		}
	}

	macro public static function arpHeatUpNow(hasImpl:Bool):Expr {
		@:macroReturn Bool;
		return macro @:mergeBlock {
#if arp_debug
			if (this._arpSlot == null) throw new arp.errors.ArpError("ArpObject is not initialized");
#end
			$e{ MacroArpObjectBlockStubs.buildHeatUpNowBlock() }
			var isSync:Bool = true;
			if (!this.arpSelfHeatUp()) isSync = false;
			$e{
				if (hasImpl) {
					macro {
						if (this.arpImpl == null) throw new arp.errors.ArpTemplateError($v{"@:arpImpl could not find backend for "} + Type.getClassName(Type.getClass(this)));
						if (!this.arpImpl.arpHeatUpNow()) isSync = false;
					}
				} else {
					macro null;
				}
			}
			if (isSync) {
				@:privateAccess this.arpSlot.heat = arp.domain.ArpHeat.Warm;
				return true;
			} else {
				@:privateAccess this.arpSlot.heat = arp.domain.ArpHeat.Warming;
				return false;
			}
		}
	}

	macro public static function arpHeatDownNow(hasImpl:Bool):Expr {
		@:macroReturn Bool;
		return macro @:mergeBlock {
#if arp_debug
			if (this._arpSlot == null) throw new arp.errors.ArpError("ArpObject is not initialized");
#end
			var isSync:Bool = true;
			$e{
				if (hasImpl) {
					macro if (!this.arpImpl.arpHeatDownNow()) isSync = false;
				} else {
					macro null;
				}
			}
			if (!this.arpSelfHeatDown()) isSync = false;
			$e{ MacroArpObjectBlockStubs.buildHeatDownNowBlock() }
			@:privateAccess this.arpSlot.heat = arp.domain.ArpHeat.Cold;
			return isSync;
		}
	}

	macro public static function arpDispose(hasImpl:Bool):Expr {
		return macro @:mergeBlock {
#if arp_debug
			if (this._arpSlot == null) throw new arp.errors.ArpError("ArpObject is not initialized");
#end
			this.arpHeatDownNow();
			$e{
				if (hasImpl) {
					macro this.arpImpl.__arp_dispose();
				} else {
					macro null;
				}
			}
			this.arpSelfDispose();
			$e{ MacroArpObjectBlockStubs.buildDisposeBlock() }
			this._arpSlot = null;
			this._arpDomain = null;
		}
	}

	macro public static function arpConsumeSeedElement():Expr {
		@:noDoc @:noCompletion
		@:macroLocal var element:arp.seed.ArpSeed;
		return MacroArpObjectBlockStubs.buildArpConsumeSeedElementBlock();
	}

	macro public static function readSelf():Expr {
		@:macroLocal var input:arp.persistable.IPersistInput;
		return macro @:mergeBlock {
			var c:Int;
			$e{ MacroArpObjectBlockStubs.buildReadSelfBlock() }
		}
	}

	macro public static function writeSelf():Expr {
		@:macroLocal var output:arp.persistable.IPersistOutput;
		return macro @:mergeBlock {
			var c:Int;
			$e{ MacroArpObjectBlockStubs.buildWriteSelfBlock() }
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
		@:macroLocal var source:arp.domain.IArpObject;
		@:macroLocal var cloneMapper:arp.domain.IArpCloneMapper;
		@:macroReturn arp.domain.IArpObject;
		var selfComplexType:ComplexType = genSelfComplexType();
		return macro @:mergeBlock {
			cloneMapper = arp.domain.ArpCloneMappers.valueOrDefault(cloneMapper);
			var src:$selfComplexType = cast source;
			$e{ MacroArpObjectBlockStubs.buildCopyFromBlock() }
			return this;
		}
	}
}
