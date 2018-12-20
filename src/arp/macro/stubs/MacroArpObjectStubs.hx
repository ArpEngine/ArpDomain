package arp.macro.stubs;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

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

	macro public static function arpInit(initBlock:Expr, hasImpl:Bool):Expr {
		@:macroLocal var slot:arp.domain.ArpUntypedSlot;
		@:macroLocal var seed:arp.seed.ArpSeed = null;
		@:macroReturn arp.domain.IArpObject;

		// call populateReflectFields() via expression macro to take local imports
		MacroArpObjectRegistry.getLocalMacroArpObject().populateReflectFields();

		return macro @:mergeBlock {
#if arp_debug
			if (this._arpSlot != null) throw new arp.errors.ArpError("ArpObject " + this.arpType + this._arpSlot + " is initialized");
#end
			this._arpDomain = slot.domain;
			this._arpSlot = slot;
			$e{ initBlock }
			if (seed != null) for (element in seed) this.arpConsumeSeedElement(element);
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

	macro public static function arpHeatLater(heatLaterBlock:Expr):Expr {
		@:macroReturn Bool;
		return macro @:mergeBlock {
#if arp_debug
			if (this._arpSlot == null) throw new arp.errors.ArpError("ArpObject is not initialized");
#end
			$e{ heatLaterBlock }
		}
	}

	macro public static function arpHeatUp(heatUpBlock:Expr, hasImpl:Bool):Expr {
		@:macroReturn Bool;
		return macro @:mergeBlock {
#if arp_debug
			if (this._arpSlot == null) throw new arp.errors.ArpError("ArpObject is not initialized");
#end
			$e{ heatUpBlock }
			var isSync:Bool = true;
			if (!this.arpSelfHeatUp()) isSync = false;
			$e{
				if (hasImpl) {
					macro {
						if (this.arpImpl == null) throw new arp.errors.ArpTemplateError($v{"@:arpImpl could not find backend for "} + Type.getClassName(Type.getClass(this)));
						if (!this.arpImpl.arpHeatUp()) isSync = false;
					}
				} else {
					macro null;
				}
			}
			if (isSync) {
				this.arpSlot.heat = arp.domain.ArpHeat.Warm;
				return true;
			} else {
				this.arpSlot.heat = arp.domain.ArpHeat.Warming;
				return false;
			}
		}
	}

	macro public static function arpHeatDown(heatDownBlock:Expr, hasImpl:Bool):Expr {
		@:macroReturn Bool;
		return macro @:mergeBlock {
#if arp_debug
			if (this._arpSlot == null) throw new arp.errors.ArpError("ArpObject is not initialized");
#end
			var isSync:Bool = true;
			$e{
				if (hasImpl) {
					macro if (!this.arpImpl.arpHeatDown()) isSync = false;
				} else {
					macro null;
				}
			}
			if (!this.arpSelfHeatDown()) isSync = false;
			// $e{ heatDownBlock }
			return isSync;
		}
	}

	macro public static function arpDispose(disposeBlock:Expr, hasImpl:Bool):Expr {
		return macro @:mergeBlock {
#if arp_debug
			if (this._arpSlot == null) throw new arp.errors.ArpError("ArpObject is not initialized");
#end
			this.arpHeatDown();
			$e{
				if (hasImpl) {
					macro this.arpImpl.arpDispose();
				} else {
					macro null;
				}
			}
			this.arpSelfDispose();
			$e{ disposeBlock }
			this._arpSlot = null;
			this._arpDomain = null;
		}
	}

	macro public static function arpConsumeSeedElement(arpConsumeSeedElementBlock:Expr):Expr {
		@:noDoc @:noCompletion
		@:macroLocal var element:arp.seed.ArpSeed;
		return arpConsumeSeedElementBlock;
	}

	macro public static function readSelf(readSelfBlock:Expr):Expr {
		@:macroLocal var input:arp.persistable.IPersistInput;
		return macro @:mergeBlock {
			var collection:arp.persistable.IPersistInput;
			var nameList:Array<String>;
			var values:arp.persistable.IPersistInput;
			$e{ readSelfBlock }
		}
	}

	macro public static function writeSelf(writeSelfBlock:Expr):Expr {
		@:macroLocal var output:arp.persistable.IPersistOutput;
		return macro @:mergeBlock {
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
			return this;
		}
	}
}
