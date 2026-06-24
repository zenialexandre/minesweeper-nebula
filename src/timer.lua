local timer = {}

function timer:build()
    nebula.ecs.addComponent(
        nebula.ecs.spawn(),
        Timer({ count = 0 }),
        Color({ r = 1.0, g = 1.0, b = 1.0, a = 0.0 }),
        Sprite({ texture = ZeroCellTexture }),
        Position({ x = 260.0, y = 35.0 }),
        Fade({ is_active = false })
    )

    nebula.ecs.addComponent(
        nebula.ecs.spawn(),
        Timer({ count = 0 }),
        Color({ r = 1.0, g = 1.0, b = 1.0, a = 0.0 }),
        Sprite({ texture = ZeroCellTexture }),
        Position({ x = 290.0, y = 35.0 }),
        Fade({ is_active = false })
    )

    nebula.ecs.addComponent(
        nebula.ecs.spawn(),
        Timer({ count = 0 }),
        Color({ r = 1.0, g = 1.0, b = 1.0, a = 0.0 }),
        Sprite({ texture = ZeroCellTexture }),
        Position({ x = 320.0, y = 35.0 }),
        Fade({ is_active = false })
    )
end

function timer:reset()
    for _, entity in pairs(nebula.ecs.getEntitiesWith(Timer)) do
        local timer_component = nebula.ecs.getComponent(entity, Timer)
        timer_component.count = 0
    end

    GameObserver.timer.elapsed = 0
    GameObserver.timer.seconds = 0
end

function timer:lookup(delta)
    if (GameObserver.state.running and not GameObserver.state.ended) then
        GameObserver.timer.elapsed = GameObserver.timer.elapsed + delta

        if (GameObserver.timer.elapsed >= 1) then
            GameObserver.timer.elapsed = GameObserver.timer.elapsed - 1
            GameObserver.timer.seconds = GameObserver.timer.seconds + 1

            local entities = nebula.ecs.getEntitiesWith(Timer)
            local left_timer = nebula.ecs.getComponent(entities[0], Timer)
            local center_timer = nebula.ecs.getComponent(entities[1], Timer)
            local right_timer = nebula.ecs.getComponent(entities[2], Timer)

            if (right_timer.count < 9) then
                right_timer.count = right_timer.count + 1
            elseif (right_timer.count == 9 and center_timer.count < 9) then
                right_timer.count = 0
                center_timer.count = center_timer.count + 1
            elseif (right_timer.count == 9 and center_timer.count == 9) then
                right_timer.count = 0
                center_timer.count = 0
                left_timer.count = left_timer.count + 1
            elseif (right_timer.count == 9 and center_timer.count == 9 and left_timer.count == 9) then
                right_timer.count = 0
                center_timer.count = 0
                left_timer.count = 0
            end
        end
    end
end

function timer:listener()
    for _, entity in pairs(nebula.ecs.getEntitiesWith(Timer)) do
        local timer_component = nebula.ecs.getComponent(entity, Timer)
        local sprite = nebula.ecs.getComponent(entity, Sprite)
        sprite.texture = NumericalTextures[timer_component.count]
    end
end

return timer
