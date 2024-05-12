local nurysium_module = {}

local Players = game:GetService("Players")

local Services = {
    game:GetService('AdService'),
    game:GetService('SocialService')
}

function nurysium_module.isAlive(Entity)
    return Entity.Character and Entity.Character.Parent == workspace.Alive
end

function nurysium_module.getBall()
    for index, ball in workspace:WaitForChild("Balls"):GetChildren() do
        if ball:IsA("BasePart") and ball:GetAttribute("realBall") then
            return ball
        end
    end
end

--// Thanks Aries for this.

function nurysium_module.resolve_parry_Remote()
    for _, value in Services do
        local temp_remote = value:FindFirstChildOfClass('RemoteEvent')
    
        if not temp_remote then
            continue
        end
    
        if not temp_remote.Name:find('\n') then
            continue
        end
    
        parry_remote = temp_remote
    end
end

return nurysium_module;
