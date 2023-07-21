local package = script.Parent

local PrefabManager = require(package.PrefabManager)

--- Returns a dictionary containing all of the attributes present on an Instance.
--- @within Attributes
local function allAttributes(instance: Instance, excludePrefab: boolean)
	local attributes = {}

	if instance:HasTag("UseAttributePrefab") and not excludePrefab then
		local prefab = PrefabManager.getPrefab(instance)

		if prefab then
			attributes = prefab:GetAttributes()
		end
	else
		return instance:GetAttributes()
	end

	for attribute, value in instance:GetAttributes() do
		attributes[attribute] = value
	end

	return attributes
end

return allAttributes