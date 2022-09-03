export type StrapperRequireMethod = (ModuleScript) -> (any)
export type LoadParams = {require: StrapperRequireMethod?, moduleReturnType: typeof(newproxy(true))}
export type StrapperConfig = {defaultLoadParams: LoadParams?}

local EMPTY_TABLE = {}

--[=[
    @class Strapper

    A powerful module that assists with requiring other modules.

    ```lua
    -- A complex implementation can look like this!

    local Strapper = require(Somewhere.Strapper)

    local strapper = Strapper.new {
        require = function(moduleScript)
            if CollectionService:HasTag(moduleScript, "DontRequire") then
                return Strapper.silence
            end

            print("Requiring", moduleScript, "...")
            local module = require(moduleScript)
            print("\tRequired", moduleScript)
            if module.OnInit then
                print("Initalizing", moduleScript, "...")
                module:OnInit()
                print("\tInitalized", moduleScript)
            end
            return module
        end)

        andThen = function(moduleScript, module)
            if module.OnStart then
                print("Starting", moduleScript)
                module:OnStart()
                print("\tStarted", moduleScript)
            end
        end
    }

    local modules = strapper:LoadModules({
        Somewhere.Modules:GetChildren(),
        Somewhere.MoreModules:GetChildren()
    })

    print("Loaded modules!", modules)
    ```

    ```lua
    -- Or a more simple implementation...

    local Strapper = require(Somewhere.Strapper)

    local strapper = Strapper.new()

    local modules = strapper:LoadModules({
        Somewhere.Modules:GetChildren(),
        Somewhere.MoreModules:GetChildren()
    })

    print("Loaded modules!", modules)
    ```
]=]
local Strapper = {}
Strapper.__index = Strapper

--- @type LoadParams {require: (ModuleScript) -> (any)?, moduleReturnType: typeof(newproxy(true))}
--- @within Strapper
--- Parameters that decide how modules should be loaded.

--- @type StrapperConfig {defaultLoadParams: LoadParams?}
--- @within Strapper
--- Parameters that decide how modules should be loaded.

--[=[
    @prop requireMethods table
    @within Strapper

    A table of basic require functions. If you don't need to write your own, you can use these:

    `quietSuccess` - Only prints that the module was required.

    `loud` - Prints that the module was required, then prints again when the require was successful.

    ```lua
    quietSuccess = function(module: ModuleScript)
        print("Requiring", module, "at", module:GetFullName())
        return require(module)
    end,

    loud = function(module: ModuleScript)
        print("Requiring", module, "at", module:GetFullName(), "...")
        local result = require(module)
        print("\tRequired", module)
        return result
    end,
    ```
]=]

Strapper.requireMethods = {
	quietSuccess = function(module: ModuleScript)
		print("Requiring", module, "at", module:GetFullName())
		return require(module)
	end,

	loud = function(module: ModuleScript)
		print("Requiring", module, "at", module:GetFullName(), "...")
		local result = require(module)
		print("\tRequired", module)
		return result
	end,
}

Strapper.moduleReturnTypes = {
	moduleDictionary = newproxy(true),
	moduleTable = newproxy(true)
}

--[=[
    @prop silence userdata
    @within Strapper

    A `StrapperRequireMethod` response that will output nothing.

    ```lua
    local CollectionService = game:GetService("CollectionService")

    local Strapper = require(Somewhere.Strapper)

    local strapper = Strapper.new {
        defaultLoadParams = {
            require = function(moduleScript)
                if CollectionService:HasTag(moduleScript, "Disabled") then
                    return Strapper.silence
                end
                return require(moduleScript)
            end
        }
    }
    ```

    :::caution
    If a `StrapperRequireMethod` returns nil, a warning will be printed to the console. Return `Strapper.silence` instead!
    :::
]=]
Strapper.silence = newproxy(true)

--[=[
    Mass requires the modules in a table. Any table items that aren't `ModuleScripts` will be skipped.

    @param modules -- A table of modules
    @param params -- Optional LoadParams

    ```lua
    -- Get the Strapper module
    local Strapper = require(Somewhere.Strapper)

    -- Construct a new strapper
    local strapper = Strapper.new()

    -- Require all ModuleScripts that are children of the 'Modules' folder
    local modules = strapper:LoadModules(ReplicatedStorage.Modules:GetChildren(), {
        require = Strapper.requireMethods.quietSuccess -- This will only print to the output that the module is being required
    })

    -- Print the dictionary of required modules
    print(modules)
    ```
]=]
function Strapper:LoadModules(modules: {Instance}, params: LoadParams?): {[ModuleScript]: any} | {ModuleScript}
	local loadParams = params or self._loadParams
	local Require = loadParams.require or require
	local ReturnType = loadParams.moduleReturnType or self.moduleReturnTypes.moduleDictionary

	local requiredModules = {}

	for _, module in modules do
		if typeof(module) == "table" then
			self:LoadModules(module, params)
			continue
		end

		if module:IsA("ModuleScript") then
			local result = Require(module)

			if result == nil then
				warn("Require did not return a value")
				continue
			end

			if result == self.silence then
				continue
			end

			if ReturnType == self.moduleReturnTypes.moduleDictionary then
				requiredModules[module] = result
			else
				table.insert(requiredModules, result)
			end
		end
	end

	if params.andThen then
		for i, v in requiredModules do
			params.andThen(i, v)
		end
	end

	return requiredModules
end

--[=[
    Constructs a new Strapper object, with the optional `config` arugment.
]=]
function Strapper.new(config: StrapperConfig?)
	config = config or EMPTY_TABLE

	local self = setmetatable({}, Strapper)

	self._loadParams = config.defaultLoadParams

	return self
end

return Strapper