local Iter = require(script.Parent)

local ForKeys = Iter.ForKeys
local ForPairs = Iter.ForPairs
local ForValues = Iter.ForValues
local UnionFilter = Iter.UnionFilter
local ForAncestors = Iter.ForAncestors

local iterate = Iter.iterate
local getNext = Iter.getNext
local makeArray = Iter.makeArray
local filter = Iter.filter
local first = Iter.first

return function()
    local function runTest(label, test)
        print("--------------------------")
        print(`Test: {label}`)
        test()
    end

    runTest("iterate for values", function()
        iterate(ForValues({"a", "e", "i"}), print)
    end)

    runTest("iterate for keys", function()
        iterate(ForKeys({"a", "e", "i"}), print)
    end)

    runTest("iterate for pairs", function()
        iterate(ForPairs({first = "a", second = "e", third = "i"}), print)
    end)

    runTest("iterate for values conditional", function()
        local function inString(thing)
            return function(value)
                return string.find(value, thing)
            end
        end

        iterate(ForValues({"apple", "banana", "pie", "pizza", "juice"}), print, inString("a"))
    end)

    runTest("get next for values", function()
        print(getNext(ForValues({"a", "b", "c"})))
    end)

    runTest("round all values", function()
        local numbers = {0.1, 0.9, 0.5, 0, 1}
        print("floats:", numbers)
        print("integers:", makeArray(ForValues(numbers), math.round))
    end)

    runTest("get tagged with KillOnTouch", function()
        local children = workspace:GetChildren()

        local function HasTag(tag)
            return function(instance: Instance)
                return instance:HasTag(tag)
            end
        end

        print("children:", children)
        print(
            "KillOnTouch",
            makeArray(ForValues(children), nil, HasTag("KillOnTouch"))
        )
    end)

    runTest("get all unanchored parts in the workspace", function()
        local function InstanceIsA(className: string)
            return function(instance: Instance)
                return if instance:IsA(className) then instance else nil
            end
        end

        local function PropertyFilter(property, value)
            return function(instance)
                return if (instance[property] == value) then instance else nil
            end
        end

        -- Creates a table of all unanchored parts inside of the workspace
        local unanchoredParts = filter(
            workspace:GetChildren(),
            UnionFilter(InstanceIsA("BasePart"), PropertyFilter("Anchored", false))
        )

        print("unanchored parts:", unanchoredParts)
    end)

    runTest("print workspace from baseplate", function()
        print(first(ForAncestors(workspace:FindFirstChild("Baseplate")), function() return true end))
    end)
end