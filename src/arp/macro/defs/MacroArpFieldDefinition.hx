package arp.macro.defs;

#if macro

import haxe.macro.Context;
import haxe.macro.Expr;

using haxe.macro.ComplexTypeTools;

class MacroArpFieldDefinition {

	public var nativeField(default, null):Field;
	public var nativeType(default, null):ComplexType;
	public var nativeDefault(default, null):Expr;
	public var nativeDoc(default, null):String;

	public var nativeName(get, never):String;
	inline private function get_nativeName():String return this.nativeField.name;
	public var nativePos(get, never):Position;
	inline private function get_nativePos():Position return this.nativeField.pos;

	// ArpField family
	public var metaArpField(default, null):MacroArpMetaArpField = null;
	public var metaArpVolatile(default, null):Bool = false;
	public var metaArpReadOnly(default, null):Bool = false;
	public var metaArpBarrier(default, null):MacroArpMetaArpBarrier = MacroArpMetaArpBarrier.None;
	public var metaArpReverseBarrier(default, null):Bool = false;
	public var metaArpOwner(default, null):Bool = false;
	public var metaArpDefault(default, null):MacroArpMetaArpDefault = MacroArpMetaArpDefault.Zero;

	// Impl family
	public var metaArpImpl:Bool = false;

	// Unmanaged family
	public var metaArpInit:String = null;
	public var metaArpHeatUp:String = null;
	public var metaArpHeatDown:String = null;
	public var metaArpDispose:String = null;

	private var _family:MacroArpFieldDefinitionFamily = MacroArpFieldDefinitionFamily.ImplicitUnmanaged;
	public var family(get, set):MacroArpFieldDefinitionFamily;
	inline private function get_family():MacroArpFieldDefinitionFamily return _family;
	inline private function set_family(value:MacroArpFieldDefinitionFamily):MacroArpFieldDefinitionFamily {
		switch (_family) {
			case MacroArpFieldDefinitionFamily.ImplicitUnmanaged: _family = value;
			case _: if (!Type.enumEq(value, _family)) Context.error("Cannot mix " + value + " with " + _family, this.nativePos);
		}
		return value;
	}

	public function new(nativeField:Field) {
		this.nativeField = nativeField;
		this.nativeDoc = nativeField.doc;
		if (this.nativeDoc == null) this.nativeDoc = "";

		switch (nativeField.kind) {
			case FieldType.FProp(_, _, n, d), FieldType.FVar(n, d):
				this.nativeType = n;
				this.nativeDefault = d;
				for (meta in nativeField.meta) {
					switch (meta.name) {
						case ":arpField":
							this.family = MacroArpFieldDefinitionFamily.ArpField;
							this.parseMetaArpField(meta.params);
						case ":arpBarrier":
							this.family = MacroArpFieldDefinitionFamily.ArpField;
							this.parseMetaArpBarrier(meta.params);
						case ":arpOwner":
							this.family = MacroArpFieldDefinitionFamily.ArpField;
							this.parseMetaArpOwner(meta.params);
						case ":arpDefault":
							this.family = MacroArpFieldDefinitionFamily.ArpField;
							switch (meta.params[0]) {
								case { expr: ExprDef.EConst(CString(s))}:
									this.metaArpDefault = MacroArpMetaArpDefault.Simple(s);
								case _: Context.error("@:arpDefault is too complex", nativeField.pos);
							}
						case ":arpImpl":
							switch (nativeType) {
								case ComplexType.TPath(typePath):
									var family = MacroArpFieldDefinitionFamily.Impl(typePath);
									if (d != null) {
										switch (d.expr) {
											case ExprDef.ENew(concreteTypePath, _):
												family = MacroArpFieldDefinitionFamily.Impl2(typePath, concreteTypePath);
											case _:
										}
									}
									this.family = family;
									this.metaArpImpl = true;
								case _: Context.error("TypePath expected for arpImpl", nativeField.pos);
							}
						case m:
							assertNotInvalidArpMeta(m);
					}
				}
			case FieldType.FFun(func):
				this.nativeType = null;
				this.nativeDefault = null;
				if (nativeField.name == "new") {
					this.family = MacroArpFieldDefinitionFamily.Constructor(func);
					return;
				}
				this.family = MacroArpFieldDefinitionFamily.Unmanaged;
				for (meta in nativeField.meta) {
					switch (meta.name) {
						case ":arpInit":
							this.metaArpInit = nativeField.name;
						case ":arpHeatUp":
							this.metaArpHeatUp = nativeField.name;
						case ":arpHeatDown":
							this.metaArpHeatDown = nativeField.name;
						case ":arpDispose":
							this.metaArpDispose = nativeField.name;
						case m:
							assertNotInvalidArpMeta(m);
					}
				}
		}

	}

	private function isArpManaged():Bool {
		switch (this.family) {
			case MacroArpFieldDefinitionFamily.ImplicitUnmanaged: return false;
			case MacroArpFieldDefinitionFamily.Unmanaged: return false;
			case _: return true;
		}
	}

	private function assertNotInvalidArpMeta(metaName:String):Void {
		if (metaName.indexOf(":arp") == 0) {
			Context.error('Unsupported arp metadata: @${metaName}', this.nativePos);
		} else if (metaName.indexOf("arp") == 0) {
			Context.error('Arp metadata is compile time only: @${metaName}', this.nativePos);
		}
	}

	public function arpFieldIsForValue():Bool {
		switch (metaArpBarrier) {
			case MacroArpMetaArpBarrier.None:
			case
				MacroArpMetaArpBarrier.Optional,
				MacroArpMetaArpBarrier.Required:
				Context.error('@:arpBarrier not available for ${this.nativeType.toString()}', this.nativePos);
		}
		return true;
	}

	public function arpFieldIsForReference():Bool {
		// everything is welcome
		return true;
	}

	private function parseMetaArpField(params:Array<Expr>):Void {
		this.metaArpField = new MacroArpMetaArpField();
		var names:Array<MacroArpMetaArpField.MacroArpMetaArpFieldName> = [];
		for (param in params) {
			switch (param.expr) {
				case ExprDef.EConst(Constant.CString(v)):
					names.push(MacroArpMetaArpField.MacroArpMetaArpFieldName.Explicit(v));
				case ExprDef.EConst(Constant.CIdent("true")):
					names.push(MacroArpMetaArpField.MacroArpMetaArpFieldName.Default);
				case ExprDef.EConst(Constant.CIdent("false")):
					names.push(MacroArpMetaArpField.MacroArpMetaArpFieldName.Anonymous);
				case ExprDef.EConst(Constant.CIdent("volatile")):
					this.metaArpVolatile = true;
				case ExprDef.EConst(Constant.CIdent("readonly")):
					this.metaArpReadOnly = true;
				case _:
					var errorMessage = "Invalid @:arpField argument.\nAccepts: \"String literal\" | true | false | volatile | readonly";
					Context.error(errorMessage, this.nativePos);
			}
		}

		switch (names.length) {
			case 0: return;
			case 1: names.push(names[0]);
		}
		this.metaArpField.groupName = names[0];
		this.metaArpField.elementName = names[1];
	}

	private function parseMetaArpBarrier(params:Array<Expr>):Void {
		this.metaArpBarrier = MacroArpMetaArpBarrier.Optional;
		if (params.length == 0) return;
		this.metaArpBarrier = switch (params[0].expr) {
			case ExprDef.EConst(Constant.CIdent("true")): MacroArpMetaArpBarrier.Required;
			case ExprDef.EConst(Constant.CIdent("false")): MacroArpMetaArpBarrier.Optional;
			case _:
				var errorMessage = "Invalid @:arpBarrier argument.\nAccepts: true | false";
				Context.error(errorMessage, this.nativePos);
		}
		if (params.length == 1) return;
		this.metaArpReverseBarrier = switch (params[1].expr) {
			case ExprDef.EConst(Constant.CIdent("true")): true;
			case ExprDef.EConst(Constant.CIdent("false")): false;
			case _:
				var errorMessage = "Invalid @:arpBarrier argument.\nAccepts: true | false";
				Context.error(errorMessage, this.nativePos);
		}
	}

	private function parseMetaArpOwner(params:Array<Expr>):Void {
		this.metaArpOwner = true;
		if (params.length == 0) return;
		this.metaArpOwner = switch (params[0].expr) {
			case ExprDef.EConst(Constant.CIdent("true")): true;
			case ExprDef.EConst(Constant.CIdent("false")): false;
			case _:
				var errorMessage = "Invalid @:arpOwner argument.\nAccepts: true | false";
				Context.error(errorMessage, this.nativePos);
		}
	}
}

#end
