-- UIComponent
-- Virshal
-- May 27, 2022

--[=[
	@class UIComponent
	
	A UIComponent is a class for managing components of user interfaces.

	This library is no longer maintained. I would suggest using Fusion instead.
	
	## Example

	```lua
	local UIComponent = require(somewhere.UIComponent)
	local CreateInstance = UIComponent.CreateInstance
	
	local LoudButton = UIComponent.new()
	
	function LoudButton:SetText(text)
		self.button.Text = text:upper()
	end
	
	function LoudButton:Build()
		self.button = CreateInstance("TextButton", {
			Size = UDim2.new(0, 80, 0, 30),
			Text = self.props.text
			Parent = self.props.parent
		})
		
		return self.button, self.SetText
	end
	
	local screenGui = CreateInstance("ScreenGui", {
		ResetOnSpawn = false, 
		Parent = LOCAL_PLAYER.PlayerGui
	})
	
	local button, _, UpdateText = LoudButton {text = "click me 10 times!", parent = screenGui}
	local clicks = 0
	
	button.button.MouseButton1Click:Connect(function(clickCounter)
		clicks += 1
		UpdateText(button, button.props.text .. " " .. clicks)
	end)
	```
]=]
local UIComponent = {}

UIComponent.Children = newproxy(true)
getmetatable(UIComponent.Children).__tostring = function() 
	return "CustomEnum(Children)" 
end

UIComponent.__call = function(self, props: {[any]: any})
	local new = setmetatable({props = props}, self)

	local args = {new:Build()}
	local topInstance = args[1]

	if topInstance then
		assert(typeof(topInstance) == "Instance", "The first argument returned by a UIComponent must be an Instance")
		new._topInstance = topInstance
	end

	if new.Defer then
		task.spawn(function()
			new:Defer()
		end)
	end

	return new, unpack(args)
end

--[=[
	A utility for creating Instances. 

	@param className string -- The class name of the Instance you want to create
	@param props table -- The properties of the instance you want to create
	@return Instance -- Returns a new Instance

	```lua
	local smokeyCube = CreateInstance("BasePart", {
		Name = "SmokeyCube",
		Anchored = true,
		Size = Vector3.new(4, 4, 4)
		Parent = workspace
		[UIComponent.Children] = CreateInstance("Smoke", {
			Size = 4
		})
	})
	
	-- ...which is equivalent to:
	local smokeyCube = Instance.new("BasePart")
	smokeyCube.Name = "SmokeyCube"
	smokeyCube.Anchored = true
	smokeyCube.Size = Vector3.new(4, 4, 4)
	smokeyCube.Parent = workspace

	local smoke = Instance.new("Smoke")
	smoke.Size = 4
	smoke.Parent = smokeyCube
	```

	### Assigning children

	Assigning children can be done within the CreateInstance function. The simplist way to do this is to simply pass a child:

	```lua
	local gui = CreateInstance("ScreenGui", {
		Parent = PlayerGui,

		Children = CreateInstance("Frame", {
			Size = UDim2.new(0, 50, 0, 50),
		}),
	})
	```

	Or a table for multiple children:
	```lua
	local gui = CreateInstance("ScreenGui", {
		Parent = PlayerGui,

		Children = {
			CreateInstance("Frame", {
				Size = UDim2.new(0, 50, 0, 50),
			}),

			CreateInstance("TextButton", {
				Size = UDim2.new(0, 50, 0, 50),
			}),
		}
	})
	```

	If you ever need to, you can also specify multiple children under different keys using the `UIComponent.Children` Enum:
	```lua
	local gui = CreateInstance("ScreenGui", {
		Parent = PlayerGui,

		[UIComponent.Children] = {
			CreateInstance("Frame", {
				Size = UDim2.new(0, 50, 0, 50),
			}),
		}

		[UIComponent.Children] = {
			CreateInstance("TextButton", {
				Size = UDim2.new(0, 50, 0, 50),
			}),
		}
	})
	```
]=]
function UIComponent.CreateInstance(className: string, props: {[any]: any})
	local instance = Instance.new(className)
	local parent
	
	local function HandleChild(child)
		if typeof(child) == "Instance" then
			child.Parent = instance
		elseif UIComponent.Is(child) then
			if child._topInstance then
				child._topInstance.Parent = instance
			else
				error("Failed to parent UIComponent because it has no top instance!")
			end
		else
			error("Instance children must be an Instance or a UIComponent! " .. tostring(child))
		end
	end
	
	for k, v in pairs (props or {}) do
		if k == "Parent" then
			parent = v
		elseif k == "Children" or k == UIComponent.Children then
			if typeof(v) == "Instance" then
				k.Parent = instance
			else
				if UIComponent.Is(v) then
					HandleChild(v)
				else
					for _, child: any in pairs (v) do
						HandleChild(child)
					end
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
	Returns the Instance returned by the component when it was built. This function will error if the component does not have an Instance.

	@return Instance

	```lua
	local Button = UIComponent.new()

	function Button:Build()
		return CreateInstance "TextButton" {
			Name = "FriendlyButton",
			Size = UDim2.new(0, 100, 0, 50),
			Text = self.props.Text,
		}, self.props
	end

	local newButton, _, props = Button {Text = "Hello World!"}
	print(newButton:GetInstance())
	print(props)

	> FriendlyButton
	> {
		Text = "Hello World!"
	}
	```
]=]
function UIComponent:GetInstance()
	return self._topInstance or error("UIComponent did not return an Instance when it was built")
end

--[=[
	`Build` is called during the UIComponent's creation.

	Build should **not** be called to create a new Instance of a UIComponent. Instead, call it like a function.

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

			return self.gui, tick()
		end

		local persistentGui, _, creationTime = MainGui.new{
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
	Checks if the given object is a UIComponent object.

	@param thing any -- Object to check

	@return boolean -- `true` if object is a UIComponent.
]=]
function UIComponent.Is(thing: any)
	return typeof(thing) == "table" and getmetatable(getmetatable(thing)) == UIComponent
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