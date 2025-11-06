function enum(input_table, is_immutable)
    local meta_table = {}

    function meta_table:random()
        local keys = {}

        for key in pairs(input_table) do
            table.insert(keys, key)
        end

        local random_key = keys[math.random(1, #keys)]
        return self[random_key]
    end

    meta_table.__index = function(_, key)
        if meta_table[key] ~= nil then
            return meta_table[key]
        end
        error("Invalid enumerator key: " .. tostring(key))
    end

    if (is_immutable) then
        meta_table.__newindex = function()
            error("Immutable enumerator")
        end
    end

    return setmetatable(input_table, meta_table)
end
