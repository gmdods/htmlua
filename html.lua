HTML = {}

HTML.Mt = {}

local elements = {"div", "p", "a"}

for _, v in ipairs(elements) do
	HTML[v] = function(t)
		return setmetatable({ tag = v, inner = t }, HTML.Mt)
	end
end

function HTML.Mt.__tostring(t)
	local out = ""
	out = out .. "<" .. t.tag
	for k, v in pairs(t.inner) do
		if type(k) == "string" then
			out = out .. " " .. k .. "=\"" .. tostring(v) .. "\""
		end
	end
	out = out .. ">"
	for _, v in ipairs(t.inner) do
		out = out .. tostring(v)
	end
	out = out .. "</" .. t.tag .. ">"
	return out
end

return HTML
