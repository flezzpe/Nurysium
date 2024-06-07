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
			BackgroundTransparency = 0.550
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

		local function Blur()
			local script = Instance.new('LocalScript', Example)

			local Lighting          = game:GetService("Lighting")
			local camera			= workspace.CurrentCamera

			local BLUR_SIZE         = Vector2.new(10, 10)
			local PART_SIZE         = 0.01
			local PART_TRANSPARENCY = 1 - 1e-7
			local START_INTENSITY	= 1

			script.Parent:SetAttribute("BlurIntensity", START_INTENSITY)

			local BLUR_OBJ          = Instance.new("DepthOfFieldEffect")
			BLUR_OBJ.FarIntensity   = 0
			BLUR_OBJ.NearIntensity  = script.Parent:GetAttribute("BlurIntensity")
			BLUR_OBJ.FocusDistance  = 0.25
			BLUR_OBJ.InFocusRadius  = 0
			BLUR_OBJ.Parent         = Lighting

			local PartsList         = {}
			local BlursList         = {}
			local BlurObjects       = {}
			local BlurredGui        = {}

			BlurredGui.__index      = BlurredGui

			function rayPlaneIntersect(planePos, planeNormal, rayOrigin, rayDirection)
				local n = planeNormal
				local d = rayDirection
				local v = rayOrigin - planePos

				local num = n.x*v.x + n.y*v.y + n.z*v.z
				local den = n.x*d.x + n.y*d.y + n.z*d.z
				local a = -num / den

				return rayOrigin + a * rayDirection, a
			end

			function rebuildPartsList()
				PartsList = {}
				BlursList = {}
				for blurObj, part in pairs(BlurObjects) do
					table.insert(PartsList, part)
					table.insert(BlursList, blurObj)
				end
			end

			function BlurredGui.new(frame, shape)
				local blurPart        = Instance.new("Part")
				blurPart.Size         = Vector3.new(1, 1, 1) * 0.01
				blurPart.Anchored     = true
				blurPart.CanCollide   = false
				blurPart.CanTouch     = false
				blurPart.Material     = Enum.Material.Glass
				blurPart.Transparency = PART_TRANSPARENCY
				blurPart.Parent       = workspace.CurrentCamera
				
				task.delay(on_screen_Time, function()
					game:GetService("Debris"):AddItem(blurPart, 0)
				end)

				local mesh
				if (shape == "Rectangle") then
					mesh        = Instance.new("BlockMesh")
					mesh.Parent = blurPart
				elseif (shape == "Oval") then
					mesh          = Instance.new("SpecialMesh")
					mesh.MeshType = Enum.MeshType.Sphere
					mesh.Parent   = blurPart
				end

				local ignoreInset = false
				local currentObj  = frame

				while task.wait() do
					currentObj = currentObj.Parent

					if (currentObj and currentObj:IsA("ScreenGui")) then
						ignoreInset = currentObj.IgnoreGuiInset
						break
					elseif (currentObj == nil) then
						break
					end
				end

				local new = setmetatable({
					Frame          = frame;
					Part           = blurPart;
					Mesh           = mesh;
					IgnoreGuiInset = ignoreInset;
				}, BlurredGui)

				BlurObjects[new] = blurPart
				rebuildPartsList()

				game:GetService("RunService"):BindToRenderStep("...", Enum.RenderPriority.Camera.Value + 1, function()
					blurPart.CFrame = camera.CFrame * CFrame.new(0,0,0)
					BlurredGui.updateAll()
				end)
				return new
			end

			function updateGui(blurObj)
				if (not blurObj.Frame.Visible) then
					blurObj.Part.Transparency = 1
					return
				end

				local camera = workspace.CurrentCamera
				local frame  = blurObj.Frame
				local part   = blurObj.Part
				local mesh   = blurObj.Mesh

				part.Transparency = PART_TRANSPARENCY

				local corner0 = frame.AbsolutePosition + BLUR_SIZE
				local corner1 = corner0 + frame.AbsoluteSize - BLUR_SIZE*2
				local ray0, ray1

				if (blurObj.IgnoreGuiInset) then
					ray0 = camera:ViewportPointToRay(corner0.X, corner0.Y, 1)
					ray1 = camera:ViewportPointToRay(corner1.X, corner1.Y, 1)
				else
					ray0 = camera:ScreenPointToRay(corner0.X, corner0.Y, 1)
					ray1 = camera:ScreenPointToRay(corner1.X, corner1.Y, 1)
				end

				local planeOrigin = camera.CFrame.Position + camera.CFrame.LookVector * (0.05 - camera.NearPlaneZ)
				local planeNormal = camera.CFrame.LookVector
				local pos0 = rayPlaneIntersect(planeOrigin, planeNormal, ray0.Origin, ray0.Direction)
				local pos1 = rayPlaneIntersect(planeOrigin, planeNormal, ray1.Origin, ray1.Direction)

				local pos0 = camera.CFrame:PointToObjectSpace(pos0)
				local pos1 = camera.CFrame:PointToObjectSpace(pos1)

				local size   = pos1 - pos0
				local center = (pos0 + pos1)/2

				mesh.Offset = center
				mesh.Scale  = size / PART_SIZE
			end

			function BlurredGui.updateAll()
				if not script.Parent then
					return
				end
				
				BLUR_OBJ.NearIntensity = tonumber(script.Parent:GetAttribute("BlurIntensity"))

				for i = 1, #BlursList do
					updateGui(BlursList[i])
				end

				local cframes = table.create(#BlursList, workspace.CurrentCamera.CFrame)
				workspace:BulkMoveTo(PartsList, cframes, Enum.BulkMoveMode.FireCFrameChanged)

				BLUR_OBJ.FocusDistance = 0.25 - camera.NearPlaneZ
			end

			function BlurredGui:Destroy()
				self.Part:Destroy()
				BlurObjects[self] = nil
				rebuildPartsList()
			end

			BlurredGui.new(script.Parent, "Rectangle")

	
			return BlurredGui

		end
		coroutine.wrap(Blur)()
	end)
end

return notify
