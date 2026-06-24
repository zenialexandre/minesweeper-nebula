local fx = {}

function fx:fade_out(entities, delta, fade_speed)
    for _, entity in pairs(entities) do
        local color = nebula.ecs.getComponent(entity, Color)
        color.a = color.a - fade_speed * delta

        if (color.a <= 0.0) then
            return true
        end
    end

    return false
end

function fx:fade_in(entities, delta, fade_speed)
    for _, entity in pairs(entities) do
        local color = nebula.ecs.getComponent(entity, Color)
        color.a = color.a + fade_speed * delta

        if (color.a >= 1.0) then
            return true
        end
    end

    return false
end

function fx:set_fading_state(entities, is_active)
    for _, entity in pairs(entities) do
        local fade = nebula.ecs.getComponent(entity, Fade)
        fade.is_active = is_active
    end
end

function fx:is_any_fading(entities)
    for _, entity in pairs(entities) do
        local fade = nebula.ecs.getComponent(entity, Fade)

        if (fade.is_active) then
            return true
        end
    end

    return false
end

return fx
