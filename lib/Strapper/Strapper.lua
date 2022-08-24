---	@class Strapper
---	Strapper is a module for mass requiring modules.
local Strapper = {}

--- @within Strapper
export type BeforeRequireCallback = (moduleScript: ModuleScript) -> (boolean | BeforeRequireCallback | nil)

--- @within Strapper
export type AfterRequireCallback = (moduleScript: ModuleScript, module: any) -> ()

--- @within Strapper
export type LoadParams = {
    beforeRequire: BeforeRequireCallback?,
    afterRequire: AfterRequireCallback?
}

--- @prop Silence
--- @within Strapper
--- A blank function
Strapper.Silence = function(_, _) end

--- @prop Loud
--- @within Strapper
--- Prints to the output
Strapper.Loud = function(_, _) end

--- @ignore
--- @private
Strapper._loudBeforeRequireCallback = function(moduleScript, _)
    print("[Strapper]: Requiring", moduleScript, "...")
end

--- @ignore
--- @private
Strapper._loudAfterRequireCallback = function(_)
    print("[Strapper]: ↑ Success!")
end

--[=[
	@param modules table -- A table of all the modules
    @param params LoadParams -- Parameters describing how the modules should be loaded

    Requires all of the modules in a provided table.
    If a BeforeRequireCallback returns `false`, the module will be skipped.

	```lua
	local Strapper = require(Packages.Strapper)

    local modules = somewhere.Modules:GetChildren()

    Strapper:LoadModules(modules, {
        beforeRequire = function(moduleScript)
            if moduleScript:GetAttribute("DontRequire") then
                print("[Strapper]: Skipped", moduleScript)
                return false
            else
                return Strapper.Loud
            end
        end,

        afterRequire = Strapper.Loud
    })

    print("All modules loaded!")
	```
]=]
function Strapper:LoadModules(modules: {ModuleScript}, params: LoadParams?)
    params = params or {
        beforeRequire = Strapper.Loud,
        afterRequire = Strapper.Silence
    }

    local beforeRequire = params.beforeRequire
    local afterRequire = params.afterRequire

    if beforeRequire == self.Loud then
        beforeRequire = self._loudBeforeRequireCallback
    end

    if afterRequire == self.Loud then
        afterRequire = self._loudAfterRequireCallback
    end

    local results = {}
    for _, moduleScript in modules do
        if not moduleScript:IsA("ModuleScript") then
            continue
        end

        if beforeRequire then
            local result = beforeRequire(moduleScript)

            if result == false then
                continue
            elseif typeof(result) == "function" then
                if result == self.Loud then
                    self._loudBeforeRequireCallback(moduleScript)
                else
                    result(moduleScript)
                end
            else
                error("BeforeRequireCallback returned an unaccepted value")
            end
        end

        local module = require(moduleScript)
        results[moduleScript] = module

        if afterRequire then
            afterRequire(moduleScript, module)
        end
    end
    return results
end

return Strapper