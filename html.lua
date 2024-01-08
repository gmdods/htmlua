HTML = {}

---@class HTML.Elt
---@field tag string
---@field inner table
---
HTML.Elt = {}
HTML.Elt.__index = HTML.Elt

HTML.attrs = {}

---Edit table t1 in contain all keys of t2.
---This function returns the given table t1.
---Usually t1 is a literal table.
---@param t1 table
---@param t2 table
---@return table
function table.merge(t1, t2)
	for k, v in pairs(t2) do
		t1[k] = v
	end
	return t1
end

---This is the iterator for the `sortedkeys` function.
local function iterator(ref, i)
	i = i + 1
	local k = ref.keys[i]
	if k then
		return i, k, ref.table[k]
	end
end

---An iterator of a table with the keys in order.
local function sortedkeys(t)
	local keys = {}
	for k, _ in pairs(t) do
		if type(k) == "string" then
			table.insert(keys, k)
		end
	end
	table.sort(keys)
	return iterator, { keys = keys, table = t }, 0
end

local regular = {
	id = "string",
	title = "string",
	hidden = "boolean",
	class = "table",
	style = "table"
}

local elements = {
	div = regular,
	p = regular,
	a = table.merge({ href = "string" }, regular),
	button = table.merge({ onclick = "string" }, regular)
}

for v, t in pairs(elements) do
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
local function attribute(key, val)
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

---Stringifies HTML element
---TODO: HTML escape
---@param elt HTML.Elt
---@return string
function HTML.Elt.__tostring(elt)
	local t = { "<", elt.tag }
	local attrs = elt:attrs()
	for _, k, v in sortedkeys(elt.inner) do
		assert(attrs[k], "attribute name: " .. k)
		assert(type(v) == attrs[k], "attribute type: " .. k)
		table.insert(t, " " .. attribute(k, v))
	end
	table.insert(t, ">")
	for _, v in ipairs(elt.inner) do
		table.insert(t, tostring(v))
	end
	table.insert(t, "</" .. elt.tag .. ">")
	return table.concat(t)
end

return HTML
