package arp;

import picotest.PicoTest;

class ArpDomainAllTests {
	static function main() {
		var r = PicoTest.runner();
		ArpDomainTestSuite.addTo(r);
		r.run();
	}
}
