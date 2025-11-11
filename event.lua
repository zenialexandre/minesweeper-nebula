local event = {}

function event:handle_player_start(delta)
    if (nebula.keyboard.isKeyPressed("enter") or GameObserver.menu_tracker.fading_text) then
        local fade_speed = 15.0
        GameObserver.menu_tracker.fading_text = true

        for _, entity in pairs(nebula.ecs.getEntitiesWith(Text)) do
            local color = nebula.ecs.getComponent(entity, Color)
            color.r = color.r - fade_speed * delta
            color.g = color.g - fade_speed * delta
            color.b = color.b - fade_speed * delta

            print("delta " .. delta)
            print("r " .. color.r)
            print("g " .. color.g)
            print("b " .. color.b)

            if (color.r <= 0.0 and color.g <= 0.0 and color.b <= 0.0) then
                GameObserver.menu_tracker.fading_text = false
            end
        end
    end
end

function event:handle_game_started()
    if (GameObserver.state.started) then
        for _, entity in pairs(nebula.ecs.getEntitiesWith(Text)) do
            nebula.ecs.despawn(entity)
        end

        grid:build()
    end
end

function event:handle_mouse_click()
    if (nebula.mouse.isPressed("left")) then
        local entities = nebula.ecs.getEntitiesWith(Cell)
        local mouse_x = nebula.mouse.getX()
        local mouse_y = nebula.mouse.getY()

        for _, entity in pairs(entities) do
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

function event:handle_game_ended()
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
    end
end

return event
