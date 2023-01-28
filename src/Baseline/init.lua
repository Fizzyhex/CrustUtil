local function GetName(subject: string | Instance)
	return if typeof(subject) == "string" then subject else subject.Name
end

--[=[
	@class Baseline

	A powerfully simple module loading library.

	```lua
	--- Require baseline!
	local Baseline = require(somewhere.Baseline)

	local function ControllerFilter(moduleScript: ModuleScript)
		return moduleScript.Name:match("Controller$") ~= nil
	end

	-- Find all ModuleScripts inside of the 'Modules' folder.
	-- Then, we'll filter through them to only get ModuleScripts that have names
	-- ending with 'Controller'.
	local controllers = Baseline.FilterForModuleScripts(
		ReplicatedStorage.Modules:GetDescendants(),
		ControllerFilter
	)

	-- Require the controllers.
	controllers = Baseline.RequireModuleScripts(
		controllers,
		"Requiring controller %s"
	)

	-- For every controller module, we'll call module:OnInit() if it's present.
	Baseline.CallAll(controllers, "OnInit", "Calling {moduleName}.{method}")
	-- Similar to CallAll, but this time we'll wrap the call in a spawn so that it
	-- doesn't yield.
	Baseline.SpawnAll(controllers, "OnStart")

	print("All controllers initalized/started!", controllers)
	```
]=]
local Baseline = {}
Baseline.__index = Baseline

-- Returns an array of all of the ModuleScripts inside of a table.
function Baseline.FilterForModuleScripts(children: {Instance}, filter: (ModuleScript) -> (boolean))
	local moduleScripts = {}

	for _, child in children do
		if child:IsA("ModuleScript") == false or (filter and filter(child) ~= true) then
			continue
		end
		table.insert(moduleScripts, child)
	end

	return moduleScripts
end

function Baseline.FilterChildren(children: {Instance}, filter: (ModuleScript) -> (boolean))
	local result = {}

	for _, child in children do
		if filter(child) then
			table.insert(result, child)
		end
	end

	return result
end

--[=[

	Requires all module scripts inside of the table. Any instances that are not ModuleScripts will be ignored.

	@param modules -- Dictionary/table of modules
	@param requireMessageOrLogger -- Optional message to print/function to call before calling the method
	@return table -- Returns a dictionary of ModuleScripts and their returned values

	```lua
	local Baseline = require(somewhere.Baseline)

	local components = Baseline.RequireModuleScripts(
		ReplicatedStorage.Components,
		"Loading component %s"
	)
	```
]=]
function Baseline.RequireModuleScripts(modules: {ModuleScript}, requireMessageOrLogger: ((ModuleScript) -> () | string | {["__call"]: (ModuleScript) -> ()})?)
	local requireMessage = if typeof(requireMessageOrLogger) == "string" then requireMessageOrLogger else nil
	local logger =
		if typeof(requireMessageOrLogger) == "function"
		or (typeof(requireMessageOrLogger) == "table" and getmetatable(requireMessageOrLogger).__call)
		then requireMessageOrLogger
		else nil

	assert(
		requireMessageOrLogger == nil or requireMessage or logger,
		"Expected function or string type at argument 2, got " .. typeof(requireMessageOrLogger)
	)

	local moduleScripts = {}

	for _, module in modules do
		if not module:IsA("ModuleScript") then
			continue
		end

		if requireMessage then
			print(requireMessage:format(module:GetFullName()))
		elseif logger then
			logger(module)
		end

		moduleScripts[module] = require(module)
	end

	return moduleScripts
end

--[=[
	Calls a specific method on all of the modules.

	@param modules -- Dictionary/table of modules
	@param method -- Method to call
	@param callMessage -- Optional message to print before calling the method
]=]
function Baseline.CallAll(modules: {any: any}, method: string, callMessage: string?)
	for moduleScript, module in modules do
		if not module[method] then
			continue
		end

		if callMessage then
			local formattedCallMessage = callMessage
				:gsub("{moduleName}", GetName(moduleScript))
				:gsub("{moduleFullName}", moduleScript:GetFullName())
				:gsub("{method}", tostring(method))

			print(formattedCallMessage)
		end

		debug.setmemorycategory(GetName(moduleScript))
		module[method](module)
	end

	debug.resetmemorycategory()
end

--[=[
	Similar to `CallAll`, but the method calls will be wrapped in `task.spawn`.

	@param modules -- Dictionary/table of modules
	@param method -- Method to call
]=]
function Baseline.SpawnAll(modules: {any: any}, method: string)
	for moduleScript, module in modules do
		if module[method] then
			debug.setmemorycategory(GetName(moduleScript))
			task.spawn(module[method], module)
		end
	end
end

return Baseline