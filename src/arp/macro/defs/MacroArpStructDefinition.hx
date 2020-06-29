package arp.macro.defs;

#if macro

import arp.seed.ArpSeed;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.macro.Type;

class MacroArpStructDefinition {

	public var nativePos(default, null):Position;
	public var arpTypeName(default, null):String;
	public var nativeDoc(default, null):String;

	public var metaArpStructStringPlaceholder(default, null):String;
	public var metaArpStructSeedPlaceholder(default, null):Dynamic;

	public function new(classType:ClassType) {
		this.nativePos = classType.pos;
		this.nativeDoc = classType.doc;
		if (this.nativeDoc == null) this.nativeDoc = "";

		this.loadMeta(classType);
	}

	private function loadMeta(classType:ClassType):Void {
		var metaArpStruct:MetadataEntry = classType.meta.extract(":arpStruct")[0];
		if (metaArpStruct != null && metaArpStruct.params.length >= 1) {
			this.arpTypeName = ExprTools.getValue(metaArpStruct.params[0]);
			arpTypeIsValidName();
		}

		var metaArpStructPlaceholder:MetadataEntry = classType.meta.extract(":arpStructPlaceholder")[0];
		if (metaArpStructPlaceholder != null && metaArpStructPlaceholder.params.length >= 2) {
			this.metaArpStructStringPlaceholder = ExprTools.getValue(metaArpStructPlaceholder.params[0]);
			this.metaArpStructSeedPlaceholder = ExprTools.getValue(metaArpStructPlaceholder.params[1]);
		}
	}

	private function arpTypeIsValidName():Void {
		if (ArpSeed.isSpecialAttrName(this.arpTypeName)) {
			Context.error('${this.arpTypeName} is not valid @:arpStruct type name', this.nativePos);
		}
	}
}

#end
