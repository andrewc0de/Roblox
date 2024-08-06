local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/andrewc0de/Roblox/main/Dependencies/KiriotESP.lua"))()

-- Default settings 
ESP:Toggle(true)
ESP.Players = false 
ESP.Tracers = false 
ESP.Boxes = true 
ESP.Names = false

local charBodies = game.Workspace:FindFirstChild("charBodies")

if charBodies then 
    print("Got charBodies folder")
else
    print("Failed to get charBodies folder...")
end 


-- Add ESP listener 
ESP:AddObjectListener(charBodies, {
    Name = "charBody",
    Type = "Model",
    Color = Color3.fromRGB(255, 0, 4),
    PrimaryPart = function(obj) -- Set the primary part to the torso  
        local torso = obj:FindFirstChild("torso")
        while not torso do 
            task.wait()
            torso = obj:FindFirstChild("torso")
        end
        return torso 
    end, 
    Validator = function(obj)
        if obj:FindFirstChild("friendlyTag") then 
            return false 
        else
            task.wait(2) -- To ensure the torso is loaded
            if obj:FindFirstChild("friendlyTag") then 
                return false 
            else
                return true 
            end
        end
    end, 
    CustomName = "Enemy",
    IsEnabled = "player"
}); ESP.player = true 

-- Periodic check for misapplied ESPs
task.spawn(function()
    while true do task.wait(3)
        pcall(function()
            for obj, box in pairs(ESP.Objects) do
                if box.Type == "Box" and obj:IsA("Model") then
                    local torso = obj:FindFirstChild("torso")
                    if torso and torso:FindFirstChild("friendlyTag") then
                        box:Remove()
                        print("Removed ESP from friendlyTagged torso")
                    end
                end
            end
        end) 
    end
end)

