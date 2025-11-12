local grid = {}

function grid:build()
    local mutable_position = Position({x = 6, y = 10})
    local number_of_blanks = 0
    local number_of_mines = 0
    local number_of_rows = 9
    local number_of_columns = 9

    for i = 1, number_of_rows do
        GameObserver.grid_tracker.matrix[i] = {}
        mutable_position.x = 6

        if (i ~= 1) then
            mutable_position.y = mutable_position.y + 55
        end

        for j = 1, number_of_columns do
            local cell = nebula.ecs.spawn()
            local position = mutable_position
            local cell_type = CellType:random()

            if (CellType.MINE == cell_type and number_of_mines == GameObserver.grid_tracker.available_mine_grid_cells) then cell_type = CellType.NUMERICAL end
            if (CellType.BLANK == cell_type and number_of_blanks == GameObserver.grid_tracker.available_blank_grid_cells) then cell_type = CellType.NUMERICAL end

            if (CellType.BLANK == cell_type) then number_of_blanks = number_of_blanks + 1 end
            if (CellType.MINE == cell_type) then number_of_mines = number_of_mines + 1 end

            if (j ~= 1) then
                position = Position({x = mutable_position.x + 56, y = mutable_position.y})
                mutable_position.x = position.x
            end

            nebula.ecs.addComponent(
                cell,
                position,
                Sprite({texture = CellTexture}),
                Color({r = 1.0, g = 1.0, b = 1.0, a = 0.0}),
                Cell({type = cell_type, is_available = true, row_index = i, column_index = j})
            )
            GameObserver.grid_tracker.matrix[i][j] = cell
        end
    end
end

function grid:get_surrounding_cells(row_index, column_index)
    local surrounding_cells = {}
    local directions = {
        {-1, -1}, {-1, 0}, {-1, 1},
        {0, -1},           {0, 1},
        {1, -1},  {1, 0},  {1, 1}
    }

    for _, direction in ipairs(directions) do
        local i = row_index + direction[1] -- Index starts at 1
        local j = column_index + direction[2]

        if (GameObserver.grid_tracker.matrix[i] and GameObserver.grid_tracker.matrix[i][j]) then -- Preventing nil rows and columns
            table.insert(surrounding_cells, GameObserver.grid_tracker.matrix[i][j])
        end
    end

    return surrounding_cells
end

function grid:reveal_surrounding_cells(row_index, column_index)
    local surrounding_cells = grid:get_surrounding_cells(row_index, column_index)

    for _, entity in pairs(surrounding_cells) do
        local cell = nebula.ecs.getComponent(entity, Cell)
        local sprite = nebula.ecs.getComponent(entity, Sprite)

        if (cell.is_available) then
            cell.is_available = false

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

function grid:numerical_sprite(cell_sprite, row_index, column_index)
    local number_of_surrounding_mines = 0
    local surrounding_cells = grid:get_surrounding_cells(row_index, column_index)

    for _, entity in pairs(surrounding_cells) do
        local cell = nebula.ecs.getComponent(entity, Cell)

        if (CellType.MINE == cell.type) then
            number_of_surrounding_mines = number_of_surrounding_mines + 1
        end
    end

    cell_sprite.texture = NumericalTextures[number_of_surrounding_mines] or BlankCellTexture
end

return grid
