package utils;

class ArayUtils
{ 
	public inline function getUnique<T>(array:Array<T>)
	{
		var hash = new haxe.DynamicAccess<Bool>();
		var result = new Array<T>();
		for (v in array)
		{
			var key = v + "";
			var exists = hash.get(key);
			if(!exists)
			{
				result.push(v);
				hash.set(key, true);
			}
		}
		return result;
	}
}

class ReverseIterator
{
	var end:Int;
	var i:Int;
	
	public inline function new(start:Int, end:Int)
	{
		this.i = start;
		this.end = end;
	}
	
	public inline function hasNext() return i >= end;
	public inline function next() return i--;
}