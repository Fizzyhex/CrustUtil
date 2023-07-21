export type Iterator = {
	(isExhausted: boolean, result...) -> ()
}

export type Filter = {
	(args...) -> (any)
}

--[[
	A functional iteration library for Luau.

	### Example

	```lua
	local Iter = require(somewhere.Iter)
	local filter = Iter.filter
	local UnionFilter = Iter.UnionFilter

	local function InstanceIsA(className: string)
		return function(instance: Instance)
			return if instance:IsA(className) then instance else nil
		end
	end

	local function PropertyFilter(property, value)
		return function(instance: Instance)
			return if (instance[property] == value) then instance else nil
		end
	end

	-- Creates a table of all unanchored parts inside of the workspace
	local unanchoredParts = filter(
		workspace:GetChildren(),
		UnionFilter(InstanceIsA("BasePart"), PropertyFilter("Anchored", false))
	)

	print("unanchored parts:", unanchoredParts)
	```
--]]
local Iter = {}

-- Returns a new iterator for looping through table values.
function Iter.ForValues(array: {})
	local index = 0

	return function()
		index += 1
		return index <= #array, array[index]
	end
end

-- Returns a new iterator for looping through table key/value pairs.
function Iter.ForPairs(array: {})
	local index = nil

	return function()
		local key, value = next(array, index)
		index = key
		return key ~= nil, key, value
	end
end

-- Returns a new iterator for looping through table keys.
function Iter.ForKeys(array: {})
	local iterator = Iter.ForPairs(array)

	return function()
		local alive, key = iterator()
		return alive, key
	end
end

-- Returns a new iterator for looping through the instance hiearchy.
function Iter.ForAncestors(instance: Instance | {Parent: any})
	return function()
		instance = instance.Parent
		return instance ~= nil, instance
	end
end

-- Returns a function that calls the specified method on an object, passing self as a parameter.
function Iter.CallMethod(method, ...)
	local args = {...}

	return function(object)
		return object[method](object, unpack(args))
	end
end

-- For each item in the `iterator`, run the `callback` if it passes the optional `filter`.
function Iter.iterate(iterator: Iterator, callback: (a...) -> (r...), filter: (a...) -> (r...))
	if typeof(iterator) ~= "function" then
		iterator = Iter.ForValues(iterator)
	end

	if filter ~= nil and typeof(filter) ~= "function" then
		filter = function()
			return filter
		end
	end

	while true do
		local results = {iterator()}
		local alive = table.remove(results, 1)

		if not alive then
			return
		end

		if filter == nil or filter(unpack(results)) then
			callback(unpack(results))
		end
	end
end

-- Returns a new table with only items that pass the filter.
function Iter.filter(iterator: Iterator, filter: Filter)
	if typeof(iterator) ~= "function" then
		iterator = Iter.ForValues(iterator)
	end

	local new = {}

	Iter.iterate(iterator, function(...)
		if filter(...) then
			local result = {...}

			if #result == 1 then
				table.insert(new, result[1])
			elseif #result == 2 then
				new[result[1]] = new[result[2]]
			end
		end
	end)

	return new
end

-- Returns the first match of a filter.
function Iter.first(iterator, filter: Filter)
	if typeof(iterator) ~= "function" then
		iterator = Iter.ForValues(iterator)
	end

	while true do
		local results = {iterator()}
		local alive = table.remove(results, 1)

		if not alive then
			return
		end

		if filter(unpack(results)) then
			return unpack(results)
		end
	end

	return nil
end

-- Gets the next item in an iterator.
function Iter.getNext(iterator: Iterator)
	return select(2, iterator())
end

-- For each item in the `iterator`, append the item (or the optionally `transformed` item) to a table if it passes the optional `filter`
function Iter.makeArray(iterator: Iterator, transform, filter: Filter)
	local array = {}

	Iter.iterate(iterator, function(...)
		if filter == nil or filter(...) then
			if transform then
				table.insert(array, next({transform(...)}))
			else
				table.insert(array, next({...}))
			end
		end
	end)

	return array
end

-- A factory that combines all provided filters into one.
function Iter.UnionFilter(...: Filter...): Filter
	local filters = {...}

	return function(...)
		for _, filter in filters do
			if not filter(...) then
				return nil
			end
		end

		return ...
	end :: Filter
end

-- A factory for a filter that returns true fi any of the provided filter's conditions are met.
function Iter.OrFilter(...: Filter...): Filter
	local filters = {...}

	return function(...)
		for _, filter in filters do
			if filter(...) then
				return true
			end
		end

		return false
	end :: Filter
end

-- A factory for a filter that returns the inverse of the filter (true becomes false and in vice versa).
function Iter.InvertedFilter(filter: Filter): Filter
	return function(...)
		return if filter(...) then nil else ...
	end :: Filter
end

return Iter