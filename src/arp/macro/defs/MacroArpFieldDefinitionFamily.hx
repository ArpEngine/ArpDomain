package arp.macro.defs;

#if macro

import haxe.macro.Expr;

enum MacroArpFieldDefinitionFamily {
	ImplicitUnmanaged;
	Unmanaged;
	ArpField;
	Impl(typePath:TypePath);
	Impl2(implTypePath:TypePath, concreteTypePath:TypePath);
	Constructor(func:Function);
}

#end
