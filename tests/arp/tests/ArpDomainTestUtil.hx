package arp.tests;

import arp.persistable.AnonPersistOutput;
import arp.persistable.PackedPersistInput;
import arp.persistable.PackedPersistOutput;
import arp.persistable.IPersistable;
import arp.domain.ArpDomain;
import arp.io.OutputWrapper;
import haxe.io.BytesInput;
import arp.io.InputWrapper;
import haxe.io.BytesOutput;
import arp.domain.IArpObject;

#if macro
import haxe.ds.Option;
import haxe.macro.Context;
import haxe.macro.Expr.ExprOf;
import sys.FileSystem;
import sys.io.File;
#end

class ArpDomainTestUtil {

	#if macro
	private static var fileCache:Map<String, Option<String>>;

	private static function readFile(file:String):Option<String> {
		if (fileCache == null) fileCache = new Map();

		if (fileCache.exists(file)) return fileCache.get(file);

		for (cp in Context.getClassPath()) {
			var fp:String = FileSystem.absolutePath('$cp$file');
			if (FileSystem.exists(fp)) {
				fileCache.set(file, Option.Some(File.getContent(fp)));
				return fileCache.get(file);
			}
		}
		fileCache.set(file, Option.None);
		return fileCache.get(file);
	}
	#end

	@:noUsing
	macro public static function string(file:String, section:String):ExprOf<String> {
		switch (readFile(file)) {
			case Option.Some(text):
				var ereg:EReg = new EReg('^${section}:\n(.*?)\nEND$', "ms");
				if (ereg.match(text)) {
					return macro $v{ereg.matched(1)};
				} else {
					return macro $v{'!!! section not found $file $section !!!'};
				}
			case Option.None:
				return macro $v{'!!! file not found $file $section !!!'};
		}
	}

	@:noUsing
	public static function roundTrip<T:IArpObject>(domain:ArpDomain, inObject:T, klass:Class<T>):T {
		var bytesOutput:BytesOutput = new BytesOutput();
		inObject.writeSelf(new PackedPersistOutput(new OutputWrapper(bytesOutput)));
		var outObject:T = domain.allocObject(klass);
		outObject.readSelf(new PackedPersistInput(new InputWrapper(new BytesInput(bytesOutput.getBytes()))));
		return outObject;
	}

	inline public static function toHash(persistable:IPersistable):Dynamic {
		var result:Dynamic = {};
		persistable.writeSelf(new AnonPersistOutput(result));
		return result;
	}
}
