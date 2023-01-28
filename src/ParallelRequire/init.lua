export type Executor = ModuleScript
export type ParallelRequireConfig = {executor: Executor, container: Instance?}

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local IS_CLIENT = RunService:IsClient()
local REQUIRER = if IS_CLIENT then script:WaitForChild("ClientRequirer") else script:WaitForChild("ServerRequirer")
local DEFAULT_EXECUTOR = script:WaitForChild("DefaultExecutor")

local ACTOR_CONTAINER = Instance.new("Folder")
ACTOR_CONTAINER.Name = "ParallelRequireActors"

--[=[
	@class ParallelRequire

	A module that assists with requiring modules into [Actor] instances.

	```lua
	local ParallelRequire = require(Somewhere.ParallelRequire)
	local SingletonExecutor = Somewhere.ParallelExecutors.Singleton

	-- This will require 'SomeModule' inside of an Actor
	ParallelRequire(Somewhere.SomeModule)

	-- This will require 'SomeModule' and 'SomeOtherSingleton' inside of the same actor, using the custom 'SingletonExecutor' Executor.
	ParallelRequire(Somewhere.Singletons:GetChildren(), SingletonExecutor)
	```
]=]
local ParallelRequire = {}
ParallelRequire.__index = ParallelRequire
ParallelRequire.__call = function(self, ...)
	return self:Require(...)
end

setmetatable(ParallelRequire, {__call = ParallelRequire.__call})

--[=[
	@type Executor ModuleScript
	@within ParallelRequire

	An executor is a [ModuleScript] that is used to load ModuleScripts that are required.

	An instance of an executor is created per [ModuleScript] that is required.

	```lua
	-- This is the default Executor ModuleScript.
	-- When an executor is required, it will have an ObjectValue parented to it that points to the module that needs to be required.

	require(script.module.Value)
	return nil
	```

	```lua
	-- Example Executor that requires the module and then calls its 'OnStart' method too.

	local module = require(script.module.Value)

	if module.OnStart then
		module:OnStart()
	end

	return nil
	```

	:::caution

	Executors must return something, as they are ModuleScripts! Because the returned value won't be used, you should just return `nil`.

	:::

	:::note

	Executors are created per `ModuleScript`, so it's safe to yield incide of them.

	:::
]=]

--[=[
	@type ParallelRequireConfig {executor: Executor, container: Instance?}
	@within ParallelRequire

	The configuration used when instantiating a new `ParallelRequire` object.
]=]

--[=[
	Requires the [ModuleScript] under a new Actor. If a table of modules is passed, they will all be placed under the same Actor.

	@param modules -- ModuleScript(s) to require
	@param executor -- The Executor that will be used to require the module
]=]
function ParallelRequire:Require(modules: ModuleScript | {ModuleScript}, executor: Executor): Actor
	if typeof(modules) ~= "table" then
		modules = {modules}
	end

	local actor = Instance.new("Actor")
	actor.Name = "ParallelRequireActor"

	for _, module in modules do
		if not module:IsA("ModuleScript") then
			continue
		end

		local requirer = REQUIRER:Clone()
		requirer.Name = module:GetFullName()
		requirer.Parent = actor

		executor = executor or self._executor or DEFAULT_EXECUTOR
		executor = executor:Clone()
		executor.Parent = requirer

		local moduleValue = Instance.new("ObjectValue")
		moduleValue.Name = "module"
		moduleValue.Value = module
		moduleValue.Parent = executor
	end

	actor.Parent = self._container or ACTOR_CONTAINER

	if ACTOR_CONTAINER.Parent == nil then
		ACTOR_CONTAINER.Parent = if IS_CLIENT then Players.LocalPlayer:WaitForChild("PlayerScripts") else ServerScriptService
	end

	return actor
end

--[=[
	An optional constructor that creates a new ParallelRequire object.

	:::tip
	You don't need to use the constructor to use the module. Only use the constructor if you need to use the `ParallelRequireConfig` parameter!
	:::

	@param config
]=]
function ParallelRequire.new(config: ParallelRequireConfig)
	return setmetatable({_executor = config.executor, _container = config._container}, ParallelRequire)
end

return ParallelRequire :: typeof(ParallelRequire) & (config: ParallelRequireConfig) -> (typeof(ParallelRequire.new({})))