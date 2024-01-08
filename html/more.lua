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
---@param t table
---@return function | nil
---@return table | nil
---@return integer | nil
function table.sortedkeys(t)
	local keys = {}
	for k, _ in pairs(t) do
		if type(k) == "string" then
			table.insert(keys, k)
		end
	end
	table.sort(keys)
	return iterator, { keys = keys, table = t }, 0
end
