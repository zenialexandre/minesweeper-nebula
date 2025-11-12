local event = {}

function event:player_start(delta)
    local entities = nebula.ecs.getEntitiesWith(Text)

    if ((nebula.keyboard.isKeyPressed("enter") or fx:is_any_fading(entities)) and not GameObserver.state.running) then
        local fade_speed = 0.5
        fx:set_fading_state(entities, true)

        if (fx:fade_out(entities, delta, fade_speed)) then
            fx:set_fading_state(entities, true)
            GameObserver.state.started = true
        end
    end
end

function event:game_started(delta)
    if (GameObserver.state.started and not GameObserver.state.running) then
        local fade_speed = 0.5

        for _, entity in pairs(nebula.ecs.getEntitiesWith(Text)) do
            nebula.ecs.despawn(entity)
        end
        
        if (fx:fade_in(nebula.ecs.getEntitiesWith(Cell), delta, fade_speed)) then
            GameObserver.state.running = true
        end
    end
end

function event:mouse_click()
    if (nebula.mouse.isPressed("left") and GameObserver.state.running) then
        local mouse_x = nebula.mouse.getX()
        local mouse_y = nebula.mouse.getY()

        for _, entity in pairs(nebula.ecs.getEntitiesWith(Cell)) do
            local sprite = nebula.ecs.getComponent(entity, Sprite)
            local position = nebula.ecs.getComponent(entity, Position)
            local cell = nebula.ecs.getComponent(entity, Cell)

            local quadrant_x = position.x + sprite.texture.width
            local quadrant_y = position.y + sprite.texture.height

            local is_mouse_in_quadrant_x = mouse_x >= position.x and mouse_x < quadrant_x
            local is_mouse_in_quadrant_y = mouse_y >= position.y and mouse_y < quadrant_y

            if (cell.is_available and is_mouse_in_quadrant_x and is_mouse_in_quadrant_y) then
                cell.is_available = false

                if (CellType.BLANK == cell.type) then
                    sprite.texture = BlankCellTexture
                    grid:reveal_surrounding_cells(cell.row_index, cell.column_index)
                elseif (CellType.NUMERICAL == cell.type) then
                    grid:numerical_sprite(sprite, cell.row_index, cell.column_index)
                else
                    GameObserver.state.ended = true
                end
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
            end
        end

        GameObserver.state.ended = false
    end
end

return event
