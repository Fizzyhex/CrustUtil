-- UIComponent
-- Virshal
-- May 27, 2022

--[=[
	@class UIComponent
	
	A UIComponent is a class for managing components of user interfaces.
	
	For example:
	```lua
		local UIComponent = require(somewhere.UIComponent)
		local CreateInstance = UIComponent.CreateInstance
		
		local LoudButton = UIComponent.new()
		
		function LoudButton:SetText(text)
			self.button.Text = text:upper()
		end
		
		function LoudButton:Build()
			self.button = CreateInstance "TextButton", {
				Size = UDim2.new(0, 80, 0, 30),
				Text = self.props.text
				Parent = self.props.parent
			}
			
			return self.SetText
		end
		
		local screenGui = CreateInstance "ScreenGui", {
			ResetOnSpawn = false, 
			Parent = LOCAL_PLAYER.PlayerGui
		}
		
		local button, UpdateText = LoudButton{text = "click me 10 times!", parent = screenGui}
		local clicks = 0
		
		button.button.MouseButton1Click:Connect(function(clickCounter)
			clicks += 1
			UpdateText(button, button.props.text .. " " .. clicks)
		end)
	```
]=]
local UIComponent = {}
UIComponent.__call = function(self, props: {[any]: any})
	local new = setmetatable({props = props}, self)

	local args = {new:Build()}

	task.spawn(function()
		new:Defer()
	end)

	return new, unpack(args)
end

--[=[
	A utility for creating Instances. 

	@param className string -- The class name of the Instance you want to create
	@param props table -- The properties of the instance you want to create
	@return Instance -- Returns a new Instance

	```lua
		local parts = {}

		-- This is equivalent to the code below...
		parts.cube = UIComponent.CreateInstance "BasePart", {
			Name = "Cube",
			Anchored = true,
			Size = Vector3.new(4, 4, 4)
			Parent = workspace
		}

		-- ...which is equivalent to:
		parts.cube = UIComponent.CreateInstance("BasePart", {
			Name = "Cube",
			Anchored = true,
			Size = Vector3.new(4, 4, 4)
			Parent = workspace
		})

		-- ...which is also equivalent to:
		parts.cube = Instance.new("BasePart")
		parts.cube.Name = "Cube"
		parts.cube.Anchored = true
		parts.cube.Size = Vector3.new(4, 4, 4)
		parts.cube.Parent = workspace
	```
]=]
function UIComponent.CreateInstance(className: string, props: {[any]: any})
	local instance = Instance.new(className)
	local parent
	for k, v in pairs (props) do
		if k == "Parent" then
			parent = v
		else
			instance[k] = v
		end
	end
	instance.Parent = parent
	return instance
end

--[=[
	`Build` is called during the UIComponent's creation.

	@return self, ... -- Returns the object and any provided arguments

	```lua
		local UIComponent = require(somewhere.UIComponent)
	
		local PersistentGui = UIComponent.new()

		function PersistentGui:Build()
			self.gui = CreateInstance("ScreenGui", {
				Name = "PersistentGui",
				ResetOnSpawn = false,
				ZIndex = self.props.ZIndex,
				Parent = LOCAL_PLAYER.PlayerGui
			})

			return tick()
		end

		local persistentGui, creationTime = MainGui.new{
			ZIndex = 3
		}

		print("Created GUI at", creationTime)
	```
]=]
function UIComponent:Build()
end

--[=[
	`Defer` is called after `Build` and will not yield the thread.
]=]
function UIComponent:Defer()
end

--[=[
	Creates a new UIComponent class.
	
	```lua
		local newComponent = UIComponent.new()
	```
	
	@return UIComponent
]=]
function UIComponent.new()
	local element = {}
	element.__index = element
	
	setmetatable(element, UIComponent)
	
	return element
end

return UIComponent