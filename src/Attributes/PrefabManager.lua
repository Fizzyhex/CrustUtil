local CollectionService = game:GetService("CollectionService")

local cache = {}

local function addToCache(instance: Instance, prefab: Instance)
	local connection
	cache[instance] = prefab

	connection = instance:GetPropertyChangedSignal("Parent"):Connect(function()
		if not instance:IsDescendantOf(game) then
			cache[instance] = nil
			connection:Disconnect()
		end
	end)
end

local function getPrefab(instance: Instance)
	if cache[instance] then
		return cache[instance]
	end

	local prefabSearchName = instance:GetAttribute("Src") or instance.Name

	for _, prefab in CollectionService:GetTagged("AttributePrefab") do
		if prefab.Name == prefabSearchName then
			-- Only cache if the instance is underneath the datamodel, as we
			-- want to avoid memory leaks.
			if instance:IsDescendantOf(game) then
				addToCache(instance, prefab)
			end

			return prefab
		end
	end

	return nil
end

return {
	getPrefab = getPrefab
}