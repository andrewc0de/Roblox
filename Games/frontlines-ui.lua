-- initialization
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/andrewc0de/Roblox/main/Dependencies/venyx.lua"))()
local ui = UI.new("Frontlines - andrewcode", 5013109572)

local themes = {
	Background = Color3.fromRGB(24, 24, 24),
	Glow = Color3.fromRGB(0, 0, 0),
	Accent = Color3.fromRGB(10, 10, 10),
	LightContrast = Color3.fromRGB(20, 20, 20),
	DarkContrast = Color3.fromRGB(14, 14, 14),  
	TextColor = Color3.fromRGB(255, 255, 255)
}


local tab = ui:addPage("Main", 5012544693)
local ESPSection = tab:addSection("ESP Settings")

-- load external ESP script
local esp = loadstring(game:HttpGet("https://raw.githubusercontent.com/andrewc0de/Roblox/main/Dependencies/ESP.lua"))()

-- set default ESP settings
esp:Toggle(true)
esp.Boxes = false
esp.Names = false
esp.Tracers = false
esp.Players = false
esp.FaceCamera = true 

-- add toggle buttons to ESP section
ESPSection:addToggle("ESP Master Switch", true, function(toggle)
    esp:Toggle(toggle)
end)

ESPSection:addToggle("Show Boxes", false, function(toggle)
    esp.Boxes = toggle 
end)

ESPSection:addToggle("Show Names", false, function(toggle)
    esp.Names = toggle 
end)

ESPSection:addToggle("Show Tracers", false, function(toggle)
    esp.Tracers = toggle 
end)

ESPSection:addToggle("Face Camera", true, function(toggle)
    esp.FaceCamera = toggle 
end)

-- load the ESP listener
esp:AddObjectListener(workspace, {
    Name = "soldier_model",
    Type = "Model",
    Color = Color3.fromRGB(255, 0, 4),

    -- Specify the primary part of the model as the HumanoidRootPart
    PrimaryPart = function(obj)
        local pos = obj:FindFirstChild("HumanoidRootPart").Position --get the pos to reference to 
        local root
        repeat
            for _, bp in pairs(workspace:GetChildren()) do --find the basepart to highlight
                if bp:IsA("BasePart") then
                    local distance = (bp.Position - pos).Magnitude
                    if distance <= 3 then
                        root = bp 
                        break 
                    end
                end
            end
            task.wait()
        until root
        return root
    end,

    Validator = function(obj)
        -- Wait for 1 second before continuing execution
        task.wait(1)

        -- Check if the object has a child named "friendly_marker"
        -- If it does, return false immediately
        if obj:FindFirstChild("friendly_marker") then
            return false
        end

        return true 
    end,

    CustomName = "🤤", -- set a custom name to use for the enemy models
    IsEnabled = "enemy" -- enable the ESP for enemy models
})

-- add toggle buttons for enemy models to ESP targets section
local ESPSection2 = tab:addSection("ESP Targets")
esp.enemy = true
ESPSection2:addToggle("Show Players", true, function(toggle)
    esp.enemy = toggle 
end)

-- set default hitbox settings
local size = Vector3.new(10, 10, 10)
local trans = 1
local notifications = true -- default value

-- function to handle when a new enemy model is added to the workspace
local function handleDescendantAdded(descendant)
    task.wait(1)

    -- If the new descendant is an enemy model and notifications are enabled, send a notification
    if descendant.Name == "soldier_model" and descendant:IsA("Model") and not descendant:FindFirstChild("friendly_marker") then
        if notifications then
            game.StarterGui:SetCore("SendNotification", {
                Title = "Script",
                Text = "[Warning] New Enemy Spawned! Applied hitboxes.",
                Icon = "",
                Duration = 3
            })
        end

        -- Apply hitboxes to the new enemy model
        local pos = descendant:FindFirstChild("HumanoidRootPart").Position
        for _, bp in pairs(workspace:GetChildren()) do
            if bp:IsA("BasePart") then
                local distance = (bp.Position - pos).Magnitude
                if distance <= 5 then
                    bp.Transparency = trans
                    bp.Size = size
                end
            end
        end
    end
end

local connectionthing 
local hitboxon = true 

local HitboxSection = tab:addSection("Hitbox Settings")

-- add toggle button for hitboxes and its corresponding function
HitboxSection:addToggle("Enable Hitboxes", true, function(toggle)
    hitboxon = toggle 
    if hitboxon then 
        connectionthing = game.Workspace.DescendantAdded:Connect(handleDescendantAdded)
    else
        connectionthing:Disconnect()
    end 
end)

-- add slider buttons for hitbox size and transparency and their corresponding functions
HitboxSection:addSlider("Hitbox Size", 10, 0, 50, function(value)
    size = Vector3.new(value,value,value)
    --reapply hitboxes
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "soldier_model" and v:IsA("Model") and not v:FindFirstChild("friendly_marker") then
            local pos = v:FindFirstChild("HumanoidRootPart").Position
            for _, bp in pairs(workspace:GetChildren()) do
                if bp:IsA("BasePart") then
                    local distance = (bp.Position - pos).Magnitude
                    if distance <= 5 then
                        bp.Transparency = trans
                        bp.Size = size
                    end
                end
            end
        end
    end
end)

HitboxSection:addSlider("Hitbox Transparency (Greater = more)", 100, 0, 100, function(value)
    trans = (value / 100)
    --reapply hitboxes
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "soldier_model" and v:IsA("Model") and not v:FindFirstChild("friendly_marker") then
            local pos = v:FindFirstChild("HumanoidRootPart").Position
            for _, bp in pairs(workspace:GetChildren()) do
                if bp:IsA("BasePart") then
                    local distance = (bp.Position - pos).Magnitude
                    if distance <= 5 then
                        bp.Transparency = trans
                        bp.Size = size
                    end
                end
            end
        end
    end
end)

task.wait(1)

-- apply hitboxes to all existing enemy models in the workspace
for _, v in pairs(workspace:GetDescendants()) do
    if v.Name == "soldier_model" and v:IsA("Model") and not v:FindFirstChild("friendly_marker") then
        local pos = v:FindFirstChild("HumanoidRootPart").Position
        for _, bp in pairs(workspace:GetChildren()) do
            if bp:IsA("BasePart") then
                local distance = (bp.Position - pos).Magnitude
                if distance <= 5 then
                    bp.Transparency = trans
                    bp.Size = size
                end
            end
        end
    end
end

local theme = ui:addPage("Settings", 5012544693)
local othersettings = theme:addSection("Settings")

othersettings:addKeybind("Toggle Keybind", Enum.KeyCode.End, function()
	ui:toggle()
end)

othersettings:addButton("Copy Discord link", function()
    setclipboard('https://discord.gg/4gdBU887Te')
end)

local colors = theme:addSection("Colors")

for theme, color in pairs(themes) do -- all in one theme changer, i know, im cool
	colors:addColorPicker(theme, color, function(color3)
		ui:setTheme(theme, color3)
	end)
end

--[[
local playertab = ui:addPage("Player", 5012544693)
local playermods = playertab:addSection("Player Modifications")

loadstring(game:HttpGet('https://raw.githubusercontent.com/andrewc0de/Roblox/main/Dependencies/metatables.lua'))()

local function addhook()
    game.Players.LocalPlayer.Character.Humanoid.hook("WalkSpeed", 16)
    game.Players.LocalPlayer.Character.Humanoid.hook("JumpPower", 16)
end

playermods:addSlider("WalkSpeed", 16, 0, 200, function(value)
    pcall(function()
        addhook()
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
        game.Players.LocalPlayer.Character.Humanoid.lock("WalkSpeed", value)
    end) 
end)

playermods:addSlider("JumpPower", 50, 0, 250, function(value)
    pcall(function()
        addhook()
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
        game.Players.LocalPlayer.Character.Humanoid.lock("JumpPower", value)
    end) 
end)
]]

-- load
ui:SelectPage(ui.pages[1], true)
ui:Notify("This shit made by andrewcode!", "Join my Discord in the settings page !!!")
