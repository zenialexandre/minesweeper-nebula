math.randomseed(os.time())
require "helper"
require "grid"

_G.GameObserver = {
    state = {
        paused = false,
        ended = false
    },
    grid_tracker = {
        available_grid_cells = 81,
        available_blank_grid_cells = 10,
        available_numerical_grid_cells = 61,
        available_mine_grid_cells = 10
    }
}

_G.GridType = enum {
    BLANK = 1,
    NUMERICAL = 2,
    MINE = 3
}

function nebula.setup()
    nebula.window.setTitle("Minesweeper")
    nebula.window.setSize(500, 500)
    nebula.window.setIcon("resources/textures/icon/yeah.jpg")

    Sprite = nebula.ecs.component("Sprite")
    Position = nebula.ecs.component("Position")
    BlankCellTexture = nebula.graphics.newTexture("resources/textures/blank_cell.png")
    MineCellTexture = nebula.graphics.newTexture("resources/textures/mine_cell.png")
    GridMatrix = nebula.ecs.component("GridMatrix", {value = {}})
    GridCell = nebula.ecs.component("GridCell", {value = GridType.NUMERICAL})

    local matrix = {}
    local grid = nebula.ecs.spawn()
    --local score = nebula.ecs.spawn()
    --local timer = nebula.ecs.spawn()

    build(matrix)
    nebula.ecs.addComponent(grid, GridMatrix({value = matrix}))
end

function nebula.update(delta)
    if (nebula.mouse.isPressed("left")) then
        local entities = nebula.ecs.getEntitiesWith(GridCell)
        local mouse_x = nebula.mouse.getX()
        local mouse_y = nebula.mouse.getY()

        for _, entity in pairs(entities) do
            local sprite = nebula.ecs.getComponent(entity, Sprite)
            local position = nebula.ecs.getComponent(entity, Position)
            local grid_cell = nebula.ecs.getComponent(entity, GridCell)

            local quadrant_x = position.x + sprite.texture.width
            local quadrant_y = position.y + sprite.texture.height

            local is_mouse_in_quadrant_x = mouse_x >= position.x and mouse_x < quadrant_x
            local is_mouse_in_quadrant_y = mouse_y >= position.y and mouse_y < quadrant_y

            if (is_mouse_in_quadrant_x and is_mouse_in_quadrant_y) then
                if (GridType.BLANK == grid_cell.value) then
                    sprite.texture = BlankCellTexture
                elseif (GridType.NUMERICAL == grid_cell.value) then
                    -- blaa
                else
                    GameObserver.state.ended = true
                end
            end
        end
    end

    if (GameObserver.state.ended) then
        for _, entity in pairs(nebula.ecs.getEntitiesWith(GridCell)) do
            local grid_cell = nebula.ecs.getComponent(entity, GridCell)
            local sprite = nebula.ecs.getComponent(entity, Sprite)

            if (GridType.BLANK == grid_cell.value) then
                sprite.texture = BlankCellTexture
            elseif (GridType.NUMERICAL == grid_cell.value) then
                -- blaa
            else
                sprite.texture = MineCellTexture
            end
        end
    end
end

function nebula.draw()
    for _, entity in pairs(nebula.ecs.getEntitiesWith(Position)) do
        nebula.graphics.draw(entity)
    end
end
