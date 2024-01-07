HTML = {}

HTML.Mt = {}

local elements = { "div", "p", "a", "button" }

for _, v in ipairs(elements) do
	HTML[v] = function(tbl)
		return setmetatable({ tag = v, inner = tbl }, HTML.Mt)
	end
end


local function css(s)
	local t = {}
	for property, value in pairs(s) do
		if type(property) == "string" then
			table.insert(t, property .. ": " .. value .. ";")
		end
	end
	return table.concat(t)
end

local function attribute(k, v)
	if type(v) == "boolean" then
		if v then return k else return "" end
	elseif type(v) == "table" then
		if k == "style" then
			return string.format("%s=%q", k, css(v))
		else
			return string.format("%s=%q", k, table.concat(v, " "))
		end
	else
		return string.format("%s=%q", k, tostring(v))
	end
end

function HTML.Mt.__tostring(elt)
	local t = { "<", elt.tag }
	local keys = {}
	for k, _ in pairs(elt.inner) do
		if type(k) == "string" then
			table.insert(keys, k)
		end
	end
	table.sort(keys)
	for _, k in ipairs(keys) do
		table.insert(t, " " .. attribute(k, elt.inner[k]))
	end
	table.insert(t, ">")
	for _, v in ipairs(elt.inner) do
		table.insert(t, tostring(v))
	end
	table.insert(t, "</" .. elt.tag .. ">")
	return table.concat(t)
end

return HTML
