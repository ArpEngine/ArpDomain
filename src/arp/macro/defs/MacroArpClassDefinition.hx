package arp.macro.defs;

#if macro

import arp.domain.core.ArpOverwriteStrategy;
import arp.seed.ArpSeed;
import haxe.macro.Context;
import haxe.macro.Expr.MetadataEntry;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.macro.Type;
import Type as StdType;

class MacroArpClassDefinition {

	public var nativeFqn(default, null):String;
	public var nativePos(default, null):Position;

	public var metaGen(default, null):Bool = false;
	public var metaNoGen(default, null):Bool = false;
	public var metaHasImpl(default, null):Bool = false;
	public var arpTypeName(default, null):String;
	public var arpTemplateName(default, null):String;
	public var metaArpOverwrite(default, null):ArpOverwriteStrategy = ArpOverwriteStrategy.Error;
	public var nativeDoc(default, null):String;

	public var isDerived(default, null):Bool = false;
	public var hasImpl(default, null):Bool = false;

	public var fieldDefs(default, null):Array<MacroArpFieldDefinition>;
	public var mergedBaseFields:Map<String, ClassField>;
	public var baseClasses:Array<ClassType>;

	public function new(classType:ClassType) {
		this.nativeFqn = MacroArpUtil.getFqnOfBaseType(classType);
		this.nativePos = classType.pos;
		this.fieldDefs = [];
		this.baseClasses = [];
		this.mergedBaseFields = new Map<String, ClassField>();

		this.nativeDoc = classType.doc;
		if (this.nativeDoc == null) this.nativeDoc = "";
		this.loadMeta(classType);
		if (!this.metaNoGen) {
			this.loadClassFields();
			this.loadBaseClasses(classType);
		}
	}

	private function loadMeta(classType:ClassType):Void {
		var metaNoGen:MetadataEntry = classType.meta.extract(":arpNoGen")[0];
		if (metaNoGen != null) {
			this.metaNoGen = true;
		}
		var metaGen:MetadataEntry = classType.meta.extract(":arpGen")[0];
		if (metaGen != null) {
			this.metaGen = true;
			Sys.stdout().writeString('arpGen detected\n');
		}
		var metaArpType:MetadataEntry = classType.meta.extract(":arpType")[0];
		if (metaArpType != null) {
			var typeMeta:Expr = metaArpType.params[0];
			var templateMeta:Expr = metaArpType.params[1];
			this.arpTypeName = typeMeta != null ? ExprTools.getValue(typeMeta) : null;
			this.arpTemplateName = templateMeta != null ? ExprTools.getValue(templateMeta) : null;
			if (this.arpTemplateName == null) {
				this.arpTemplateName = this.arpTypeName;
			}
		}
		var metaArpOverwrite:MetadataEntry = classType.meta.extract(":arpOverwrite")[0];
		if (metaArpOverwrite != null) {
			this.parseMetaArpOverwrite(metaArpOverwrite.params);
		}
		arpTypeIsValidName();
	}


	private function arpTypeIsValidName():Void {
		if (ArpSeed.isSpecialAttrName(this.arpTypeName)) {
			Context.error('${this.arpTypeName} is not valid @:arpStruct type name', this.nativePos);
		}
	}

	private function parseMetaArpOverwrite(params:Array<Expr>):Void {
		if (params.length == 0) return;
		var en:Enum<ArpOverwriteStrategy> = cast StdType.getEnum(ArpOverwriteStrategy.Error);
		switch (params[0].expr) {
			case EConst(CIdent(value)) | EField(_, value) if (StdType.getEnumConstructs(en).indexOf(value) >= 0):
				this.metaArpOverwrite = StdType.createEnum(en, value);
			case _:
				Context.error('Invalid @:arpOverwrite argument. Accepts: Error | Merge | Replace', this.nativePos);
		}
	}

	private function loadClassFields():Void {
		for (field in Context.getBuildFields()) {
			var fieldDef:MacroArpFieldDefinition = new MacroArpFieldDefinition(field);
			this.fieldDefs.push(fieldDef);
			if (fieldDef.metaArpImpl) this.hasImpl = true;
		}
	}

	private function loadBaseClasses(classType:ClassType):Void {
		do {
			var superClass = classType.superClass;
			if (superClass == null) break;
			classType = superClass.t.get();
			for (intfRef in classType.interfaces) {
				var intf:ClassType = intfRef.t.get();
				if (MacroArpUtil.getFqnOfBaseType(intf) == MacroArpUtil.IArpObject) {
					this.isDerived = true;
				} else if (intf.superClass != null) {
					intf = intf.superClass.t.get();
					if (MacroArpUtil.getFqnOfBaseType(intf) == MacroArpUtil.IArpObjectImpl) {
						this.metaHasImpl = true;
					}
				}
			}

			this.baseClasses.push(classType);
			for (field in classType.fields.get()) {
				if (!this.mergedBaseFields.exists(field.name)) {
					this.mergedBaseFields.set(field.name, field);
				}
			}
		} while (classType != null);
	}
}

#end
