local icon = {}

function icon:build()
    nebula.ecs.addComponent(
        nebula.ecs.spawn(),
        Icon({ type = IconType.SMILE, is_pressed = false }),
        Color({ r = 1.0, g = 1.0, b = 1.0, a = 0.0 }),
        Sprite({ texture = SmileCellTexture }),
        Position({ x = 210.0, y = 20.0 }),
        Fade({ is_active = false })
    )
end

function icon:listener()
    for _, entity in pairs(nebula.ecs.getEntitiesWith(Icon)) do
        local icon_component = nebula.ecs.getComponent(entity, Icon)
        local sprite = nebula.ecs.getComponent(entity, Sprite)

        if (IconType.SMILE == icon_component.type) then
            sprite.texture = SmileCellTexture
        elseif (IconType.SAD == icon_component.type) then
            sprite.texture = SadCellTexture
        else
            sprite.texture = WowCellTexture
        end

        if (icon_component.is_pressed) then
            if (IconType.SMILE == icon_component.type) then
                sprite.texture = SmilePressedCellTexture
            elseif (IconType.SAD == icon_component.type) then
                sprite.texture = SadPressedCellTexture
            else
                sprite.texture = WowPressedCellTexture
            end
        end
    end
end

function icon:reset()
    for _, entity in pairs(nebula.ecs.getEntitiesWith(Icon)) do
        local icon_component = nebula.ecs.getComponent(entity, Icon)
        icon_component.type = IconType.SMILE
        icon_component.is_pressed = false
    end
end

return icon
