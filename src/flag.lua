local flag = {}

function flag:listener()
    for _, entity in pairs(nebula.ecs.getEntitiesWith(Flag)) do
        local cell = nebula.ecs.getComponent(entity, Cell)
        local sprite = nebula.ecs.getComponent(entity, Sprite)
        local flag_component = nebula.ecs.getComponent(entity, Flag)

        if (flag_component.is_placed) then
            sprite.texture = FlagCellTexture
        elseif (not flag_component.is_placed and cell.is_available) then
            sprite.texture = CellTexture
        end
    end
end

return flag
