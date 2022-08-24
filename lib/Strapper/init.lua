export type BeforeRequireCallback = (moduleScript: ModuleScript) -> (boolean | BeforeRequireCallback | nil)
export type AfterRequireCallback = (moduleScript: ModuleScript, module: any) -> ()
export type LoadParams = {
    beforeRequire: BeforeRequireCallback?,
    afterRequire: AfterRequireCallback?
}

--- @class Strapper
--- A module that assists with requiring other modules.
local Strapper = {}

--- @type BeforeRequireCallback (moduleScript: ModuleScript) -> (boolean | BeforeRequireCallback | nil)
--- @within Strapper
--- The callback that will be called before a module is required.
--- If a `BeforeRequireCallback` returns `false`, then the module will be skipped.

--- @type AfterRequireCallback (moduleScript: ModuleScript, module: any) -> ()
--- @within Strapper
--- The callback that will be called after a module is successfully required.

--- @type LoadParams {beforeRequire: BeforeRequireCallback?, afterRequire: AfterRequireCallback?}
--- @within Strapper

--- @prop Silence function
--- @within Strapper
--- A callback that does nothing.
Strapper.Silence = function(_, _) end

--- @prop Loud function
--- @within Strapper
--- A callback that will output details about the require.
Strapper.Loud = function(_, _) end

--- @ignore
--- @private
--- @within Strapper
--- @prop _loudBeforeRequireCallback function
Strapper._loudBeforeRequireCallback = function(moduleScript, _)
    print("[Strapper]: Requiring", moduleScript, "...")
end

--- @ignore
--- @private
--- @within Strapper
--- @prop _loudBeforeRequireCallback function
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