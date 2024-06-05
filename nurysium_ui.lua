local nurysium = {}

local tween_service = game:GetService("TweenService")
local user_input = game:GetService("UserInputService")

local ui = nil
local uiVisible = nil

local search_table = {}
local ui_data = {
	current_section = "nil"
}

local color_shader = Instance.new("ColorCorrectionEffect", workspace.CurrentCamera)
local blur_shader = Instance.new("BlurEffect", workspace.CurrentCamera)

local is_Mobile = game:GetService("UserInputService").TouchEnabled

if not is_Mobile then
	blur_shader.Size = 256
	color_shader.Saturation = -1
end

local function animate_elements(speed: number)
	ui.Background["functions_frame"].UIListLayout.Padding = UDim.new(0.45, 0)

	tween_service:Create(ui.Background["functions_frame"].UIListLayout, TweenInfo.new(speed, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
		Padding = UDim.new(0.015, 0)
	}):Play()
end

function nurysium: open()
	tween_service:Create(color_shader, TweenInfo.new(1.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
		Saturation = -1
	}):Play()

	tween_service:Create(blur_shader, TweenInfo.new(0.65, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
		Size = 256
	}):Play()

	task.delay(0.65, function()
		ui.Background["functions_frame"].Visible = true
		ui.Background.Sections.Visible = true
		ui.Background.Search.Visible = true
	end)

	tween_service:Create(ui.Background["functions_frame"].UIListLayout, TweenInfo.new(2, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
		Padding = UDim.new(0.02, 0)
	}):Play()

	tween_service:Create(ui.Background.Title, TweenInfo.new(1.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
		TextTransparency = 0
	}):Play()

	tween_service:Create(ui.Background, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
		Size = UDim2.new(0, 655, 0, 325),
		Position = UDim2.new(0.4, 0, 0.3, 0),
		BackgroundTransparency = 0
	}):Play()
end


function nurysium: close()
	tween_service:Create(color_shader, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
		Saturation = 0
	}):Play()

	tween_service:Create(blur_shader, TweenInfo.new(0.65, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
		Size = 0
	}):Play()

	task.delay(0.35, function()
		ui.Background["functions_frame"].Visible = false
		ui.Background.Sections.Visible = false
		ui.Background.Search.Visible = false
	end)

	tween_service:Create(ui.Background["functions_frame"].UIListLayout, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
		Padding = UDim.new(0.02, 0)
	}):Play()

	tween_service:Create(ui.Background.Title, TweenInfo.new(0.45, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
		TextTransparency = 1
	}):Play()

	tween_service:Create(ui.Background, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
		Size = UDim2.new(0, 0, 0, 0),
		Position = UDim2.new(0.510, 0, 1, 0),
		BackgroundTransparency = 1
	}):Play()
end

function nurysium: init(name: string, is_draggable: boolean, parent)
	if parent:FindFirstChild(name) then
		parent:FindFirstChild(name):Destroy()
	end

	local Main = Instance.new("ScreenGui")
	local uiVisible = Instance.new("TextButton")
	local UIGradient = Instance.new("UIGradient")
	local UICorner = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")
	local BackgroundShadow = Instance.new("ImageLabel")
	local Eye = Instance.new("ImageLabel")
	local Background = Instance.new("Frame")
	local UICorner_2 = Instance.new("UICorner")
	local Sections = Instance.new("Frame")
	local UICorner_3 = Instance.new("UICorner")
	local real_sections = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")
	local UIGradient_2 = Instance.new("UIGradient")
	local CornerFix = Instance.new("Frame")
	local UIGradient_3 = Instance.new("UIGradient")
	local Title = Instance.new("TextLabel")
	local functions_frame = Instance.new("ScrollingFrame")
	local UIPadding = Instance.new("UIPadding")
	local UIListLayout_2 = Instance.new("UIListLayout")
	local Search = Instance.new("Frame")
	local UICorner_4 = Instance.new("UICorner")
	local ImageLabel = Instance.new("ImageLabel")
	local Bar = Instance.new("TextBox")
	local UIStroke_2 = Instance.new("UIStroke")
	local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
	local UIGradient_5 = Instance.new("UIGradient")
	local UIStroke_3 = Instance.new("UIStroke")
	local BackgroundShadow_2 = Instance.new("ImageLabel")

	Main.Name = name
	Main.Parent = parent

	uiVisible = Instance.new("TextButton", Main)

	uiVisible.Name = "uiVisible"
	uiVisible.Parent = Main
	uiVisible.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	uiVisible.BorderColor3 = Color3.fromRGB(0, 0, 0)
	uiVisible.BorderSizePixel = 0
	uiVisible.Position = UDim2.new(0.0450000018, 0, 0.862999976, 0)
	uiVisible.Size = UDim2.new(0, 50, 0, 50)
	uiVisible.ZIndex = 15
	uiVisible.Font = Enum.Font.GothamBold
	uiVisible.TextColor3 = Color3.fromRGB(0, 0, 0)
	uiVisible.TextSize = 1.000
	uiVisible.TextTransparency = 1.000
	uiVisible.TextWrapped = true
	uiVisible.Visible = true

	UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(16, 18, 24)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(21, 24, 33))}
	UIGradient.Rotation = -88
	UIGradient.Parent = uiVisible

	UICorner.CornerRadius = UDim.new(0, 12)
	UICorner.Parent = uiVisible

	UIStroke.Parent = uiVisible
	UIStroke.Color = Color3.fromRGB(85, 85, 85)
	UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	BackgroundShadow.Name = "BackgroundShadow"
	BackgroundShadow.Parent = uiVisible
	BackgroundShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	BackgroundShadow.BackgroundTransparency = 1.000
	BackgroundShadow.Position = UDim2.new(0.499168396, 0, 0.492307693, 2)
	BackgroundShadow.Size = UDim2.new(1.00498962, 142, 1.00923073, 142)
	BackgroundShadow.Image = "rbxassetid://12817494724"
	BackgroundShadow.ImageTransparency = 0.500
	BackgroundShadow.ScaleType = Enum.ScaleType.Slice
	BackgroundShadow.SliceCenter = Rect.new(85, 85, 427, 427)

	Eye.Name = "Eye"
	Eye.Parent = uiVisible
	Eye.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Eye.BackgroundTransparency = 1.000
	Eye.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Eye.BorderSizePixel = 0
	Eye.Position = UDim2.new(0.239999995, 0, 0.239999995, 0)
	Eye.Size = UDim2.new(0.5, 0, 0.5, 0)
	Eye.ZIndex = 25
	Eye.Image = "rbxassetid://17615525476"
	Eye.ImageTransparency = 0.450

	ui = Instance.new("ScreenGui", Main)

	ui.Name = 'nurysium'
	ui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	
	local girl_Image = Instance.new("Frame")
	local girl = Instance.new("ImageLabel")
	local girl_UIGradient = Instance.new("UIGradient")
	local girl_UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

	girl_Image.Name = "girl_Image"
	girl_Image.Parent = ui
	girl_Image.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	girl_Image.BackgroundTransparency = 1.000
	girl_Image.BorderColor3 = Color3.fromRGB(0, 0, 0)
	girl_Image.BorderSizePixel = 0
	girl_Image.Size = UDim2.new(1, 0, 1, 0)

	girl.Name = "girl"
	girl.Parent = girl_Image
	girl.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	girl.BackgroundTransparency = 1.000
	girl.BorderColor3 = Color3.fromRGB(0, 0, 0)
	girl.BorderSizePixel = 0
	girl.Position = UDim2.new(0.730189502, 0, 0.475565195, 0)
	girl.Size = UDim2.new(0.269810468, 0, 0.524434745, 0)
	girl.Image = "rbxassetid://17663188480"

	girl_UIGradient.Rotation = -74
	girl_UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 1.00), NumberSequenceKeypoint.new(0.17, 0.80), NumberSequenceKeypoint.new(0.34, 0.47), NumberSequenceKeypoint.new(0.43, 0.00), NumberSequenceKeypoint.new(0.50, 0.00), NumberSequenceKeypoint.new(0.68, 0.00), NumberSequenceKeypoint.new(0.90, 0.97), NumberSequenceKeypoint.new(1.00, 1.00)}
	girl_UIGradient.Parent = girl
	
	girl_UIAspectRatioConstraint.Parent = girl
	girl_UIAspectRatioConstraint.AspectRatio = 0.87

	Background.Name = "Background"
	Background.Parent = ui
	Background.BackgroundColor3 = Color3.fromRGB(234, 234, 234)
	Background.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Background.BorderSizePixel = 0
	Background.Position = UDim2.new(0.387321681, 0, 0.332433224, 0)
	Background.Size = UDim2.new(0, 655, 0, 325)
	Background.ZIndex = 5

	UICorner_2.CornerRadius = UDim.new(0, 12)
	UICorner_2.Parent = Background


	Sections.Name = "Sections"
	Sections.Parent = Background
	Sections.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Sections.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Sections.BorderSizePixel = 0
	Sections.Position = UDim2.new(-2.03027554e-07, 0, 0, 0)
	Sections.Size = UDim2.new(0.282425195, 0, 1, 0)
	Sections.ZIndex = 5

	UICorner_3.CornerRadius = UDim.new(0, 15)
	UICorner_3.Parent = Sections

	real_sections.Name = "real_sections"
	real_sections.Parent = Sections
	real_sections.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	real_sections.BackgroundTransparency = 1.000
	real_sections.BorderColor3 = Color3.fromRGB(0, 0, 0)
	real_sections.BorderSizePixel = 0
	real_sections.Position = UDim2.new(0.249553874, 0, 0.170943886, 0)
	real_sections.Size = UDim2.new(0, 107, 0, 230)
	real_sections.ZIndex = 6

	UIListLayout.Parent = real_sections
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0.0450000018, 0)

	UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(16, 18, 24)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(22, 25, 34))}
	UIGradient_2.Rotation = -113
	UIGradient_2.Parent = Sections

	CornerFix.Name = "CornerFix"
	CornerFix.Parent = Sections
	CornerFix.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	CornerFix.BorderColor3 = Color3.fromRGB(0, 0, 0)
	CornerFix.BorderSizePixel = 0
	CornerFix.Position = UDim2.new(0.0952685028, 0, 0, 0)
	CornerFix.Size = UDim2.new(0.904730499, 0, 1, 0)
	CornerFix.ZIndex = 5

	UIGradient_3.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(16, 18, 24)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(22, 25, 34))}
	UIGradient_3.Rotation = -113
	UIGradient_3.Parent = CornerFix

	Title.Name = "Title"
	Title.Parent = Background
	Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Title.BackgroundTransparency = 1.000
	Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Title.BorderSizePixel = 0
	Title.Position = UDim2.new(0.0269060303, 0, 0.035999544, 0)
	Title.Size = UDim2.new(0, 70, 0, 20)
	Title.ZIndex = 5
	Title.Font = Enum.Font.GothamBold
	Title.Text = name
	Title.TextColor3 = Color3.fromRGB(231, 231, 243)
	Title.TextScaled = true
	Title.TextSize = 14.000
	Title.TextWrapped = true

	functions_frame.Name = "functions_frame"
	functions_frame.Parent = Background
	functions_frame.Active = true
	functions_frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	functions_frame.BackgroundTransparency = 1.000
	functions_frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	functions_frame.BorderSizePixel = 0
	functions_frame.Position = UDim2.new(0.31407398, 0, 0.170943886, 0)
	functions_frame.Size = UDim2.new(0, 397, 0, 254)
	functions_frame.ZIndex = 5
	functions_frame.ScrollBarImageColor3 = Color3.fromRGB(223, 223, 223)
	functions_frame.CanvasPosition = Vector2.new(0, 300)
	functions_frame.ScrollBarThickness = 0

	UIPadding.Parent = functions_frame
	UIPadding.PaddingTop = UDim.new(0.00999999978, 0)

	UIListLayout_2.Parent = functions_frame
	UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout_2.Padding = UDim.new(0.0149999997, 0)

	Search.Name = "Search"
	Search.Parent = Background
	Search.BackgroundColor3 = Color3.fromRGB(27, 31, 44)
	Search.BackgroundTransparency = 0.500
	Search.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Search.BorderSizePixel = 0
	Search.Position = UDim2.new(0.775426149, 0, 0.0338461548, 0)
	Search.Size = UDim2.new(0, 120, 0, 35)
	Search.ZIndex = 5

	UICorner_4.CornerRadius = UDim.new(0, 15)
	UICorner_4.Parent = Search

	ImageLabel.Parent = Search
	ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ImageLabel.BackgroundTransparency = 1.000
	ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ImageLabel.BorderSizePixel = 0
	ImageLabel.Position = UDim2.new(0.0675648972, 0, 0.244624332, 0)
	ImageLabel.Size = UDim2.new(0, 17, 0, 17)
	ImageLabel.ZIndex = 12
	ImageLabel.Image = "rbxassetid://17441620727"
	ImageLabel.ImageTransparency = 0.450

	Bar.Name = "Bar"
	Bar.Parent = Search
	Bar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Bar.BackgroundTransparency = 1.000
	Bar.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Bar.BorderSizePixel = 0
	Bar.Position = UDim2.new(0.275000006, 0, 0.0199957713, 0)
	Bar.Size = UDim2.new(0, 87, 0, 34)
	Bar.SizeConstraint = Enum.SizeConstraint.RelativeXX
	Bar.ZIndex = 7
	Bar.Font = Enum.Font.GothamBold
	Bar.PlaceholderText = "Search"
	Bar.Text = ""
	Bar.TextColor3 = Color3.fromRGB(231, 231, 243)
	Bar.TextSize = 14.000
	Bar.TextTransparency = 0.450
	Bar.TextWrapped = true
	Bar.TextXAlignment = Enum.TextXAlignment.Left

	local function bar_handler()
		local script = Instance.new('LocalScript', Bar)

		Bar:GetPropertyChangedSignal("Text"):Connect(function()
			if Bar.Text:len() > 1 then
				animate_elements(1.35)

				for _, element in functions_frame:GetDescendants() do

					if element:IsA("Frame") and element:FindFirstChild("Title") then

						if string.find(element.Title.Text:lower(), Bar.Text:lower()) then
							table.insert(search_table, element.Name)
						else

							if table.find(search_table, element.Name) then
								table.remove(search_table, table.find(search_table, element.Name))
							end

						end
					end

				end
			else
				table.clear(search_table)
			end
		end)
	end

	coroutine.wrap(bar_handler)()

	UIStroke_2.Parent = Search
	UIStroke_2.Color = Color3.fromRGB(34, 34, 34)
	UIStroke_2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	UIAspectRatioConstraint.Parent = Background
	UIAspectRatioConstraint.AspectRatio = 1.850

	UIGradient_5.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(16, 18, 24)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(21, 24, 33))}
	UIGradient_5.Rotation = -88
	UIGradient_5.Parent = Background

	UIStroke_3.Parent = Background
	UIStroke_3.Color = Color3.fromRGB(85, 85, 85)
	UIStroke_3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	BackgroundShadow_2.Name = "BackgroundShadow"
	BackgroundShadow_2.Parent = Background
	BackgroundShadow_2.AnchorPoint = Vector2.new(0.5, 0.5)
	BackgroundShadow_2.BackgroundTransparency = 1.000
	BackgroundShadow_2.Position = UDim2.new(0.499168396, 0, 0.492307693, 2)
	BackgroundShadow_2.Size = UDim2.new(1.00498962, 142, 1.00923073, 142)
	BackgroundShadow_2.Image = "rbxassetid://12817494724"
	BackgroundShadow_2.ImageTransparency = 0.500
	BackgroundShadow_2.ScaleType = Enum.ScaleType.Slice
	BackgroundShadow_2.SliceCenter = Rect.new(85, 85, 427, 427)

	tween_service:Create(UIAspectRatioConstraint, TweenInfo.new(1.65, Enum.EasingStyle.Exponential), {AspectRatio = 1.850}):Play()
	task.delay(0.25, function()
		tween_service:Create(Title, TweenInfo.new(1.85, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
	end)

	task.defer(function()
		if is_draggable then
			local function drag_script()
				local script = Instance.new('LocalScript', Background)

				local UserInputService = game:GetService("UserInputService")
				local runService = (game:GetService("RunService"));

				local gui = script.Parent

				local dragging
				local dragInput
				local dragStart
				local startPos

				local function Lerp(a, b, m)
					return a + (b - a) * m
				end;

				local lastMousePos
				local lastGoalPos
				local DRAG_SPEED = (9);

				local function Update(dt)
					if not (startPos) then return end;
					if not (dragging) and (lastGoalPos) then
						gui.Position = UDim2.new(startPos.X.Scale, Lerp(gui.Position.X.Offset, lastGoalPos.X.Offset, dt * DRAG_SPEED), startPos.Y.Scale, Lerp(gui.Position.Y.Offset, lastGoalPos.Y.Offset, dt * DRAG_SPEED))
						return 
					end;

					local delta = (lastMousePos - UserInputService:GetMouseLocation())
					local xGoal = (startPos.X.Offset - delta.X);
					local yGoal = (startPos.Y.Offset - delta.Y);
					lastGoalPos = UDim2.new(startPos.X.Scale, xGoal, startPos.Y.Scale, yGoal)
					gui.Position = UDim2.new(startPos.X.Scale, Lerp(gui.Position.X.Offset, xGoal, dt * DRAG_SPEED), startPos.Y.Scale, Lerp(gui.Position.Y.Offset, yGoal, dt * DRAG_SPEED))
				end;

				gui.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = true
						dragStart = input.Position
						startPos = gui.Position
						lastMousePos = UserInputService:GetMouseLocation()

						input.Changed:Connect(function()
							if input.UserInputState == Enum.UserInputState.End then
								dragging = false
							end
						end)
					end
				end)

				gui.InputChanged:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
						dragInput = input
					end
				end)

				runService.Heartbeat:Connect(Update)
			end

			coroutine.wrap(drag_script)()
		end
	end)

	task.defer(function()
		uiVisible.TouchTap:Connect(function()
			if not ui.Enabled then
				nurysium:open()

				task.delay(0.15, function()
					ui.Enabled = true
				end)
			else
				nurysium:close()

				task.delay(1, function()
					ui.Enabled = false
				end)
			end
		end)

		uiVisible.MouseButton1Up:Connect(function()
			if not ui.Enabled then
				nurysium:open()

				task.delay(0.15, function()
					ui.Enabled = true
				end)
			else
				nurysium:close()

				task.delay(1, function()
					ui.Enabled = false
				end)
			end
		end)

		user_input.InputEnded:Connect(function(input, is_event)
			if not is_event and (input.KeyCode == Enum.KeyCode.RightShift or input.KeyCode == Enum.KeyCode.Insert)  then

				if not ui.Enabled then
					nurysium:open()

					task.delay(0.15, function()
						ui.Enabled = true
					end)
				else
					nurysium:close()

					task.delay(1, function()
						ui.Enabled = false
					end)
				end
			end
		end)
	end)
end

function nurysium: create_section(name: string, imageID: number)
	task.wait(0.1)

	local Example = Instance.new("TextButton", ui.Background.Sections.real_sections)
	local ImageLabel = Instance.new("ImageLabel")

	Example.Name = name
	Example.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Example.BackgroundTransparency = 1.000
	Example.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Example.BorderSizePixel = 0
	Example.Size = UDim2.new(0, 85, 0, 16)
	Example.ZIndex = 6
	Example.Font = Enum.Font.GothamBold
	Example.Text = name
	Example.TextColor3 = Color3.fromRGB(231, 231, 243)
	Example.TextScaled = true
	Example.TextSize = 14.000
	Example.TextWrapped = true
	Example.TextTransparency = 1
	Example.TextXAlignment = Enum.TextXAlignment.Left

	tween_service:Create(Example, TweenInfo.new(1.35, Enum.EasingStyle.Exponential), {TextTransparency = 0.45}):Play()

	Example.MouseButton1Up:Connect(function()
		ui_data.current_section = Example.Text

		for _, section in ui.Background.Sections.real_sections:GetChildren() do

			if section:IsA("TextButton") then
				if section.Text:match(name) then

					local click_sound = Instance.new("Sound", game:GetService("SoundService"))

					click_sound.SoundId = "rbxassetid://6895079853"
					click_sound:Play()

					animate_elements(1.65)

					tween_service:Create(section, TweenInfo.new(0.65, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
					tween_service:Create(section.ImageLabel, TweenInfo.new(0.65, Enum.EasingStyle.Exponential), {ImageTransparency = 0}):Play()

				else
					tween_service:Create(section, TweenInfo.new(0.45, Enum.EasingStyle.Exponential), {TextTransparency = 0.45}):Play()
					tween_service:Create(section.ImageLabel, TweenInfo.new(0.45, Enum.EasingStyle.Exponential), {ImageTransparency = 0.45}):Play()
				end
			end

		end
	end)

	Example.TouchTap:Connect(function()
		ui_data.current_section = Example.Text

		for _, section in ui.Background.Sections.real_sections:GetChildren() do

			if section:IsA("TextButton") then
				if section.Text:match(name) then

					local click_sound = Instance.new("Sound", game:GetService("SoundService"))

					click_sound.SoundId = "rbxassetid://6895079853"
					click_sound:Play()

					animate_elements(1.65)

					tween_service:Create(section, TweenInfo.new(0.45, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
					tween_service:Create(section.ImageLabel, TweenInfo.new(0.45, Enum.EasingStyle.Exponential), {ImageTransparency = 0}):Play()

					if section.Text:match("Settings") then
						tween_service:Create(section.ImageLabel, TweenInfo.new(1.45, Enum.EasingStyle.Exponential), {Rotation = 90}):Play()

						task.delay(4, function()
							tween_service:Create(section.ImageLabel, TweenInfo.new(1.45, Enum.EasingStyle.Exponential), {Rotation = 0}):Play()
						end)
					end
				else
					tween_service:Create(section, TweenInfo.new(0.45, Enum.EasingStyle.Exponential), {TextTransparency = 0.45}):Play()
					tween_service:Create(section.ImageLabel, TweenInfo.new(0.45, Enum.EasingStyle.Exponential), {ImageTransparency = 0.45}):Play()
				end
			end

		end
	end)

	ImageLabel.Parent = Example
	ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ImageLabel.BackgroundTransparency = 1.000
	ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ImageLabel.BorderSizePixel = 0
	ImageLabel.Position = UDim2.new(-0.257435054, 0, 0.0446243286, 0)
	ImageLabel.Size = UDim2.new(0, 13, 0, 13)
	ImageLabel.ZIndex = 6
	ImageLabel.ImageTransparency = 1
	ImageLabel.Image = `rbxassetid://{imageID}`

	tween_service:Create(ImageLabel, TweenInfo.new(3, Enum.EasingStyle.Exponential), {ImageTransparency = 0.45}):Play()
end

function nurysium: create_toggle(name: string, section_name: string, callback)
	task.wait(0.1)

	callback = callback or function() end
	local toggled = false

	local Example = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local Hitbox = Instance.new("TextButton")
	local Title = Instance.new("TextLabel")
	local Toggle = Instance.new("Frame")
	local UICorner_2 = Instance.new("UICorner")
	local checkmark = Instance.new("ImageButton")
	local UIStroke = Instance.new("UIStroke")
	local UIGradient = Instance.new("UIGradient")
	local UIStroke_2 = Instance.new("UIStroke")

	Example.Name = name
	Example.Parent = ui.Background["functions_frame"]
	Example.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Example.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Example.BorderSizePixel = 0
	Example.Position = UDim2.new(0.0428211577, 0, 0.0157480314, 0)
	Example.Size = UDim2.new(0, 380, 0, 43)
	Example.ZIndex = 10

	UICorner.CornerRadius = UDim.new(0, 10)
	UICorner.Parent = Example

	Hitbox.Name = "Hitbox"
	Hitbox.Parent = Example
	Hitbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Hitbox.BackgroundTransparency = 1.000
	Hitbox.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Hitbox.BorderSizePixel = 0
	Hitbox.Size = UDim2.new(1, 0, 1, 0)
	Hitbox.Font = Enum.Font.SourceSans
	Hitbox.TextColor3 = Color3.fromRGB(0, 0, 0)
	Hitbox.TextSize = 1.000
	Hitbox.TextTransparency = 1.000

	Title.Name = "Title"
	Title.Parent = Example
	Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Title.BackgroundTransparency = 1.000
	Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Title.BorderSizePixel = 0
	Title.Position = UDim2.new(0.0449240431, 0, 0.275129795, 0)
	Title.Size = UDim2.new(0, 140, 0, 20)
	Title.ZIndex = 10
	Title.Font = Enum.Font.GothamBold
	Title.Text = tostring(name)
	Title.TextColor3 = Color3.fromRGB(231, 231, 243)
	Title.TextScaled = true
	Title.TextSize = 14.000
	Title.TextWrapped = true
	Title.TextXAlignment = Enum.TextXAlignment.Left

	Toggle.Name = "Toggle"
	Toggle.Parent = Example
	Toggle.BackgroundColor3 = Color3.fromRGB(15, 18, 24)
	Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Toggle.BorderSizePixel = 0
	Toggle.Position = UDim2.new(0.902837157, 0, 0.251873642, 0)
	Toggle.Size = UDim2.new(0, 21, 0, 20)
	Toggle.ZIndex = 15

	UICorner_2.CornerRadius = UDim.new(0, 5)
	UICorner_2.Parent = Toggle

	checkmark.Name = "checkmark"
	checkmark.Parent = Toggle
	checkmark.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	checkmark.BackgroundTransparency = 1.000
	checkmark.BorderColor3 = Color3.fromRGB(0, 0, 0)
	checkmark.BorderSizePixel = 0
	checkmark.ImageTransparency = 1
	checkmark.Position = UDim2.new(0.227271676, 0, 0.200000003, 0)
	checkmark.Size = UDim2.new(0.545454562, 0, 0.600000024, 0)
	checkmark.ZIndex = 15
	checkmark.Image = "rbxassetid://9754130783"

	UIStroke.Parent = Toggle
	UIStroke.Color = Color3.fromRGB(29, 33, 45)
	UIStroke.Transparency = 0.500
	UIStroke.Thickness = 2.000
	UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(16, 18, 24)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(22, 25, 34))}
	UIGradient.Rotation = -9
	UIGradient.Parent = Example

	UIStroke_2.Parent = Example
	UIStroke_2.Color = Color3.fromRGB(31, 31, 31)
	UIStroke_2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	game:GetService("RunService").Heartbeat:Connect(function()
		if not section_name:match(ui_data.current_section) and not table.find(search_table, name)then
			Example.Visible = false
		else
			Example.Visible = true
		end
	end)

	Hitbox.MouseButton1Up:Connect(function()
		toggled = not toggled

		callback(toggled)

		if toggled then

			tween_service:Create(checkmark, TweenInfo.new(0.45, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
				ImageTransparency = 0.25,
			}):Play()

		else

			tween_service:Create(checkmark, TweenInfo.new(0.45, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
				ImageTransparency = 1,
			}):Play()

		end
	end)

	Hitbox.TouchTap:Connect(function()
		toggled = not toggled

		callback(toggled)

		if toggled then

			tween_service:Create(checkmark, TweenInfo.new(0.45, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
				ImageTransparency = 0.25,
			}):Play()

		else

			tween_service:Create(checkmark, TweenInfo.new(0.45, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
				ImageTransparency = 1,
			}):Play()

		end
	end)

end

return nurysium
