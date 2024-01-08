HTML = {}

local attr = require "html.attr"
require "html.more"

---@class HTML.Elt
---@field tag string
---@field inner table
---
HTML.Elt = {}
HTML.Elt.__index = HTML.Elt

HTML.attrs = {}

for v, t in pairs(attr.elements) do
	HTML.attrs[v] = t
	HTML[v] = function(tbl)
		return setmetatable({ tag = v, inner = tbl }, HTML.Elt)
	end
end

---Returns the list of valid attributes
---@return table
function HTML.Elt:attrs()
	return HTML.attrs[self.tag]
end

---Stringifies HTML element
---TODO: HTML escape
---@param elt HTML.Elt
---@return string
function HTML.Elt.__tostring(elt)
	local t = { "<", elt.tag }
	local attrs = elt:attrs()
	for _, k, v in table.sortedkeys(elt.inner) do
		assert(attrs[k], "attribute name: " .. k)
		assert(type(v) == attrs[k], "attribute type: " .. k)
		table.insert(t, " " .. attr.attribute(k, v))
	end
	table.insert(t, ">")
	for _, v in ipairs(elt.inner) do
		table.insert(t, tostring(v))
	end
	table.insert(t, "</" .. elt.tag .. ">")
	return table.concat(t)
end

return HTML
