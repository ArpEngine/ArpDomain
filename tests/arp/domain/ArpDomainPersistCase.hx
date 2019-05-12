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

	private final PERSIST:Dynamic = untyped {
		"numDirs": 3,
		"dirs": [
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
		assertMatch(PERSIST, Json.parse(json));
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
		assertMatch(PERSIST, Json.parse(json));
	}

	private function normalizeJson(json:String):String {
		// XXX slots and dirs are unordered
		var obj:Dynamic = Json.parse(json);
		(obj.dirs:Array<Dynamic>).sort((a, b) -> Reflect.compare(a.path, b.path));
		(obj.slots:Array<Dynamic>).sort((a, b) -> Reflect.compare(a.name, b.name));
		return Json.stringify(obj);
	}
}
