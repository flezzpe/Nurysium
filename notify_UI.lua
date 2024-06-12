local notify = {}

local TweenService = game:GetService("TweenService")

local notify_List = nil

function notify.init(parent: any)
	local self = Instance.new("ScreenGui", parent)
	
	notify_List = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")

	notify_List.Name = "notify_List"
	notify_List.Parent = self
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

function notify.render_Notify(notify_Text: string, on_screen_Time: number)
	task.defer(function()
		
		local Example = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local Data = Instance.new("Folder")
		local Icon = Instance.new("ImageLabel")
		local Text = Instance.new("TextLabel")
		local UIGradient = Instance.new("UIGradient")
		local Line = Instance.new("Frame")
		local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
		local UIAspectRatioConstraint_2 = Instance.new("UIAspectRatioConstraint")
		
		local sound_Effect = Instance.new("Sound", Example)
		sound_Effect.SoundId = 'rbxassetid://9077482766'
		sound_Effect.PlaybackSpeed = 2.5
		sound_Effect.Volume = 0.1
		sound_Effect:Play()

		Example.Name = "Example"
		Example.Parent = notify_List
		Example.BackgroundColor3 = Color3.fromRGB(41, 67, 78)
		Example.BackgroundTransparency = 1
		Example.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Example.BorderSizePixel = 0
		Example.Position = UDim2.new(0.254966736, 0, 0, 0)
		Example.Size = UDim2.new(0.62932235, 0, 0.0854922757, 0)

		UICorner.CornerRadius = UDim.new(0, 9)
		UICorner.Parent = Example

		Data.Name = "Data"
		Data.Parent = Example

		Icon.Name = "Icon"
		Icon.Parent = Data
		Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Icon.BackgroundTransparency = 1.000
		Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Icon.BorderSizePixel = 0
		Icon.Position = UDim2.new(0.0373533294, 0, 0.168862924, 0)
		Icon.Size = UDim2.new(0.0907369405, 0, 0.629204273, 0)
		Icon.ZIndex = 6
		Icon.Image = "rbxassetid://17745044731"
		Icon.ImageColor3 = Color3.fromRGB(141, 194, 225)
		Icon.ImageTransparency = 1

		Text.Name = "Text"
		Text.Parent = Data
		Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Text.BackgroundTransparency = 1.000
		Text.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Text.BorderSizePixel = 0
		Text.Position = UDim2.new(0.193315268, 0, -3.04304126e-06, 0)
		Text.Size = UDim2.new(0.80398488, 0, 1.00000322, 0)
		Text.ZIndex = 5
		Text.Font = Enum.Font.GothamBold
		Text.Text = notify_Text
		Text.TextColor3 = Color3.fromRGB(141, 194, 225)
		Text.TextSize = 21.000
		Text.TextTransparency = 1
		Text.TextWrapped = true
		Text.TextXAlignment = Enum.TextXAlignment.Left

		UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(0.65, 0.45), NumberSequenceKeypoint.new(1.00, 1.00)}
		UIGradient.Parent = Text

		Line.Name = "Line"
		Line.Parent = Example
		Line.BackgroundColor3 = Color3.fromRGB(113, 155, 180)
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
			BackgroundTransparency = 0.250
		}):Play()

		TweenService:Create(Icon, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
			ImageTransparency = 0.450
		}):Play()

		TweenService:Create(Text, TweenInfo.new(1.25, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
			TextTransparency = 0.4
		}):Play()

		TweenService:Create(Line, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
			BackgroundTransparency = 0.7
		}):Play()

		task.delay(on_screen_Time, function()
			TweenService:Create(UIAspectRatioConstraint_2, TweenInfo.new(0.65, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
				AspectRatio = 0.01
			}):Play()

			TweenService:Create(Example, TweenInfo.new(0.65, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
				BackgroundTransparency = 1
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
				game:GetService("Debris"):AddItem(Example, 0)
			end)
		end)
	end)
end

return notify
