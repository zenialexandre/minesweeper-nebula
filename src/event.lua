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
    if (GameObserver.state.running) then
        local mouse_x = nebula.mouse.getX()
        local mouse_y = nebula.mouse.getY()

        for _, entity in pairs(nebula.ecs.getEntitiesWith(Cell)) do
            local cell = nebula.ecs.getComponent(entity, Cell)
            local sprite = nebula.ecs.getComponent(entity, Sprite)
            local position = nebula.ecs.getComponent(entity, Position)
            local is_mouse_in_quadrant_of_cell = helper:is_mouse_in_quadrant_of_texture(sprite, position, mouse_x, mouse_y)

            event:handle_pressed(entity, cell, nil, sprite, is_mouse_in_quadrant_of_cell)
        end

        for _, entity in pairs(nebula.ecs.getEntitiesWith(Icon)) do
            local icon = nebula.ecs.getComponent(entity, Icon)
            local sprite = nebula.ecs.getComponent(entity, Sprite)
            local position = nebula.ecs.getComponent(entity, Position)
            local is_mouse_in_quadrant_of_icon = helper:is_mouse_in_quadrant_of_texture(sprite, position, mouse_x, mouse_y)

            event:handle_pressed(entity, nil, icon, sprite, is_mouse_in_quadrant_of_icon)
            event:handle_released(icon)
        end
    end
end

function event:handle_pressed(entity, cell, icon_component, sprite, is_mouse_in_quadrant)
    if (nebula.mouse.isPressed("left") or nebula.mouse.isPressed("right")) then
        if (cell ~= nil) then
            if (cell.is_available and is_mouse_in_quadrant) then
                local flag = nebula.ecs.getComponent(entity, Flag)

                if (nebula.mouse.isPressed("right")) then
                    if (flag.is_placed) then
                        flag.is_placed = false
                    else
                        flag.is_placed = true
                    end
                end

                if (nebula.mouse.isPressed("left")) then
                    for _, icon_entity in pairs(nebula.ecs.getEntitiesWith(Icon)) do
                        local temp_icon = nebula.ecs.getComponent(icon_entity, Icon)
                        temp_icon.type = IconType.WOW
                    end

                    cell.is_available = false
                    GameObserver.grid_tracker.available_grid_cells = GameObserver.grid_tracker.available_grid_cells - 1

                    if (flag.is_placed) then
                        flag.is_placed = false
                    end

                    if (GameObserver.grid_tracker.available_grid_cells == 20 and CellType.MINE ~= cell.type) then
                        GameObserver.state.ended = true
                        GameObserver.state.won = true
                    end

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
                        GameObserver.state.won = false
                    end
                end
            end
        end

        if (icon_component ~= nil) then
            if (nebula.mouse.isPressed("left") and is_mouse_in_quadrant) then
                icon_component.is_pressed = true
            end
        end
    end
end

function event:handle_released(icon_component)
    if (nebula.mouse.isReleased("left")) then
        if (icon_component.is_pressed) then
            icon_component.is_pressed = false
            icon_component.type = IconType.SMILE

            grid:reset()
            icon:reset()
            timer:reset()
            cell_counter:reset()

            for _, entity in pairs(nebula.ecs.getEntitiesWith(Text)) do
                nebula.ecs.despawn(entity)
            end

            GameObserver.state.ended = false
            GameObserver.state.won = false
            GameObserver.state.running = true
            GameObserver.state.started = true
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

            if (GameObserver.state.won) then
                icon.type = IconType.YEAH

                nebula.ecs.addComponent(
                    nebula.ecs.spawn(),
                    Text({
                        font = nebula.graphics.newFont("resources/fonts/RobotoMono-Italic.ttf", 15.0),
                        value = "choose life lil bro",
                    }),
                    Position({ x = 110.0, y = 100.0 }),
                    Color({ r = 1.0, g = 1.0, b = 1.0, a = 1.0 }),
                    Fade({ is_active = false })
                )
            else
                icon.type = IconType.SAD
            end
        end
    end
end

return event
