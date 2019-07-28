package arp.macro;

import arp.domain.ArpCloneMappers;
import arp.domain.ArpDomain;
import arp.domain.ArpSlot;
import arp.domain.core.ArpType;
import arp.macro.mocks.MockMacroArpObject;
import arp.seed.ArpSeed;
import arp.tests.ArpDomainTestUtil;
import picotest.PicoAssert.*;

class MacroDeepCopyArpObjectCase {

	private var domain:ArpDomain;
	private var xml:Xml;
	private var seed:ArpSeed;

	inline private static var MOCK_TYPE = new ArpType("mock");

	public function setup():Void {
		domain = new ArpDomain();
		domain.addTemplate(MockMacroArpObject, true);
		xml = Xml.parse('
<data>
	<mock name="nullRef" stringField="nullRef" />
	<mock name="simpleRef" stringField="simpleRef" refField="nullRef" />
	<mock name="recRef" stringField="recRef" refField="recRef" />
</data>
').firstElement();
		seed = ArpSeed.fromXml(xml);
		domain.loadSeed(seed);
	}

	private function checkIsIdentity(original:MockMacroArpObject, clone:MockMacroArpObject):Void {
		assertEquals(original.arpDomain, clone.arpDomain);
		assertEquals(original.arpType, clone.arpType);
		assertEquals(original.arpSlot, clone.arpSlot);

		// assertEquals(original.intField, clone.intField);
		// assertEquals(original.floatField, clone.floatField);
		// assertEquals(original.boolField, clone.boolField);
		assertEquals(original.stringField, clone.stringField);
		// assertEquals(original.refField, clone.refField);
	}

	private function checkIsClone(original:MockMacroArpObject, clone:MockMacroArpObject):Void {
		assertEquals(original.arpDomain, clone.arpDomain);
		assertEquals(original.arpType, clone.arpType);
		assertNotEquals(original.arpSlot, clone.arpSlot);

		// assertEquals(original.intField, clone.intField);
		// assertEquals(original.floatField, clone.floatField);
		// assertEquals(original.boolField, clone.boolField);
		assertEquals(original.stringField, clone.stringField);
		// assertEquals(original.refField, clone.refField);
	}

	public function testArpCloneShallow():Void {
		var nullRef:MockMacroArpObject = domain.query("nullRef", MOCK_TYPE).value();
		var nullClone:MockMacroArpObject = cast nullRef.arpClone(ArpCloneMappers.shallow());
		checkIsClone(nullRef, nullClone);
		assertNull(nullClone.refField);

		var simpleRef:MockMacroArpObject = domain.query("simpleRef", MOCK_TYPE).value();
		var simpleClone:MockMacroArpObject = cast simpleRef.arpClone(ArpCloneMappers.shallow());
		checkIsClone(simpleRef, simpleClone);
		checkIsIdentity(simpleRef.refField, simpleClone.refField);

		var recRef:MockMacroArpObject = domain.query("recRef", MOCK_TYPE).value();
		var recClone:MockMacroArpObject = cast recRef.arpClone(ArpCloneMappers.shallow());
		checkIsClone(recRef, recClone);
		checkIsIdentity(recRef.refField, recClone.refField);
	}

	public function testArpCloneDeep():Void {
		var nullRef:MockMacroArpObject = domain.query("nullRef", MOCK_TYPE).value();
		var nullClone:MockMacroArpObject = cast nullRef.arpClone(ArpCloneMappers.deep());
		checkIsClone(nullRef, nullClone);
		assertNull(nullClone.refField);

		var simpleRef:MockMacroArpObject = domain.query("simpleRef", MOCK_TYPE).value();
		var simpleClone:MockMacroArpObject = cast simpleRef.arpClone(ArpCloneMappers.deep());
		checkIsClone(simpleRef, simpleClone);
		checkIsClone(simpleRef.refField, simpleClone.refField);

		var recRef:MockMacroArpObject = domain.query("recRef", MOCK_TYPE).value();
		var recClone:MockMacroArpObject = cast recRef.arpClone(ArpCloneMappers.deep());
		checkIsClone(recRef, recClone);
		checkIsClone(recRef.refField, recClone.refField);
	}

	public function testArpCloneMarshal():Void {
		var nullRef:MockMacroArpObject = domain.query("nullRef", MOCK_TYPE).value();
		var nullClone:MockMacroArpObject = cast nullRef.arpClone(ArpCloneMappers.serialize());
		checkIsClone(nullRef, nullClone);
		assertNull(nullClone.refField);

		var simpleRef:MockMacroArpObject = domain.query("simpleRef", MOCK_TYPE).value();
		var simpleClone:MockMacroArpObject = cast simpleRef.arpClone(ArpCloneMappers.serialize());
		checkIsClone(simpleRef, simpleClone);
		checkIsClone(simpleRef.refField, simpleClone.refField);
	}
}
