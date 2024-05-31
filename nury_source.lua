--// nurysium recode

local version = '0.3.0'

print('nurysium llc. - https://dsc.gg/nurysium')
print(version)
warn('use new version...')

setfpscap(165)

local Stats = game:GetService('Stats')
local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local TweenService = game:GetService('TweenService')

local Nurysium_Util = loadstring(game:HttpGet('https://raw.githubusercontent.com/flezzpe/Nurysium/main/nurysium_helper.lua'))()

local local_player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local nurysium_Data = nil
local hit_Sound = nil

local closest_Entity = nil
local parry_remote = nil

getgenv().aura_Enabled = false
getgenv().hit_sound_Enabled = false
getgenv().hit_effect_Enabled = false
getgenv().night_mode_Enabled = false
getgenv().trail_Enabled = false
getgenv().self_effect_Enabled = false
getgenv().kill_effect_Enabled = false
getgenv().shaders_effect_Enabled = false
getgenv().ai_Enabled = false
getgenv().spectate_Enabled = false

local Services = {
	game:GetService('AdService'),
	game:GetService('SocialService')
}

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/flezzpe/Nurysium/main/nurysium_ui.lua"))()
task.wait(0.5)

--// Yes, you can rename, I don't mind 🌠
library:init("https://dsc.gg/nurysium", game:GetService("UserInputService").TouchEnabled, game:GetService("CoreGui"))

library:create_section("Combat", 17440545793)
library:create_section("World", 17440865331)
--// library:create_section("Misc", 17440868530)
--// library:create_section("Settings", 17440866925)

function initializate(dataFolder_name: string)
	local nurysium_Data = Instance.new('Folder', game:GetService('CoreGui'))
	nurysium_Data.Name = dataFolder_name

	hit_Sound = Instance.new('Sound', nurysium_Data)
	hit_Sound.SoundId = 'rbxassetid://6607204501'
	hit_Sound.Volume = 6
end

local function get_closest_entity(Object: Part)
	task.spawn(function()
		local closest
		local max_distance = math.huge

		for index, entity in workspace.Alive:GetChildren() do
			if entity.Name ~= Players.LocalPlayer.Name then
				local distance = (Object.Position - entity.HumanoidRootPart.Position).Magnitude

				if distance < max_distance then
					closest_Entity = entity
					max_distance = distance
				end

			end
		end

		return closest_Entity
	end)
end

local function get_center()
	for _, object in workspace.Map:GetDescendants() do
		if object.Name == 'BALLSPAWN' then
			return object
		end
	end
end

--// Thanks Aries for this.
function resolve_parry_Remote()
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

function walk_to(position)
	local_player.Character.Humanoid:MoveTo(position)
end

library:create_toggle("Attack Aura", "Combat", function(toggled)
	resolve_parry_Remote()
	getgenv().aura_Enabled = toggled
end)

library:create_toggle("AI", "Combat", function(toggled)
	resolve_parry_Remote()
	getgenv().ai_Enabled = toggled
end)

library:create_toggle("Hit Sound", "Combat", function(toggled)
	getgenv().hit_sound_Enabled = toggled
end)

library:create_toggle("Hit Effect", "World", function(toggled)
	getgenv().hit_effect_Enabled = toggled
end)

library:create_toggle("Night Mode", "World", function(toggled)
	getgenv().night_mode_Enabled = toggled
end)

library:create_toggle("Trail", "World", function(toggled)
	getgenv().trail_Enabled = toggled
end)

library:create_toggle("Self Effect", "World", function(toggled)
	getgenv().self_effect_Enabled = toggled
end)

library:create_toggle("Kill Effect", "World", function(toggled)
	getgenv().kill_effect_Enabled = toggled
end)

library:create_toggle("Shaders", "World", function(toggled)
	getgenv().shaders_effect_Enabled = toggled
end)

library:create_toggle("Spectate Ball", "World", function(toggled)
	getgenv().spectate_Enabled = toggled
end)

--// kill effect

function play_kill_effect(Part)
	task.defer(function()
		local bell = game:GetObjects("rbxassetid://17519762269")[1]

		bell.Name = 'Yeat_BELL'
		bell.Parent = workspace

		bell.Position = Part.Position - Vector3.new(0, 20, 0)
		bell:WaitForChild('Sound'):Play()

		TweenService:Create(bell, TweenInfo.new(0.85, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
			Position = Part.Position + Vector3.new(0, 10, 0)
		}):Play()

		task.delay(5, function()
			TweenService:Create(bell, TweenInfo.new(1.75, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
				Position = Part.Position + Vector3.new(0, 100, 0)
			}):Play()
		end)

		task.delay(6, function()
			bell:Destroy()
		end)
	end)
end

task.defer(function()
	workspace.Alive.ChildRemoved:Connect(function(child)
		if not workspace.Dead:FindFirstChild(child.Name) and child ~= local_player.Character and #workspace.Alive:GetChildren() > 1 then
			return
		end

		if getgenv().kill_effect_Enabled then
			play_kill_effect(child.HumanoidRootPart)
		end
	end)
end)

--// self effect

task.defer(function()
	game:GetService("RunService").Heartbeat:Connect(function()

		if not local_player.Character then
			return
		end

		if getgenv().self_effect_Enabled then
			local effect = game:GetObjects("rbxassetid://17519530107")[1]

			effect.Name = 'nurysium_efx'

			if local_player.Character.PrimaryPart:FindFirstChild('nurysium_efx') then
				return
			end

			effect.Parent = local_player.Character.PrimaryPart
		else

			if local_player.Character.PrimaryPart:FindFirstChild('nurysium_efx') then
				local_player.Character.PrimaryPart['nurysium_efx']:Destroy()
			end
		end

	end)
end)

--// trail

task.defer(function()
	game:GetService("RunService").Heartbeat:Connect(function()

		if not local_player.Character then
			return
		end

		if getgenv().trail_Enabled then
			local trail = game:GetObjects("rbxassetid://17483658369")[1]

			trail.Name = 'nurysium_fx'

			if local_player.Character.PrimaryPart:FindFirstChild('nurysium_fx') then
				return
			end

			local Attachment0 = Instance.new("Attachment", local_player.Character.PrimaryPart)
			local Attachment1 = Instance.new("Attachment", local_player.Character.PrimaryPart)

			Attachment0.Position = Vector3.new(0, -2.411, 0)
			Attachment1.Position = Vector3.new(0, 2.504, 0)

			trail.Parent = local_player.Character.PrimaryPart
			trail.Attachment0 = Attachment0
			trail.Attachment1 = Attachment1
		else

			if local_player.Character.PrimaryPart:FindFirstChild('nurysium_fx') then
				local_player.Character.PrimaryPart['nurysium_fx']:Destroy()
			end
		end

	end)
end)

--// night mode

task.defer(function()
	while task.wait(1) do
		if getgenv().night_mode_Enabled then
			TweenService:Create(game:GetService("Lighting"), TweenInfo.new(3), {ClockTime = 1.9}):Play()
		else
			TweenService:Create(game:GetService("Lighting"), TweenInfo.new(3), {ClockTime = 13.5}):Play()
		end
	end
end)

--// spectate ball

task.defer(function()
    RunService.RenderStepped:Connect(function()
        if getgenv().spectate_Enabled then

            local self = Nurysium_Util.getBall()

            if not self then
                return
            end

            workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(CFrame.new(workspace.CurrentCamera.CFrame.Position, self.Position), 1.5)
        end
    end)
end)

--// shaders

task.defer(function()
	while task.wait(1) do
		if getgenv().shaders_effect_Enabled then
			TweenService:Create(game:GetService("Lighting").Bloom, TweenInfo.new(4), {
				Size = 100,
				Intensity = 2.1
			}):Play()
		else
			TweenService:Create(game:GetService("Lighting").Bloom, TweenInfo.new(3), {
				Size = 3,
				Intensity = 1
			}):Play()
		end
	end
end)

ReplicatedStorage.Remotes.ParrySuccess.OnClientEvent:Connect(function()
	if getgenv().hit_sound_Enabled then
		hit_Sound:Play()
	end

	if getgenv().hit_effect_Enabled then
		local hit_effect = game:GetObjects("rbxassetid://17407244385")[1]

		hit_effect.Parent = Nurysium_Util.getBall()
		hit_effect:Emit(3)

		task.delay(5, function()
			hit_effect:Destroy()
		end)

	end
end)

--// aura

local aura = {
	can_parry = true,
	is_spamming = false,

	parry_Range = 0,
	spam_Range = 0,  
	hit_Count = 0,

	hit_Time = tick(),
	ball_Warping = tick(),
	is_ball_Warping = false,
	last_target = nil
}

--// AI

task.defer(function()
    game:GetService("RunService").Heartbeat:Connect(function()
        if getgenv().ai_Enabled and workspace.Alive:FindFirstChild(local_player.Character.Name) then
            local self = Nurysium_Util.getBall()

            if not self or not closest_Entity then
                return
            end

            if not closest_Entity:FindFirstChild('HumanoidRootPart') then
                walk_to(local_player.Character.HumanoidRootPart.Position + Vector3.new(math.sin(tick()) * math.random(35, 50), 0, math.cos(tick()) * math.random(35, 50)))
                return
            end

            local ball_Position = self.Position
            local ball_Speed = self.AssemblyLinearVelocity.Magnitude
            local ball_Distance = local_player:DistanceFromCharacter(ball_Position)

            local player_Position = local_player.Character.PrimaryPart.Position

            local target_Position = closest_Entity.HumanoidRootPart.Position
            local target_Distance = local_player:DistanceFromCharacter(target_Position)
            local target_LookVector = closest_Entity.HumanoidRootPart.CFrame.LookVector

            local resolved_Position = Vector3.zero

            local target_Humanoid = closest_Entity:FindFirstChildOfClass("Humanoid")
            if target_Humanoid and target_Humanoid:GetState() == Enum.HumanoidStateType.Jumping and local_player.Character.Humanoid.FloorMaterial ~= Enum.Material.Air then
                local_player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end

            if (ball_Position - player_Position):Dot(local_player.Character.PrimaryPart.CFrame.LookVector) < -0.2 and tick() % 4 <= 2 then
                return
            end

            if tick() % 4 <= 2 then
                if target_Distance > 10 then
                    resolved_Position = target_Position + (player_Position - target_Position).Unit * 8
                else
                    resolved_Position = target_Position + (player_Position - target_Position).Unit * 25
                end
            else
                resolved_Position = target_Position - target_LookVector * (math.random(8.5, 13.5) + (ball_Distance / math.random(8, 20)))
            end

            if (player_Position - target_Position).Magnitude < 8 then
                resolved_Position = target_Position + (player_Position - target_Position).Unit * 35
            end

            if ball_Distance < 8 then
                resolved_Position = player_Position + (player_Position - ball_Position).Unit * 10
            end

            if aura.is_spamming then
                resolved_Position = player_Position + (ball_Position - player_Position).Unit * 10
            end

            walk_to(resolved_Position + Vector3.new(math.sin(tick()) * 10, 0, math.cos(tick()) * 10))
        end
    end)
end)


ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function()
	aura.hit_Count += 1

	task.delay(0.185, function()
		aura.hit_Count -= 1
	end)
end)


task.spawn(function()
	RunService.PreRender:Connect(function()
		if not getgenv().aura_Enabled then
			return
		end

		if closest_Entity then
			if workspace.Alive:FindFirstChild(closest_Entity.Name) then
				if aura.is_spamming then
					if local_player:DistanceFromCharacter(closest_Entity.HumanoidRootPart.Position) <= aura.spam_Range then   
						parry_remote:FireServer(
							0.5,
							CFrame.new(camera.CFrame.Position, Vector3.zero),
							{[closest_Entity.Name] = closest_Entity.HumanoidRootPart.Position},
							{closest_Entity.HumanoidRootPart.Position.X, closest_Entity.HumanoidRootPart.Position.Y},
							false
						)
					end
				end
			end
		end
	end)

	RunService.PreRender:Connect(function()
		if not getgenv().aura_Enabled then
			return
		end

		workspace:WaitForChild("Balls").ChildRemoved:Once(function(child)
			aura.hit_Count = 0
			aura.is_ball_Warping = false
			aura.is_spamming = false
			aura.can_parry = true
			aura.last_target = nil
		end)

		local ping = Stats.Network.ServerStatsItem['Data Ping']:GetValue() / 10
		local self = Nurysium_Util.getBall()

		if not self then
			return
		end

		self:GetAttributeChangedSignal('target'):Once(function()
			aura.can_parry = true
		end)

		self:GetAttributeChangedSignal('from'):Once(function()
			aura.last_target = workspace.Alive:FindFirstChild(self:GetAttribute('from'))
		end)

		if self:GetAttribute('target') ~= local_player.Name or not aura.can_parry then
			return
		end

		get_closest_entity(local_player.Character.PrimaryPart)

		local player_Position = local_player.Character.PrimaryPart.Position
		local player_Velocity = local_player.Character.HumanoidRootPart.AssemblyLinearVelocity
		local player_isMoving = player_Velocity.Magnitude > 0

		local ball_Position = self.Position
		local ball_Velocity = self.AssemblyLinearVelocity

		if self:FindFirstChild('zoomies') then
			ball_Velocity = self.zoomies.VectorVelocity
		end

		local ball_Direction = (local_player.Character.PrimaryPart.Position - ball_Position).Unit
		local ball_Distance = local_player:DistanceFromCharacter(ball_Position)
		local ball_Dot = ball_Direction:Dot(ball_Velocity.Unit)
		local ball_Speed = ball_Velocity.Magnitude
		local ball_speed_Limited = math.min(ball_Speed / 1000, 0.1)

		local target_Position = closest_Entity.HumanoidRootPart.Position
		local target_Distance = local_player:DistanceFromCharacter(target_Position)
		local target_distance_Limited = math.min(target_Distance / 10000, 0.1)
		local target_Direction = (local_player.Character.PrimaryPart.Position - closest_Entity.HumanoidRootPart.Position).Unit
		local target_Velocity = closest_Entity.HumanoidRootPart.AssemblyLinearVelocity
		local target_isMoving = target_Velocity.Magnitude > 0
		local target_Dot = target_isMoving and math.max(target_Direction:Dot(target_Velocity.Unit), 0)

		aura.spam_Range = math.max(ping / 10, 10.5) + ball_Speed / 6.15
		aura.parry_Range = math.max(math.max(ping, 3.5) + ball_Speed / 3.25, 9.5)

		if target_isMoving then
            aura.is_spamming = (aura.hit_Count > 1 or (target_Distance < 11 and ball_Distance < 10)) and ball_Dot > -0.25
        else
            aura.is_spamming = (aura.hit_Count > 1 or (target_Distance < 11.5 and ball_Distance < 10))
        end

		if ball_Dot < -0.2 then
			aura.ball_Warping = tick()
		end

		task.spawn(function()
			if (tick() - aura.ball_Warping) >= 0.15 + target_distance_Limited - ball_speed_Limited or ball_Distance < 10 then
				aura.is_ball_Warping = false
				return
			end

			if (ball_Position - aura.last_target.HumanoidRootPart.Position).Magnitude > 35.5 or target_Distance <= 12 then
				aura.is_ball_Warping = false
				return
			end

			aura.is_ball_Warping = true
		end)

		if ball_Distance <= aura.parry_Range and not aura.is_ball_Warping and ball_Dot > -0.1 then
			parry_remote:FireServer(
				0.5,
				CFrame.new(camera.CFrame.Position, Vector3.new(math.random(-1000, 1000), math.random(0, 1000), math.random(100, 1000))),
				{[closest_Entity.Name] = target_Position},
				{target_Position.X, target_Position.Y},
				false
			)

			aura.can_parry = false
			aura.hit_Time = tick()
			aura.hit_Count += 1

			task.delay(0.2, function()
				aura.hit_Count -= 1
			end)
		end

		task.spawn(function()
			repeat
				RunService.PreRender:Wait()
			until (tick() - aura.hit_Time) >= 1
			    aura.can_parry = true
		end)
	end)
end)



initializate('nurysium_temp')
