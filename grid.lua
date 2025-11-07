function build(matrix)
    local grid_cell_texture = nebula.graphics.newTexture("resources/textures/grid_cell.png")
    local mutable_position = Position({x = 6, y = 10})
    local number_of_blanks = 0
    local number_of_mines = 0
    local number_of_rows = 9
    local number_of_columns = 9

    for i = 1, number_of_rows do
        matrix[i] = {}
        mutable_position.x = 6

        if (i ~= 1) then
            mutable_position.y = mutable_position.y + 55
        end

        for j = 1, number_of_columns do
            local grid_cell = nebula.ecs.spawn()
            local position = mutable_position
            local grid_cell_type = GridType:random()

            if (number_of_mines == GameObserver.grid_tracker.available_mine_grid_cells) then grid_cell_type = GridType.NUMERICAL end
            if (number_of_blanks == GameObserver.grid_tracker.available_blank_grid_cells) then grid_cell_type = GridType.NUMERICAL end

            if (GridType.BLANK == grid_cell_type) then number_of_blanks = number_of_blanks + 1 end
            if (GridType.MINE == grid_cell_type) then number_of_mines = number_of_mines + 1 end

            if (j ~= 1) then
                position = Position({x = mutable_position.x + 56, y = mutable_position.y})
                mutable_position.x = position.x
            end

            nebula.ecs.addComponent(
                grid_cell,
                position,
                Sprite({texture = grid_cell_texture}),
                GridCell({value = grid_cell_type})
            )
            matrix[i][j] = grid_cell
        end
    end
end
