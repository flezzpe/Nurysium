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

return nurysium_module;
