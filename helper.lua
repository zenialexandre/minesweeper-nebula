function enum(table)
    return setmetatable(table, {
        __index = function(_, key)
            error("Invalid enumerator key: " .. tostring(key))
        end,
        __newindex = function()
            error("Immutable enumarator.")
        end
    })
end
