package arp.domain;

import arp.domain.core.ArpType;
import arp.domain.mocks.MockArpObject;
import arp.persistable.JsonPersistInput;
import arp.persistable.JsonPersistOutput;
import arp.persistable.VerbosePersistInput;
import arp.persistable.VerbosePersistOutput;
import arp.seed.ArpSeed;
import haxe.Json;
import picotest.PicoAssert.*;

class ArpDomainPersistCase {

	private var domain:ArpDomain;
	private var xml:Xml;
	private var seed:ArpSeed;

	private final PERSIST_JSON:Dynamic = untyped {
		"numDirs": 4,
		"dirs": [
			{
				"numSlots": 0,
				"path": '/$$anon',
				"slots": [
				]
			},
			{
				"numSlots": 1,
				"path": "/name1",
				"slots": [
					"mock",
					"/name1:mock"
				]
			},
			{
				"numSlots": 1,
				"path": "/name2",
				"slots": [
					"mock",
					"/name2:mock"
				]
			},
			{
				"numSlots": 1,
				"path": "/name3",
				"slots": [
					"mock",
					"/name3:mock"
				]
			}
		],
		"numSlots": 5,
		"slots": [
			{
				"class": "data:data",
				"heat": "cold",
				"name": "$0:data"
			},
			{
				"class": "$null",
				"heat": "cold",
				"name": "$null"
			},
			{
				"stringField": "stringValue",
				"boolField": true,
				"intField": 42,
				"name": "/name1:mock",
				"floatField": 3.14,
				"class": "mock:mock",
				"heat": "cold",
				"refField": "/name1:mock"
			},
			{
				"stringField": "stringDefault",
				"boolField": false,
				"intField": 0,
				"name": "/name2:mock",
				"floatField": 0,
				"class": "mock:mock",
				"heat": "cold",
				"refField": "/name1:mock"
			},
			{
				"stringField": "stringDefault",
				"boolField": false,
				"intField": 0,
				"name": "/name3:mock",
				"floatField": 0,
				"class": "mock:mock",
				"heat": "cold",
				"refField": "$null"
			}
		]
	};

	private final PERSIST_VERBOSE:Dynamic = untyped [
		"   1:0 :writeInt32:numDirs:4",
		"   2:0 :writeListEnter:dirs",
		"   3:1   :pushEnter:",
		"   4:2     :writeInt32:numSlots:0",
		"   5:2     :writeUtf:path:%2F%24anon",
		"   6:2     :writeListEnter:slots",
		"   7:2     :writeExit:",
		"   8:1   :writeExit:",
		"   9:1   :pushEnter:",
		"  10:2     :writeInt32:numSlots:1",
		"  11:2     :writeUtf:path:%2Fname1",
		"  12:2     :writeListEnter:slots",
		"  13:3       :pushUtf:mock",
		"  14:3       :pushUtf:%2Fname1%3Amock",
		"  15:2     :writeExit:",
		"  16:1   :writeExit:",
		"  17:1   :pushEnter:",
		"  18:2     :writeInt32:numSlots:1",
		"  19:2     :writeUtf:path:%2Fname2",
		"  20:2     :writeListEnter:slots",
		"  21:3       :pushUtf:mock",
		"  22:3       :pushUtf:%2Fname2%3Amock",
		"  23:2     :writeExit:",
		"  24:1   :writeExit:",
		"  25:1   :pushEnter:",
		"  26:2     :writeInt32:numSlots:1",
		"  27:2     :writeUtf:path:%2Fname3",
		"  28:2     :writeListEnter:slots",
		"  29:3       :pushUtf:mock",
		"  30:3       :pushUtf:%2Fname3%3Amock",
		"  31:2     :writeExit:",
		"  32:1   :writeExit:",
		"  33:0 :writeExit:",
		"  34:0 :writeInt32:numSlots:5",
		"  35:0 :writeListEnter:slots",
		"  36:1   :pushEnter:",
		"  37:2     :writeUtf:class:mock%3Amock",
		"  38:2     :writeUtf:heat:cold",
		"  39:2     :writeUtf:name:%2Fname3%3Amock",
		"  40:2     :writeInt32:intField:0",
		"  41:2     :writeDouble:floatField:0",
		"  42:2     :writeBool:boolField:false",
		"  43:2     :writeUtf:stringField:stringDefault",
		"  44:2     :writeUtf:refField:%24null",
		"  45:1   :writeExit:",
		"  46:1   :pushEnter:",
		"  47:2     :writeUtf:class:data%3Adata",
		"  48:2     :writeUtf:heat:cold",
		"  49:2     :writeUtf:name:%240%3Adata",
		"  50:1   :writeExit:",
		"  51:1   :pushEnter:",
		"  52:2     :writeUtf:class:mock%3Amock",
		"  53:2     :writeUtf:heat:cold",
		"  54:2     :writeUtf:name:%2Fname1%3Amock",
		"  55:2     :writeInt32:intField:42",
		"  56:2     :writeDouble:floatField:3.14",
		"  57:2     :writeBool:boolField:true",
		"  58:2     :writeUtf:stringField:stringValue",
		"  59:2     :writeUtf:refField:%2Fname1%3Amock",
		"  60:1   :writeExit:",
		"  61:1   :pushEnter:",
		"  62:2     :writeUtf:class:%24null",
		"  63:2     :writeUtf:heat:cold",
		"  64:2     :writeUtf:name:%24null",
		"  65:1   :writeExit:",
		"  66:1   :pushEnter:",
		"  67:2     :writeUtf:class:mock%3Amock",
		"  68:2     :writeUtf:heat:cold",
		"  69:2     :writeUtf:name:%2Fname2%3Amock",
		"  70:2     :writeInt32:intField:0",
		"  71:2     :writeDouble:floatField:0",
		"  72:2     :writeBool:boolField:false",
		"  73:2     :writeUtf:stringField:stringDefault",
		"  74:2     :writeUtf:refField:%2Fname1%3Amock",
		"  75:1   :writeExit:",
		"  76:0 :writeExit:"
	]
	;

	public function setup():Void {
		domain = new ArpDomain();
		domain.addTemplate(MockArpObject, true);
		xml = Xml.parse('<data>
		<mock name="name1" intField="42" floatField="3.14" boolField="true" stringField="stringValue" refField="/name1" />
		<mock name="name2" refField="/name1" />
		<mock name="name3" />
		</data>
		').firstElement();
		seed = ArpSeed.fromXml(xml);
		domain.loadSeed(seed, new ArpType("data"));
	}

	public function testWriteSelf():Void {
		var output:JsonPersistOutput = new JsonPersistOutput();
		new ArpDomainPersist(domain).writeSelf(output);

		var json = normalizeJson(output.json);
		// trace(json);
		assertMatch(PERSIST_JSON, Json.parse(json));
	}

	@Ignore("Verbose output has unordered slots and dirs")
	public function testWriteSelfVerbose():Void {
		var output:VerbosePersistOutput = new VerbosePersistOutput();
		new ArpDomainPersist(domain).writeSelf(output);

		var data = output.data;
		// trace(data.join(",\n"));
		assertMatch(PERSIST_VERBOSE, output.data);
	}

	public function testReadWriteSelf():Void {
		var otherDomain = new ArpDomain();
		otherDomain.addTemplate(MockArpObject, true);

		var output:JsonPersistOutput = new JsonPersistOutput();
		new ArpDomainPersist(domain).writeSelf(output);
		new ArpDomainPersist(otherDomain).readSelf(new JsonPersistInput(output.json));
		assertMatch(domain.obj("name1", MockArpObject).arpSlot.sid, otherDomain.obj("name1", MockArpObject).arpSlot.sid);
		assertMatch(domain.obj("name1", MockArpObject).intField, otherDomain.obj("name1", MockArpObject).intField);
	}

	public function testReadWriteSelfVerbose():Void {
		var otherDomain = new ArpDomain();
		otherDomain.addTemplate(MockArpObject, true);

		var output:VerbosePersistOutput = new VerbosePersistOutput();
		new ArpDomainPersist(domain).writeSelf(output);
		new ArpDomainPersist(otherDomain).readSelf(new VerbosePersistInput(output.data));
		assertMatch(domain.obj("name1", MockArpObject).arpSlot.sid, otherDomain.obj("name1", MockArpObject).arpSlot.sid);
		assertMatch(domain.obj("name1", MockArpObject).intField, otherDomain.obj("name1", MockArpObject).intField);
	}

	public function testWriteReadWriteSelf():Void {
		var otherDomain = new ArpDomain();
		otherDomain.addTemplate(MockArpObject, true);

		var output:JsonPersistOutput = new JsonPersistOutput();
		new ArpDomainPersist(domain).writeSelf(output);
		new ArpDomainPersist(otherDomain).readSelf(new JsonPersistInput(output.json));
		output = new JsonPersistOutput();
		new ArpDomainPersist(otherDomain).writeSelf(output);

		var json = normalizeJson(output.json);
		// trace(json);
		assertMatch(PERSIST_JSON, Json.parse(json));
	}

	@Ignore("Verbose output has unordered slots and dirs")
	public function testWriteReadWriteSelfVerbose():Void {
		var otherDomain = new ArpDomain();
		otherDomain.addTemplate(MockArpObject, true);

		var output:VerbosePersistOutput = new VerbosePersistOutput();
		new ArpDomainPersist(domain).writeSelf(output);
		new ArpDomainPersist(otherDomain).readSelf(new VerbosePersistInput(output.data));
		output = new VerbosePersistOutput();
		new ArpDomainPersist(otherDomain).writeSelf(output);

		var data = output.data;
		// trace(data.join(",\n"));
		assertMatch(PERSIST_VERBOSE, output.data);
	}


	private function normalizeJson(json:String):String {
		// XXX slots and dirs are unordered
		var obj:Dynamic = Json.parse(json);
		(obj.dirs:Array<Dynamic>).sort((a, b) -> Reflect.compare(a.path, b.path));
		(obj.slots:Array<Dynamic>).sort((a, b) -> Reflect.compare(a.name, b.name));
		return Json.stringify(obj);
	}
}
