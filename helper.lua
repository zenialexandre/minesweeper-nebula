local helper = {}

function helper:enum(input_table)
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

    meta_table.__newindex = function()
        error("Immutable enumerator")
    end

    return setmetatable(input_table, meta_table)
end

function helper:is_mouse_in_quadrant_of_texture(sprite, position, mouse_x, mouse_y)
    local quadrant_x = position.x + sprite.texture.width
    local quadrant_y = position.y + sprite.texture.height

    return mouse_x >= position.x and mouse_x < quadrant_x and mouse_y >= position.y and mouse_y < quadrant_y
end

return helper
