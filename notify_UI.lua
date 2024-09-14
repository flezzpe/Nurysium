local TweenService = game:GetService('TweenService')
local TextService = game:GetService('TextService')
local Debris = game:GetService('Debris')

local notify_lib = {
	notify = Instance.new("ScreenGui"),
	notify_count = 0
}

function notify_lib:__init()
	notify_lib.notify.Name = "notify"
	notify_lib.notify.Parent = self.parent

	local notify_list = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")

	notify_list.Name = "notify_list"
	notify_list.Parent = notify_lib.notify
	notify_list.AnchorPoint = Vector2.new(0.5, 0.5)
	notify_list.BackgroundColor3 = Color3.fromRGB(191, 229, 248)
	notify_list.BackgroundTransparency = 1.000
	notify_list.BorderColor3 = Color3.fromRGB(0, 0, 0)
	notify_list.BorderSizePixel = 0
	notify_list.Position = UDim2.new(0.5, 0, 0.8, 0)
	notify_list.Size = UDim2.new(0, 495, 0, 440)
	
	UIListLayout.Parent = notify_list
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0.015, 0)
end

function notify_lib.draw_notify(text: string, draw_time: number)
	notify_lib.notify_count += 1

	if notify_lib.notify_count > 5 then
		for _, old_notify in notify_lib.notify.notify_list:GetChildren() do
			if old_notify:IsA('Frame') then
				Debris:AddItem(old_notify, 0)

				task.wait()
			end
		end
		
		notify_lib.notify_count = 1
	end

	local background = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local title = Instance.new("TextLabel")
	local line = Instance.new("Frame")
	local UICorner_2 = Instance.new("UICorner")
	local icon = Instance.new("ImageLabel")
	local UIScale = Instance.new("UIScale")

	background.Name = "background"
	background.Parent = notify_lib.notify.notify_list
	background.AnchorPoint = Vector2.new(0.5, 0.5)
	background.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
	background.BackgroundTransparency = 0.9
	background.BorderColor3 = Color3.fromRGB(0, 0, 0)
	background.BorderSizePixel = 0
	background.Position = UDim2.new(0, 0, 0, 0)
	background.Size = UDim2.new(0, 0, 0, 33)

	UICorner.CornerRadius = UDim.new(0.25, 0)
	UICorner.Parent = background

	title.Name = "title"
	title.Parent = background
	title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	title.BackgroundTransparency = 1.000
	title.BorderColor3 = Color3.fromRGB(0, 0, 0)
	title.BorderSizePixel = 0
	title.Position = UDim2.new(0, 32, 0, 6)
	title.Size = UDim2.new(0, 80, 0, 21)
	title.Font = Enum.Font.GothamBold
	title.Text = text
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 15
	title.TextWrapped = true
	title.TextTransparency = 1

	UIScale.Parent = background
	UIScale.Scale = 1

	local text_size = TextService:GetTextSize(title.Text, title.TextSize, title.Font, Vector2.new(1000, title.TextSize))

	title.Size = UDim2.new(0, text_size.X, 0, 21)
	
	task.delay(0.4, function()
		TweenService:Create(title, TweenInfo.new(1, Enum.EasingStyle.Back), {
			TextTransparency = 0
		}):Play()
	end)

	TweenService:Create(background, TweenInfo.new(1.5, Enum.EasingStyle.Exponential), {
		Size = UDim2.new(0, text_size.X + 65, 0, 33)
	}):Play()
	
	TweenService:Create(background, TweenInfo.new(0.6, Enum.EasingStyle.Back), {
		Transparency = 0.1
	}):Play()

	task.delay(draw_time, function()
		TweenService:Create(title, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
			TextTransparency = 1
		}):Play()
		
		TweenService:Create(background, TweenInfo.new(0.6, Enum.EasingStyle.Back), {
			Transparency = 1
		}):Play()

		TweenService:Create(UIScale, TweenInfo.new(1.5, Enum.EasingStyle.Exponential), {
			Scale = 0
		}):Play()

		Debris:AddItem(background, 1.5)
		
		task.wait(1)
		
		notify_lib.notify_count -= 1
	end)
end

return notify_lib
