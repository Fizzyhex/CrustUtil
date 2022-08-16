local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")

local ModifiedComponent = require(script:WaitForChild("ModifiedComponent"))

local LOCAL_PLAYER = Players.LocalPlayer

local scriptContainer = Instance.new("Folder")
scriptContainer.Name = "ParallelComponentActors"
scriptContainer.Parent = if LOCAL_PLAYER then LOCAL_PLAYER:WaitForChild("PlayerScripts") else game:GetService("ServerScriptService")

local moduleRunner = if LOCAL_PLAYER then script:WaitForChild("ModuleRunnerClient") else script:WaitForChild("ModuleRunnerServer")

--[=[
	@class ParallelComponent
	
	ParallelComponent is a modified version of Sleitnick's Component that places each Instance of a component into separate acutators.

	The method used to achieve this could greatly be improved on.
]=]
local ParallelComponent = {}

function ParallelComponent.new(...)
	return ModifiedComponent.new(...)
end

--[=[
	Used to load a component. This should be done instead of requiring the component directly!

	@param module Instance -- The ModuleScript to load
]=]
function ParallelComponent:LoadComponent(module: ModuleScript)
	local tag = module.Name
	
	local actors = {}
	
	local function OnInstanceTagged(instance: Instance)
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