local package = script.Parent

local PrefabManager = require(package.PrefabManager)

--[=[
	Gets an instance's attributes, falling back on the prefab if it exists.
	@within Attributes

	```lua
	-- For this example, we'll use our local player
	local localPlayer = game:GetService("Players").LocalPlayer

	-- Set the 'Level' attribute to 7
	Attributes.setAttribute(localPlayer, "Level", 7)
	-- Get the 'Level' attribute
	local level = Attributes.getAttribute(localPlayer, "Level")

	-- Print to test if it worked!
	print(level)

	Output: 7
	```
]=]
local function getAttribute(instance: Instance, attribute: string)
	local prefab = PrefabManager.getPrefab(instance)
	local value = instance:GetAttribute(attribute)
	return if prefab and value == nil then prefab:GetAttribute(attribute) else value
end

return getAttribute