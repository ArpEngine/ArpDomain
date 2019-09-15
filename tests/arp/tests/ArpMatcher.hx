package arp.tests;

import arp.domain.ArpUntypedSlot;
import arp.domain.ds.IArpObjectList;
import arp.domain.ds.IArpObjectMap;
import arp.domain.ds.IArpObjectOmap;
import arp.domain.ds.IArpObjectSet;
import arp.domain.IArpObject;
import arp.ds.IList;
import arp.ds.IMap;
import arp.ds.IOmap;
import arp.ds.ISet;
import picotest.matcher.patterns.PicoMatchBasic;
import picotest.matcher.patterns.PicoMatchPrimitive;
import picotest.matcher.patterns.standard.PicoMatchArray;
import picotest.matcher.patterns.standard.PicoMatchCircular;
import picotest.matcher.patterns.standard.PicoMatchStruct;
import picotest.matcher.PicoMatcher;
import picotest.matcher.PicoMatcherContext;
import picotest.matcher.PicoMatchResult;

using arp.ds.lambda.SetOp;
using arp.ds.lambda.MapOp;
using arp.ds.lambda.ListOp;
using arp.ds.lambda.OmapOp;

class ArpMatcher extends PicoMatcher {

	public function new() {
		super();
		this.append(new PicoMatchPrimitive());
		this.append(new PicoMatchCircular());
		this.appendMatcher(matchArpDs);
		this.appendMatcher(matchArpObject);
		this.appendMatcher(matchArpObjectSlot);
		this.append(new PicoMatchArray());
		this.append(new PicoMatchStruct());
		this.append(new PicoMatchBasic());
	}

	private static function matchArpObject(context:PicoMatcherContext, expected:Dynamic, actual:Dynamic):PicoMatchResult {
		if (Std.is(expected, IArpObject) || Std.is(actual, IArpObject)) {
			var e:String = if (expected == null) "null" else (expected:IArpObject).arpSlot.sid.toString();
			var a:String = if (actual == null) "null" else (actual:IArpObject).arpSlot.sid.toString();
			if (e == a) return PicoMatchResult.Match;
			return PicoMatchResult.Mismatch(e, a);
		}
		return PicoMatchResult.Unknown;
	}

	private static function matchArpObjectSlot(context:PicoMatcherContext, expected:Dynamic, actual:Dynamic):PicoMatchResult {
		if (Std.is(expected, ArpUntypedSlot) || Std.is(actual, ArpUntypedSlot)) {
			var e:String = if (expected == null) "null" else (expected:ArpUntypedSlot).sid.toString();
			var a:String = if (actual == null) "null" else (actual:ArpUntypedSlot).sid.toString();
			if (e == a) return PicoMatchResult.Match;
			return PicoMatchResult.Mismatch(e, a);
		}
		return PicoMatchResult.Unknown;
	}

	private static function matchArpDs(context:PicoMatcherContext, expected:Dynamic, actual:Dynamic):PicoMatchResult {
		if (Std.is(expected, IArpObjectSet) && Std.is(actual, IArpObjectSet)) {
			var e:IArpObjectSet<Dynamic> = expected;
			var a:IArpObjectSet<Dynamic> = expected;
			return context.match(
				e.slotSet.toAnon(),
				a.slotSet.toAnon()
			);
		}
		if (Std.is(expected, IArpObjectList) && Std.is(actual, IArpObjectList)) {
			var e:IArpObjectList<Dynamic> = expected;
			var a:IArpObjectList<Dynamic> = expected;
			return context.match(
				e.slotList.toArray(),
				a.slotList.toArray()
			);
		}
		if (Std.is(expected, IArpObjectMap) && Std.is(actual, IArpObjectMap)) {
			var e:IArpObjectMap<String, Dynamic> = expected;
			var a:IArpObjectMap<String, Dynamic> = expected;
			return context.match(
				e.slotMap.toAnon(),
				a.slotMap.toAnon()
			);
		}
		if (Std.is(expected, IArpObjectOmap) && Std.is(actual, IArpObjectOmap)) {
			var e:IArpObjectOmap<String, Dynamic> = expected;
			var a:IArpObjectOmap<String, Dynamic> = expected;
			return context.match(
				e.slotOmap.toArray(),
				a.slotOmap.toArray()
			);
		}
		if (Std.is(expected, ISet) && Std.is(actual, ISet)) {
			var e:ISet<Dynamic> = expected;
			var a:ISet<Dynamic> = expected;
			return context.match(
				e.toAnon(),
				a.toAnon()
			);
		}
		if (Std.is(expected, IList) && Std.is(actual, IList)) {
			var e:IList<Dynamic> = expected;
			var a:IList<Dynamic> = expected;
			return context.match(
				e.toArray(),
				a.toArray()
			);
		}
		if (Std.is(expected, IMap) && Std.is(actual, IMap)) {
			var e:IMap<String, Dynamic> = expected;
			var a:IMap<String, Dynamic> = expected;
			return context.match(
				e.toAnon(),
				a.toAnon()
			);
		}
		if (Std.is(expected, IOmap) && Std.is(actual, IOmap)) {
			var e:IOmap<String, Dynamic> = expected;
			var a:IOmap<String, Dynamic> = expected;
			return context.match(
				e.toArray(),
				a.toArray()
			);
		}
		return PicoMatchResult.Unknown;
	}


}
