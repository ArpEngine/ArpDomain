﻿package arp.macro;

#if macro

import haxe.macro.MacroStringTools;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.TypeTools;

class MacroArpUtil {

	inline public static var IArpObject = "arp.domain.IArpObject";
	inline public static var IArpObjectImpl = "arp.impl.IArpObjectImpl";

	inline public static function __arpReserved(value:String):String return '__arp_$value';
	inline public static function __arpGenerated(value:String):String return '__arp__$value';

	public static function error(message:String, pos:Position):Void {
		Context.error(message, pos);
#if arp_macro_debug
		throw message;
#end
	}

	public static function fatal<T>(message:String, pos:Position):T {
		Context.error(message, pos);
		throw message;
		return null;
	}

	public static function getLocalClass():ClassType {
		var localClass:Null<Ref<ClassType>> = Context.getLocalClass();
		if (localClass == null) return null;
		return localClass.get();
	}

	public static function getFqnOfType(type:Type):String {
		switch (TypeTools.follow(type)) {
			case Type.TInst(c, _): return getFqnOfBaseType(c.get());
			case Type.TEnum(c, _): return getFqnOfBaseType(c.get());
			case Type.TType(c, _): return getFqnOfBaseType(c.get());
			case Type.TAbstract(c, _): return getFqnOfBaseType(c.get());
			case _: throw "invalid type " + TypeTools.toString(type);
		}
		return null;
	}

	public static function getFqnOfBaseType(baseType:BaseType):String {
		var p = baseType.module.split(".");
		if (p[p.length - 1] != baseType.name) p.push(baseType.name);
		return p.join(".");
	}

	public static function getFqnOfTypePath(typePath:TypePath):String {
		return MacroStringTools.toDotPath(typePath.pack, typePath.name);
	}

	public static function prependFunctionBody(nativeField:Field, expr:Expr):Field {
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

}

#end
