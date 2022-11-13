type AncestorList = { Instance }

--[=[
	@type ExtensionFn (component) -> ()
	@within Component
]=]
type ExtensionFn = (any) -> ()

--[=[
	@type ExtensionShouldFn (component) -> boolean
	@within Component
]=]
type ExtensionShouldFn = (any) -> boolean

--[=[
	@interface Extension
	@within Component
	.ShouldExtend ExtensionShouldFn?
	.ShouldConstruct ExtensionShouldFn?
	.Constructing ExtensionFn?
	.Constructed ExtensionFn?
	.Starting ExtensionFn?
	.Started ExtensionFn?
	.Stopping ExtensionFn?
	.Stopped ExtensionFn?

	An extension allows the ability to extend the behavior of
	components. This is useful for adding injection systems or
	extending the behavior of components by wrapping around
	component lifecycle methods.

	The `ShouldConstruct` function can be used to indicate
	if the component should actually be created. This must
	return `true` or `false`. A component with multiple
	`ShouldConstruct` extension functions must have them _all_
	return `true` in order for the component to be constructed.
	The `ShouldConstruct` function runs _before_ all other
	extension functions and component lifecycle methods.

	The `ShouldExtend` function can be used to indicate if
	the extension itself should be used. This can be used in
	order to toggle an extension on/off depending on whatever
	logic is appropriate. If no `ShouldExtend` function is
	provided, the extension will always be used if provided
	as an extension to the component.

	As an example, an extension could be created to simply log
	when the various lifecycle stages run on the component:

	```lua
	local Logger = {}
	function Logger.Constructing(component) print("Constructing", component) end
	function Logger.Constructed(component) print("Constructed", component) end
	function Logger.Starting(component) print("Starting", component) end
	function Logger.Started(component) print("Started", component) end
	function Logger.Stopping(component) print("Stopping", component) end
	function Logger.Stopped(component) print("Stopped", component) end

	local MyComponent = Component.new({Tag = "MyComponent", Extensions = {Logger}})
	```

	Sometimes it is useful for an extension to control whether or
	not a component should be constructed. For instance, if a
	component on the client should only be instantiated for the
	local player, an extension might look like this, assuming the
	instance has an attribute linking it to the player's UserId:
	```lua
	local player = game:GetService("Players").LocalPlayer

	local OnlyLocalPlayer = {}
	function OnlyLocalPlayer.ShouldConstruct(component)
		local ownerId = component.Instance:GetAttribute("OwnerId")
		return ownerId == player.UserId
	end

	local MyComponent = Component.new({Tag = "MyComponent", Extensions = {OnlyLocalPlayer}})
	```

	It can also be useful for an extension itself to turn on/off
	depending on various contexts. For example, let's take the
	Logger from the first example, and only use that extension
	if the bound instance has a Log attribute set to `true`:
	```lua
	function Logger.ShouldExtend(component)
		return component.Instance:GetAttribute("Log") == true
	end
	```
]=]
type Extension = {
	ShouldExtend: ExtensionShouldFn?,
	ShouldConstruct: ExtensionShouldFn?,
	Constructing: ExtensionFn?,
	Constructed: ExtensionFn?,
	Starting: ExtensionFn?,
	Started: ExtensionFn?,
	Stopping: ExtensionFn?,
	Stopped: ExtensionFn?,
}

--[=[
	@interface ComponentConfig
	@within Component
	.Tag string -- CollectionService tag to use
	.Ancestors {Instance}? -- Optional array of ancestors in which components will be started
	.Extensions {Extension}? -- Optional array of extension objects

	Component configuration passed to `Component.new`.

	- If no Ancestors option is included, it defaults to `{workspace, game.Players}`.
	- If no Extensions option is included, it defaults to a blank table `{}`.
]=]
type ComponentConfig = {
	Tag: string,
	Ancestors: AncestorList?,
	Extensions: { Extension }?,
}

--[=[
	@within Component
	@prop Started Signal
	@tag Event
	@tag Component Class

	Fired when a new instance of a component is started.

	```lua
	local MyComponent = Component.new({Tag = "MyComponent"})

	MyComponent.Started:Connect(function(component) end)
	```
]=]

--[=[
	@within Component
	@prop Stopped Signal
	@tag Event
	@tag Component Class

	Fired when an instance of a component is stopped.

	```lua
	local MyComponent = Component.new({Tag = "MyComponent"})

	MyComponent.Stopped:Connect(function(component) end)
	```
]=]

--[=[
	@tag Component Instance
	@within Component
	@prop Instance Instance
	
	A reference back to the _Roblox_ instance from within a _component_ instance. When
	a component instance is created, it is bound to a specific Roblox instance, which
	will always be present through the `Instance` property.

	```lua
	MyComponent.Started:Connect(function(component)
		local robloxInstance: Instance = component.Instance
		print("Component is bound to " .. robloxInstance:GetFullName())
	end)
	```
]=]

local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")

local ModifiedComponent = require(script:WaitForChild("ModifiedComponent"))

local LOCAL_PLAYER = Players.LocalPlayer

local containerParent = if LOCAL_PLAYER then LOCAL_PLAYER:WaitForChild("PlayerScripts") else game:GetService("ServerScriptService")
local scriptContainer = containerParent:FindFirstChild("ParallelComponentActors") or Instance.new("Folder")
scriptContainer.Name = "ParallelComponentActors"
scriptContainer.Parent = containerParent

local moduleRunner = if LOCAL_PLAYER then script:WaitForChild("ModuleRunnerClient") else script:WaitForChild("ModuleRunnerServer")

--[=[
	@class ParallelComponent

	ParallelComponent is a modified version of [Sleitnick's Component](https://sleitnick.github.io/RbxUtil/api/Component) that places each Instance of a component into separate acutators.

	:::caution
	This module is experimental! Use at your own risk.
	:::
]=]
local ParallelComponent = {}

--[=[
	@param config ComponentConfig
	@return ComponentClass

	Constructs a new Parallel Component.

	```lua
	local MyComponent = ParallelComponent.new {
		Tag = "MyComponent"
		ParallelInstance = script:FindFirstChild("ParallelInstance") -- Required!
	}
	```
]=]
function ParallelComponent.new(config: ComponentConfig)
	return ModifiedComponent.new(config)
end

--[=[
	Used to load a component. This should be used instead of requiring the component directly!

	@param module Instance -- The ModuleScript to load
]=]
function ParallelComponent:LoadComponent(module: ModuleScript)
	local tag = module.Name
	
	local actors = {}
	
	local function OnInstanceTagged(instance: Instance)
		if not instance:IsDescendantOf(workspace) then
			return
		end

		local actor = Instance.new("Actor")
		actor.Name = "Component Actor " .. tag
		local moduleClone = module:Clone()

		local parallelInstance = Instance.new("ObjectValue")
		parallelInstance.Name = "ParallelInstance"
		parallelInstance.Value = instance
		parallelInstance.Parent = moduleClone

		local executor = moduleRunner:Clone()
		executor.Parent = moduleClone

		moduleClone.Parent = actor

		actor.Parent = scriptContainer

		actors[instance] = actor
	end
	
	CollectionService:GetInstanceAddedSignal(tag):Connect(function(instance: Instance)
		OnInstanceTagged(instance)
	end)
	
	CollectionService:GetInstanceRemovedSignal(tag):Connect(function(instance: Instance)
		if actors[instance] then
			pcall(function()
				actors[instance][module.Name].Stop:Invoke()
			end)
			
			actors[instance]:Destroy()
		end
	end)
	
	for _, instance in CollectionService:GetTagged(tag) do
		task.defer(OnInstanceTagged, instance)
	end
end

return ParallelComponent