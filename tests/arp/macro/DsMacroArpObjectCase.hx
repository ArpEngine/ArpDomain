package arp.macro;

import arp.domain.ArpDomain;
import arp.domain.ArpSlot;
import arp.domain.core.ArpType;
import arp.domain.ds.ArpObjectList;
import arp.domain.ds.ArpObjectMap;
import arp.domain.ds.ArpObjectOmap;
import arp.domain.ds.ArpObjectSet;
import arp.ds.IList;
import arp.ds.IMap;
import arp.ds.IOmap;
import arp.ds.ISet;
import arp.ds.lambda.ListOp;
import arp.ds.lambda.MapOp;
import arp.ds.lambda.OmapOp;
import arp.ds.lambda.SetOp;
import arp.macro.mocks.MockDsMacroArpObject;
import arp.seed.ArpSeed;
import arp.tests.ArpDomainTestUtil;
import picotest.matcher.patterns.PicoMatchBasic;
import picotest.matcher.patterns.PicoMatchPrimitive;
import picotest.matcher.patterns.standard.PicoMatchArray;
import picotest.matcher.patterns.standard.PicoMatchCircular;
import picotest.matcher.patterns.standard.PicoMatchStruct;
import picotest.matcher.PicoMatcher;
import picotest.matcher.PicoMatcherContext;
import picotest.matcher.PicoMatchResult;
import picotest.PicoAssert.*;

class DsMacroArpObjectCase {

	private var domain:ArpDomain;
	private var slot:ArpSlot<MockDsMacroArpObject>;
	private var arpObj:MockDsMacroArpObject;
	private var xml:Xml;
	private var seed:ArpSeed;

	public function setup():Void {
		var matcher:PicoMatcher = new PicoMatcher();
		matcher.append(new PicoMatchPrimitive());
		matcher.append(new PicoMatchCircular());
		matcher.appendMatcher(matchArpDs);
		matcher.append(new PicoMatchArray());
		matcher.append(new PicoMatchStruct());
		matcher.append(new PicoMatchBasic());
		pushMatcher(matcher);

		domain = new ArpDomain();
		domain.addTemplate(MockDsMacroArpObject, true);
		xml = Xml.parse('
<mock name="name1">
	<intSet value="100" />
	<intSet value="101" />
	<intList value="200" />
	<intList value="201" />
	<intMap key="im1" value="300" />
	<intMap key="im2" value="301" />
	<intOmap key="io1" value="400" />
	<intOmap key="io2" value="401" />
	<refSet ref="name1" />
	<refSet ref="name1" />
	<refList ref="name1" />
	<refList ref="name1" />
	<refMap key="rm1" ref="name1" />
	<refMap key="rm2" ref="name1" />
	<refOmap key="ro1" ref="name1" />
	<refOmap key="ro2" ref="name1" />
</mock>
		').firstElement();
		seed = ArpSeed.fromXml(xml);
	}

	public function tearDown():Void {
		popMatcher();
	}

	public function testCreateEmpty():Void {
		arpObj = domain.allocObject(MockDsMacroArpObject);

		assertEquals(domain, arpObj.arpDomain);
		assertEquals(new ArpType("mock"), arpObj.arpType);
	}

	public function testLoadSeed():Void {
		slot = domain.loadSeed(seed, new ArpType("mock"));
		arpObj = slot.value;

		assertEquals(domain, arpObj.arpDomain);
		assertEquals(new ArpType("mock"), arpObj.arpType);
		assertEquals(slot, arpObj.arpSlot);

		assertMatch([100, 101], SetOp.toArray(arpObj.intSet));
		assertMatch([200, 201], ListOp.toArray(arpObj.intList));
		assertMatch({im1: 300, im2: 301}, MapOp.toAnon(arpObj.intMap));
		assertMatch({io1: 400, io2: 401}, OmapOp.toAnon(arpObj.intOmap));
		assertMatch([arpObj], SetOp.toArray(arpObj.refSet));
		assertMatch([arpObj, arpObj], ListOp.toArray(arpObj.refList));
		assertMatch({rm1: arpObj, rm2: arpObj}, MapOp.toAnon(arpObj.refMap));
		assertMatch({ro1: arpObj, ro2: arpObj}, OmapOp.toAnon(arpObj.refOmap));
		assertEquals(8, arpObj.arpSlot.refCount);
	}

	private static function matchArpDs(context:PicoMatcherContext, expected:Dynamic, actual:Dynamic):PicoMatchResult {
		if (Std.is(expected, ISet) && Std.is(actual, ISet)) {
			return context.match(expected.toString(), actual.toString());
			// return context.match(SetOp.toArray(expected), SetOp.toArray(actual));
		}
		if (Std.is(expected, IList) && Std.is(actual, IList)) {
			return context.match(expected.toString(), actual.toString());
			// return context.match(ListOp.toArray(expected), ListOp.toArray(actual));
		}
		if (Std.is(expected, IMap) && Std.is(actual, IMap)) {
			return context.match(expected.toString(), actual.toString());
			// return context.match(MapOp.toAnon(expected), MapOp.toAnon(actual));
		}
		if (Std.is(expected, IOmap) && Std.is(actual, IOmap)) {
			return context.match(expected.toString(), actual.toString());
			// return context.match(OmapOp.toArray(expected), OmapOp.toArray(actual));
		}
		return PicoMatchResult.Unknown;
	}

	private function checkIsClone(original:MockDsMacroArpObject, clone:MockDsMacroArpObject):Void {
		assertEquals(original.arpDomain, clone.arpDomain);
		assertEquals(original.arpType, clone.arpType);
		assertNotEquals(original.arpSlot, clone.arpSlot);

		assertMatch(original.intSet, clone.intSet);
		assertMatch(original.intList, clone.intList);
		assertMatch(original.intMap, clone.intMap);
		assertMatch(original.intOmap, clone.intOmap);

		assertMatch(original.refSet, clone.refSet);
		assertMatch(original.refList, clone.refList);
		assertMatch(original.refMap, clone.refMap);
		assertMatch(original.refOmap, clone.refOmap);
	}

	@Ignore("at least until we can handle reference properly")
	public function testPersistable():Void {
		slot = domain.loadSeed(seed, new ArpType("mock"));
		arpObj = slot.value;

		var clone:MockDsMacroArpObject = ArpDomainTestUtil.roundTrip(domain, arpObj, MockDsMacroArpObject);
		checkIsClone(arpObj, clone);
	}

	public function testArpClone():Void {
		slot = domain.loadSeed(seed, new ArpType("mock"));
		arpObj = slot.value;

		var clone:MockDsMacroArpObject = cast arpObj.arpClone();
		checkIsClone(arpObj, clone);
	}
}
