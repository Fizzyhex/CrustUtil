local component = require(script.Parent)

if component.Tag ~= component.Name then
	error("Component " .. component.Name .. " has a different tag to its module name!")
end