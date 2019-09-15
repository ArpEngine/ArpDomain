package arp.domain.query;

class ArpDirectoryQuery {

	private var root:ArpDirectory;
	private var path:String;
	private var pathArray:Array<String>;

	public function new(root:ArpDirectory, path:String = null) {
		if (path == null) path = "";
		switch (path.charAt(0)) {
			case ArpDirectory.PATH_DELIMITER:
				//force absolute path
				root = root.domain.root;
				path = path.substr(1);
			case ArpDirectory.PATH_CURRENT:
				//force current path
				root = root.domain.currentDir;
				path = path.substr(1);
		}
		this.root = root;
		this.path = path;
		this.pathArray = null;
		if (path.indexOf(ArpDirectory.PATH_DELIMITER) >= 0) {
			this.pathArray = path.split(ArpDirectory.PATH_DELIMITER);
		}
	}

	public function directory():ArpDirectory {
		if (this.path == null) return this.root;
		if (this.pathArray == null) return this.root.child(this.path);
		var slot:ArpDirectory = this.root;
		for (element in this.pathArray) slot = slot.child(element);
		return slot;
	}
}
