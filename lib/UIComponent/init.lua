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
		local smokeyCube = CreateInstance "BasePart", {
			Name = "SmokeyCube",
			Anchored = true,
			Size = Vector3.new(4, 4, 4)
			Parent = workspace
			[Children] = CreateInstance "Smoke" { 
				Size = 4 
			}
		}

		-- ...which is equivalent to:
		local smokeyCube = CreateInstance("BasePart", {
			Name = "SmokeyCube",
			Anchored = true,
			Size = Vector3.new(4, 4, 4)
			Parent = workspace
			[Children] = CreateInstance("Smoke", {
				Size = 4
			})
		})
		
		-- ...which is also equivalent to:
		local smokeyCube = Instance.new("BasePart")
		smokeyCube.Name = "SmokeyCube"
		smokeyCube.Anchored = true
		smokeyCube.Size = Vector3.new(4, 4, 4)
		smokeyCube.Parent = workspace

		local smoke = Instance.new("Smoke")
		smoke.Size = 4
		smoke.Parent = smokeyCube
	```
]=]
function UIComponent.CreateInstance(className: string, props: {[any]: any})
	local instance = Instance.new(className)
	local parent
	for k, v in pairs (props) do
		if k == "Parent" then
			parent = v
		elseif k == "Children" then
			if typeof(k) ~= "table" then
				k.Parent = instance
			else
				for _, child: Instance in pairs (k) do
					child.Parent = instance
				end
			end
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