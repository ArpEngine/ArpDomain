package arp.domain.dump;

enum abstract ArpSlotStatus(String) to String {
	var ColdSlot = "-";
	var WarmingSlot = "*";
	var WarmSlot = "+";
	var InvalidSlot = "?";
	var NullSlot = "!";
	var Directory = "%";
	var Aux = "#";
	var None = " ";

	public static function fromHeat(heat:ArpHeat):ArpSlotStatus {
		return switch (heat) {
			case ArpHeat.Cold: ColdSlot;
			case ArpHeat.Warming: WarmingSlot;
			case ArpHeat.Warm: WarmSlot;
			default: InvalidSlot;
		}
	}
}
