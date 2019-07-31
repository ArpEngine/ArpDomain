package arp.macro;

import arp.domain.ArpCloneMappers;
import arp.domain.ArpDomain;
import arp.domain.ArpSlot;
import arp.domain.core.ArpType;
import arp.macro.mocks.MockMacroDeepCopyArpObject;
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
		domain.addTemplate(MockMacroDeepCopyArpObject, true);
		xml = Xml.parse('
<data>
	<mock name="nullRef" stringField="nullRef" />
	<mock name="simpleRef" stringField="simpleRef" refField="nullRef" refField2="nullRef" />
	<mock name="recRef" stringField="recRef" refField="recRef" refField2="recRef" />
</data>
').firstElement();
		seed = ArpSeed.fromXml(xml);
		domain.loadSeed(seed);
	}

	private function checkIsIdentity(original:MockMacroDeepCopyArpObject, clone:MockMacroDeepCopyArpObject):Void {
		assertEquals(original.arpDomain, clone.arpDomain);
		assertEquals(original.arpType, clone.arpType);
		assertEquals(original.arpSlot, clone.arpSlot);

		// assertEquals(original.intField, clone.intField);
		// assertEquals(original.floatField, clone.floatField);
		// assertEquals(original.boolField, clone.boolField);
		assertEquals(original.stringField, clone.stringField);
		// assertEquals(original.refField, clone.refField);
	}

	private function checkIsClone(original:MockMacroDeepCopyArpObject, clone:MockMacroDeepCopyArpObject):Void {
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
		var nullRef:MockMacroDeepCopyArpObject = domain.query("nullRef", MOCK_TYPE).value();
		var nullClone:MockMacroDeepCopyArpObject = cast nullRef.arpClone(ArpCloneMappers.shallow());
		checkIsClone(nullRef, nullClone);
		assertNull(nullClone.refField);
		assertNull(nullClone.refField2);

		var simpleRef:MockMacroDeepCopyArpObject = domain.query("simpleRef", MOCK_TYPE).value();
		var simpleClone:MockMacroDeepCopyArpObject = cast simpleRef.arpClone(ArpCloneMappers.shallow());
		checkIsClone(simpleRef, simpleClone);
		checkIsIdentity(simpleRef.refField, simpleClone.refField);
		checkIsIdentity(simpleRef.refField2, simpleClone.refField2);

		var recRef:MockMacroDeepCopyArpObject = domain.query("recRef", MOCK_TYPE).value();
		var recClone:MockMacroDeepCopyArpObject = cast recRef.arpClone(ArpCloneMappers.shallow());
		checkIsClone(recRef, recClone);
		checkIsIdentity(recRef.refField, recClone.refField);
		checkIsIdentity(recRef.refField2, recClone.refField2);
	}

	public function testArpCloneSelective():Void {
		var nullRef:MockMacroDeepCopyArpObject = domain.query("nullRef", MOCK_TYPE).value();
		var nullClone:MockMacroDeepCopyArpObject = cast nullRef.arpClone(ArpCloneMappers.selective());
		checkIsClone(nullRef, nullClone);
		assertNull(nullClone.refField);
		assertNull(nullClone.refField2);

		var simpleRef:MockMacroDeepCopyArpObject = domain.query("simpleRef", MOCK_TYPE).value();
		var simpleClone:MockMacroDeepCopyArpObject = cast simpleRef.arpClone(ArpCloneMappers.selective());
		checkIsClone(simpleRef, simpleClone);
		checkIsClone(simpleRef.refField, simpleClone.refField);
		checkIsIdentity(simpleRef.refField2, simpleClone.refField2);

		var recRef:MockMacroDeepCopyArpObject = domain.query("recRef", MOCK_TYPE).value();
		var recClone:MockMacroDeepCopyArpObject = cast recRef.arpClone(ArpCloneMappers.selective());
		checkIsClone(recRef, recClone);
		checkIsClone(recRef.refField, recClone.refField);
		checkIsIdentity(recRef.refField2, recClone.refField2);
	}

	public function testArpCloneDeep():Void {
		var nullRef:MockMacroDeepCopyArpObject = domain.query("nullRef", MOCK_TYPE).value();
		var nullClone:MockMacroDeepCopyArpObject = cast nullRef.arpClone(ArpCloneMappers.deep());
		checkIsClone(nullRef, nullClone);
		assertNull(nullClone.refField);
		assertNull(nullClone.refField2);

		var simpleRef:MockMacroDeepCopyArpObject = domain.query("simpleRef", MOCK_TYPE).value();
		var simpleClone:MockMacroDeepCopyArpObject = cast simpleRef.arpClone(ArpCloneMappers.deep());
		checkIsClone(simpleRef, simpleClone);
		checkIsClone(simpleRef.refField, simpleClone.refField);
		checkIsClone(simpleRef.refField2, simpleClone.refField2);

		var recRef:MockMacroDeepCopyArpObject = domain.query("recRef", MOCK_TYPE).value();
		var recClone:MockMacroDeepCopyArpObject = cast recRef.arpClone(ArpCloneMappers.deep());
		checkIsClone(recRef, recClone);
		checkIsClone(recRef.refField, recClone.refField);
		checkIsClone(recRef.refField2, recClone.refField2);
	}

	public function testArpCloneMarshal():Void {
		var nullRef:MockMacroDeepCopyArpObject = domain.query("nullRef", MOCK_TYPE).value();
		var nullClone:MockMacroDeepCopyArpObject = cast nullRef.arpClone(ArpCloneMappers.serialize());
		checkIsClone(nullRef, nullClone);
		assertNull(nullClone.refField);
		assertNull(nullClone.refField2);

		var simpleRef:MockMacroDeepCopyArpObject = domain.query("simpleRef", MOCK_TYPE).value();
		var simpleClone:MockMacroDeepCopyArpObject = cast simpleRef.arpClone(ArpCloneMappers.serialize());
		checkIsClone(simpleRef, simpleClone);
		checkIsClone(simpleRef.refField, simpleClone.refField);
		checkIsClone(simpleRef.refField2, simpleClone.refField2);
	}
}
