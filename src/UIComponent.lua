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
			self.button = CreateInstance("TextButton", {
				Size = UDim2.new(0, 80, 0, 30),
				Text = self.props.text
				Parent = self.props.parent
			})
			
			return self.SetText
		end
		
		local screenGui = CreateInstance("ScreenGui", {
			ResetOnSpawn = false, 
			Parent = LOCAL_PLAYER.PlayerGui
		})
		
		local button, UpdateText = LoudButton{text = "click me 10 times!", parent = screenGui}
		local clicks = 0
		
		button.button.MouseButton1Click:Connect(function(clickCounter)
			clicks += 1
			UpdateText(button, button.props.text .. " " .. clicks)
		end)
	```
]=]
local UIComponent = {}

UIComponent.__call = function(self, props)
	local new = setmetatable({props = props}, self)

	local args = {new:Build(props)}

	if new.Defer then
		task.spawn(function()
			new:Defer()
		end)
	end

	return new, unpack(args)
end

--[=[
	Creates a new Instance. 

	@param className string -- The class name of the Instance you want to create
	@param props table -- The properties of the instance you want to create
	@return Instance -- Returns a new Instance
]=]
function UIComponent.CreateInstance(className: string, props: {[string]: any})
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
	Creates a new UIComponent class.
	
	```lua
		local newComponent = UIComponent.new()
	```
	
	@return Export
]=]
function UIComponent.new()
	local element = {}
	element.__index = element
	
	setmetatable(element, UIComponent)
	
	return element
end

return UIComponent