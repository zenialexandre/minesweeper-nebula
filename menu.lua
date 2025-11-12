local menu = {}

function menu:started()
    local title_font = nebula.graphics.newFont("resources/fonts/RobotoMono-Italic.ttf", 30.0)
    local enter_call_font = nebula.graphics.newFont("resources/fonts/RobotoMono-Italic.ttf", 20.0)
    local title = nebula.ecs.spawn()
    local enter_call = nebula.ecs.spawn()

    nebula.ecs.addComponent(
        title,
        Text({font = title_font, value = "Minesweeper Nebula"}),
        Position({x = 90.0, y = 220.0}),
        Color({r = 1.0, g = 1.0, b = 1.0, a = 1.0})
    )

    nebula.ecs.addComponent(
        enter_call,
        Text({font = enter_call_font, value = "Press >> enter << to start"}),
        Position({x = 90.0, y = 260.0}),
        Color({r = 0.255, g = 0.255, b = 0.0, a = 1.0})
    )
end

function menu:paused()

end

function menu:ended()

end

return menu
