local notify = {}

local TweenService = game:GetService('TweenService')

local nury_Hud = Instance.new('ScreenGui')
nury_Hud.Name = 'nury_Hud'

local notify_List = Instance.new('Frame')
notify_List.Name = 'notify_List'
notify_List.Parent = nury_Hud

function notify.init(parent: any)
	local UIListLayout = Instance.new('UIListLayout')
	
	nury_Hud.Parent = parent

	notify_List.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	notify_List.BackgroundTransparency = 1.000
	notify_List.BorderColor3 = Color3.fromRGB(0, 0, 0)
	notify_List.BorderSizePixel = 0
	notify_List.Position = UDim2.new(0.388183862, 0, 0.537472963, 0)
	notify_List.Size = UDim2.new(0.223632291, 0, 0.40625, 0)

	UIListLayout.Parent = notify_List
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0.0149999997, 0)
end

function notify.render_Notify(text: string, image_ID: string, on_screen_Time: number)
	if game:GetService('UserInputService').TouchEnabled then
		return
	end
	
	local notify_Sound = Instance.new('Sound')
	
	local Example = Instance.new('Frame')
	local UICorner = Instance.new('UICorner')
	local Shadow = Instance.new('ImageLabel')
	local Data = Instance.new('Folder')
	local Icon = Instance.new('ImageLabel')
	local Text = Instance.new('TextLabel')
	local UIGradient = Instance.new('UIGradient')
	local Line = Instance.new('Frame')
	local UIAspectRatioConstraint = Instance.new('UIAspectRatioConstraint')
	local UIAspectRatioConstraint_2 = Instance.new('UIAspectRatioConstraint')

	Example.Name = text:lower()
	Example.Parent = notify_List
	Example.BackgroundColor3 = Color3.fromRGB(43, 39, 47)
	Example.BackgroundTransparency = 0.350
	Example.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Example.BorderSizePixel = 0
	Example.Position = UDim2.new(0.254966736, 0, 0, 0)
	Example.Size = UDim2.new(0.62932235, 0, 0.0854922757, 0)
	
	notify_Sound.Parent = Example
	notify_Sound.SoundId = 'rbxassetid://8458408918'
	notify_Sound.Volume = 0.1
	notify_Sound:Play()

	UICorner.CornerRadius = UDim.new(0, 9)
	UICorner.Parent = Example

	Shadow.Name = 'Shadow'
	Shadow.Parent = Example
	Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	Shadow.BackgroundTransparency = 1.000
	Shadow.Position = UDim2.new(0.5, 0, 0.5, 2)
	Shadow.Size = UDim2.new(1, 137, 1, 137)
	Shadow.ZIndex = 0
	Shadow.Image = 'rbxassetid://12817518992'
	Shadow.ImageColor3 = Color3.fromRGB(223, 200, 243)
	Shadow.ImageTransparency = 1
	Shadow.ScaleType = Enum.ScaleType.Slice
	Shadow.SliceCenter = Rect.new(85, 85, 427, 427)

	Data.Name = 'Data'
	Data.Parent = Example

	Icon.Name = 'Icon'
	Icon.Parent = Data
	Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Icon.BackgroundTransparency = 1.000
	Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Icon.BorderSizePixel = 0
	Icon.Position = UDim2.new(0.0409145541, 0, 0.168862924, 0)
	Icon.Size = UDim2.new(0.0907369405, 0, 0.629204273, 0)
	Icon.ZIndex = 6
	
	if image_ID:len() > 1 then
		Icon.Image = `rbxassetid://{image_ID}`
	else
		Icon.Image = 'rbxassetid://15428182962'
	end
	
	Icon.ImageColor3 = Color3.fromRGB(223, 200, 243)
	Icon.ImageTransparency = 1

	Text.Name = 'Text'
	Text.Parent = Data
	Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Text.BackgroundTransparency = 1.000
	Text.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Text.BorderSizePixel = 0
	Text.Position = UDim2.new(0.193315268, 0, -3.04304126e-06, 0)
	Text.Size = UDim2.new(0.80398488, 0, 1.00000322, 0)
	Text.ZIndex = 5
	Text.Font = Enum.Font.GothamBold
	Text.Text = text
	Text.TextColor3 = Color3.fromRGB(223, 200, 243)
	Text.TextSize = 18.000
	Text.TextTransparency = 1
	Text.TextWrapped = true
	Text.TextXAlignment = Enum.TextXAlignment.Left

	UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(0.65, 0.45), NumberSequenceKeypoint.new(1.00, 1.00)}
	UIGradient.Parent = Text

	Line.Name = 'Line'
	Line.Parent = Example
	Line.BackgroundColor3 = Color3.fromRGB(223, 200, 243)
	Line.BackgroundTransparency = 1
	Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Line.BorderSizePixel = 0
	Line.Position = UDim2.new(0.16014117, 0, -1.51757968e-06, 0)
	Line.Size = UDim2.new(0.00361005589, 0, 1.00000381, 0)

	UIAspectRatioConstraint.Parent = Line
	UIAspectRatioConstraint.AspectRatio = 0.025

	UIAspectRatioConstraint_2.Parent = Example
	UIAspectRatioConstraint_2.AspectRatio = 0.01
	UIAspectRatioConstraint_2.DominantAxis = Enum.DominantAxis.Height
	
	TweenService:Create(UIAspectRatioConstraint_2, TweenInfo.new(0.65, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
		AspectRatio = 7.000
	}):Play()

	TweenService:Create(Example, TweenInfo.new(0.65, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
		BackgroundTransparency = 0.700
	}):Play()

	TweenService:Create(Shadow, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
		ImageTransparency = 0.600
	}):Play()

	TweenService:Create(Icon, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
		ImageTransparency = 0.450
	}):Play()

	TweenService:Create(Text, TweenInfo.new(1.25, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
		TextTransparency = 0.400
	}):Play()

	TweenService:Create(Line, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
		BackgroundTransparency = 0.7
	}):Play()
	
	task.delay(on_screen_Time, function()
		TweenService:Create(UIAspectRatioConstraint_2, TweenInfo.new(0.65, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
			AspectRatio = 0
		}):Play()
		
		TweenService:Create(Example, TweenInfo.new(0.65, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
			BackgroundTransparency = 1
		}):Play()
		
		TweenService:Create(Shadow, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
			ImageTransparency = 1
		}):Play()
		
		TweenService:Create(Icon, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
			ImageTransparency = 1
		}):Play()
		
		TweenService:Create(Text, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
			TextTransparency = 1
		}):Play()
		
		TweenService:Create(Line, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
			BackgroundTransparency = 1
		}):Play()
		
		task.delay(on_screen_Time + 1, function()
			game:GetService('Debris'):AddItem(Example, 0)
		end)
	end)
end

return notify
