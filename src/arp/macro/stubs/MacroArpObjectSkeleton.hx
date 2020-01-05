package arp.macro.stubs;

#if macro

import arp.macro.defs.MacroArpClassDefinition;
import arp.macro.defs.MacroArpImplClassDefinition;
import haxe.macro.Expr;

class MacroArpObjectSkeleton {

	private static function getTemplate():MacroArpObject {
		return MacroArpObjectRegistry.getLocalMacroArpObject();
	}

	private var _template:MacroArpObject;
	private var template(get, null):MacroArpObject;
	private function get_template():MacroArpObject {
		return (_template != null) ? _template : (_template = getTemplate());
	}

	private var classDef(get, never):MacroArpClassDefinition;
	private function get_classDef():MacroArpClassDefinition return template.classDef;
	private var arpFields(get, never):Array<IMacroArpField>;
	private function get_arpFields():Array<IMacroArpField> return template.arpFields;

	private function new() return;

	private function buildBlock(iFieldName:String, forPersist:Bool = false):Expr {
		return macro arp.macro.stubs.MacroArpObjectBlockStubs.block($v{iFieldName}, $v{forPersist});
	}

	private function buildInitBlock():Expr return buildBlock("buildInitBlock");
	private function buildHeatLaterDepsBlock():Expr return buildBlock("buildHeatLaterDepsBlock");
	private function buildHeatUpNowBlock():Expr return buildBlock("buildHeatUpNowBlock");
	private function buildHeatDownNowBlock():Expr return buildBlock("buildHeatDownNowBlock");
	private function buildDisposeBlock():Expr return buildBlock("buildDisposeBlock");
	private function buildReadSelfBlock():Expr return buildBlock("buildReadSelfBlock", true);
	private function buildWriteSelfBlock():Expr return buildBlock("buildWriteSelfBlock", true);
	private function buildCopyFromBlock():Expr return buildBlock("buildCopyFromBlock");

	private function buildArpConsumeSeedElementBlock():Expr {
		return macro arp.macro.stubs.MacroArpObjectBlockStubs.arpConsumeSeedElementBlock();
	}

	private function genTypeFields():Array<Field> {
		var arpTypeName = this.classDef.arpTypeName;
		var arpTemplateName = this.classDef.arpTemplateName;
		return (macro class Generated {
			@:noDoc @:noCompletion private var _arpDomain:arp.domain.ArpDomain;
			public var arpDomain(get, never):arp.domain.ArpDomain;
			@:noDoc @:noCompletion private function get_arpDomain():arp.domain.ArpDomain return this._arpDomain;

			public static var _arpTypeInfo(default, never):arp.domain.ArpTypeInfo = new arp.domain.ArpTypeInfo($v{arpTemplateName}, new arp.domain.core.ArpType($v{arpTypeName}));
			public var arpTypeInfo(get, never):arp.domain.ArpTypeInfo;
			@:noDoc @:noCompletion private function get_arpTypeInfo():arp.domain.ArpTypeInfo return _arpTypeInfo;
			public var arpType(get, never):arp.domain.core.ArpType;
			@:noDoc @:noCompletion private function get_arpType():arp.domain.core.ArpType return _arpTypeInfo.arpType;

			@:noDoc @:noCompletion private var _arpSlot:arp.domain.ArpUntypedSlot;
			public var arpSlot(get, never):arp.domain.ArpUntypedSlot;
			@:noDoc @:noCompletion private function get_arpSlot():arp.domain.ArpUntypedSlot return this._arpSlot;

			public var arpHeat(get, never):arp.domain.ArpHeat;
			@:noDoc @:noCompletion private function get_arpHeat():arp.domain.ArpHeat return this._arpSlot.heat;

			@:noDoc @:noCompletion
			public function __arp_init(slot:arp.domain.ArpUntypedSlot):arp.domain.IArpObject {
				arp.macro.stubs.MacroArpObjectStubs.arpInit(
					$e{ this.buildInitBlock() },
					$v{ this.classDef.hasImpl }
				);
			}

			@:noDoc @:noCompletion
			public function __arp_loadSeed(seed:arp.seed.ArpSeed):Void {
				for (element in seed) this.arpConsumeSeedElement(element);
				this.arpSelfLoadSeed(seed);
			}

			@:noDoc @:noCompletion
			public function __arp_heatLaterDeps():Void {
				arp.macro.stubs.MacroArpObjectStubs.arpHeatLaterDeps(
					$e{ this.buildHeatLaterDepsBlock() }
				);
			}

			public function arpHeatUpNow():Bool {
				arp.macro.stubs.MacroArpObjectStubs.arpHeatUpNow(
					$e{ this.buildHeatUpNowBlock() },
					$v{ this.classDef.hasImpl }
				);
			}

			public function arpHeatDownNow():Bool {
				arp.macro.stubs.MacroArpObjectStubs.arpHeatDownNow(
					$e{ this.buildHeatDownNowBlock() },
					$v{ this.classDef.hasImpl }
				);
			}

			inline public function arpHeatLater(nonblocking:Bool = false):Bool return this._arpDomain.heatLater(this._arpSlot, nonblocking);

			@:noDoc @:noCompletion
			public function __arp_dispose():Void {
				arp.macro.stubs.MacroArpObjectStubs.arpDispose(
					$e{ this.buildDisposeBlock() },
					$v{ this.classDef.hasImpl }
				);
			}

			@:noDoc @:noCompletion
			private function arpConsumeSeedElement(element:arp.seed.ArpSeed):Void {
				arp.macro.stubs.MacroArpObjectStubs.arpConsumeSeedElement(
					$e{ this.buildArpConsumeSeedElementBlock() }
				);
			}

			public function readSelf(input:arp.persistable.IPersistInput):Void {
				arp.macro.stubs.MacroArpObjectStubs.readSelf(
					$e{ this.buildReadSelfBlock() }
				);
			}

			public function writeSelf(output:arp.persistable.IPersistOutput):Void {
				arp.macro.stubs.MacroArpObjectStubs.writeSelf(
					$e{ this.buildWriteSelfBlock() }
				);
			}

			@:access(arp.domain.ArpDomain)
			public function arpClone(cloneMapper:arp.domain.IArpCloneMapper = null):arp.domain.IArpObject {
				arp.macro.stubs.MacroArpObjectStubs.arpClone();
			}

			public function arpCopyFrom(source:arp.domain.IArpObject, cloneMapper:arp.domain.IArpCloneMapper = null):arp.domain.IArpObject {
				arp.macro.stubs.MacroArpObjectStubs.arpCopyFrom(
					$e{ this.buildCopyFromBlock() }
				);
			}
		}).fields;
	}

	private function genDerivedTypeFields():Array<Field> {
		var arpTypeName = this.classDef.arpTypeName;
		var arpTemplateName = this.classDef.arpTemplateName;
		return (macro class Generated {
			public static var _arpTypeInfo(default, never):arp.domain.ArpTypeInfo = new arp.domain.ArpTypeInfo($v{arpTemplateName}, new arp.domain.core.ArpType($v{arpTypeName}));
			override private function get_arpTypeInfo():arp.domain.ArpTypeInfo return _arpTypeInfo;
			@:noDoc @:noCompletion override private function get_arpType():arp.domain.core.ArpType return _arpTypeInfo.arpType;

			@:noDoc @:noCompletion
			override public function __arp_init(slot:arp.domain.ArpUntypedSlot):arp.domain.IArpObject {
				arp.macro.stubs.MacroArpDerivedObjectStubs.arpInit(
					$e{ this.buildInitBlock() }
				);
			}

			@:noDoc @:noCompletion
			override public function __arp_heatLaterDeps():Void {
				arp.macro.stubs.MacroArpDerivedObjectStubs.arpHeatLaterDeps(
					$e{ this.buildHeatLaterDepsBlock() }
				);
			}

			override public function arpHeatUpNow():Bool {
				arp.macro.stubs.MacroArpDerivedObjectStubs.arpHeatUpNow(
					$e{ this.buildHeatUpNowBlock() }
				);
			}

			override public function arpHeatDownNow():Bool {
				arp.macro.stubs.MacroArpDerivedObjectStubs.arpHeatDownNow(
					$e{ this.buildHeatDownNowBlock() }
				);
			}

			@:noDoc @:noCompletion
			override public function __arp_dispose():Void {
				arp.macro.stubs.MacroArpDerivedObjectStubs.arpDispose(
					$e{ this.buildDisposeBlock() }
				);
			}

			@:noDoc @:noCompletion
			override private function arpConsumeSeedElement(element:arp.seed.ArpSeed):Void {
				arp.macro.stubs.MacroArpDerivedObjectStubs.arpConsumeSeedElement(
					$e{ this.buildArpConsumeSeedElementBlock() }
				);
			}

			override public function readSelf(input:arp.persistable.IPersistInput):Void {
				arp.macro.stubs.MacroArpDerivedObjectStubs.readSelf(
					$e{ this.buildReadSelfBlock() }
				);
			}

			override public function writeSelf(output:arp.persistable.IPersistOutput):Void {
				arp.macro.stubs.MacroArpDerivedObjectStubs.writeSelf(
					$e{ this.buildWriteSelfBlock() }
				);
			}

			@:access(arp.domain.ArpDomain)
			override public function arpClone(cloneMapper:arp.domain.IArpCloneMapper = null):arp.domain.IArpObject {
				arp.macro.stubs.MacroArpDerivedObjectStubs.arpClone();
			}

			override public function arpCopyFrom(source:arp.domain.IArpObject, cloneMapper:arp.domain.IArpCloneMapper = null):arp.domain.IArpObject {
				arp.macro.stubs.MacroArpDerivedObjectStubs.arpCopyFrom(
					$e{ this.buildCopyFromBlock() }
				);
			}
		}).fields;
	}

	private function genDefaultTypeFields():Array<Field> {
		return (macro class Generated {
			@:noDoc @:noCompletion private function arpSelfInit():Void return;
			@:noDoc @:noCompletion private function arpSelfLoadSeed(seed:arp.seed.ArpSeed = null):Void return;
			@:noDoc @:noCompletion private function arpSelfHeatUp():Bool return true;
			@:noDoc @:noCompletion private function arpSelfHeatDown():Bool return true;
			@:noDoc @:noCompletion private function arpSelfDispose():Void return;
		}).fields;
	}

	private function genVoidCallbackField(fun:String, callback:String):Array<Field> {
		return (macro class Generated {
			@:noDoc @:noCompletion
			private function $fun():Void {
				this.$callback();
			}
		}).fields;
	}

	private function genBoolCallbackField(fun:String, callback:String):Array<Field> {
		return (macro class Generated {
			@:noDoc @:noCompletion
			private function $fun():Bool {
				return this.$callback();
			}
		}).fields;
	}

	private function genSeedCallbackField(fun:String, callback:String):Array<Field> {
		return (macro class Generated {
			@:noDoc @:noCompletion
			private function $fun(seed:arp.seed.ArpSeed = null):Void {
				this.$callback(seed);
			}
		}).fields;
	}

	private function genImplFields(implTypePath:TypePath, concreteTypePath:TypePath):Array<Field> {
		var implType:ComplexType = ComplexType.TPath(implTypePath);
		var implClassDef:MacroArpImplClassDefinition = new MacroArpImplClassDefinition(implType);
		var concreteType:ComplexType = ComplexType.TPath(concreteTypePath);
		var concreteClassDef:MacroArpImplClassDefinition = new MacroArpImplClassDefinition(concreteType);

		// generate arpImpl
		var fields:Array<Field> = (macro class Generated {
			@:noDoc @:noCompletion
			private var arpImpl:$implType;

			@:noDoc @:noCompletion
			private function createImpl():$implType return ${
				if (concreteClassDef.isInterface) {
					// can not instantiate interfaces
					macro null;
				} else {
					// can instantiate
					macro new $concreteTypePath(this);
				}
			};
		}).fields;

		// and populate delegate methods
		fields = fields.concat(implClassDef.fields);
		return fields;
	}

	private function genDerivedImplFields(concreteTypePath:TypePath):Array<Field> {
		var implType = ComplexType.TPath(concreteTypePath);
		var concreteType:ComplexType = ComplexType.TPath(concreteTypePath);
		var concreteClassDef:MacroArpImplClassDefinition = new MacroArpImplClassDefinition(concreteType);
		return (macro class Generated {
			@:noDoc @:noCompletion
			override private function createImpl() return ${
				if (concreteClassDef.isInterface) {
					// in case of unsupported backend for target platform
					macro null;
				} else {
					// can instantiate
					macro new $concreteTypePath(this);
				}
			};
		}).fields;
	}

	private function prependFunctionBody(nativeField:Field, expr:Expr):Field {
		var nativeFunc:Function;
		switch (nativeField.kind) {
			case FieldType.FFun(func):
				nativeFunc = func;
			case _:
				MacroArpUtil.error("Internal error: field is not a function", nativeField.pos);
		}
		return {
			name: nativeField.name,
			doc: nativeField.doc,
			access: nativeField.access,
			kind: FieldType.FFun({
				args:nativeFunc.args,
				ret:nativeFunc.ret,
				expr: macro @:mergeBlock {
					${expr}
					${nativeFunc.expr}
				},
				params: nativeFunc.params
			}),
			pos: nativeField.pos,
			meta:nativeField.meta
		};
	}

	private function genConstructorField(nativeField:Field, nativeFunc:Function):Array<Field> {
		return [nativeField];
	}

}

#end
