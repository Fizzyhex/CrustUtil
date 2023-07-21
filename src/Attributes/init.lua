--- A wrapper for Roblox attributes that allows you to create Prefabs.
--- @class Attributes
local Attributes = {
	patchAttributes = require(script.patchAttributes),
    setAttribute = require(script.setAttribute),
	getAttribute = require(script.getAttribute),
	allAttributes = require(script.allAttributes),
    NIL = require(script.Symbols).NIL
}

return Attributes