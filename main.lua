math.randomseed(os.time())
require "helper"

_G.GameObserver = {
    state = {
        running = true,
        paused = false,
        ended = false
    },
    grid_tracker = {
        available_grid_cells = 81,
        available_numerical_grid_cells = 71,
        available_mine_grid_cells = 10
    }
}

_G.GridType = enum {
    NUMERICAL = 1,
    MINE = 2
}

function nebula.setup()
    nebula.window.setTitle("Minesweeper")
    nebula.window.setSize(500, 500)
    nebula.window.setIcon("resources/textures/icon/yeah.jpg")

    Position = nebula.ecs.component("Position")
    Quad = nebula.ecs.component("Quad")
    Color = nebula.ecs.component("Color")
    GridMatrix = nebula.ecs.component("GridMatrix", {value = {}})
    GridCell = nebula.ecs.component("GridCell", {value = GridType.NUMERICAL})

    local mutable_position = Position({x = 6, y = 10})
    local matrix = {}
    local number_of_mines = 0
    local number_of_rows = 9
    local number_of_columns = 9
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
            local grid_cell_type = GridType:random()

            if (number_of_mines == 10) then
                grid_cell_type = GridType.NUMERICAL
            end

            if (GridType.MINE == grid_cell_type) then
                number_of_mines = number_of_mines + 1
            end

            if (j ~= 1) then
                position = Position({x = mutable_position.x + 56, y = mutable_position.y})
                mutable_position.x = position.x
            end

            nebula.ecs.addComponent(
                grid_cell,
                position,
                Quad({width = 40, height = 40}),
                Color({r = 0.238, g = 0.239, b = 0.237}),
                GridCell({value = grid_cell_type})
            )
            matrix[i][j] = grid_cell
        end
    end

    nebula.ecs.addComponent(grid, GridMatrix({value = matrix}))
end

function nebula.update(delta)
    if (nebula.mouse.isPressed("left")) then
        local entities = nebula.ecs.getEntitiesWith(GridCell)
        local mouse_x = nebula.mouse.getX()
        local mouse_y = nebula.mouse.getY()

        for entity in pairs(entities) do
            local quad = nebula.ecs.getComponent(entity, Quad)
            local position = nebula.ecs.getComponent(entity, Position)
            local grid_cell = nebula.ecs.getComponent(entity, GridCell)

            local quadrant_x = position.x + quad.width
            local quadrant_y = position.y + quad.height

            local is_mouse_in_quadrant_x = mouse_x <= quadrant_x and mouse_x >= quadrant_x
            local is_mouse_in_quadrant_y = mouse_y <= quadrant_y and mouse_y >= quadrant_y

            if (GridType.MINE == grid_cell.value and (is_mouse_in_quadrant_x and is_mouse_in_quadrant_y)) then
                print("ops!! booom")
            end
        end
    end
end

function nebula.draw()
    for i, entity in pairs(nebula.ecs.getEntitiesWith(Position)) do
        nebula.graphics.draw(entity)
    end
end
