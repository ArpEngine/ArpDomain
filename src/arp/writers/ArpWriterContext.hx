package arp.writers;

import haxe.io.BytesBuffer;
import arp.errors.ArpError;

#if sys
import sys.FileSystem;
import sys.io.FileOutput;
import sys.io.File;
#end

class ArpWriterContext {

	private var dirs:Array<String>;
	private var contents:Map<String, BytesBuffer>;

	public function new():Void {
		this.dirs = [];
		this.contents = new Map();
	}

	public function dir(name:String):Void {
		if (this.dirs.indexOf(name) >= 0) return;
		this.dirs.push(name);
	}

	public function get(name:String):BytesBuffer {
		if (this.contents.exists(name)) return this.contents.get(name);
		var buf:BytesBuffer = new BytesBuffer();
		this.contents.set(name, buf);
		return buf;
	}

	public function writeAll(prefix:String = ""):Void {
#if sys
		for (dir in this.dirs) FileSystem.createDirectory(prefix + dir);

		for (name in this.contents.keys()) {
			var out:FileOutput = File.write(prefix + name, true);
			out.write(this.contents.get(name).getBytes());
			out.close();
		}
#else
		throw new ArpError("ArpWriterContext.writeAll(): not supported");
#end
	}

}
