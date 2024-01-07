HTML = {}

HTML.Mt = {}
HTML.attrs = {}

function table.merge(t1, t2)
	for k, v in pairs(t2) do
		t1[k] = v
	end
	return t1
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

local function sortedkeys(t)
	local keys = {}
	for k, _ in pairs(t) do
		if type(k) == "string" then
			table.insert(keys, k)
		end
	end
	table.sort(keys)
	return ipairs(keys)
end

function HTML.Mt.__tostring(elt)
	local t = { "<", elt.tag }
	local attrs = HTML.attrs[elt.tag]
	for _, k in sortedkeys(elt.inner) do
		local v = elt.inner[k]
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
