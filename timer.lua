local timer = {}

function timer:build()
    nebula.ecs.addComponent(
        nebula.ecs.spawn(),
        Timer({ count = 0 }),
        Color({ r = 1.0, g = 1.0, b = 1.0, a = 0.0 }),
        Sprite({ texture = ZeroCellTexture }),
        Position({ x = 350.0, y = 20.0 }),
        Fade({ is_active = false })
    )

    nebula.ecs.addComponent(
        nebula.ecs.spawn(),
        Timer({ count = 0 }),
        Color({ r = 1.0, g = 1.0, b = 1.0, a = 0.0 }),
        Sprite({ texture = ZeroCellTexture }),
        Position({ x = 390.0, y = 20.0 }),
        Fade({ is_active = false })
    )

    nebula.ecs.addComponent(
        nebula.ecs.spawn(),
        Timer({ count = 0 }),
        Color({ r = 1.0, g = 1.0, b = 1.0, a = 0.0 }),
        Sprite({ texture = ZeroCellTexture }),
        Position({ x = 430.0, y = 20.0 }),
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

        if (timer_component.count == 0) then
            sprite.texture = ZeroCellTexture
        elseif (timer_component.count == 1) then
            sprite.texture = OneCellTexture
        elseif (timer_component.count == 2) then
            sprite.texture = TwoCellTexture
        elseif (timer_component.count == 3) then
            sprite.texture = ThreeCellTexture
        elseif (timer_component.count == 4) then
            sprite.texture = FourCellTexture
        elseif (timer_component.count == 5) then
            sprite.texture = FiveCellTexture
        elseif (timer_component.count == 6) then
            sprite.texture = SixCellTexture
        elseif (timer_component.count == 7) then
            sprite.texture = SevenCellTexture
        elseif (timer_component.count == 8) then
            sprite.texture = EightCellTexture
        elseif (timer_component.count == 9) then
            sprite.texture = NineCellTexture
        end
    end
end

return timer
