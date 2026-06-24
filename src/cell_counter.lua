local cell_counter = {}

function cell_counter:build()
    nebula.ecs.addComponent(
        nebula.ecs.spawn(),
        CellCounter({ is_fixed = true, value = 0 }),
        Color({ r = 1.0, g = 1.0, b = 1.0, a = 0.0 }),
        Sprite({ texture = EmptyCellTexture }),
        Position({ x = 40.0, y = 35.0 }),
        Fade({ is_active = false })
    )

    nebula.ecs.addComponent(
        nebula.ecs.spawn(),
        CellCounter({ is_fixed = false, value = 8 }),
        Color({ r = 1.0, g = 1.0, b = 1.0, a = 0.0 }),
        Sprite({ texture = EightCellTexture }),
        Position({ x = 70.0, y = 35.0 }),
        Fade({ is_active = false })
    )

    nebula.ecs.addComponent(
        nebula.ecs.spawn(),
        CellCounter({ is_fixed = false, value = 1 }),
        Color({ r = 1.0, g = 1.0, b = 1.0, a = 0.0 }),
        Sprite({ texture = OneCellTexture }),
        Position({ x = 100.0, y = 35.0 }),
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

function cell_counter:lookup()
    local entities = nebula.ecs.getEntitiesWith(CellCounter)
    local center_counter = nebula.ecs.getComponent(entities[1], CellCounter)
    local right_counter = nebula.ecs.getComponent(entities[2], CellCounter)

    local available_grid_cells = tostring(GameObserver.grid_tracker.available_grid_cells)

    if (GameObserver.grid_tracker.available_grid_cells > 9) then
        local as_array = {}

        for i = 1, #available_grid_cells do
            table.insert(as_array, tonumber(available_grid_cells:sub(i, i)))
        end

        center_counter.value = as_array[1]
        right_counter.value = as_array[2]
    else
        center_counter.value = 0
        right_counter.value = tonumber(available_grid_cells)
    end
end

function cell_counter:listener()
    for _, entity in pairs(nebula.ecs.getEntitiesWith(CellCounter)) do
        local cell_counter_component = nebula.ecs.getComponent(entity, CellCounter)

        if (not cell_counter_component.is_fixed) then
            local sprite = nebula.ecs.getComponent(entity, Sprite)
            sprite.texture = NumericalTextures[cell_counter_component.value]
        end
    end
end

return cell_counter
