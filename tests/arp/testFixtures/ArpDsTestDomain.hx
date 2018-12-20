package arp.testFixtures;

import arp.domain.ArpDomain;
import arp.domain.mocks.MockArpObject;
import arp.seed.ArpSeed;
import arp.testFixtures.ArpSupportFixtures.IArpSupportFixture;

class ArpDsTestDomain extends ArpDomain implements IArpSupportFixture<MockArpObject> {

	public var a1(get, never):MockArpObject;
	private function get_a1():MockArpObject return value1;
	public var a2(get, never):MockArpObject;
	private function get_a2():MockArpObject return value2;
	public var a3(get, never):MockArpObject;
	private function get_a3():MockArpObject return value3;
	public var a4(get, never):MockArpObject;
	private function get_a4():MockArpObject return value4;
	public var a5(get, never):MockArpObject;
	private function get_a5():MockArpObject return value5;
	public var a6(get, never):MockArpObject;
	private function get_a6():MockArpObject return value6;
	public var a7(get, never):MockArpObject;
	private function get_a7():MockArpObject return value7;
	public var a8(get, never):MockArpObject;
	private function get_a8():MockArpObject return value8;
	public var a9(get, never):MockArpObject;
	private function get_a9():MockArpObject return value9;

	public var value1:MockArpObject;
	public var value2:MockArpObject;
	public var value3:MockArpObject;
	public var value4:MockArpObject;
	public var value5:MockArpObject;
	public var value6:MockArpObject;
	public var value7:MockArpObject;
	public var value8:MockArpObject;
	public var value9:MockArpObject;

	private var withNull:Bool;

	public function new(withNull:Bool) {
		super();
		this.withNull = withNull;
	}

	private function createFixtures():IArpSupportFixture<MockArpObject> {
		this.addTemplate(MockArpObject, true);
		var xml = Xml.parse('<data>
		<mock name="name1"/>
		<mock name="name2"/>
		<mock name="name3" />
		<mock name="name4" />
		<mock name="name5" />
		<mock name="name6" />
		<mock name="name7" />
		<mock name="name8" />
		<mock name="name9" />
		</data>
		').firstElement();
		this.loadSeed(ArpSeed.fromXml(xml));
		this.value1 = withNull ? null : this.query("name1", MockArpObject._arpTypeInfo.arpType).value();
		this.value2 = this.query("name2", MockArpObject._arpTypeInfo.arpType).value();
		this.value3 = this.query("name3", MockArpObject._arpTypeInfo.arpType).value();
		this.value4 = this.query("name4", MockArpObject._arpTypeInfo.arpType).value();
		this.value5 = this.query("name5", MockArpObject._arpTypeInfo.arpType).value();
		this.value6 = this.query("name6", MockArpObject._arpTypeInfo.arpType).value();
		this.value7 = this.query("name7", MockArpObject._arpTypeInfo.arpType).value();
		this.value8 = this.query("name8", MockArpObject._arpTypeInfo.arpType).value();
		this.value9 = this.query("name9", MockArpObject._arpTypeInfo.arpType).value();
		return this;
	}

	public function toString():String return '[ArpDsTestDomain ${this.value1}]';

	public function create():IArpSupportFixture<MockArpObject> return new ArpDsTestDomain(this.withNull).createFixtures();
}
