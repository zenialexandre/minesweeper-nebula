require "helper"

_G.GameObserver = {
    state = {
        running = true,
        paused = false,
        ended = false
    },
    grid_tracker = {
        available_grid_cells = 81,
        available_numerical_grid_cells = 0,
        available_mine_grid_cells = 0
    }
}

_G.GridType = enum {
    NUMERICAL = 0,
    MINE = 1
}

function nebula.setup()
    nebula.window.setTitle("Minesweeper")
    nebula.window.setSize(500, 500)
    nebula.window.setIcon("resources/textures/icon/yeah.jpg")

    Position = nebula.ecs.component("Position")
    Quad = nebula.ecs.component("Quad")
    Color = nebula.ecs.component("Color")
    GridMatrix = nebula.ecs.component("GridMatrix", {internal_matrix = {}})
    GridCell = nebula.ecs.component("GridCell", {type = GridType.NUMERICAL})

    local mutable_position = Position({x = 6, y = 10});
    local matrix = {}
    local number_of_rows = 9;
    local number_of_columns = 9;
    local grid = nebula.ecs.spawn()
    --local score = nebula.ecs.spawn()
    --local timer = nebula.ecs.spawn()

    for i = 1, number_of_rows do
        matrix[i] = {}
        mutable_position.x = 6

        if (i ~= 1) then
            mutable_position.y = mutable_position.y + 55
        end

        for j = 1, number_of_columns do
            local grid_cell = nebula.ecs.spawn()
            local position = mutable_position

            if (j ~= 1) then
                position = Position({x = mutable_position.x + 56, y = mutable_position.y})
                mutable_position.x = position.x
            end

            nebula.ecs.addComponent(
                grid_cell,
                position,
                Quad({width = 40, height = 40}),
                Color({r = 0.238, g = 0.239, b = 0.237}),
                GridCell({type = GridType.NUMERICAL})
            )
            matrix[i][j] = grid_cell
        end
    end

    nebula.ecs.addComponent(grid, GridMatrix({internal_matrix = matrix}))
end

function nebula.update(dt)

end

function nebula.draw()
    for i, entity in pairs(nebula.ecs.getEntitiesWith(Position)) do
        nebula.graphics.draw(entity)
    end
end
