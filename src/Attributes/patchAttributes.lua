local Symbols = require(script.Parent.Symbols)

--[=[
	Patches the targetted instance's attributes.
	@within Attributes

	```lua
	local baseplate: BasePart = workspace.Baseplate

	patchAttributes(baseplate) {
		LastModified = tick(),
		-- ⚠ You need to use Attributes.NIL to set a value to nil, as lua tables
		-- cannot contain nil values!
		Owner = Attributes.NIL
	}
	```
]=]
local function patchAttributes(instance: Instance): (attributes: {[string]: any}) -> ()
	--[=[
		A decorator used to patch an instance with the provided attributes.
		@prop attributes table
		@within Attributes

		```lua
		local baseplate: BasePart = workspace.Baseplate

		patchAttributes(baseplate) {
			LastModified = tick(),
			-- ⚠ You need to use Attributes.NIL to set a value to nil, as lua tables
			-- cannot contain nil values!
			Owner = Attributes.NIL
		}
		```
	]=]
	return function(attributes: {[string]: any})
		for name, value in attributes do
			instance:SetAttribute(name, if value == Symbols.NIL then nil else value)
		end
	end
end

return patchAttributes