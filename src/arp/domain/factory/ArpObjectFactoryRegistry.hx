package arp.domain.factory;

import arp.domain.core.ArpType;
import arp.ds.impl.ArraySet;
import arp.ds.lambda.SetOp;
import arp.errors.loadErrors.ArpVoidFactoryError;
import arp.seed.ArpSeed;

class ArpObjectFactoryRegistry {

	private var factoriesByArpType:ArpObjectFactoryListMap;
	private var factoriesByFqn:Map<String, ArpObjectFactory<Dynamic>>;

	public function new() {
		this.factoriesByArpType = new ArpObjectFactoryListMap();
		this.factoriesByFqn = new Map<String, ArpObjectFactory<Dynamic>>();
	}

	public function addTemplate<T:IArpObject>(klass:Class<T>, forceDefault:Null<Bool> = null, overwriteStrategy:OverwriteStrategy = OverwriteStrategy.Error) {
		var factory:ArpObjectFactory<T> = new ArpObjectFactory<T>(klass, forceDefault, overwriteStrategy);
		if (this.factoriesByFqn.exists(factory.arpTypeInfo.fqn)) return;
		this.factoriesByArpType.listFor(factory.arpType).push(factory);
		this.factoriesByFqn.set(factory.arpTypeInfo.fqn, factory);
	}

	public function resolveWithSeed<T:IArpObject>(seed:ArpSeed, type:ArpType):ArpObjectFactory<T> {
		var className = seed.className;
		if (className == null) className = seed.env.getDefaultClass(type.toString());
		var result:ArpObjectFactory<Dynamic> = null;
		var resultMatch:Float = 0;
		for (factory in this.factoriesByArpType.listFor(type)) {
			var match:Float = factory.matchSeed(seed, type, className);
			if (match > resultMatch) {
				result = factory;
				resultMatch = match;
			}
		}
		if (result == null) {
			throw new ArpVoidFactoryError('factory not found for <$type class=${seed.className}>');
		}
		return cast result;
	}

	public function resolveWithFqn<T:IArpObject>(fqn:String):ArpObjectFactory<T> {
		var result:ArpObjectFactory<Dynamic> = factoriesByFqn.get(fqn);
		if (result == null) {
			throw new ArpVoidFactoryError('factory [$fqn] not found');
		}
		return cast result;
	}

	public function allArpTypes():Array<ArpType> {
		var result:ArraySet<ArpType> = new ArraySet();
		for (arpType in this.factoriesByArpType.allArpTypes()) result.add(arpType);
		return SetOp.toArray(result);
	}
}

private class ArpObjectFactoryListMap {

	private var map:Map<String, Array<ArpObjectFactory<Dynamic>>>;

	public function new() {
		this.map = new Map();
	}

	public function listFor(type:ArpType):Array<ArpObjectFactory<Dynamic>> {
		var t:String = type.toString();
		if (this.map.exists(t)) return this.map.get(t);
		var a:Array<ArpObjectFactory<Dynamic>> = [];
		this.map.set(t, a);
		return a;
	}

	public function allArpTypes():Array<ArpType> {
		return [for (arpType in this.map.keys()) new ArpType(arpType)];
	}
}
