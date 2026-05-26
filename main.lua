math.randomseed(os.time())

_G.helper = require("helper")
_G.fx = require("fx")
_G.menu = require("menu")
_G.icon = require("icon")
_G.timer = require("timer")
_G.cell_counter = require("cell_counter")
_G.grid = require("grid")
_G.event = require("event")

_G.GameObserver = {
    state = {
        started = false,
        running = false,
        ended = false
    },
    grid_tracker = {
        matrix = {},
        available_grid_cells = 81,
        available_blank_grid_cells = 15,
        available_mine_grid_cells = 20,
        end_game_mine_cell_row_index = 0,
        end_game_mine_cell_column_index = 0
    },
    timer = {
        elapsed = 0,
        seconds = 0
    }
}

_G.IconType = helper:enum {
    SMILE = 1,
    SAD = 2,
    WOW = 3
}

_G.CellType = helper:enum {
    BLANK = 1,
    NUMERICAL = 2,
    MINE = 3
}

function nebula.setup()
    nebula.graphics.setBackground(0.0, 0.0, 0.0)
    nebula.window.setTitle("Minesweeper")
    nebula.window.setSize(475, 600)
    nebula.window.setIcon("resources/textures/icon/yeah_cell.jpg")
    nebula.graphics.setDefaultFilter("nearest")

    Fade = nebula.ecs.component("Fade", { is_active = false })
    Color = nebula.ecs.component("Color")
    Text = nebula.ecs.component("Text")
    Sprite = nebula.ecs.component("Sprite")
    Position = nebula.ecs.component("Position")
    Icon = nebula.ecs.component("Icon", { type = IconType.SMILE, is_pressed = false })
    Timer = nebula.ecs.component("Timer", { count = 0 })
    CellCounter = nebula.ecs.component("CellCounter", { is_fixed = false, value = 0 })
    Cell = nebula.ecs.component("Cell", { type = CellType.NUMERICAL, is_available = false, row_index = 0, column_index = 0 })

    -- Icons
    SmileCellTexture = nebula.graphics.newTexture("resources/textures/icon/smile_cell.png")
    SmilePressedCellTexture = nebula.graphics.newTexture("resources/textures/icon/smile_pressed_cell.png")
    SadCellTexture = nebula.graphics.newTexture("resources/textures/icon/sad_cell.png")
    SadPressedCellTexture = nebula.graphics.newTexture("resources/textures/icon/sad_pressed_cell.png")
    WowCellTexture = nebula.graphics.newTexture("resources/textures/icon/wow_cell.png")
    WowPressedCellTexture = nebula.graphics.newTexture("resources/textures/icon/wow_pressed_cell.png")

    -- Timer
    ZeroCellTexture = nebula.graphics.newTexture("resources/textures/timer/zero_cell.png")
    OneCellTexture = nebula.graphics.newTexture("resources/textures/timer/one_cell.png")
    TwoCellTexture = nebula.graphics.newTexture("resources/textures/timer/two_cell.png")
    ThreeCellTexture = nebula.graphics.newTexture("resources/textures/timer/three_cell.png")
    FourCellTexture = nebula.graphics.newTexture("resources/textures/timer/four_cell.png")
    FiveCellTexture = nebula.graphics.newTexture("resources/textures/timer/five_cell.png")
    SixCellTexture = nebula.graphics.newTexture("resources/textures/timer/six_cell.png")
    SevenCellTexture = nebula.graphics.newTexture("resources/textures/timer/seven_cell.png")
    EightCellTexture = nebula.graphics.newTexture("resources/textures/timer/eight_cell.png")
    NineCellTexture = nebula.graphics.newTexture("resources/textures/timer/nine_cell.png")
    EmptyCellTexture = nebula.graphics.newTexture("resources/textures/timer/empty_cell.png")

    -- Grid
    CellTexture = nebula.graphics.newTexture("resources/textures/grid/grid_cell.png")
    BlankCellTexture = nebula.graphics.newTexture("resources/textures/grid/blank_cell.png")
    MineCellTexture = nebula.graphics.newTexture("resources/textures/grid/mine_cell.png")
    MineRedCellTexture = nebula.graphics.newTexture("resources/textures/grid/mine_red_cell.png")
    FlagCellTexture = nebula.graphics.newTexture("resources/textures/grid/flag_cell.png")
    NumericalOneCellTexture = nebula.graphics.newTexture("resources/textures/grid/numerical_one_cell.png")
    NumericalTwoCellTexture = nebula.graphics.newTexture("resources/textures/grid/numerical_two_cell.png")
    NumericalThreeCellTexture = nebula.graphics.newTexture("resources/textures/grid/numerical_three_cell.png")
    NumericalFourCellTexture = nebula.graphics.newTexture("resources/textures/grid/numerical_four_cell.png")
    NumericalFiveCellTexture = nebula.graphics.newTexture("resources/textures/grid/numerical_five_cell.png")
    NumericalSixCellTexture = nebula.graphics.newTexture("resources/textures/grid/numerical_six_cell.png")
    NumericalSevenCellTexture = nebula.graphics.newTexture("resources/textures/grid/numerical_seven_cell.png")
    NumericalEightCellTexture = nebula.graphics.newTexture("resources/textures/grid/numerical_eight_cell.png")

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
    icon:build()
    timer:build()
    cell_counter:build()
    grid:build()
end

function nebula.update(delta)
    icon:listener()
    timer:listener()
    cell_counter:listener()
    event:player_start(delta)
    event:game_started(delta)
    event:mouse_click()
    event:game_ended()
    timer:lookup(delta)
    cell_counter:lookup()
end

function nebula.draw()
    for _, entity in pairs(nebula.ecs.getEntitiesWith(Position)) do
        nebula.graphics.draw(entity)
    end
end
