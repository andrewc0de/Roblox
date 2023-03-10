--[[
	Disclaimer: Very old code, I also had to rewrite a lot of Dino's code.. (cringe)
	
	Credits:
		Dino
		Magik Manz
		Luzu
--]]

local UI
do
	local UserInputService = game:GetService("UserInputService")
	local ContentProvider = game:GetService("ContentProvider")
	local TweenService = game:GetService("TweenService")
	local RunService = game:GetService("RunService")
	local CoreGui = game:GetService("CoreGui")

	local rnd = Random.new(math.random(tick()))

	local fromScale = UDim2.fromScale
	local fromOffset = UDim2.fromOffset

	local DEFAULT_SETTINGS = {
		TextButton = {
			AutoButtonColor = false,
			TextWrapped = true,
			LineHeight = 1,
			BorderSizePixel = 0,
			TextSize = 20,
			TextColor3 = Color3.new(1, 1, 1),
			TextXAlignment = "Left",
			TextYAlignment = "Center",
			Font = "SourceSans"
		},

		TextLabel = {
			Font = "SourceSansSemibold",
			BorderSizePixel = 0,
			TextColor3 = Color3.new(1, 1, 1),
			TextSize = 16,
			TextWrapped = false
		},

		UIListLayout = {
			Padding = UDim.new(0, 0),
			FillDirection = "Vertical",
			HorizontalAlignment = "Left",
			SortOrder = "LayoutOrder",
			VerticalAlignment = "Top"
		},

		ScreenGui = {
			DisplayOrder = 999999
		},

		Frame = {
			BorderSizePixel = 0
		},

		ImageLabel = {
			BorderSizePixel = 0,
			BackgroundTransparency = 1
		},

		ScrollingFrame = {
			BorderSizePixel = 0,
			ScrollBarImageTransparency = 0,
			ScrollBarThickness = 0,
			ScrollingEnabled = true,
			ScrollingDirection = "Y",
			VerticalScrollBarInset = "None",
			VerticalScrollBarPosition = "Right"
		}
	}

	local THEME = {
		Background = Color3.fromRGB(24, 24, 24),
		Glow = Color3.fromRGB(0, 0, 0),
		Accent = Color3.fromRGB(10, 10, 10),
		LightContrast = Color3.fromRGB(20, 20, 20),
		DarkContrast = Color3.fromRGB(34, 34, 34),
		TextColor = Color3.fromRGB(255, 255, 255)
	}

	local TAB_INFO = TweenInfo.new(0.5)

	local screengui
	local function new(class)
		local object = Instance.new(class)
		object.Name = rnd:NextNumber(1, 7000)

		for p, v in pairs(DEFAULT_SETTINGS[class] or {}) do
			object[p] = v
		end

		return object
	end

	local Utility = {}
	function Utility:Tween(instance, properties, duration, ...)
		TweenService:Create(instance, TweenInfo.new(duration, ...), properties):Play()
	end

	function Utility:Pop(object, shrink)
		local clone = object:Clone()

		clone.AnchorPoint = Vector2.new(0.5, 0.5)
		clone.Size = clone.Size - UDim2.new(0, shrink, 0, shrink)
		clone.Position = UDim2.new(0.5, 0, 0.5, 0)

		clone.Parent = object
		clone:ClearAllChildren()

		object.ImageTransparency = 1
		Utility:Tween(clone, {Size = object.Size}, 0.2)

		task.spawn(function()
			task.wait(0.2)

			object.ImageTransparency = 0
			clone:Destroy()
		end)

		return clone
	end

	function Utility:DraggingEnabled(frame, parent, allowed)
		allowed = allowed or function() return true end
		parent = parent or frame

		-- stolen from wally or kiriot, kek
		local dragging = false
		local dragInput, mousePos, framePos

		frame.InputBegan:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.MouseButton1 or not allowed() then return end

			dragging = true
			mousePos = input.Position
			framePos = parent.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end)

		frame.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement and allowed() then
				dragInput = input
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if input == dragInput and dragging and allowed() then
				local delta = input.Position - mousePos
				parent.Position  = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
			end
		end)
	end


	UI = {}
	UI.__index = UI

	local InternalUI = {
		flags = {}
	}
	InternalUI.__index = InternalUI

	-- Animation Handling
	local activeContainers = {}
	local tweenToggle, sliderBox, mouseDetection, calculateSliderValue, awaitKey, findElement, calculateBrightness, changeMiscColours, calculateColour, closeUI, openUI do 
		local TOGGLE_POSITIONS = {
			In = UDim2.new(0, 2, 0.5, -6),
			Out = UDim2.new(0, 20, 0.5, -6)
		}

		local ALLOWED_INPUT_TYPES = {
			[Enum.UserInputType.MouseButton1] = "LMB",
			[Enum.UserInputType.MouseButton2] = "RMB"
		}

		closeUI = function(ui, size)
			local off
			ui:TweenSize(size, Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.2, true, function()
				off = true
			end)

			while not off do
				RunService.RenderStepped:Wait()
			end
		end

		openUI = function(ui, size)
			local off
			ui:TweenSize(size, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true, function()
				off = true
			end)

			while not off do
				RunService.RenderStepped:Wait()
			end
		end

		-- Function decToHex (renamed, updated): http://lua-users.org/lists/lua-l/2004-09/msg00054.html
		decToHex = function(IN)
			local B, K, OUT, I = 16, "0123456789ABCDEF", "", 0
			local D
			while IN > 0 do
				I = I + 1
				IN , D = math.floor(IN / B), math.fmod(IN , B) + 1
				OUT = string.sub(K, D, D) .. OUT
			end

			return OUT
		end

		-- Function rgbToHex: http://gameon365.net/index.php
		convertRGBToHex = function(c)
			c = {r = c.R * 255, g = c.G * 255, b = c.B * 255}
			local output = decToHex(c["r"]) .. decToHex(c["g"]) .. decToHex(c["b"]);
			return '#'.. output
		end

		convertHexToRGB = function(Hex)
			local str = Hex:gsub("#","")
			local Red = tonumber("0x" .. str:sub(1, 2))
			local Green = tonumber("0x" .. str:sub(3, 4))
			local Blue = tonumber("0x".. str:sub(5, 6))
			return Red, Green, Blue
		end

		findElement = function(t, e)
			local len = string.len(e)
			local lower = string.lower(e)
			for i, v in pairs(t) do
				if string.sub(string.lower(v), 1, len) == lower then
					return i
				end
			end
		end

		tweenToggle = function(value, toggleimg2)
			value = value and "Out" or "In"

			Utility:Tween(toggleimg2, {
				Size = UDim2.new(1, -22, 1, -9),
				Position = TOGGLE_POSITIONS[value] + UDim2.new(0, 0, 0, 2.5)
			}, 0.2)

			task.wait(0.1)
			Utility:Tween(toggleimg2, {
				Size = UDim2.new(1, -22, 1, -4),
				Position = TOGGLE_POSITIONS[value]
			}, 0.1)
		end

		sliderBox = function(value, min, max)
			value = tonumber(value)
			if not value then return end

			return math.clamp(value, min, max)
		end

		local function isInGui(frame)
			local mloc = UserInputService:GetMouseLocation()
			local mouse = Vector2.new(mloc.X, mloc.Y - 36)

			local x1, x2 = frame.AbsolutePosition.X, frame.AbsolutePosition.X + frame.AbsoluteSize.X
			local y1, y2 = frame.AbsolutePosition.Y, frame.AbsolutePosition.Y + frame.AbsoluteSize.Y

			return (mouse.X >= x1 and mouse.X <= x2) and (mouse.Y >= y1 and mouse.Y <= y2)
		end

		mouseDetection = function(object, entered, leave, isSlider)
			local wasIn
			object.InputChanged:Connect(function(a, b)
				if a.UserInputType == Enum.UserInputType.MouseMovement and isInGui(object) and not wasIn 
					and (isSlider or object.Visible and activeContainers[object.Parent]) then
					wasIn = true
					entered()
				end
			end)

			object.InputEnded:Connect(function(a, b)
				if a.UserInputType == Enum.UserInputType.MouseMovement and not isInGui(object) and wasIn then
					wasIn = false
					leave()
				end
			end)

			UserInputService.InputBegan:Connect(function(input, g)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					if not isInGui(object) and wasIn then
						wasIn = false
						leave()
					elseif isInGui(object) and (isSlider or object.Visible and activeContainers[object.Parent]) then
						entered(true)
					end
				end
			end)

			UserInputService.InputEnded:Connect(function(input, g)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					if not isInGui(object) and wasIn then
						wasIn = false
						leave()
					elseif isInGui(object) then
						entered(false)
					end
				end
			end)
		end

		calculateColour = function(circle, absPos, absSize, startAt)
			local mousePosition = UserInputService:GetMouseLocation()
			mousePosition = Vector2.new(mousePosition.X, mousePosition.Y - 0.1)

			local relPosition = mousePosition - absPos
			local relSize = relPosition / absSize

			local cSize = circle.AbsoluteSize
			local x
			local y
			local h, s
			if startAt then
				h, s = Color3.toHSV(startAt)

				x = 1 - h
				y = 1 - s
			else
				x = math.clamp(mousePosition.X - absPos.X, 0, absSize.X - cSize.X)
				y = math.clamp(mousePosition.Y - absPos.Y - 36, 0, absSize.Y - cSize.Y)

				h = math.clamp(1 - relSize.X, 0, 1)
				s = math.clamp(1 - relSize.Y, 0, 1)
			end

			circle.Position = startAt and fromScale(x, y) or fromOffset(x, y)
			-- hue, sat
			return h, s
		end

		changeMiscColours = function(colour, uis)
			uis[1].Text = math.round(colour.R * 255)
			uis[2].Text = math.round(colour.G * 255)
			uis[3].Text = math.round(colour.B * 255)

			uis[4].Text = convertRGBToHex(colour)
		end

		calculateBrightness = function(absPos, absSize)
			return math.clamp(1 - (UserInputService:GetMouseLocation().Y - 36 - absPos.Y) / absSize.Y, 0, 1)
		end

		calculateSliderValue = function(absPos, absSize, startAt, min, max)
			local mousePosition = UserInputService:GetMouseLocation()
			local percent = 0
			if startAt then
				percent = 1 - (max - startAt) / (max - min)
			else
				percent = (mousePosition.X - absPos.X) / absSize.X
			end

			percent = math.clamp(percent, 0, 1)
			return percent, math.round(min + (max - min) * percent)
		end

		awaitKey = function(button, default, func)
			local selectedKey = default
			default = ALLOWED_INPUT_TYPES[default] or default

			button.Text = "..."

			local isMBS
			local cachedInput
			if not selectedKey then
				local c
				c = UserInputService.InputBegan:Connect(function(input, busy)
					if busy then return end

					local inputType = ALLOWED_INPUT_TYPES[input.UserInputType]
					isMBS = inputType
					cachedInput = input
					if not isMBS then
						local keysPressed = UserInputService:GetKeysPressed()
						for _, v in ipairs(keysPressed) do
							if v.KeyCode == input.KeyCode then
								inputType = v.KeyCode
								break
							end
						end
					end

					selectedKey = inputType
				end)

				while not selectedKey do
					RunService.RenderStepped:Wait()
				end

				c:Disconnect()
			end

			coroutine.resume(coroutine.create(func), isMBS and cachedInput.UserInputType or selectedKey)
			button.Text = default or isMBS or string.sub(tostring(selectedKey), 14)
		end
	end

	function InternalUI:Dropdown(name, list, value, callback)
		value = value or list[1]
		callback = callback or function() end

		local mainFrame = new("Frame")
		local button = new("ImageButton")
		local searchbox = new("TextBox") 
		local elementsFrame = new("ScrollingFrame")

		local tabbing = 0
		local oText = value
		local focused
		local info = TweenInfo.new(0.1)

		local function UIClose(value)
			if not focused then return end

			focused = false
			TweenService:Create(button, info, {Rotation = 0}):Play()

			mainFrame:TweenSize(UDim2.new(1, 0, 0, 30), "Out", "Quad", 0.3, true)
			local element = table.find(list, value) or findElement(list, searchbox.Text)
			if not element then
				searchbox.Text = oText
				return
			end

			element = list[element]
			searchbox.Text = string.format("%s [%s]", name, element)
			for _, v in ipairs(elementsFrame:GetChildren()) do
				if not v:IsA("UIListLayout") then
					v.Visible = true
				end
			end

			if value == oText then return end

			oText = searchbox.Text
			callback(element)
		end

		do
			local background = new("ImageLabel")
			local listFrame = new("ImageLabel")

			local listlayout = new("UIListLayout")
			listlayout.Parent = mainFrame
			listlayout.Padding = UDim.new(0, 4)

			local s = listlayout:Clone()
			s.Parent = elementsFrame

			mainFrame.Parent = self.container
			mainFrame.BackgroundTransparency = 1
			mainFrame.Size = UDim2.new(1, 0, 0, 30)
			mainFrame.ClipsDescendants = true

			background.BackgroundTransparency = 1
			background.Size = UDim2.new(1, 0, 0, 30)
			background.ZIndex = 2
			background.Image = "rbxassetid://5028857472"
			background.ImageColor3 = THEME.DarkContrast
			background.ScaleType = "Slice"
			background.SliceCenter = Rect.new(2, 2, 289, 289)
			background.Parent = mainFrame

			searchbox.BackgroundTransparency = 1
			searchbox.ZIndex = 3
			searchbox.Size = UDim2.new(1, -42, 1, 0)
			searchbox.AnchorPoint = Vector2.new(0, 0.5)
			searchbox.Font = "Gotham"
			searchbox.Text = string.format("%s [%s]", name, value)
			searchbox.TextSize = 12
			searchbox.TextColor3 = THEME.TextColor
			searchbox.TextTruncate = "AtEnd"
			searchbox.TextTransparency = 0.1
			searchbox.TextXAlignment = "Left"
			searchbox.Position = UDim2.new(0, 10, 0.5, 1)
			searchbox.Parent = background

			button.ImageColor3 = THEME.TextColor
			button.BackgroundTransparency = 1
			button.ZIndex = 3
			button.Image = "rbxassetid://5012539403"
			button.Size = fromOffset(18, 18)
			button.Position = UDim2.new(1, -28, 0.5, -9)
			button.Parent = background

			listFrame.BackgroundTransparency = 1
			listFrame.Image = "rbxassetid://5028857472"
			listFrame.ImageColor3 = THEME.Background
			listFrame.ScaleType = "Slice"
			listFrame.SliceCenter = Rect.new(2, 2, 298, 298)
			listFrame.ZIndex = 2
			listFrame.Size = UDim2.new(1, 0, 1, -34)
			listFrame.Parent = mainFrame

			elementsFrame.ClipsDescendants = true
			elementsFrame.ZIndex = 2
			elementsFrame.ScrollBarImageTransparency = 0
			elementsFrame.ScrollBarThickness = 3
			elementsFrame.ScrollBarImageColor3 = Color3.fromRGB(14, 14, 14)
			elementsFrame.ScrollingDirection = "Y"
			elementsFrame.Size = UDim2.new(1, -8, 1, -8)
			elementsFrame.BackgroundTransparency = 1
			elementsFrame.Parent = listFrame

			s:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				elementsFrame.CanvasSize = fromOffset(0, s.AbsoluteContentSize.Y)
				if focused then
					mainFrame:TweenSize(UDim2.new(1, 0, 0, math.clamp(40 + s.AbsoluteContentSize.Y, 40, 140)), "Out", "Quad", 0.3, true)
				end
			end)

			for _, v in ipairs(list) do
				local button = new("ImageButton")
				button.Size = UDim2.new(1, 0, 0, 30)
				button.ZIndex = 2
				button.Image = "rbxassetid://5028857472"
				button.ImageColor3 = THEME.DarkContrast
				button.ScaleType = Enum.ScaleType.Slice
				button.SliceCenter = Rect.new(2, 2, 298, 298)
				button.BackgroundTransparency = 1
				button.Parent = elementsFrame

				local text = new("TextLabel")
				text.BackgroundTransparency = 1
				text.Position = UDim2.new(0, 10, 0, 0)
				text.Size = UDim2.new(1, -10, 1, 0)
				text.ZIndex = 3
				text.Font = Enum.Font.Gotham
				text.Text = v
				text.TextColor3 = THEME.TextColor
				text.TextSize = 12
				text.TextXAlignment = "Left"
				text.TextTransparency = 0.1
				text.Parent = button

				button.MouseButton1Down:Connect(function()
					value = v
					UIClose(value)
				end)
			end
		end

		local function openFrame()
			if tabbing > tick() then return end

			tabbing = tick() + 1
			if button.Rotation == 0 then
				TweenService:Create(button, info, {Rotation = 180}):Play()
				mainFrame:TweenSize(UDim2.new(1, 0, 0, math.clamp(40 + elementsFrame.CanvasSize.Y.Offset, 30, 140)), "Out", "Quad", 0.3, true)
				searchbox:CaptureFocus()
			elseif focused then
				focused = false
				UIClose()
			end	
		end

		searchbox.FocusLost:Connect(function()
			if not focused or searchbox.Text == "" then 
				return
			end

			UIClose(searchbox.Text)
		end)

		searchbox.Focused:Connect(function()
			if focused then return end

			openFrame()
			focused = true
		end)

		searchbox:GetPropertyChangedSignal("Text"):Connect(function()
			local txt = searchbox.Text
			if txt == "" then 
				for _, v in ipairs(elementsFrame:GetChildren()) do
					if not v:IsA("UIListLayout") then
						v.Visible = true
					end
				end

				return 
			end

			local len = txt:len()
			for _, v in ipairs(elementsFrame:GetChildren()) do
				if not v:IsA("UIListLayout") then
					if string.sub(v:FindFirstChildOfClass("TextLabel").Text:lower(), 1, len) == txt then
						v.Visible = true
					else
						v.Visible = false
					end
				end
			end
		end)

		button.MouseButton1Down:Connect(openFrame)
	end

	function InternalUI:Slider(name, min, max, value, callback)
		min = min or 0
		max = max or 150

		value = value or min
		callback = callback or function() end 

		local main = new("ImageButton")	
		local fill = new("ImageLabel")
		local circle = new("ImageLabel")
		local bar = new("ImageLabel")
		local box = new("TextBox")
		do
			local slider = new("TextLabel")
			local title = new("TextLabel")

			main.Parent = self.container
			main.BackgroundTransparency = 1
			main.BorderSizePixel = 0
			main.Position = UDim2.new(0.292817682, 0, 0.299145311, 0)
			main.Size = UDim2.new(1, 0, 0, 50)
			main.ZIndex = 2
			main.Image = "rbxassetid://5028857472"
			main.ImageColor3 = THEME.DarkContrast
			main.ScaleType = Enum.ScaleType.Slice
			main.SliceCenter = Rect.new(2, 2, 298, 298)

			title.Parent = main
			title.BackgroundTransparency = 1
			title.Position = fromOffset(10, 6)
			title.Size = UDim2.new(0.5, 0, 0, 16)
			title.ZIndex = 3
			title.Font = "Gotham"
			title.Text = name
			title.TextColor3 = THEME.TextColor
			title.TextSize = 12
			title.TextTransparency = 0.1
			title.TextXAlignment = "Left"
			title.Parent = main

			bar.Parent = slider
			bar.AnchorPoint = Vector2.new(0, 0.5)
			bar.BackgroundTransparency = 1
			bar.Position = UDim2.new(0, 0, 0.5, 0)
			bar.Size = UDim2.new(1, 0, 0, 4)
			bar.ZIndex = 3
			bar.Image = "rbxassetid://5028857472"
			bar.ImageColor3 = THEME.LightContrast
			bar.ScaleType = Enum.ScaleType.Slice
			bar.SliceCenter = Rect.new(2, 2, 298, 298)

			box.Parent = main
			box.BackgroundTransparency = 1
			box.BorderSizePixel = 0
			box.Position = UDim2.new(1, -30, 0, 6)
			box.Size = UDim2.new(0, 20, 0, 16)
			box.ZIndex = 3
			box.Font = Enum.Font.GothamSemibold
			box.Text = value
			box.TextColor3 = THEME.TextColor
			box.TextSize = 12
			box.TextXAlignment = Enum.TextXAlignment.Right

			slider.Parent = main
			slider.BackgroundTransparency = 1
			slider.Position = UDim2.new(0, 10, 0, 28)
			slider.Size = UDim2.new(1, -20, 0, 16)
			slider.ZIndex = 3
			slider.Text = ""

			fill.Parent = bar
			fill.BackgroundTransparency = 1
			fill.Size = UDim2.new(0.8, 0, 1, 0)
			fill.ZIndex = 3
			fill.Image = "rbxassetid://5028857472"
			fill.ImageColor3 = THEME.TextColor
			fill.ScaleType = Enum.ScaleType.Slice
			fill.SliceCenter = Rect.new(2, 2, 298, 298)

			circle.Parent = fill
			circle.AnchorPoint = Vector2.new(0.5, 0.5)
			circle.BackgroundTransparency = 1
			circle.ImageTransparency = 1
			circle.ImageColor3 = THEME.TextColor
			circle.Position = UDim2.new(1, 0, 0.5, 0)
			circle.Size = UDim2.new(0, 10, 0, 10)
			circle.ZIndex = 3
			circle.Image = "rbxassetid://4608020054"
		end

		local oValue = box.Text
		local isFocused
		local function onFocusLost()
			local value = sliderBox(box.Text, min, max) or oValue
			local percent, _ = calculateSliderValue(bar.AbsolutePosition, bar.AbsoluteSize, value, min, max)

			fill:TweenSize(fromScale(percent, 1), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.02, true)

			box.Text = value
			isFocused = false
			if value == oValue then return end

			callback(value)
		end

		onFocusLost()
		box.Focused:Connect(function()
			isFocused = true
			oValue = box.Text 
		end)

		box.FocusLost:Connect(onFocusLost)

		local info = TweenInfo.new(0.1)
		local onTween = TweenService:Create(circle, info, {ImageTransparency = 0})
		local offTween = TweenService:Create(circle, info, {ImageTransparency = 1})
		mouseDetection(main, function(pressed)
			if isFocused or not self.container.Parent.Visible then return end

			onTween:Play()
			buttonDown = pressed
			while buttonDown do
				local percent, newValue = calculateSliderValue(bar.AbsolutePosition, bar.AbsoluteSize, nil, min, max)
				fill:TweenSize(fromScale(percent, 1), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.05, true)
				box.Text = newValue

				value = newValue
				RunService.RenderStepped:Wait()
			end

			if pressed then
				callback(value)
			end
		end, function()
			offTween:Play()
			buttonDown = false
		end, true)
	end

	function InternalUI:Button(name, callback)
		callback = callback or function() end

		local button = new("ImageButton") 
		local title = new("TextLabel")
		do
			button.Parent = self.container
			button.BackgroundTransparency = 1
			button.BorderSizePixel = 0
			button.Size = UDim2.new(1, 0, 0, 30)
			button.ZIndex = 2
			button.Image = "rbxassetid://5028857472"
			button.ImageColor3 = THEME.DarkContrast
			button.ScaleType = Enum.ScaleType.Slice
			button.SliceCenter = Rect.new(2, 2, 298, 298)

			title.BackgroundTransparency = 1
			title.Size = UDim2.new(1, 0, 1, 0)
			title.Position = fromOffset(10, 6)
			title.ZIndex = 3
			title.Font = Enum.Font.Gotham
			title.Text = name
			title.TextColor3 = Color3.new(1, 1, 1)
			title.TextSize = 12
			title.TextTransparency = 0.1
			title.Parent = button
		end

		local lastDone = 0
		button.MouseButton1Click:Connect(function()
			if tick() < lastDone then return end

			lastDone = tick() + 0.25
			Utility:Pop(button, 10)

			title.TextSize = 0
			Utility:Tween(title, {TextSize = 14}, 0.2)

			coroutine.resume(coroutine.create(callback))
			task.wait(0.2)

			Utility:Tween(title, {TextSize = 12}, 0.2)
		end)
	end

	function InternalUI:Toggle(name, value, callback)
		callback = callback or function() end

		local toggle = new("ImageButton")
		local toggleimg = new("ImageLabel")
		local toggleimg2 = new("ImageLabel")
		local title = new("TextLabel")
		do			
			toggle.Parent = self.container
			toggle.BackgroundTransparency = 1
			toggle.BorderSizePixel = 0
			toggle.Size = UDim2.new(1, 0, 0, 30)
			toggle.ZIndex = 2
			toggle.Image = "rbxassetid://5028857472"
			toggle.ImageColor3 = THEME.DarkContrast
			toggle.ScaleType = Enum.ScaleType.Slice
			toggle.SliceCenter = Rect.new(2, 2, 298, 298)

			title.AnchorPoint = Vector2.new(0, 0.5)
			title.TextXAlignment = "Left"
			title.TextTransparency = 0.1
			title.TextColor3 = Color3.new(1, 1, 1)
			title.Font = "Gotham"
			title.TextSize = 12
			title.Text = name
			title.ZIndex = 3
			title.Size = fromScale(0.5, 1)
			title.Position = UDim2.new(0, 10, 0.5, 1)
			title.BackgroundTransparency = 1
			title.Parent = toggle

			toggleimg.Image = "rbxassetid://5028857472"
			toggleimg.ScaleType = "Slice"
			toggleimg.ImageColor3 = Color3.fromRGB(20, 20, 20)
			toggleimg.SliceCenter = Rect.new(2, 2, 298, 298)
			toggleimg.BackgroundTransparency = 1
			toggleimg.Size = fromOffset(40, 16)
			toggleimg.ZIndex = 3
			toggleimg.Position = UDim2.new(1, -50, 0.5, -8)
			toggleimg.Parent = toggle

			toggleimg2.Image = "rbxassetid://5028857472"
			toggleimg2.ScaleType = "Slice"
			toggleimg2.ZIndex = 3
			toggleimg2.ImageColor3 = Color3.new(1, 1, 1)
			toggleimg2.BackgroundTransparency = 1
			toggleimg2.Position = UDim2.new(0, 2, 0.5, -6)
			toggleimg2.Size = UDim2.new(1, -22, 1, -4)
			toggleimg2.SliceCenter = Rect.new(2, 2, 298, 298)
			toggleimg2.Parent = toggleimg
		end

		coroutine.resume(coroutine.create(callback), value)
		tweenToggle(value, toggleimg2)

		local lastDone = 0
		toggle.MouseButton1Down:Connect(function()
			if tick() < lastDone then return end

			lastDone = tick() + 0.25
			value = not value

			-- animation
			Utility:Pop(toggle, 10)

			title.TextSize = 0
			Utility:Tween(title, {TextSize = 14}, 0.2)

			coroutine.resume(coroutine.create(callback), value)
			tweenToggle(value, toggleimg2)

			task.wait(0.05)
			Utility:Tween(title, {TextSize = 12}, 0.2)
		end)
	end

	function InternalUI:Key(name, value, callback)
		callback = callback or function() end

		local button = new("ImageButton") 
		local keybind = new("TextLabel")
		do			
			local title = new("TextLabel")
			local bg = new("ImageLabel")

			button.Parent = self.container
			button.BackgroundTransparency = 1
			button.BorderSizePixel = 0
			button.Size = UDim2.new(1, 0, 0, 30)
			button.ZIndex = 2
			button.Image = "rbxassetid://5028857472"
			button.ImageColor3 = THEME.DarkContrast
			button.ScaleType = Enum.ScaleType.Slice
			button.SliceCenter = Rect.new(2, 2, 298, 298)

			bg.Parent = button
			bg.Position = UDim2.new(1, -110, 0.5, -8)
			bg.BackgroundTransparency = 1
			bg.BorderSizePixel = 0
			bg.Size = fromOffset(100, 16)
			bg.ZIndex = 2
			bg.Image = "rbxassetid://5028857472"
			bg.ImageColor3 = THEME.DarkContrast
			bg.ScaleType = Enum.ScaleType.Slice
			bg.SliceCenter = Rect.new(2, 2, 298, 298)

			keybind.BackgroundTransparency = 1
			keybind.Size = fromScale(1, 1)
			keybind.ZIndex = 3
			keybind.Font = Enum.Font.Gotham
			keybind.Text = name
			keybind.TextColor3 = Color3.new(1, 1, 1)
			keybind.TextSize = 11
			keybind.TextTransparency = 0
			keybind.Parent = bg

			title.BackgroundTransparency = 1
			title.Size = fromScale(1, 1)
			title.TextXAlignment = "Left"
			title.Position = UDim2.new(0, 10, 0.5, 1)
			title.ZIndex = 3
			title.Font = Enum.Font.Gotham
			title.Text = name
			title.AnchorPoint = Vector2.new(0, 0.5)
			title.TextColor3 = Color3.new(1, 1, 1)
			title.TextSize = 12
			title.TextTransparency = 0.1
			title.Parent = button
		end

		awaitKey(keybind, value, callback)
		button.MouseButton1Down:Connect(function()
			awaitKey(keybind, nil, callback)
		end)
	end

	function InternalUI:ColourPicker(name, value, callback)
		value = value or Color3.new(1, 1, 1)
		callback = callback or function() end

		local originalColour = value
		local colour = originalColour

		local button = new("ImageButton")

		local mainContainer = new("Frame")
		mainContainer.ZIndex = 4

		local colourImage = new("ImageLabel")
		colourImage.ZIndex = 4

		local brightness = new("ImageLabel")
		brightness.ZIndex = 4

		local circle = new("ImageLabel")
		circle.ZIndex = 4

		local r = new("TextBox")
		r.ZIndex = 4

		local g = new("TextBox")
		g.ZIndex = 4

		local b = new("TextBox")
		b.ZIndex = 4

		local hex = new("TextBox")
		hex.ZIndex = 4

		local original
		local colourButton
		local hue, sat, value = Color3.toHSV(value)
		local miscUIs = {r, g, b, hex}
		do
			local title = new("TextLabel")

			button.BackgroundTransparency = 1
			button.Size = UDim2.new(1, 0, 0, 30)
			button.Image = "rbxassetid://5028857472"
			button.ImageColor3 = THEME.DarkContrast
			button.ScaleType = "Slice"
			button.SliceCenter = Rect.new(2, 2, 298, 298)
			button.ZIndex = 2
			button.Parent = self.container

			colourButton = button:Clone()
			colourButton.ImageColor3 = originalColour
			colourButton.Position = UDim2.new(1, -50, 0.5, -7)
			colourButton.Size = fromOffset(40, 14)
			colourButton.ZIndex = 2
			colourButton.Parent = button

			local miscFrame = new("Frame")
			miscFrame.Size = fromOffset(92, 166)
			miscFrame.Position = fromScale(0.669, 0, 0)
			miscFrame.BackgroundTransparency = 1
			miscFrame.Parent = mainContainer
			miscFrame.ZIndex = 4

			title.Text = name
			title.BackgroundTransparency = 1
			title.Size = fromOffset(183, 9)
			title.Position = fromOffset(7, 9)
			title.AnchorPoint = Vector2.new(0, 0.5)
			title.Font = "Gotham"
			title.TextColor3 = Color3.new(1, 1, 1)
			title.TextSize = 12
			title.TextXAlignment = "Left"
			title.TextTransparency = 0.1
			title.ZIndex = 3
			title.Parent = mainContainer
			title.ZIndex = 4

			title = title:Clone()
			title.BackgroundTransparency = 1
			title.Size = fromScale(1, 1)
			title.TextXAlignment = "Left"
			title.Position = UDim2.new(0, 10, 0.5, 1)
			title.ZIndex = 3
			title.Font = Enum.Font.Gotham
			title.Text = name
			title.AnchorPoint = Vector2.new(0, 0.5)
			title.TextColor3 = Color3.new(1, 1, 1)
			title.TextSize = 12
			title.TextTransparency = 0.1
			title.Parent = button

			local label = new("TextLabel")
			label.BackgroundTransparency = 1
			label.Position = fromScale(0.202, 0.293)
			label.Size = fromOffset(14, 24)
			label.Font = "Gotham"
			label.Text = "R:"
			label.TextColor3 = Color3.fromRGB(223, 223, 223)
			label.TextSize = 12
			label.Parent = miscFrame
			label.TextXAlignment = "Left"
			label.ZIndex = 4

			label = new("TextLabel")
			label.ZIndex = 4
			label.BackgroundTransparency = 1
			label.Position = fromScale(0.202, 0.429)
			label.Size = fromOffset(14, 24)
			label.Font = "Gotham"
			label.Text = "G:"
			label.TextColor3 = Color3.fromRGB(223, 223, 223)
			label.TextSize = 12
			label.Parent = miscFrame
			label.TextXAlignment = "Left"

			label = new("TextLabel")
			label.ZIndex = 4
			label.BackgroundTransparency = 1
			label.Position = fromScale(0.202, 0.577)
			label.Size = fromOffset(14, 24)
			label.Font = "Gotham"
			label.Text = "B:"
			label.TextColor3 = Color3.fromRGB(223, 223, 223)
			label.TextSize = 12
			label.Parent = miscFrame
			label.TextXAlignment = "Left"

			mainContainer.Size = fromOffset(287, 0)
			mainContainer.Position = UDim2.new(1, 5, 0, 0)
			mainContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			mainContainer.ClipsDescendants = true
			mainContainer.Parent = screengui

			colourImage.Image = "rbxassetid://698052001"
			colourImage.Size = fromOffset(164, 149)
			colourImage.Position = fromScale(0.028, 0.092)
			colourImage.Visible = false
			colourImage.Parent = mainContainer

			brightness.Image = "rbxassetid://3641079629"
			brightness.Size = fromOffset(17, 149)
			brightness.Position = fromScale(0.617, 0.092)
			brightness.Visible = false
			brightness.Parent = mainContainer

			circle.Image = "rbxassetid://5100115962"
			circle.Size = fromOffset(10, 10)
			circle.Position = fromOffset(34, 22)
			circle.Parent = colourImage

			original = button:Clone()
			original.ZIndex = 6
			original:ClearAllChildren()
			original.Image = "rbxassetid://5028857472"
			original.ImageColor3 = originalColour
			original.Size = fromOffset(62, 34)
			original.Position = fromScale(0.197, 0.758)
			original.Parent = miscFrame

			r.ZIndex = 5
			r.BackgroundTransparency = 1
			r.Size = fromOffset(24, 18)
			r.Position = fromScale(0.472, 0.313)
			r.Font = "Gotham"
			r.TextColor3 = Color3.fromRGB(223, 223, 223)
			r.TextSize = 10
			r.ClearTextOnFocus = false
			r.Text = math.floor(colour.R * 255)
			r.Parent = miscFrame

			g.ZIndex = 5
			g.BackgroundTransparency = 1
			g.Size = fromOffset(24, 18)
			g.Position = fromScale(0.472, 0.445)
			g.Font = "Gotham"
			g.TextColor3 = Color3.fromRGB(223, 223, 223)
			g.TextSize = 10
			g.ClearTextOnFocus = false
			g.Text = math.floor(colour.G * 255)
			g.Parent = miscFrame

			b.ZIndex = 5
			b.BackgroundTransparency = 1
			b.Size = fromOffset(24, 18)
			b.Position = fromScale(0.472, 0.602)
			b.Font = "Gotham"
			b.TextColor3 = Color3.fromRGB(223, 223, 223)
			b.TextSize = 10
			b.ClearTextOnFocus = false
			b.Text = math.floor(colour.B * 255)
			b.Parent = miscFrame

			hex.ZIndex = 5
			hex.BackgroundTransparency = 0.75
			hex.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
			hex.Size = fromOffset(61, 19)
			hex.Position = fromScale(0.154, 0.082)
			hex.Font = "SourceSans"
			hex.Text = convertRGBToHex(colour)
			hex.TextSize = 14
			hex.ClearTextOnFocus = false
			hex.TextColor3 = Color3.fromRGB(223, 223, 223)
			hex.TextXAlignment = "Center"
			hex.Parent = miscFrame

			pcall(ContentProvider.PreloadAsync, ContentProvider, {colourImage, circle, brightness})
			hue, sat = calculateColour(circle, colourImage.AbsolutePosition, colourImage.AbsoluteSize, colour)

			local function changedText()
				hue, sat = calculateColour(circle, colourImage.AbsolutePosition, colourImage.AbsoluteSize, colour)
				button.BackgroundColor3 = colour
				brightness.ImageColor3 = colour
				callback(colour)
			end

			local oHex = hex.Text
			hex.FocusLost:Connect(function()
				if hex.Text == oHex then return end

				local len = string.len(hex.Text)
				if not string.find(hex.Text, "#") or len > 7 then
					hex.Text = oHex
					return	
				end

				for _ = len, 6 do
					hex.Text ..= "0"
				end

				oHex = hex.Text
				colour = Color3.fromRGB(convertHexToRGB(oHex))
				changedText()
			end)

			local oR = r.Text
			local oG = g.Text
			local oB = b.Text
			r.FocusLost:Connect(function()
				if r.Text == oR then return end

				r.Text = math.clamp(r.Text, 0, 255)
				oR = r.Text
				colour = Color3.new(oR / 255, colour.G, colour.B)
				changedText()
			end)

			g.FocusLost:Connect(function()
				if g.Text == oG then return end

				g.Text = math.clamp(g.Text, 0, 255)
				oG = g.Text
				colour = Color3.new(colour.R, oG / 255, colour.B)
				changedText()
			end)

			b.FocusLost:Connect(function()
				if b.Text == oB then return end

				b.Text = math.clamp(b.Text, 0, 255)
				oB = b.Text
				colour = Color3.new(colour.R, colour.G, oB / 255)
				changedText()
			end)

			original.MouseButton1Down:Connect(function()
				colour = originalColour
				changedText()
				changeMiscColours(colour, miscUIs)
			end)
		end

		local function onPressed()
			activeContainers[mainContainer] = not activeContainers[mainContainer]
			if activeContainers[mainContainer] then
				colourImage.Visible = true
				brightness.Visible = true

				local absPosition = colourButton.AbsolutePosition
				mainContainer.Position = fromOffset(absPosition.X + 80, absPosition.Y)
				openUI(mainContainer, fromOffset(287, 176))
			else
				closeUI(mainContainer, fromOffset(287, 0))

				colourImage.Visible = false
				brightness.Visible = false
			end
		end		

		local colourDown, brightnessDown
		local lastTicked = 0
		mouseDetection(colourImage, function(pressed)
			colourDown = pressed
			while colourDown do
				hue, sat = calculateColour(circle, colourImage.AbsolutePosition, colourImage.AbsoluteSize)
				colour = Color3.fromHSV(hue, sat, value)
				colourButton.ImageColor3 = colour
				brightness.ImageColor3 = colour

				changeMiscColours(colour, miscUIs)
				RunService.RenderStepped:Wait()
			end

			if pressed then
				callback(colour)
			end
		end, function()
			if colourDown then
				lastTicked = tick() + 2
				colourDown = false
				callback(colour)
			end
		end)

		mouseDetection(brightness, function(pressed)
			brightnessDown = pressed
			while brightnessDown do
				value = calculateBrightness(brightness.AbsolutePosition, brightness.AbsoluteSize)
				colour = Color3.fromHSV(hue, sat, value)
				colourButton.ImageColor3 = colour

				changeMiscColours(colour, miscUIs)
				RunService.RenderStepped:Wait()
			end

			if pressed then
				callback(colour)
			end
		end, function()
			if brightnessDown then
				lastTicked = tick() + 2
				brightnessDown = false
				callback(colour)
			end
		end)

		Utility:DraggingEnabled(mainContainer, nil, function()
			return not (brightnessDown or colourDown) and lastTicked < tick()
		end)

		button.MouseButton1Down:Connect(onPressed)
		colourButton.MouseButton1Down:Connect(onPressed)
	end

	function InternalUI:Section(name)
		local container = new("Frame")		
		do			
			local listlayout = new("UIListLayout")
			listlayout.Padding = UDim.new(0, 4)
			listlayout.FillDirection = "Vertical"
			listlayout.HorizontalAlignment = "Left"
			listlayout.VerticalAlignment = "Top"
			listlayout.Parent = container

			container.ClipsDescendants = true
			container.BackgroundTransparency = 1
			container.Parent = self.container

			local title = new("TextLabel")
			title.BackgroundTransparency = 1
			title.Text = name
			title.ZIndex = 2
			title.Size = UDim2.new(1, 0, 0, 20)
			title.Font = "GothamSemibold"
			title.TextXAlignment = "Left"
			title.TextColor3 = Color3.new(1, 1, 1)
			title.TextSize = 12
			title.Parent = container

			container.Size = UDim2.new(1, -10, 0, listlayout.AbsoluteContentSize.Y)
			listlayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				container.Size = UDim2.new(1, -10, 0, listlayout.AbsoluteContentSize.Y)
			end)
		end

		return setmetatable({
			container = container
		}, InternalUI)
	end

	function UI:Tab(name)
		local container = new("ScrollingFrame")
		local button = new("TextButton")
		local icon = new("ImageLabel")

		local btnTweenO = TweenService:Create(button, TAB_INFO, {TextTransparency = 0.65})
		local btnTween = TweenService:Create(button, TAB_INFO, {TextTransparency = 0})

		local icnTween0 = TweenService:Create(icon, TAB_INFO, {ImageTransparency = 0.65})
		local icnTween = TweenService:Create(icon, TAB_INFO, {ImageTransparency = 0})
		do
			local main = new("Frame")
			local list = new("UIListLayout")

			list.Padding = UDim.new(0, 10)
			list.FillDirection = "Vertical"
			list.HorizontalAlignment = "Left"
			list.VerticalAlignment = "Top"
			list.Parent = container

			container.BackgroundTransparency = 1
			container.Size = UDim2.new(1, -142, 1, -56)
			container.Position = fromOffset(134, 46)
			container.ScrollBarThickness = 3
			container.ScrollBarImageTransparency = 0
			container.ScrollBarImageColor3 = Color3.fromRGB(14, 14, 14)
			container.ScrollingDirection = "Y"
			container.Parent = self.mainContainer

			main.BackgroundTransparency = 1
			main.Size = UDim2.new(1, 0, 0, 26)
			main.ZIndex = 2

			icon.AnchorPoint = Vector2.new(0, 0.5)
			icon.BackgroundTransparency = 1
			icon.Size = fromOffset(16, 16)
			icon.Position = UDim2.new(0, 12, 0.5, 0)
			icon.Image = "rbxassetid://5012544693"
			icon.ImageTransparency = 0.65
			icon.Parent = main
			icon.ZIndex = 2

			button.BackgroundTransparency = 1
			button.AnchorPoint = Vector2.new(0, 0.5)
			button.Position = UDim2.new(0, 40, 0.5, 0)
			button.Size = UDim2.new(0, 76, 1, 0)
			button.Font = "GothamSemibold"
			button.Text = name
			button.TextSize = 12
			button.TextXAlignment = "Left"
			button.ZIndex = 2
			button.TextTransparency = 0.65
			button.Parent = main

			main.Parent = self.container

			list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				local abs = list.AbsoluteContentSize
				container.CanvasSize = fromOffset(abs.X, abs.Y)
			end)
		end

		local lastSelected = 0
		if self.selectedContainer then
			container.Visible = false
			container.Position = fromOffset(520, 46)
		else
			btnTween:Play()
			icnTween:Play()

			self.selectedContainer = container
			self.label = btnTweenO
			self.icon = icnTween0
		end

		button.MouseButton1Down:Connect(function()
			if self.selectedContainer == container or tick() < lastSelected then return end

			lastSelected = tick() + 1
			local oSelected = self.selectedContainer
			oSelected:TweenPosition(fromOffset(134, 450), "In", "Quad", 0.25, true, function()
				oSelected.Position = fromOffset(520, 46)
				oSelected.Visible = false
			end)

			self.label:Play()
			self.icon:Play()

			btnTween:Play()
			icnTween:Play()
			container.Visible = true
			container:TweenPosition(fromOffset(134, 46), "In", "Quad", 0.25, true)

			self.selectedContainer = container
			self.label = btnTweenO
			self.icon = icnTween0
		end)

		return setmetatable({
			container = container,
		}, InternalUI)
	end

	function UI.new(name)
		screengui = new("ScreenGui")
		local main = new("Frame")

		Utility:DraggingEnabled(main)
		local container = new("ScrollingFrame")

		screengui.Parent = CoreGui

		main.Size = fromOffset(511, 428)
		main.BackgroundTransparency = 1
		main.AnchorPoint = Vector2.new(0.5, 0.5)
		main.Position = fromScale(0.5, 0.5)
		main.ClipsDescendants = true
		main.Parent = screengui

		container.Size = UDim2.new(0, 126, 1, -48)
		container.Position = fromOffset(0, 48)
		container.BackgroundColor3 = THEME.Background
		container.ZIndex = 2
		container.BackgroundTransparency = 1
		container.ScrollBarThickness = 0
		container.ScrollingDirection = "Y"
		container.VerticalScrollBarPosition = "Right"
		container.Parent = main

		local disabled
		local waiting
		UserInputService.InputBegan:Connect(function(key, busy)
			if busy or waiting then return end

			if key.KeyCode ~= Enum.KeyCode.RightShift then return end

			disabled = not disabled
			waiting = true
			if disabled then
				local waitedOnce
				for i, v in pairs(activeContainers) do
					if v then
						if not waitedOnce then
							closeUI(i, fromOffset(287, 0))	
						else
							coroutine.resume(coroutine.create(closeUI), i, fromOffset(287, 0))
						end

						waitedOnce = true
					end
				end

				main:TweenSize(fromOffset(511, 0), "In", "Quad", 0.35, true, function()
					screengui.Enabled = false
					waiting = false
				end)
			else					
				screengui.Enabled = true
				main:TweenSize(fromOffset(511, 428), "In", "Quad", 0.35, true, function()
					for i, v in pairs(activeContainers) do
						if v then
							coroutine.resume(coroutine.create(openUI), i, fromOffset(287, 176))
						end
					end
					
					waiting = false
				end)
			end
		end)

		do
			local bg = new("ImageLabel")

			local glow = new("ImageLabel")
			local title = new("Frame")
			local label = new("TextLabel")

			local layout = new("UIListLayout")

			layout.Padding = UDim.new(0, 10)
			layout.FillDirection = "Vertical"
			layout.HorizontalAlignment = "Left"
			layout.VerticalAlignment = "Top"
			layout.Parent = container

			bg.Image = "rbxassetid://4641149554"
			bg.Size = fromScale(1, 1)
			bg.Position = fromScale(0, 0)
			bg.ImageColor3 = Color3.fromRGB(24, 24, 24)
			bg.ScaleType = "Slice"
			bg.SliceCenter = Rect.new(4, 4, 296, 296)
			bg.SliceScale = 1
			bg.Parent = main

			title.Position = fromScale(0, 0)
			title.BackgroundTransparency = 1
			title.Size = UDim2.new(1, 0, 0, 48)
			title.Parent = bg

			label.Text = name or "Test"
			label.Font = "GothamBold"
			label.BackgroundTransparency = 1
			label.Size = UDim2.new(1, -46, 1, 0)
			label.Position = fromOffset(12, 19)
			label.TextXAlignment = "Left"
			label.TextSize = 14
			label.AnchorPoint = Vector2.new(0, 0.5)
			label.Parent = title

			glow.Image = "rbxassetid://5028857084"
			glow.Size = UDim2.new(1, 30, 1, 30)
			glow.Position = fromOffset(-15, -15)
			glow.ImageColor3 = Color3.new(0, 0, 0)
			glow.ScaleType = "Slice"
			glow.SliceCenter = Rect.new(24, 24, 276, 276)
			glow.SliceScale = 1
			glow.Parent = main
		end

		return setmetatable({
			container = container,
			mainContainer = main,
			screengui = screengui
		}, UI)
	end
end

return UI
