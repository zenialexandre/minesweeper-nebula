math.randomseed(os.time())

_G.helper = require("helper")
_G.fx = require("fx")
_G.menu = require("menu")
_G.grid = require("grid")
_G.event = require("event")

_G.GameObserver = {
    state = {
        started = false,
        running = false,
        paused = false,
        ended = false
    },
    grid_tracker = {
        matrix = {},
        available_grid_cells = 81,
        available_blank_grid_cells = 15,
        available_mine_grid_cells = 20
    }
}

_G.CellType = helper:enum {
    BLANK = 1,
    NUMERICAL = 2,
    MINE = 3
}

function nebula.setup()
    nebula.graphics.setBackground(0.0, 0.0, 0.0)
    nebula.window.setTitle("Minesweeper")
    nebula.window.setSize(500, 500)
    nebula.window.setIcon("resources/textures/icon/yeah.jpg")

    Fade = nebula.ecs.component("Fade", {is_active = false})
    Color = nebula.ecs.component("Color")
    Text = nebula.ecs.component("Text")
    Sprite = nebula.ecs.component("Sprite")
    Position = nebula.ecs.component("Position")
    Cell = nebula.ecs.component("Cell", {type = CellType.NUMERICAL, is_available = false, row_index = 0, column_index = 0})

    CellTexture = nebula.graphics.newTexture("resources/textures/grid_cell.png")
    BlankCellTexture = nebula.graphics.newTexture("resources/textures/blank_cell.png")
    MineCellTexture = nebula.graphics.newTexture("resources/textures/mine_cell.png")
    NumericalOneCellTexture = nebula.graphics.newTexture("resources/textures/numerical_one_cell.png")
    NumericalTwoCellTexture = nebula.graphics.newTexture("resources/textures/numerical_two_cell.png")
    NumericalThreeCellTexture = nebula.graphics.newTexture("resources/textures/numerical_three_cell.png")
    NumericalFourCellTexture = nebula.graphics.newTexture("resources/textures/numerical_four_cell.png")
    NumericalFiveCellTexture = nebula.graphics.newTexture("resources/textures/numerical_five_cell.png")
    NumericalSixCellTexture = nebula.graphics.newTexture("resources/textures/numerical_six_cell.png")
    NumericalSevenCellTexture = nebula.graphics.newTexture("resources/textures/numerical_seven_cell.png")
    NumericalEightCellTexture = nebula.graphics.newTexture("resources/textures/numerical_eight_cell.png")

    NumericalTextures = {
        [1] = NumericalOneCellTexture,
        [2] = NumericalTwoCellTexture,
        [3] = NumericalThreeCellTexture,
        [4] = NumericalFourCellTexture,
        [5] = NumericalFiveCellTexture,
        [6] = NumericalSixCellTexture,
        [7] = NumericalSevenCellTexture,
        [8] = NumericalEightCellTexture
    }

    menu:started()
    grid:build()
end

function nebula.update(delta)
    event:player_start(delta)
    event:game_started(delta)
    event:mouse_click()
    event:game_ended()
end

function nebula.draw()
    for _, entity in pairs(nebula.ecs.getEntitiesWith(Position)) do
        nebula.graphics.draw(entity)
    end
end
