local RobloxReplicatedStorage = cloneref(game:GetService('RobloxReplicatedStorage'))
local RbxAnalyticsService = cloneref(game:GetService('RbxAnalyticsService'))
local ReplicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local UserInputService = cloneref(game:GetService('UserInputService'))
local NetworkClient = cloneref(game:GetService("NetworkClient"))
local TweenService = cloneref(game:GetService('TweenService'))
local VirtualUser = cloneref(game:GetService('VirtualUser'))
local HttpService = cloneref(game:GetService('HttpService'))
local RunService = cloneref(game:GetService('RunService'))
local LogService = cloneref(game:GetService('LogService'))
local Lighting = cloneref(game:GetService('Lighting'))
local CoreGui = cloneref(game:GetService('CoreGui'))
local Players = cloneref(game:GetService('Players'))
local Debris = cloneref(game:GetService('Debris'))
local Stats = cloneref(game:GetService('Stats'))

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local crypter = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Egor-Skriptunoff/pure_lua_SHA/master/sha2.lua'), true))()
local notify = loadstring(game:HttpGet('https://raw.githubusercontent.com/flezzpe/Nurysium/main/notify_UI.lua'))()

notify.__init({
	parent = cloneref(game:GetService('CoreGui'))
})

setfpscap(200)

local LocalPlayer = Players.LocalPlayer
local client_id = RbxAnalyticsService:GetClientId()

local names_map = {
	['protected'] = crypter.sha3_384(client_id, 'sha3-256'),
	
	['Pillow'] = crypter.sha3_384(client_id .. 'Pillow', 'sha3-256'),
	['Touhou'] = crypter.sha3_384(client_id .. 'Touhou', 'sha3-256'),
	['Shion'] = crypter.sha3_384(client_id .. 'Shion', 'sha3-256'),
	['Miku'] = crypter.sha3_384(client_id .. 'Miku', 'sha3-256'),
	['Sino'] = crypter.sha3_384(client_id .. 'Sino', 'sha3-256'),
	['Soi'] = crypter.sha3_384(client_id .. 'Soi', 'sha3-256')
}

local interface = loadstring(game:HttpGet('https://raw.githubusercontent.com/flezzpe/EvadeAutoBHOP/main/libs/ef.java'))()

local assets = game:GetObjects('rbxassetid://98657300657778')[1]

assets.Parent = RobloxReplicatedStorage
assets.Name = names_map['protected']

local effects_folder = assets.effects
local objects_folder = assets.objects
local sounds_folder = assets.sounds
local gui_folder = assets.gui

local watermark_asset = gui_folder.watermark
local watermark = watermark_asset:Clone()

local color_shift_effect = Instance.new('ColorCorrectionEffect', assets)

local RunTime = workspace.Runtime
local Alive = workspace.Alive
local Dead = workspace.Dead

local AutoParry = {
	ball = nil,
	target = nil,
	entity_properties = nil
}

local Player = {
	Entity = nil,

	properties = {
		grab_animation = nil
	}
}

Player.Entity = {
    properties = {
		sword = '',
		server_position = Vector3.zero,
		velocity = Vector3.zero,
		position = Vector3.zero,
        is_moving = false,
		speed = 0,
		ping = 0
    }
}

local World = {}

AutoParry.ball = {
	training_ball_entity = nil,
	client_ball_entity = nil,
    ball_entity = nil,
    
    properties = {
		aero_dynamic_time = tick(),
		hell_hook_completed = true,
		last_position = Vector3.zero,
		rotation = Vector3.zero,
		position = Vector3.zero,
		last_warping = tick(),
        parry_remote = nil,
		is_curved = false,
		last_tick = tick(),
        auto_spam = false,
        cooldown = false,
		respawn_time = 0,
        parry_range = 0,
        spam_range = 0,
        maximum_speed = 0,
		old_speed = 0,
        parries = 0,
		direction = 0,
        distance = 0,
        velocity = 0,
        last_hit = 0,
		lerp_radians = 0,
		radians = 0,
		speed = 0,
		dot = 0
    }
}

AutoParry.target = {
    current = nil,
    from = nil,
    aim = nil,
}

AutoParry.entity_properties = {
    server_position = Vector3.zero,
	velocity = Vector3.zero,
	is_moving = false,
	direction = 0,
	distance = 0,
	speed = 0,
	dot = 0
}


function create_animation(object: Instance, info: TweenInfo, value: table)
	local animation = TweenService:Create(object, info, value)

	animation:Play()
			
	task.wait(info.Time)
	
	Debris:AddItem(animation, 0)
	animation:Destroy()
	animation = nil
end

local ConnectionsManager = {}

function ConnectionsManager:disconnect()
    if not ConnectionsManager[self] then
        return
    end

    ConnectionsManager[self]:Disconnect()
    ConnectionsManager[self] = nil
end


function ConnectionsManager:abadone()
	interface.flags = {}
	
	for _, connection in ConnectionsManager do
		if typeof(connection) == 'function' then
			continue
		end

		connection:Disconnect()
		connection = nil
	end
end

ConnectionsManager['controller'] = RunService.Heartbeat:Connect(function()
	if not interface.disconnected then
		return
	end

	ConnectionsManager.abadone()
end)

local function linear_predict(a: any, b: any, time_volume: number)
    return a + (b - a) * time_volume
end

function World:get_pointer()
    local mouse_location = UserInputService:GetMouseLocation()
    local ray = workspace.CurrentCamera:ScreenPointToRay(mouse_location.X, mouse_location.Y, 0)

    return CFrame.lookAt(ray.Origin, ray.Origin + ray.Direction)
end

function AutoParry.get_ball()
    for _, ball in workspace.Balls:GetChildren() do
        if ball:GetAttribute("realBall") then
            return ball
        end
    end
end

function AutoParry.get_client_ball()
    for _, ball in workspace.Balls:GetChildren() do
        if not ball:GetAttribute("realBall") then
            return ball
        end
    end
end

function Player:get_aim_entity()
	local closest_entity = nil
	local minimal_dot_product = -math.huge
	local camera_direction = workspace.CurrentCamera.CFrame.LookVector

	for _, player in Alive:GetChildren() do
		if not player then
			continue
		end

		if player.Name ~= LocalPlayer.Name then
			if not player:FindFirstChild('HumanoidRootPart') then
				continue
			end

			local entity_direction = (player.HumanoidRootPart.Position - workspace.CurrentCamera.CFrame.Position).Unit
			local dot_product = camera_direction:Dot(entity_direction)
	
			if dot_product > minimal_dot_product then
				minimal_dot_product = dot_product
				closest_entity = player
			end
		end
	end

	return closest_entity
end

function Player:get_closest_player_to_cursor()
    local closest_player = nil
    local minimal_dot_product = -math.huge

    for _, player in workspace.Alive:GetChildren() do
        if player == LocalPlayer.Character then
            continue
        end
        
        if player.Parent ~= Alive then
            continue
        end

        local player_direction = (player.PrimaryPart.Position - workspace.CurrentCamera.CFrame.Position).Unit
        local pointer = World.get_pointer()
        local dot_product = pointer.LookVector:Dot(player_direction)

        if dot_product > minimal_dot_product then
            minimal_dot_product = dot_product
            closest_player = player
        end
    end

    return closest_player
end

function AutoParry.get_parry_remote()
	for _, object in { cloneref(game:GetService('AdService')), cloneref(game:GetService('SocialService')) }  do
		local temp_remote = object:FindFirstChildOfClass('RemoteEvent')

		if not temp_remote then
			continue
		end

		if not temp_remote.Name:find('\n') then
			continue
		end

		AutoParry.ball.properties.parry_remote = temp_remote
	end
end

AutoParry.get_parry_remote()

function AutoParry.perform_grab_animation()
	local animation = ReplicatedStorage.Shared.SwordAPI.Collection.Default:FindFirstChild('GrabParry')
	local currently_equipped = Player.Entity.properties.sword
    
	if not currently_equipped or currently_equipped == 'Titan Blade' then
        return
    end

	if not animation then
		return
	end

	local sword_data = ReplicatedStorage.Shared.ReplicatedInstances.Swords.GetSword:Invoke(currently_equipped)

	if not sword_data or not sword_data['AnimationType'] then
        return
    end

	local character = LocalPlayer.Character

	if not character or not character:FindFirstChild('Humanoid') then
		return
	end

	for _, object in ReplicatedStorage.Shared.SwordAPI.Collection:GetChildren() do
        if object.Name ~= sword_data['AnimationType'] then
            continue
        end
		
		if not (object:FindFirstChild('GrabParry') or object:FindFirstChild('Grab')) then
            continue
        end

		local sword_animation_type = 'GrabParry'

		if object:FindFirstChild('Grab') then
			sword_animation_type = 'Grab'
		end

        animation = object[type]
    end

	Player.properties.grab_animation = character.Humanoid:LoadAnimation(animation)
	Player.properties.grab_animation:Play()
end

function AutoParry.perform_parry()
	local ball_properties = AutoParry.ball.properties
	
	if ball_properties.cooldown and not ball_properties.auto_spam then
		return
	end

	ball_properties.parries += 1
	AutoParry.ball.properties.last_hit = tick()

	local camera = workspace.CurrentCamera
	local camera_direction = camera.CFrame.Position
	
	local direction = camera.CFrame
	local target_position = AutoParry.entity_properties.server_position
	
    if not ball_properties.auto_spam then
		AutoParry.perform_grab_animation()

		ball_properties.cooldown = true
	
		local current_curve = interface.flags['curve_method']

		if current_curve == 'Linear' then
			direction = CFrame.new(LocalPlayer.Character.PrimaryPart.Position, target_position)
		end

		if current_curve == 'Backwards' then
			direction = CFrame.new(camera_direction, (camera_direction + (-camera.CFrame.LookVector * 10000)) + Vector3.new(0, 1000, 0))
		end
	
		if current_curve == 'Random' then
			direction = CFrame.new(LocalPlayer.Character.PrimaryPart.Position, Vector3.new(math.random(-1000, 1000), math.random(-350, 1000), math.random(-1000, 1000)))
		end
	
		if current_curve == 'Accelerated' then
			direction = CFrame.new(LocalPlayer.Character.PrimaryPart.Position, target_position + Vector3.new(0, 150, 0))
		end
	else
		direction = CFrame.new(camera_direction, target_position + Vector3.new(0, 60, 0))

		ball_properties.parry_remote:FireServer(
			0,
			direction,
			{ [AutoParry.target.aim.Name] = target_position },
			{ target_position.X, target_position.Y },
			false
		)
	
		task.delay(0.25, function()
			if ball_properties.parries > 0 then
				ball_properties.parries -= 1
			end
		end)

		return
	end

	ball_properties.parry_remote:FireServer(
		0.5,
		direction,
		{ [AutoParry.target.aim.Name] = target_position },
		{ target_position.X, target_position.Y },
		false
	)

    task.delay(0.25, function()
        if ball_properties.parries > 0 then
            ball_properties.parries -= 1
        end
    end)
end

function AutoParry.reset()
	AutoParry.ball.properties.is_curved = false
    AutoParry.ball.properties.auto_spam = false
    AutoParry.ball.properties.cooldown = false
    AutoParry.ball.properties.maximum_speed = 0
    AutoParry.ball.properties.parries = 0
	AutoParry.entity_properties.server_position = Vector3.zero
	AutoParry.target.current = nil
	AutoParry.target.from = nil
end

ReplicatedStorage.Remotes.PlrHellHooked.OnClientEvent:Connect(function(hooker: Model)
	if hooker.Name == LocalPlayer.Name then
		AutoParry.ball.properties.hell_hook_completed = true

		return
	end

	AutoParry.ball.properties.hell_hook_completed = false
end)

ReplicatedStorage.Remotes.PlrHellHookCompleted.OnClientEvent:Connect(function()
	AutoParry.ball.properties.hell_hook_completed = true
end)

function AutoParry.is_curved()
	local target = AutoParry.target.current

	if not target then
		return false
	end

	local ball_properties = AutoParry.ball.properties
	local current_target = AutoParry.target.current.Name

	if target.PrimaryPart:FindFirstChild('MaxShield') and current_target ~= LocalPlayer.Name and ball_properties.distance < 50 then
		return false
	end

	if AutoParry.ball.ball_entity:FindFirstChild('TimeHole1') and current_target ~= LocalPlayer.Name and ball_properties.distance < 100 then
		ball_properties.auto_spam = false
		
		return false
	end

	if AutoParry.ball.ball_entity:FindFirstChild('WEMAZOOKIEGO') and current_target ~= LocalPlayer.Name and ball_properties.distance < 100 then
		return false
	end

	if AutoParry.ball.ball_entity:FindFirstChild('At2') and ball_properties.speed <= 0 then
		return true
	end

	if AutoParry.ball.ball_entity:FindFirstChild('AeroDynamicSlashVFX') then
		Debris:AddItem(AutoParry.ball.ball_entity.AeroDynamicSlashVFX, 0)

		ball_properties.auto_spam = false
		ball_properties.aero_dynamic_time = tick()
	end

	if RunTime:FindFirstChild('Tornado') then
		if ball_properties.distance > 5 and (tick() - ball_properties.aero_dynamic_time) < (RunTime.Tornado:GetAttribute("TornadoTime") or 1) + 0.314159 then
			return true
		end
	end

	if not ball_properties.hell_hook_completed and target.Name == LocalPlayer.Name and ball_properties.distance > 5 - math.random() then
		return true
	end
	
	local ball_direction = ball_properties.velocity.Unit
	local ball_speed = ball_properties.speed
	
	local speed_threshold = math.min(ball_speed / 100, 40)
	local angle_threshold = 40 * math.max(ball_properties.dot, 0)

	local player_ping = Player.Entity.properties.ping

	local accurate_direction = ball_properties.velocity.Unit
	accurate_direction *= ball_direction

	local direction_difference = (accurate_direction - ball_properties.velocity).Unit
	local accurate_dot = ball_properties.direction:Dot(direction_difference)
	local dot_difference = ball_properties.dot - accurate_dot
	local dot_threshold = 0.5 - player_ping / 1000

	local reach_time = ball_properties.distance / ball_properties.maximum_speed - (player_ping / 1000)
	local enough_speed = ball_properties.maximum_speed > 100

	local ball_distance_threshold = 15 - math.min(ball_properties.distance / 1000, 15) + angle_threshold + speed_threshold
	
	if enough_speed and reach_time > player_ping / 10 then
        ball_distance_threshold = math.max(ball_distance_threshold - 15, 15)
    end
	
	if ball_properties.distance < ball_distance_threshold then
		return false
	end

	if dot_difference < dot_threshold then
		return true
	end

	if ball_properties.lerp_radians < 0.018 then
		ball_properties.last_curve_position = ball_properties.position
		ball_properties.last_warping = tick() 
	end

	if (tick() - ball_properties.last_warping) < (reach_time / 1.5) then
		return true
	end

	return ball_properties.dot < dot_threshold
end

local old_from_target = nil :: Model

function AutoParry:is_spam() --// im autistic 😁
	local target = AutoParry.target.current

	if not target then
		return false
	end

	if AutoParry.target.from ~= LocalPlayer.Character then
		old_from_target = AutoParry.target.from
	end

	if self.parries < 3 and AutoParry.target.from == old_from_target then
		return false
	end

	local player_ping = Player.Entity.properties.ping
	local distance_threshold = 18 + (player_ping / 80)

	local ball_properties = AutoParry.ball.properties
	local reach_time = ball_properties.distance / ball_properties.maximum_speed - (player_ping / 1000)

	if (tick() - self.last_hit) > 0.8 and self.entity_distance > distance_threshold and self.parries < 3 then
		self.parries = 1

		return false
	end

 	if ball_properties.lerp_radians > 0.028 then
		if self.parries > 3 then
			self.parries = 1
		end

		return false
	end

	if (tick() - ball_properties.last_warping) < (reach_time / 1.3) and self.entity_distance > distance_threshold and self.parries < 4 then
		if self.parries > 3 then
			self.parries = 1
		end

		return false
	end

	if math.abs(self.speed - self.old_speed) < 5.2 and self.entity_distance > distance_threshold and self.speed < 60 and self.parries < 3 then
		if self.parries > 3 then
			self.parries = 0
		end

		return false
	end
	
	if self.speed < 10 then
		self.parries = 1

		return false
	end

	if self.maximum_speed < self.speed and self.entity_distance > distance_threshold then
		self.parries = 1
		
		return false
	end

	if self.entity_distance > self.range and self.entity_distance > distance_threshold then
		if self.parries > 2 then
			self.parries = 1
		end

		return false
	end

	if self.ball_distance > self.range and self.entity_distance > distance_threshold then
		if self.parries > 2 then
			self.parries = 2
		end

		return false
	end

	if self.last_position_distance > self.spam_accuracy and self.entity_distance > distance_threshold then
		if self.parries > 4 then
			self.parries = 2
		end

		return false
	end

	if self.ball_distance > self.spam_accuracy and self.ball_distance > distance_threshold then
		if self.parries > 3 then
			self.parries = 2
		end

		return false
	end

	if self.entity_distance > self.spam_accuracy and self.entity_distance > (distance_threshold - math.pi) then
		if self.parries > 3 then
			self.parries = 2
		end

		return false
	end

    return true	
end

function Player:claim_rewards()
	repeat
		task.wait(1)
	until not AutoParry.ball.properties.auto_spam

	local net = ReplicatedStorage:WaitForChild("Packages")['_Index']['sleitnick_net@0.1.0'].net

	ReplicatedStorage:WaitForChild("Remote"):WaitForChild("RemoteEvent"):FireServer('ClaimLoginReward')
	
	task.defer(function()
		for day = 1, 30 do
			task.wait()

			ReplicatedStorage.Remote.RemoteFunction:InvokeServer('ClaimNewDailyLoginReward', day)

			net:WaitForChild("RE/SummerWheel/ProcessRoll"):FireServer()
			net:WaitForChild("RE/SummerWheel/ClaimReward"):FireServer()

			net:WaitForChild("RE/ProcessTournamentEventRoll"):FireServer()
			net:WaitForChild("RE/CyborgWheel/ProcessRoll"):FireServer()
			net:WaitForChild("RE/SynthWheel/ProcessRoll"):FireServer()
			net:WaitForChild("RE/ProcessTournamentRoll"):FireServer()
			net:WaitForChild("RE/RolledReturnCrate"):FireServer()
			net:WaitForChild("RE/ProcessLTMRoll"):FireServer()
		end
	end)

	task.defer(function()
		for reward = 1, 6 do
			net:WaitForChild("RF/ClaimPlaytimeReward"):InvokeServer(reward)
			net:WaitForChild("RE/ClaimSeasonPlaytimeReward"):FireServer(reward)

			ReplicatedStorage:WaitForChild("Remote"):WaitForChild("RemoteFunction"):InvokeServer('SpinWheel')
			net:WaitForChild("RE/SpinFinished"):FireServer()
		end
	end)

	task.defer(function()
		for reward = 1, 5 do
			net:WaitForChild("RF/RedeemQuestsType"):InvokeServer('SummerClashEvent', 'Daily', reward)
		end
	end)

	task.defer(function()
		for reward = 1, 4 do
			net:WaitForChild("RE/SummerWheel/ClaimStreakReward"):FireServer(reward)
		end
	end)
end

RunService:BindToRenderStep('server position simulation', 1, function()
    local ping = Stats.Network.ServerStatsItem['Data Ping']:GetValue()

    if not LocalPlayer.Character then
        return
    end

    if not LocalPlayer.Character.PrimaryPart then
        return
    end

	local PrimaryPart = LocalPlayer.Character.PrimaryPart
    local old_position = PrimaryPart.Position

    task.delay(ping / 1000, function()
        Player.Entity.properties.server_position = old_position
	end)
end)

RunService.PreSimulation:Connect(function()
	NetworkClient:SetOutgoingKBPSLimit(math.huge)

	local character = LocalPlayer.Character
	
	if not character then
		return
	end

	if not character.PrimaryPart then
		return
	end

	local player_properties = Player.Entity.properties

	player_properties.sword = character:GetAttribute('CurrentlyEquippedSword')
    player_properties.ping = Stats.Network.ServerStatsItem['Data Ping']:GetValue()
    player_properties.velocity = character.PrimaryPart.AssemblyLinearVelocity
    player_properties.speed = Player.Entity.properties.velocity.Magnitude
    player_properties.is_moving = Player.Entity.properties.speed > 30
end)

AutoParry.ball.ball_entity = AutoParry.get_ball()
AutoParry.ball.client_ball_entity = AutoParry.get_client_ball()

RunService.PreSimulation:Connect(function()
	local ball = AutoParry.ball.ball_entity
	
	if not ball then
		return
	end

	local zoomies = ball:FindFirstChild('zoomies')

	local ball_properties = AutoParry.ball.properties

    ball_properties.position = ball.Position
	ball_properties.velocity = ball.AssemblyLinearVelocity

	if zoomies then
		ball_properties.velocity = ball.zoomies.VectorVelocity
	end

    ball_properties.distance = (Player.Entity.properties.server_position - ball_properties.position).Magnitude
    ball_properties.speed = ball_properties.velocity.Magnitude
    ball_properties.direction = (Player.Entity.properties.server_position - ball_properties.position).Unit
    ball_properties.dot = ball_properties.direction:Dot(ball_properties.velocity.Unit)
	ball_properties.radians = math.rad(math.asin(ball_properties.dot))
	ball_properties.lerp_radians = linear_predict(ball_properties.lerp_radians, ball_properties.radians, 0.8)

	if not (ball_properties.lerp_radians < 0) and not (ball_properties.lerp_radians > 0) then
		ball_properties.lerp_radians = 0.027
	end

    ball_properties.maximum_speed = math.max(ball_properties.speed, ball_properties.maximum_speed)

    AutoParry.target.aim = (not is_mobile and Player.get_closest_player_to_cursor() or Player.get_aim_entity())

	if ball:GetAttribute('from') ~= nil then
		AutoParry.target.from = Alive:FindFirstChild(ball:GetAttribute('from'))
	end

    AutoParry.target.current = Alive:FindFirstChild(ball:GetAttribute('target'))

	if AutoParry.target == nil then
		return
	end

	ball_properties.rotation = ball_properties.position

	if AutoParry.target.current and AutoParry.target.current.Name == LocalPlayer.Name then
		ball_properties.rotation = AutoParry.target.aim.PrimaryPart.Position

		return
	end

	if not AutoParry.target.current then
		return
	end

	local target_server_position = AutoParry.target.current.PrimaryPart.Position
    local target_velocity = AutoParry.target.current.PrimaryPart.AssemblyLinearVelocity
    
    AutoParry.entity_properties.server_position = target_server_position
    AutoParry.entity_properties.velocity = target_velocity
    AutoParry.entity_properties.distance = LocalPlayer:DistanceFromCharacter(target_server_position)
    AutoParry.entity_properties.direction = (Player.Entity.properties.server_position - target_server_position).Unit
    AutoParry.entity_properties.speed = target_velocity.Magnitude
    AutoParry.entity_properties.is_moving = target_velocity.Magnitude > 0.1
    AutoParry.entity_properties.dot = AutoParry.entity_properties.is_moving and math.max(AutoParry.entity_properties.direction:Dot(target_velocity.Unit), 0)
end)

local LocalPlayer = Players.LocalPlayer

local main = interface.create({
	name = 'Nurysium',
	parent = gethui()
})

local blatant = main.create_tab('Blatant', 'rbxassetid://76028667326757')
local visuals = main.create_tab('Visuals', 'rbxassetid://18782727355')
local misc = main.create_tab('Misc', 'rbxassetid://18782883071')

--// auto parry

do
	local auto_parry = blatant.create_module({
		text = 'Auto Parry',
		flag = 'auto_parry',
		side = 'left'
	})

	local auto_parry_rotation = auto_parry.create_toggle({
		title = 'Rotation',
		flag = 'auto_parry_rotation'
	})

	local auto_parry_rotation_acuity = auto_parry.create_slider({
		value = 5,
		title = 'Acuity',
		flag = 'auto_parry_rotation_acuity'
	})
	
	local curve_method = auto_parry.create_dropdown({
		title = 'Curve Method',
		flag = 'curve_method',
		mods = {
			'Accelerated',
			'Backwards',
			'Linear',
			'Camera',
			'Random'
		}
	})
end

--// win sound

do
	local win_sound = blatant.create_module({
		text = 'Win Sound',
		flag = 'win_sound',
		side = 'right'
	})
end

--// hit sound

do
	local hit_sound = blatant.create_module({
		text = 'Hit Sound',
		flag = 'hit_sound',
		side = 'right'
	})
end

--// no slow

do
	local no_slow = blatant.create_module({
		text = 'No Slow',
		flag = 'no_slow',
		side = 'right'
	})
end

--// no render

do
	local no_render = visuals.create_module({
		text = 'No Render',
		flag = 'no_render',
		side = 'right'
	})	

	local smart_no_render = no_render.create_toggle({
		title = 'Smart',
		flag = 'smart_no_render'
	})
end

--// shaders

do
	local shaders = visuals.create_module({
		text = 'Shaders',
		flag = 'shaders',
		side = 'left'
	})

	local shaders_intensity = shaders.create_slider({
		value = 50,
		title = 'Intensity',
		flag = 'shaders_intensity'
	})
	
	local shaders_size = shaders.create_slider({
		value = 70,
		title = 'Size',
		flag = 'shaders_size'
	})

	local shaders_threshold = shaders.create_slider({
		value = 100,
		title = 'Threshold',
		flag = 'shaders_threshold'
	})
	
	local environment_diffuse_scale = shaders.create_slider({
		value = 100,
		title = 'Diffuse Scale',
		flag = 'environment_diffuse_scale'
	})

	local environment_specular_scale = shaders.create_slider({
		value = 100,
		title = 'Specular Scale',
		flag = 'environment_specular_scale'
	})
	
	local shaders_ray_tracing = shaders.create_toggle({
		title = 'Ray Tracing',
		flag = 'ray_tracing'
	})
end

--// Ambient

do
	local ambient = visuals.create_module({
		text = 'Ambient',
		flag = 'ambient',
		side = 'right'
	})
	
	local ambient_density = ambient.create_slider({
		value = 50,
		title = 'Density',
		flag = 'ambient_density'
	})	
end

--// night mode

do
	local night_mode = visuals.create_module({
		text = 'Night Mode',
		flag = 'night_mode',
		side = 'left'
	})
end

--// plushie

do
	local plushie = visuals.create_module({
		text = 'Plushie',
		flag = 'plushie',
		side = 'right'
	})
	
	local plushie_dropdown = plushie.create_dropdown({
		title = 'Plushie type',
		flag = 'plushie_type',
		mods = {
			'Pillow',
			'Touhou',
			'Shion',
			'Miku',
			'Sino',
			'Soi' 
		}
	})
end

--// color shift

do
	local color_shift = visuals.create_module({
		text = 'Color Shift',
		flag = 'color_shift',
		side = 'right'
	})
end

--// skybox

do
	local skybox = visuals.create_module({
		text = 'Skybox',
		flag = 'skybox',
		side = 'left'
	})
	
	local remove_clouds = skybox.create_toggle({
		title = 'Remove Clouds',
		flag = 'remove_clouds'
	})
	
	local skybox_dropdown = skybox.create_dropdown({
		title = 'Skybox type',
		flag = 'skybox_type',
		mods = {
			'Anime',
			'Rufus',
			'Fantasy',
			'Angelic',
			'Clouded',
			'Lyfestyle',
			'Deepspace',
			'Spongebob',
			'Morning Mudd',
			'Met Tha Devil'
		}
	})
end

--// trail

do
	local trail = visuals.create_module({
		text = 'Trail',
		flag = 'trail',
		side = 'right'
	})
	
	local trail_scale = trail.create_slider({
		value = 30,
		title = 'Scale',
		flag = 'trail_scale'
	})
end

--// hit effect

do
	local hit_effect = visuals.create_module({
		text = 'Hit Effect',
		flag = 'hit_effect',
		side = 'left'
	})
end

--// auto rewards

do
	local auto_rewards = misc.create_module({
		text = 'Auto Rewards',
		flag = 'auto_rewards',
		side = 'right'
	})	
end

--// strafe

do
	local strafe = misc.create_module({
		text = 'Strafe',
		flag = 'strafe',
		side = 'left'
	})	
	
	local strafe_speed = strafe.create_slider({
		value = 50,
		title = 'Speed',
		flag = 'strafe_speed'
	})
end

--// personnel detector

do
	local personnel_detector = misc.create_module({
		text = 'Personnel Detector',
		flag = 'personnel_detector',
		side = 'right'
	})
	
	local personnel_detector_auto_leave = personnel_detector.create_toggle({
		title = 'Auto Leave',
		flag = 'personnel_detector_auto_leave'
	})
end

--// gravity

do
	local gravity = misc.create_module({
		text = 'Gravity',
		flag = 'gravity',
		side = 'left'
	})
	
	local gravity_strength = gravity.create_slider({
		value = 50,
		title = 'Gravity',
		flag = 'gravity_strength'
	})
end

--// camera

do
	local camera = misc.create_module({
		text = 'Camera',
		flag = 'camera',
		side = 'right'
	})
	
	local field_of_view = camera.create_slider({
		value = 70,
		title = 'Field Of View',
		flag = 'field_of_view'
	})
end

--// ability vulnerability

do
	local ability_vulnerability = misc.create_module({
		text = 'Ability Vulnerability',
		flag = 'ability_vulnerability',
		side = 'left'
	})
	
	local ability_vulnerability_mode = ability_vulnerability.create_dropdown({
		title = 'Mode',
		flag = 'ability_vulnerability_mode',
		mods = {
			'Continuity Zero',
			'Quad Jump',
			'Quasar'
		}
	})	
end

--// animations

local animations = misc.create_module({
	text = 'Animations',
	flag = 'animations',
	side = 'right'
})

local smart_animations = animations.create_toggle({
	title = 'Smart',
	flag = 'smart_animations'
})

local dropdown_emotes_table = {}
local emote_instances = {}

for _, emote in ReplicatedStorage.Misc.Emotes:GetChildren() do
	local emote_name = emote:GetAttribute('EmoteName')

	if not emote_name then
	return
	end

	table.insert(dropdown_emotes_table, emote_name)
	emote_instances[emote_name] = emote
end

local animation_type = animations.create_dropdown({
	title = 'Animation',
	flag = 'animation_type',
	mods = dropdown_emotes_table
})

LocalPlayer.Idled:Connect(function()
	VirtualUser:CaptureController()
	VirtualUser:ClickButton2(Vector2.zero)
end)

local current_animation = nil
local current_animation_name = nil

local looped_emotes = {
    "Emote108",
    "Emote225",
    "Emote300",
    "Emote301"
}

ConnectionsManager['animations'] = RunService.Heartbeat:Connect(function()
	local character = LocalPlayer.Character

	if not character then
		if current_animation then
			current_animation:Stop()
			current_animation:Destroy()
		end

		current_animation = nil
		current_animation_name = nil

		return
	end

	local humanoid = character:FindFirstChildOfClass('Humanoid')

	if not humanoid or humanoid.Health <= 0 then
		if current_animation then
			current_animation:Stop()
			current_animation:Destroy()
		end

		current_animation = nil
		current_animation_name = nil

		return
	end

	local animations_enabled = interface.flags['animations']
	local animation_type = interface.flags['animation_type']

	if not animations_enabled then
		if current_animation then
			current_animation:Stop()
			current_animation:Destroy()
			current_animation = nil
			current_animation_name = nil
		end

		return
	end

	local smart_animations_enabled = interface.flags['smart_animations']

	if smart_animations_enabled and Player.Entity.properties.is_moving then
		if current_animation then
			current_animation:Stop()
			current_animation:Destroy()
			current_animation = nil
			current_animation_name = nil
		end
		return
	end

	if not animation_type or current_animation_name == animation_type then
		return
	end

	if current_animation then
		current_animation:Stop()
		current_animation:Destroy()
		current_animation = nil
		current_animation_name = nil
	end

	local animation_object = emote_instances[animation_type]

	if not animation_object then
		return
	end

	local animator = humanoid:FindFirstChildOfClass('Animator')

	if not animator then
		if current_animation then
			current_animation:Stop()
			current_animation:Destroy()
		end	

		current_animation = nil
		current_animation_name = nil

		return
	end

	local animation = Instance.new('Animation')
	animation.AnimationId = animation_object.AnimationId

	current_animation = animator:LoadAnimation(animation)
	current_animation_name = animation_type

	if not table.find(looped_emotes, animation_object.Name) then
		current_animation.Looped = true
	end

	local time_position = {}

	current_animation:GetMarkerReachedSignal('Pin'):Connect(function(state)
		time_position[state] = current_animation.TimePosition
	end)

	current_animation:GetMarkerReachedSignal('GOTO'):Connect(function(state)
		local current_time_position = time_position[state]

		if current_time_position then
			current_animation.TimePosition = current_time_position
		end
	end)

	ReplicatedStorage.Remotes.CustomEmote:FireServer(true, animation_object.Name)
	current_animation:Play()
end)

ConnectionsManager['camera_field_of_view'] = RunService.PostSimulation:Connect(function()
	if not workspace.CurrentCamera then
		return
	end

	local character = LocalPlayer.Character

	if not character then
		return
	end

	local camera_enabled = interface.flags['camera']

	local current_camera = workspace.CurrentCamera

	if not camera_enabled then
		current_camera.FieldOfView = 70

		return
	end

	local field_of_view = interface.flags['field_of_view']

	current_camera.FieldOfView = field_of_view

	if AutoParry.ball.client_ball_entity == nil or #workspace.Balls:GetChildren() == 0 then
		current_camera.CameraSubject = LocalPlayer.Character

		return
	end
end)

local spamming_done = true :: boolean

ConnectionsManager['ability_vulnerability'] = RunService.PostSimulation:Connect(function()
	local ability_vulnerability_enabled = interface.flags['ability_vulnerability']

	if not ability_vulnerability_enabled then
		spamming_done = true
		
		return
	end

	
	local character = LocalPlayer.Character

	if not character then
		return
	end

	if Player.Entity.properties.ping > 250 then
		return
	end

	local mode = interface.flags['ability_vulnerability_mode']

	if not spamming_done then
		return
	end

	if not character.Abilities[mode].Enabled then
		return
	end

	if not mode or mode == 'Quad Jump' then
		spamming_done = false

		for threads = 1, 3650 do
			ReplicatedStorage.Remotes.XtraJumped:FireServer()
		end

		spamming_done = true
	elseif mode == 'Continuity Zero' and AutoParry.target.current ~= LocalPlayer.Character then
		spamming_done = false

		ReplicatedStorage.Remotes.UseContinuityPortal:FireServer(CFrame.new(tick(), tick(), tick(), tick(), tick(), tick(), tick()))

		task.delay(20, function()
			spamming_done = true
		end)
	elseif mode == 'Quasar' then
		spamming_done = false
			
		ReplicatedStorage.Remotes.PlrQuasared:FireServer(AutoParry.target.aim)

		task.delay(0.085, function()
			spamming_done = true
		end)
	end
end)


ConnectionsManager['gravity'] = RunService.PostSimulation:Connect(function()
	if not workspace.CurrentCamera then
		return
	end

	local character = LocalPlayer.Character

	if not character then
		return
	end

	local gravity_enabled = interface.flags['gravity']

	if not gravity_enabled then
		workspace.Gravity = 196.2

		return
	end

	local strength = interface.flags['gravity_strength']

	workspace.Gravity = 196.2 / (strength / 10)
end)

local function clear_skyboxes()
	for _, child in Lighting:GetChildren() do
		if not child:IsA('Sky') then
			continue
		end

		Debris:AddItem(child, 0)
	end
end

Lighting.ChildAdded:Connect(function(child)
	if interface.disconnected then
        return
    end

	local skybox_enabled = interface.flags['skybox']

	if not selected_skybox then
		selected_skybox = 'Anime'
	end

	if skybox_enabled and child:IsA('Sky') then
		clear_skyboxes()

		local selected_skybox = interface.flags['skybox_type']

		local skybox = effects_folder.skyboxes:FindFirstChild(selected_skybox)

		if not skybox then
			return
		end

		if Lighting:FindFirstChild(skybox) then
			return
		end

		skybox:Clone().Parent = Lighting
	end
end)

ConnectionsManager['skybox_connection'] = RunService.PostSimulation:Connect(function()
	local skybox_enabled = interface.flags['skybox']
	local selected_skybox = interface.flags['skybox_type']

	if not selected_skybox then
		selected_skybox = 'Anime'
	end

	local remove_clouds = interface.flags['remove_clouds']

	if not skybox_enabled then
		clear_skyboxes()

		workspace.Terrain.Clouds.Enabled = true

		return
	end

	if remove_clouds then
		workspace.Terrain.Clouds.Enabled = false
	else
		workspace.Terrain.Clouds.Enabled = true
	end

	if not Lighting:FindFirstChild(selected_skybox) then
		clear_skyboxes()

		local skybox = effects_folder.skyboxes:FindFirstChild(selected_skybox)

		if not skybox then
			return
		end

		if Lighting:FindFirstChild(skybox) then
			return
		end

		local cloned_skybox = skybox:Clone()
		
		cloned_skybox.Parent = Lighting
	end
end)

local staff_roles = {
	'content creator',
	'contributor',
	'trial qa',
	'tester',
	'mod'
}

Players.PlayerAdded:Connect(function(player)
	local is_friend = LocalPlayer:IsFriendsWith(player.UserId)

	if is_friend then
		notify.draw_notify('Friend ' .. player.Name .. ' joined!', 4)
	end
	
	local personnel_detector_enabled = interface.flags['personnel_detector']

	if not personnel_detector_enabled then
		return
	end
	
	local personnel_detector_auto_leave_enabled = interface.flags['personnel_detector_auto_leave']

	local player_role = tostring(player:GetRoleInGroup(12836673)):lower()
	local player_is_staff = table.find(staff_roles, player_role)

	if player_is_staff then
		if personnel_detector_auto_leave_enabled then
			game:Shutdown()
			
			return
		end
	
		notify.draw_notify('Personnel joined, ' .. player.Name .. ', role ' .. player_role .. '.', 30)
	end
end)

ConnectionsManager['strafe'] = RunService.PostSimulation:Connect(function()
	if not LocalPlayer.Character then
		return
	end

	local strafe_enabled = interface.flags['strafe']

	if not strafe_enabled then
		return
	end

	local strength = interface.flags['strafe_speed']
	
	if not LocalPlayer.Character.PrimaryPart then
        return
    end

	local Humanoid = LocalPlayer.Character.Humanoid

	if not Humanoid then
		return
	end

	if Humanoid.MoveDirection.Magnitude < 0 then
       return
	end

	LocalPlayer.Character:TranslateBy(LocalPlayer.Character.Humanoid.MoveDirection * math.max((strength / 15), 2) * RunService.Heartbeat:Wait() * 10)
end)

ConnectionsManager['no_slow'] = RunService.PostSimulation:Connect(function()
	if not LocalPlayer.Character then
		return
	end

	local no_slow_enabled = interface.flags['no_slow']

	if not no_slow_enabled then
		return
	end

	if not Alive:FindFirstChild(LocalPlayer.Name) then
		return
	end

	if not LocalPlayer.Character:FindFirstChild('Humanoid') then
		return
	end

	if LocalPlayer.Character.Humanoid.WalkSpeed < 36 then
		LocalPlayer.Character.Humanoid.WalkSpeed = 36
	end
end)

task.defer(function()
	while task.wait(60) do
		local auto_rewards_enabled = interface.flags['auto_rewards']
		
		if auto_rewards_enabled then
			Player.claim_rewards()
		end
	end
end)

ConnectionsManager['trail'] = RunService.PostSimulation:Connect(function()
	if not LocalPlayer.Character then
		return
	end

	if not LocalPlayer.Character.PrimaryPart then 
		return
	end

	local trail_enabled = interface.flags['trail']

	if not trail_enabled then
		if LocalPlayer.Character.PrimaryPart:FindFirstChild('nurysium_trail') then
			Debris:AddItem(LocalPlayer.Character.PrimaryPart['nurysium_trail'], 0)
		end

		return
	end

	if LocalPlayer.Character.PrimaryPart:FindFirstChild('nurysium_trail') then
		local trail = LocalPlayer.Character.PrimaryPart['nurysium_trail']

		trail.Position = LocalPlayer.Character.PrimaryPart.Position

		local trail_scale = interface.flags['trail_scale']
		local calculeted_scale = trail_scale / 100

		trail['down_line'].Lifetime = calculeted_scale
		trail['upper_line'].Lifetime = calculeted_scale
		trail['trail'].Lifetime = calculeted_scale

		return
	end

	local trail = effects_folder:FindFirstChild('Trail')

	if not trail then
		return
	end

	local cloned_trail = trail:Clone()
	
	cloned_trail.Name = 'nurysium_trail'
	cloned_trail.Parent = LocalPlayer.Character.PrimaryPart
end)

ConnectionsManager['color_shift'] = RunService.PostSimulation:Connect(function()
	if not workspace.CurrentCamera then
		return
	end

	local color_shift_enabled = interface.flags['color_shift']

	if not color_shift_enabled then
		local color_shift = workspace.CurrentCamera:FindFirstChild('color_shift') 

		if color_shift then
			color_shift.Saturation = 0
			color_shift.Brightness = 0
			color_shift.Contrast = 0

			Debris:AddItem(color_shift, 0)
		end

		return
	end

	if not workspace.CurrentCamera:FindFirstChild('color_shift') then
		local cloned_effect = color_shift_effect:Clone()

		cloned_effect.Name = 'color_shift'
		cloned_effect.Parent = workspace.CurrentCamera
	end

	workspace.CurrentCamera['color_shift'].Saturation = -0.7
	workspace.CurrentCamera['color_shift'].Contrast = 0.1

	Lighting.ExposureCompensation = -0.7
end)

local plushie_temp = Instance.new('Folder', workspace)
plushie_temp.Name = names_map['protected']

local function clear_all_plushies()
	if #plushie_temp:GetChildren() == 0 then
		return
	end

	for _, mesh in plushie_temp:GetChildren() do
		Debris:AddItem(mesh, 0)
	end
end

ConnectionsManager['plushie'] = RunService.RenderStepped:Connect(function()
    local plushie_enabled = interface.flags['plushie']
    local selected_plushie = interface.flags['plushie_type']

    if not plushie_enabled then
        clear_all_plushies()

        return
    end

    if not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then
        return
    end

	local protected_name = names_map[selected_plushie]

    if plushie_temp:FindFirstChild(protected_name) then
        local plushie = plushie_temp[protected_name]
        local Root = plushie

        local target_CFrame = LocalPlayer.Character.PrimaryPart.CFrame 
            * CFrame.new(Vector3.new(-2 - math.cos(tick() / 2), 6.5 + math.cos(tick() / 2), -2 - math.sin(tick() / 2))) 
            * CFrame.Angles(0, math.rad(-90), 0)

		if selected_plushie == 'Miku' then
			target_CFrame = LocalPlayer.Character.PrimaryPart.CFrame 
            * CFrame.new(Vector3.new(-2 - math.cos(tick() / 2), 6.5 + math.cos(tick() / 2), -2 - math.sin(tick() / 2)))
		end

		if selected_plushie == 'Sino' then
			target_CFrame = LocalPlayer.Character.PrimaryPart.CFrame 
            * CFrame.new(Vector3.new(-2 - math.cos(tick() / 2), 6.5 + math.cos(tick() / 2), -2 - math.sin(tick() / 2)))
			* CFrame.Angles(math.rad(90), math.rad(0), math.rad(260))
		end

		if selected_plushie == 'Pillow' then
			target_CFrame = LocalPlayer.Character.PrimaryPart.CFrame 
            * CFrame.new(Vector3.new(-2 - math.cos(tick() / 2), 6.5 + math.cos(tick() / 2), -2 - math.sin(tick() / 2)))
			* CFrame.Angles(math.rad(180 - math.cos(tick() / 5) * 4), math.rad(0), math.rad(180 + math.cos(tick() / 8) * 4))
		end

		if selected_plushie == 'Shion' then
			target_CFrame = LocalPlayer.Character.PrimaryPart.CFrame 
            * CFrame.new(Vector3.new(-2 - math.cos(tick() / 2), 6.5 + math.cos(tick() / 2), -2 - math.sin(tick() / 2)))
			* CFrame.Angles(math.rad(110), math.rad(0), math.rad(90))
		end

		if selected_plushie == 'Soi' then
			target_CFrame = LocalPlayer.Character.PrimaryPart.CFrame 
            * CFrame.new(Vector3.new(-2 - math.cos(tick() / 2), 6.5 + math.cos(tick() / 2), -2 - math.sin(tick() / 2)))
			* CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))
		end

		create_animation(Root, TweenInfo.new(1.45), {
			CFrame = target_CFrame
		})
    else
		clear_all_plushies()

        local new_plushie = objects_folder:FindFirstChild(selected_plushie)

        if new_plushie then
            local plushie_clone = new_plushie:Clone()

            plushie_clone.Parent = plushie_temp
            plushie_clone.Name = protected_name
        end
    end		
end)

ConnectionsManager['night_mode'] = RunService.PostSimulation:Connect(function()
	local night_mode_enabled = interface.flags['night_mode']

	if not night_mode_enabled then
		if Lighting.ClockTime == 11.2 then
			return
		end

		create_animation(Lighting, TweenInfo.new(1.6), {
			ClockTime = 11.2
		})

		return
	end

	if Lighting.ClockTime ==  2.5 then
		return
	end

	create_animation(Lighting, TweenInfo.new(1.6), {
		ClockTime = 2.5
	})
end)

ConnectionsManager['shaders'] = RunService.PostSimulation:Connect(function()		
	local shaders_enabled = interface.flags['shaders']
		
 	if not shaders_enabled then
		Lighting.Technology = "ShadowMap"

		Lighting.Bloom.Intensity = 1
		Lighting.Bloom.Size = 25
		Lighting.Bloom.Threshold = 1.75

		return
	end
	
	local shaders_intensity_value = interface.flags['shaders_intensity'] / 150
	local shaders_size_value = interface.flags['shaders_size'] / math.pi
	local shaders_threshold_value = interface.flags['shaders_threshold'] / 135

	local environment_specular_scale_value = interface.flags['environment_specular_scale'] / 100
	local environment_diffuse_scale_value = interface.flags['environment_diffuse_scale'] / 100

	Lighting.EnvironmentSpecularScale = environment_specular_scale_value
	Lighting.EnvironmentDiffuseScale = environment_diffuse_scale_value
	
	Lighting.Bloom.Intensity = shaders_intensity_value
	Lighting.Bloom.Size = shaders_size_value
	Lighting.Bloom.Threshold = shaders_threshold_value

	local shaders_raytracing_enabled = interface.flags['ray_tracing']

 	if not shaders_raytracing_enabled then
		Lighting.Technology = "ShadowMap"

		return
	end

	Lighting.Technology = "Future"
end)

ConnectionsManager['ambient'] = RunService.PostSimulation:Connect(function()
	local ambient_enabled = interface.flags['ambient']
	local secured_name = names_map['protected']

	if not ambient_enabled then
		local nurysium_atmosphere = Lighting:FindFirstChild(secured_name)

		if nurysium_atmosphere then
			create_animation(nurysium_atmosphere, TweenInfo.new(2), {
				Density = 0
			})

			Debris:AddItem(nurysium_atmosphere, 2)
		end

		return
	end

	local nurysium_atmosphere = Lighting:FindFirstChild(secured_name)

	if nurysium_atmosphere then
		local density_strength = interface.flags['ambient_density'] / 100
	
		if nurysium_atmosphere.Density == density_strength then
			return
		end

		create_animation(nurysium_atmosphere, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {
			Density = density_strength
		})

		return
	end

	local atmosphere = effects_folder:FindFirstChildOfClass('Atmosphere')

	if not atmosphere then
		return
	end

	local cloned_atmosphere = atmosphere:Clone()

	cloned_atmosphere.Parent = Lighting
	cloned_atmosphere.Name = secured_name
	cloned_atmosphere.Glare = 0
	cloned_atmosphere.Density = 0
end)

local is_respawned = false :: boolean

workspace.Balls.ChildRemoved:Connect(function(child)
	is_respawned = false
	
	if child == AutoParry.ball.ball_entity then
		AutoParry.ball.ball_entity = nil
		AutoParry.ball.client_ball_entity = nil

		ConnectionsManager.disconnect('on_target_change')
		AutoParry.reset()
	end
end)

workspace.Balls.ChildAdded:Connect(function()
	if is_respawned then
		return
	end

	is_respawned = true

	local ball_properties = AutoParry.ball.properties

	ball_properties.respawn_time = tick()

	AutoParry.ball.ball_entity = AutoParry.get_ball()
	AutoParry.ball.client_ball_entity = AutoParry.get_client_ball()

	ConnectionsManager['on_target_change'] = AutoParry.ball.ball_entity:GetAttributeChangedSignal('target'):Connect(function()
		if target == LocalPlayer.Name then
			ball_properties.cooldown = false

			return
		end

		ball_properties.cooldown = false
		ball_properties.old_speed = ball_properties.speed
		ball_properties.last_position = ball_properties.position
	
		ball_properties.parries += 1
	
		task.delay(0.25, function()
			if ball_properties.parries > 0 then
				ball_properties.parries -= 1
			end
		end)	
	end)
end)

RunService.PreSimulation:Connect(function()
	if not AutoParry.ball.properties.auto_spam then
		return
    end

	AutoParry.perform_parry()
end)

local custom_win_audio = Instance.new('Sound', sounds_folder)

ReplicatedStorage.Remotes.WinnerText.OnClientEvent:Connect(function(winner_text: string)
	if winner_text:find(LocalPlayer.DisplayName) then
		local win_sound_enabled = interface.flags['win_sound']

		if win_sound_enabled then
			if isfile('Nurysium/assets/win_round.mp3') then
				custom_win_audio.SoundId = getcustomasset('Nurysium/assets/win_round.mp3')
				custom_win_audio:Play()
			else
				notify.draw_notify('[Nurysium]: win sound is missing! add file in Nurysium/assets/win_round.mp3', 15)
			end
		end
	end
end)

ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function(slash: any, root: any)
	task.spawn(function()
		if root.Parent and root.Parent ~= LocalPlayer.Character then
			if root.Parent.Parent ~= Alive then
				return
			end
	
			AutoParry.ball.properties.cooldown = false
		end
	end)

	if AutoParry.ball.properties.auto_spam then
		AutoParry.perform_parry()
	end
end)

local custom_audio = Instance.new('Sound', sounds_folder)

ReplicatedStorage.Remotes.ParrySuccess.OnClientEvent:Connect(function()
	if LocalPlayer.Character.Parent ~= Alive then
		return
	end

	if not Player.properties.grab_animation then
		return
	end

	Player.properties.grab_animation:Stop()
	
	local ball = AutoParry.get_client_ball()

	if not ball then
		return
	end

	local hit_sound_enabled = interface.flags['hit_sound']

	if hit_sound_enabled then
		if isfile('Nurysium/assets/hit1.mp3') and isfile('Nurysium/assets/hit2.mp3') then
			local random_sound_id = getcustomasset(`Nurysium/assets/hit{math.random(1, 2)}.mp3`)

			custom_audio.SoundId = random_sound_id
			custom_audio:Play()
		else
			notify.draw_notify('[Nurysium]: hit sound is missing! add file in Nurysium/assets/hit1.mp3 and Nurysium/assets/hit2.mp3', 15)
		end
	end

	local hit_effect_enabled = interface.flags['hit_effect']
	local hit_effect_vfx = effects_folder:FindFirstChild('HitEffect')

	if hit_effect_vfx and hit_effect_enabled then
		local cloned_hit_effect = hit_effect_vfx:Clone()

		cloned_hit_effect.Name = names_map['protected']
		cloned_hit_effect.Parent = ball

		cloned_hit_effect:Emit(10)

		Debris:AddItem(cloned_hit_effect, 3)
	end

	ball = nil
end)

local function look_at(primary_part, position, delta, radians)
    local primary_part_pos = primary_part.Position
    local target_pos = position

    primary_part_pos = Vector3.new(primary_part_pos.X, 0, primary_part_pos.Z)
    target_pos = Vector3.new(target_pos.X, 0, target_pos.Z)

    local primary_part_look_vector = primary_part.CFrame.LookVector
    primary_part_look_vector = Vector3.new(primary_part_look_vector.X, 0, primary_part_look_vector.Z).unit

    local lerp_vector = primary_part_look_vector:Lerp((target_pos - primary_part_pos).unit, delta)

    if lerp_vector:Dot(primary_part_look_vector) < math.cos(math.rad(radians)) then
        lerp_vector = CFrame.Angles(0, math.rad(radians), 0) * primary_part_look_vector
    end

    primary_part.CFrame = CFrame.lookAt(primary_part.Position, primary_part.Position + lerp_vector)
end

ConnectionsManager['auto_parry_rotation'] = RunService.PostSimulation:Connect(function()
	local auto_parry_rotation_enabled = interface.flags['auto_parry_rotation']

	if not auto_parry_rotation_enabled then
		return
	end

	local character = LocalPlayer.Character

	if not character then
		return
	end

	if not character.PrimaryPart then
		return
	end

	local humanoid = character:FindFirstChildOfClass('Humanoid')

	if not humanoid or humanoid.Health <= 0 then
		return
	end

	if Dead:FindFirstChild(LocalPlayer.Name) then
		humanoid.AutoRotate = true

		return
	end

	local ball = AutoParry.get_ball()

	if not ball then
		return
	end

	local auto_parry_rotation_acuity_value = interface.flags['auto_parry_rotation_acuity'] / 100

	local ball_properties = AutoParry.ball.properties

	if AutoParry.ball.properties.speed < 10 or AutoParry.ball.properties.distance < 20 + ball_properties.speed / 2 then
		look_at(character.PrimaryPart, ball_properties.rotation, auto_parry_rotation_acuity_value / 2, 25)

		return
	end

	look_at(character.PrimaryPart, ball_properties.rotation, auto_parry_rotation_acuity_value, 25)
end)

ConnectionsManager['auto_parry'] = RunService.PostSimulation:Connect(function()
	local auto_parry_enabled = interface.flags['auto_parry']

	if not auto_parry_enabled then
		AutoParry.reset()

        return
    end

	local Character = LocalPlayer.Character

	if not Character then
		return
	end

    if Character.Parent == Dead then
		AutoParry.reset()
		
        return
    end

    if not AutoParry.ball.ball_entity then
        return
    end

	local ball_properties = AutoParry.ball.properties

	ball_properties.is_curved = AutoParry.is_curved()
	
	local ping_threshold = math.clamp(Player.Entity.properties.ping / 10, 10, 16)
	local spam_accuracity = ball_properties.maximum_speed / 7 + ping_threshold
	local parry_accuracity = ball_properties.maximum_speed / 11.5 + ping_threshold

	ball_properties.spam_range = ping_threshold + ball_properties.speed / 2.3
    ball_properties.parry_range = ping_threshold + ball_properties.speed / math.pi

	if Player.Entity.properties.sword == 'Titan Blade' then
		ball_properties.parry_range += 11
		ball_properties.spam_range += 2
	end	

	local distance_to_last_position = LocalPlayer:DistanceFromCharacter(ball_properties.last_position)

	if ball_properties.auto_spam and AutoParry.target.current then
		ball_properties.auto_spam = AutoParry.is_spam({
			speed = ball_properties.speed,
			spam_accuracy = spam_accuracity,
			parries = ball_properties.parries,
			ball_speed = ball_properties.speed,
			range = ball_properties.spam_range / (3.15 - ping_threshold / 10),
			last_hit = ball_properties.last_hit,
			ball_distance = ball_properties.distance,
			maximum_speed = ball_properties.maximum_speed,
			old_speed = AutoParry.ball.properties.old_speed,
			entity_distance = AutoParry.entity_properties.distance,
			last_position_distance = distance_to_last_position,
		})
	end

	if ball_properties.auto_spam then
        return
    end

	if AutoParry.target.current and AutoParry.target.current.Name == LocalPlayer.Name then
		ball_properties.auto_spam = AutoParry.is_spam({
			speed = ball_properties.speed,
			spam_accuracy = spam_accuracity,
			parries = ball_properties.parries,
			ball_speed = ball_properties.speed,
			range = ball_properties.spam_range,
			last_hit = ball_properties.last_hit,
			ball_distance = ball_properties.distance,
			maximum_speed = ball_properties.maximum_speed,
			old_speed = AutoParry.ball.properties.old_speed,
			entity_distance = AutoParry.entity_properties.distance,
			last_position_distance = distance_to_last_position,
		})
	end

	if ball_properties.auto_spam then
        return
    end
	
	if ball_properties.is_curved then
        return
    end

	if ball_properties.distance > ball_properties.parry_range and ball_properties.distance > parry_accuracity then
        return
    end
	
	if AutoParry.target.current and AutoParry.target.current ~= LocalPlayer.Character then
        return
    end

	AutoParry.perform_parry()

	task.spawn(function()
		repeat
			RunService.PreSimulation:Wait(0)
		until 
			(tick() - ball_properties.last_hit) > 1 - (ping_threshold / 100)

		ball_properties.cooldown = false
	end)
end)

task.defer(function()
	RunTime.ChildAdded:Connect(function(child)
		local no_render_enabled = interface.flags['no_render']
	
		local smart_no_render_enabled = interface.flags['smart_no_render']
		local ability_vulnerability_enabled = interface.flags['ability_vulnerability']

		if no_render_enabled then
            if AutoParry.ball.properties.auto_spam then
				AutoParry.perform_parry()
			end

			if (smart_no_render_enabled and not ability_vulnerability_enabled) and not AutoParry.ball.properties.auto_spam then
				LocalPlayer.PlayerScripts.EffectScripts.ClientFX.Enabled = true

				return
			end

			LocalPlayer.PlayerScripts.EffectScripts.ClientFX.Enabled = false

			if child.Name == 'Tornado' then
				return
			end

			Debris:AddItem(child, 0)

			return
		end

		LocalPlayer.PlayerScripts.EffectScripts.ClientFX.Enabled = true
	end)
end)

task.delay(30, function()
	if interface.disconnected then
        return
    end

	local player_ping = Player.Entity.properties.ping

    if player_ping > 100 and player_ping < 200 then
        notify.draw_notify('[Warning]: Low connection speed, delays may occur.', 15)
    end

    if player_ping >= 200 then
        notify.draw_notify('[Warning]: Critically slow connection speed, delays ensured.', 15)
    end
end)