package arp.macro.fields.base;

#if macro

import arp.macro.defs.MacroArpFieldDefinition;
import haxe.macro.Expr;

class MacroArpObjectCollectionFieldBase extends MacroArpCollectionFieldBase {

	private var contentNativeType:ComplexType;

	override private function get_arpType():String return MacroArpObjectRegistry.arpTypeOf(contentNativeType).toString();

	override private function createEmptyDs(concreteNativeTypePath:TypePath):Expr {
		return macro new $concreteNativeTypePath(slot.domain);
	}

	private function new(fieldDef:MacroArpFieldDefinition, contentNativeType:ComplexType, concreteDs:Bool) {
		super(fieldDef, concreteDs);
		this.contentNativeType = contentNativeType;
	}
}

#end
