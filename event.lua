local event = {}

function event:player_start(delta)
    local entities = nebula.ecs.getEntitiesWith(Text)

    if ((nebula.keyboard.isKeyPressed("enter") or fx:is_any_fading(entities)) and not GameObserver.state.running) then
        local fade_speed = 0.5
        fx:set_fading_state(entities, true)

        if (fx:fade_out(entities, delta, fade_speed)) then
            fx:set_fading_state(entities, false)
            GameObserver.state.started = true
        end
    end
end

function event:game_started(delta)
    if (GameObserver.state.started and not GameObserver.state.running) then
        local fade_speed = 0.5
        local entities = nebula.ecs.getEntitiesWith(Cell)
        local icon_entities = nebula.ecs.getEntitiesWith(Icon)
        local timer_entities = nebula.ecs.getEntitiesWith(Timer)
        local cell_counter_entities = nebula.ecs.getEntitiesWith(CellCounter)

        for _, entity in pairs(icon_entities) do
            table.insert(entities, entity)
        end

        for _, entity in pairs(timer_entities) do
            table.insert(entities, entity)
        end

        for _, entity in pairs(cell_counter_entities) do
            table.insert(entities, entity)
        end

        for _, entity in pairs(nebula.ecs.getEntitiesWith(Text)) do
            nebula.ecs.despawn(entity)
        end

        if (fx:fade_in(entities, delta, fade_speed)) then
            GameObserver.state.running = true
        end
    end
end

function event:mouse_click()
    if ((nebula.mouse.isPressed("left") or nebula.mouse.isPressed("right")) and GameObserver.state.running) then
        local mouse_x = nebula.mouse.getX()
        local mouse_y = nebula.mouse.getY()

        for _, entity in pairs(nebula.ecs.getEntitiesWith(Cell)) do
            local sprite = nebula.ecs.getComponent(entity, Sprite)
            local position = nebula.ecs.getComponent(entity, Position)
            local cell = nebula.ecs.getComponent(entity, Cell)
            local is_mouse_in_quadrant_of_cell = helper:is_mouse_in_quadrant_of_texture(sprite, position, mouse_x, mouse_y)

            if (cell.is_available and is_mouse_in_quadrant_of_cell) then
                if (nebula.mouse.isPressed("right")) then
                    sprite.texture = FlagCellTexture
                    return
                end

                for _, icon_entity in pairs(nebula.ecs.getEntitiesWith(Icon)) do
                    local icon_component = nebula.ecs.getComponent(icon_entity, Icon)
                    icon_component.type = IconType.WOW
                end

                cell.is_available = false
                GameObserver.grid_tracker.available_grid_cells = GameObserver.grid_tracker.available_grid_cells - 1

                if (CellType.BLANK == cell.type) then
                    sprite.texture = BlankCellTexture
                    grid:reveal_surrounding_cells(cell.row_index, cell.column_index)
                elseif (CellType.NUMERICAL == cell.type) then
                    grid:numerical_sprite(sprite, cell.row_index, cell.column_index)
                else
                    sprite.texture = MineRedCellTexture
                    GameObserver.grid_tracker.end_game_mine_cell_row_index = cell.row_index
                    GameObserver.grid_tracker.end_game_mine_cell_column_index = cell.column_index
                    GameObserver.state.ended = true
                end
            end
        end

        for _, icon_entity in pairs(nebula.ecs.getEntitiesWith(Icon)) do
            local icon_component = nebula.ecs.getComponent(icon_entity, Icon)
            local sprite = nebula.ecs.getComponent(icon_entity, Sprite)
            local position = nebula.ecs.getComponent(icon_entity, Position)
            local is_mouse_in_quadrant_of_icon = helper:is_mouse_in_quadrant_of_texture(sprite, position, mouse_x, mouse_y)

            if (is_mouse_in_quadrant_of_icon) then
                icon_component.is_pressed = true
            end
        end
    end

    if (nebula.mouse.isReleased("left") and GameObserver.state.running) then
        for _, entity in pairs(nebula.ecs.getEntitiesWith(Icon)) do
            local icon_component = nebula.ecs.getComponent(entity, Icon)

            if (icon_component.is_pressed) then
                icon_component.is_pressed = false
                icon_component.type = IconType.SMILE

                grid:reset()
                icon:reset()
                timer:reset()
                cell_counter:reset()

                GameObserver.state.ended = false
                GameObserver.state.running = true
                GameObserver.state.started = true
            end
        end
    end
end

function event:game_ended()
    if (GameObserver.state.ended) then
        for _, entity in pairs(nebula.ecs.getEntitiesWith(Cell)) do
            local cell = nebula.ecs.getComponent(entity, Cell)
            local sprite = nebula.ecs.getComponent(entity, Sprite)

            if (CellType.BLANK == cell.type) then
                sprite.texture = BlankCellTexture
            elseif (CellType.NUMERICAL == cell.type) then
                grid:numerical_sprite(sprite, cell.row_index, cell.column_index)
            else
                sprite.texture = MineCellTexture

                if (
                        cell.row_index == GameObserver.grid_tracker.end_game_mine_cell_row_index and
                        cell.column_index == GameObserver.grid_tracker.end_game_mine_cell_column_index
                    ) then
                    sprite.texture = MineRedCellTexture
                end
            end
        end

        GameObserver.grid_tracker.available_grid_cells = 0

        for _, entity in pairs(nebula.ecs.getEntitiesWith(Icon)) do
            local icon = nebula.ecs.getComponent(entity, Icon)
            icon.type = IconType.SAD
        end
    end
end

return event
