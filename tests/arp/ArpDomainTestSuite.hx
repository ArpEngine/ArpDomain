package arp;

import arp.domain.ArpDirectoryCase;
import arp.domain.ArpDomainCase;
import arp.domain.ArpDomainPersistCase;
import arp.domain.MockArpObjectCase;
import arp.domain.MockDerivedArpObjectCase;
import arp.domain.query.ArpDirectoryQueryCase;
import arp.domain.query.ArpObjectQueryCase;
import arp.macro.DsMacroArpObjectCase;
import arp.macro.EarlyPrepareMacroArpObjectCase;
import arp.macro.HeatUpMacroArpObjectCase;
import arp.macro.HookMacroArpObjectCase;
import arp.macro.LatePrepareMacroArpObjectCase;
import arp.macro.MacroArpObjectCase;
import arp.macro.MacroColumnArpObjectCase;
import arp.macro.MacroConcreteImplArpObjectCase;
import arp.macro.MacroDefaultArpObjectCase;
import arp.macro.MacroDerivedArpObjectCase;
import arp.macro.MacroHierarchicalArpObjectCase;
import arp.macro.MacroImplArpObjectCase;
import arp.macro.MacroOwnerArpObjectCase;
import arp.macro.StdDsMacroArpObjectCase;
import arp.tests.ArpDomainTestUtilCase;
import picotest.PicoTestRunner;

class ArpDomainTestSuite {
	public static function addTo(r:PicoTestRunner) {
		r.load(ArpDomainTestUtilCase);

		r.load(ArpDirectoryCase);
		r.load(ArpDirectoryQueryCase);
		r.load(ArpObjectQueryCase);

		r.load(MockArpObjectCase);
		r.load(MockDerivedArpObjectCase);

		r.load(MacroArpObjectCase);
		r.load(MacroDefaultArpObjectCase);
		r.load(MacroHierarchicalArpObjectCase);
		r.load(MacroColumnArpObjectCase);
		r.load(MacroDerivedArpObjectCase);
		r.load(StdDsMacroArpObjectCase);
		r.load(DsMacroArpObjectCase);
		r.load(HookMacroArpObjectCase);
		r.load(HeatUpMacroArpObjectCase);
		r.load(LatePrepareMacroArpObjectCase);
		r.load(EarlyPrepareMacroArpObjectCase);
		r.load(MacroImplArpObjectCase);
		r.load(MacroConcreteImplArpObjectCase);
		r.load(MacroOwnerArpObjectCase);

		r.load(ArpDomainCase);
		r.load(ArpDomainPersistCase);

		ArpDomainDsCompatTestSuite.addTo(r);
	}
}
