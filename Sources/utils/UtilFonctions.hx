package utils;
   
function getUnique<T>(array:Array<T>)
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