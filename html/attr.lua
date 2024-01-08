Attr = {}

require "html.more"

local regular = {
	id = "string",
	title = "string",
	hidden = "boolean",
	class = "table",
	style = "table"
}

Attr.elements = {
	div = regular,
	span = regular,
	p = regular,
	a = table.merge({ href = "string" }, regular),
	button = table.merge({ onclick = "string" }, regular)
}

---Stringifies table as a stylesheet
---@param styletable table
---@return string
local function css(styletable)
	local t = {}
	for property, value in pairs(styletable) do
		if type(property) == "string" then
			table.insert(t, property .. ": " .. value .. ";")
		end
	end
	return table.concat(t)
end

---Stringifies key-value pair as an attribute
---@param key string
---@param val any
---@return string
function Attr.attribute(key, val)
	if type(val) == "boolean" then
		if val then return key else return "" end
	elseif type(val) == "table" then
		if key == "style" then
			return string.format("%s=%q", key, css(val))
		else
			return string.format("%s=%q", key, table.concat(val, " "))
		end
	else
		return string.format("%s=%q", key, tostring(val))
	end
end

return Attr
