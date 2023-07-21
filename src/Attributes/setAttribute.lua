--[=[
    Sets an instance's attribute to the specified value.
    @within Attributes

    ```lua
    -- For this example, we'll use our local player
    local localPlayer = game:GetService("Players").LocalPlayer

    -- Set the 'Level' attribute to 7
    Attributes.setAttribute(localPlayer, "Level", 7)
    -- Get the 'Level' attribute
    local level = Attributes.getAttribute(localPlayer, "Level")

    -- Print to test if it worked!
    print(level)

    Output: 7
    ```
]=]
local function setAttribute(instance: Instance, attribute: string, value: any)
    instance:SetAttribute(attribute, value)
end

return setAttribute