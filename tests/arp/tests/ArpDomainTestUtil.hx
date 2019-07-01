package arp.tests;

import haxe.io.Path;
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
import haxe.macro.Compiler;
import haxe.macro.Expr.ExprOf;
import sys.FileSystem;
import sys.io.File;
#end

class ArpDomainTestUtil {

	#if macro
	private static var fileCache:Map<String, Option<String>>;

	private static function resolveFile(file:String):Option<String> {
		for (cp in Context.getClassPath()) {
			var fp:String = FileSystem.absolutePath('$cp$file');
			if (FileSystem.exists(fp)) return Some(fp);
		}
		return None;
	}

	private static function readFile(file:String):Option<String> {
		if (fileCache == null) fileCache = new Map();

		if (fileCache.exists(file)) return fileCache.get(file);

		fileCache.set(file, switch (resolveFile(file)) {
			case None: None;
			case Some(fp): Some(File.getContent(fp));
		});
		return fileCache.get(file);
	}

	private static var destRoot(get, never):String;
	private static function get_destRoot():String {
		if (Context.defined("flash") || Context.defined("js")) {
			return Path.directory(Compiler.getOutput());
		} else {
			return Sys.getCwd();
		}
	}
	#end

	@:noUsing
	macro public static function deployFile(file:String):ExprOf<Void> {
		switch (resolveFile(file)) {
			case None:
				Context.error('File <$file> not found in classpaths', Context.currentPos());
			case Some(sp):
				var dp:String = Path.join([destRoot, file]);
				FileSystem.createDirectory(Path.directory(dp));
				File.copy(sp, dp);
		}
		return macro null;
	}

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
