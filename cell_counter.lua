local cell_counter = {}

function cell_counter:build()
    nebula.ecs.addComponent(
        nebula.ecs.spawn(),
        Timer({ is_fixed = true, value = 0 }),
        Color({ r = 1.0, g = 1.0, b = 1.0, a = 0.0 }),
        Sprite({ texture = EmptyCellTexture }),
        Position({ x = 20.0, y = 20.0 }),
        Fade({ is_active = false })
    )

    nebula.ecs.addComponent(
        nebula.ecs.spawn(),
        CellCounter({ is_fixed = false, value = 8 }),
        Color({ r = 1.0, g = 1.0, b = 1.0, a = 0.0 }),
        Sprite({ texture = EightCellTexture }),
        Position({ x = 60.0, y = 20.0 }),
        Fade({ is_active = false })
    )

    nebula.ecs.addComponent(
        nebula.ecs.spawn(),
        CellCounter({ is_fixed = false, value = 1 }),
        Color({ r = 1.0, g = 1.0, b = 1.0, a = 0.0 }),
        Sprite({ texture = OneCellTexture }),
        Position({ x = 100.0, y = 20.0 }),
        Fade({ is_active = false })
    )
end

function cell_counter:reset()
    local entities = nebula.ecs.getEntitiesWith(CellCounter)
    local left_counter = nebula.ecs.getComponent(entities[0], CellCounter)
    local center_counter = nebula.ecs.getComponent(entities[1], CellCounter)
    local right_counter = nebula.ecs.getComponent(entities[2], CellCounter)

    left_counter.value = 0
    center_counter.value = 8
    right_counter.value = 1
end

function cell_counter:listener()
    for _, entity in pairs(nebula.ecs.getEntitiesWith(CellCounter)) do
        local cell_counter_component = nebula.ecs.getComponent(entity, CellCounter)
        local sprite = nebula.ecs.getComponent(entity, Sprite)

        if (cell_counter_component.is_fixed) then
            return
        end

        if (cell_counter_component.value == 0) then
            sprite.texture = ZeroCellTexture
        elseif (cell_counter_component.value == 1) then
            sprite.texture = OneCellTexture
        elseif (cell_counter_component.value == 2) then
            sprite.texture = TwoCellTexture
        elseif (cell_counter_component.value == 3) then
            sprite.texture = ThreeCellTexture
        elseif (cell_counter_component.value == 4) then
            sprite.texture = FourCellTexture
        elseif (cell_counter_component.value == 5) then
            sprite.texture = FiveCellTexture
        elseif (cell_counter_component.value == 6) then
            sprite.texture = SixCellTexture
        elseif (cell_counter_component.value == 7) then
            sprite.texture = SevenCellTexture
        elseif (cell_counter_component.value == 8) then
            sprite.texture = EightCellTexture
        elseif (cell_counter_component.value == 9) then
            sprite.texture = NineCellTexture
        end
    end
end

return cell_counter
