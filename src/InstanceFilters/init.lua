local function MethodFilter(method, match)
	return function(instance: Instance)
		return if instance[method](instance, match) ~= nil then instance else nil
	end
end

--[[
    A collection of handy generic filters for Roblox Instances.

    ### Sample

    ```lua
    -- Let's create a new function that we can use to filter out parts.
    local basePartFilter = InstanceFilters.ClassFilter("BasePart")

    print(basePartFilter(workspace.Baseplate)) -> Baseplate
    print(basePartFilter(Instance.new("Folder"))) -> nil
    print(basePartFilter(Instance.new("Part"))) -> Part
    ```
--]]
local InstanceFilters = {}

InstanceFilters.TagFilter = function(tag: string)
	-- Returns the instance if it has the correct tag.
	return function(instance: Instance)
		return if instance:HasTag(tag) then instance else nil
	end
end

InstanceFilters.HasAttributeFilter = function(attribute: string)
	-- Returns the instance if an attribute is present on it.
	return function(instance: Instance)
		return if instance:GetAttribute(attribute) ~= nil then instance else nil
	end
end

InstanceFilters.PropertyFilter = function(property: string, value: any)
	-- Returns the instance if an attribute is present on it.
	return function(instance: Instance)
		return if instance[property] == value then instance else nil
	end
end

InstanceFilters.IsAFilter = function(className: string)
	-- Returns the instance if `Instance:IsA(className)` returns true.
	return MethodFilter("IsA", className)
end

InstanceFilters.ChildWhichIsAFilter = function(className: string)
	-- Returns the instance if a child which inherits from `className` or is a `className` is found.
	return MethodFilter("FindFirstChildWhichIsA", className)
end

InstanceFilters.AncestorOfClassWhichIsAFilter = function(className: string)
	-- Returns the instance if a child which inherits from `className` or is a `className` is found.
	MethodFilter("FindFirstChildWhichIsA", className)
end

InstanceFilters.AncestorWhichIsAFilter = function(className: string)
	-- Returns the instance if a child which inherits from `className` or is a `className` is found.
	MethodFilter("FindFirstAncestorWhichIsA", className)
end

return InstanceFilters