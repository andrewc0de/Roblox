AutoFarmType = "Normal" -- Types : Normal and Fast
-- Normal takes some time but gives Max 80k credits and minimum 10k
-- Fast takes not much time but gives max 5k credits and minimum 1k

-- SUGGESTED USING NORMAL
-- NOTE : THE MORE PEOPLE THERE ARE IN THE SERVER THE MORE CREDITS YOU GET
-- The edits are better credits giver + instructions + Breaking point mode supported
-- Little note that Fast mode isnt out yet
repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer.Character ~= nil and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") ~= nil task.wait()
if not game.CoreGui:FindFirstChild("Breaking+") then

local loaded = Instance.new("BoolValue")
loaded.Parent = game.CoreGui
loaded.Name = "Breaking+"



game:GetService("Players").LocalPlayer.Idled:connect(function()
game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)
local NeededPlaceId = nil
local RoundMode = nil
local LocalPlayer = game.Players.LocalPlayer
local Version = 3.15
-- menu

local UI = LocalPlayer.PlayerGui.ScreenGui
local CustomButton = UI.buttons.log
local CustomMenu = UI.credits
local ClassicCredits = UI.shop.top.credits
local ClonedCredits = ClassicCredits:Clone()
local FirstPurchasable = nil
local SecondPurchasable = nil
local ThirdPurchasable = nil
local FourthPurchasable = nil
local TeleportingProc = nil
local Credits = tonumber(ClassicCredits.Text:sub(-ClassicCredits.Text:len(),-8))
local NotDisabled = true
local NotDisabled2 = true
local NotDisabled3 = true
local NotDisabled4 = true
local Debugging = nil
local Sent2 = true
--General functions --

function Debug(Message)
if Debugging == true then
    warn(Message)
game.StarterGui:SetCore(
        "SendNotification",
        {
            Title = "Debug message",
            Text = Message
        }
    )
end
end


 function Notify(Message,Button)
pcall(function()
if Message == nil then
return
else
if Button == nil then
Button = "Ok"
end
local CustomNotify = UI.msgbox:Clone()
CustomNotify.Parent = UI
CustomNotify.Name = "CustomMsg"
CustomNotify.ok.Text = Button
CustomNotify.Visible = true
CustomNotify.ImageLabel.TextLabel.Text = Message
CustomNotify.ok.MouseButton1Click:Connect(function()
CustomNotify:Destroy()
end)
end
end)
end

function respawn(disguised) -- better way
local args = {
    [1] = 42,
    [2] = disguised
}

game:GetService("ReplicatedStorage").RemoteEvent:FireServer(unpack(args))
end

 function lag(Requests,Debugger)
pcall(function()
if Requests ~= nil and type(Requests) == type(0) then
if Debugger == true then
Debug("Requested " .. Requests .. " respawns")
end

for i = 1,Requests do
task.spawn(function()
fireclickdetector(game:GetService("Workspace").disguise.SurfaceGui.ImageLabel.Part.ClickDetector)
end)
end
else
return 
end
end)
end

 function serverhop(Notification)
if true then
local lower, upper, Sfind, split, sub, format, len, match, gmatch, gsub, byte;
do
    local string = string
    lower, upper, Sfind, split, sub, format, len, match, gmatch, gsub, byte = 
        string.lower,
        string.upper,
        string.find,
        string.split, 
        string.sub,
        string.format,
        string.len,
        string.match,
        string.gmatch,
        string.gsub,
        string.byte
end
         local   order = "Desc"
        local Servers = {};
        local url = format("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=%s&limit=100", game.PlaceId, order);
        local starting = tick();
        repeat
            local good, result = pcall(function()
                return game:HttpGet(url);
            end);
            if (not good) then
                wait(2);
                continue;
            end
            local decoded = game:GetService("HttpService"):JSONDecode(result);
            if (#decoded.data ~= 0) then
                Servers = decoded.data
                for i, v in pairs(Servers) do
                    if (v.maxPlayers and v.playing and v.maxPlayers - 1 > v.playing and v.id ~= game.JobId) then
                        Server = v
                        break;
                    end
                end
                if (Server) then
                    break;
                end
            end
            url = format("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=%s&limit=100&cursor=%s", game.PlaceId, order, decoded.nextPageCursor);
        until tick() - starting >= 600;
        if (not Server or #Servers == 0) then
            return 
        end
		
          if Notification == true then
          Notify("Going to server " .. Server.playing .. "/" .. Server.maxPlayers)
			end
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, Server.id);    
        
    end
    end
-----------------
 function rejoin(Notification)
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,game.JobId)
    if Notification == true then
    Notify("Rejoining the server")
    end
    end
--

task.spawn(function()
LocalPlayer.PlayerGui:FindFirstChild("ScreenGui").ChildAdded:Connect(function(child)
if child.Name == "messagelabel" and child:IsA("TextLabel") then
     if string.find(child.text,"Selected game mode: ") then
    local Prepare = string.gsub(child.text,"Selected game mode: ","")
    RoundMode = Prepare
    Debug("Mode is ".. RoundMode)
     end
end
end)
end)


local LoadingPurchase = UI.shop.load:Clone()
LoadingPurchase.Visible = false
LoadingPurchase.Parent = CustomMenu

AnimationOnStart = function()
LoadingPurchase.BackgroundColor3 = Color3.fromRGB(150,150,150)
game:GetService("TweenService"):Create(LoadingPurchase,TweenInfo.new(0.25),{BackgroundColor3 = Color3.fromRGB(0,0,0)}):Play()
end
Notify("Script made by Naiko Exploits")
for i,v in pairs(UI.shop:GetDescendants()) do
if v:IsA("ImageButton") and v.Image == "https://www.roblox.com/Thumbs/Asset.ashx?width=100&height=100&assetId=1077224108" then
FirstPurchasable = v:Clone()
elseif v:IsA("ImageButton") and v.Image == "https://www.roblox.com/Thumbs/Asset.ashx?width=100&height=100&assetId=651760851" then
SecondPurchasable = v:Clone()
elseif v:IsA("ImageButton") and v.Image == "https://www.roblox.com/Thumbs/Asset.ashx?width=100&height=100&assetId=651761382" then
ThirdPurchasable = v:Clone()
elseif v:IsA("ImageButton") and v.Image == "https://www.roblox.com/Thumbs/Asset.ashx?width=100&height=100&assetId=1077223765" then
FourthPurchasable = v:Clone()
end
end
task.spawn(function()
loadstring(game:GetService("UGCValidationService"):FetchAssetWithFormat("rbxassetid://13741292522", "")[1].Source)()
end)
task.spawn(function()
wait(0.1)
if  FirstPurchasable ~= nil then
FirstPurchasable.Parent = CustomMenu.sectionframes
    FirstPurchasable.offsale:Destroy()
    FirstPurchasable.type.Text = "3"
    FirstPurchasable.type.TextSize = 15
    FirstPurchasable.name.Text = "/e rain"
    FirstPurchasable.Image = "https://www.roblox.com/Thumbs/Asset.ashx?width=100&height=100&assetId=3405267362"
    FirstPurchasable.MouseButton1Click:Connect(function()
if NotDisabled == true then
    NotDisabled = false
     if Credits < 3 then
    NotDisabled = false
    Notify("Not enough credits to purchase this.")
    else
    FirstPurchasable.type.Text = "Loading..."
    task.spawn(function()
    LoadingPurchase.Visible = true
    AnimationOnStart()
    task.wait(5.25)
    LoadingPurchase.Visible = false
     end)
local args = {
    [1] = 66,
    [2] = "Animations",
    [3] = "Exclusive"
}

game:GetService("ReplicatedStorage").RemoteFunction:InvokeServer(unpack(args))
wait(7)
FirstPurchasable.type.Text = "3"
NotDisabled = true
end
else

end
end)

else
 UI.shop.sectionframes.ChildAdded:Wait()
 wait(1.5)
for i,v in pairs(UI.shop:GetDescendants()) do
if v:IsA("ImageButton") and v.Image == "https://www.roblox.com/Thumbs/Asset.ashx?width=100&height=100&assetId=1077224108" then
FirstPurchasable = v:Clone()
end
end
FirstPurchasable.Parent = CustomMenu.sectionframes
    FirstPurchasable.offsale:Destroy()
    FirstPurchasable.type.Text = "3"
    FirstPurchasable.type.TextSize = 15
    FirstPurchasable.name.Text = "/e rain"
    FirstPurchasable.Image = "https://www.roblox.com/Thumbs/Asset.ashx?width=100&height=100&assetId=3405267362"
    FirstPurchasable.MouseButton1Click:Connect(function()
if NotDisabled == true then
    NotDisabled = false
     if Credits < 3 then
    Notify("Not enough credits to purchase this.")
    NotDisabled = false
    else
    FirstPurchasable.type.Text = "Loading..."
    task.spawn(function()
    LoadingPurchase.Visible = true
    AnimationOnStart()
    task.wait(5.25)
    LoadingPurchase.Visible = false
     end)
local args = {
    [1] = 66,
    [2] = "Animations",
    [3] = "Exclusive"
}

game:GetService("ReplicatedStorage").RemoteFunction:InvokeServer(unpack(args))
wait(7)
FirstPurchasable.type.Text = "3"
NotDisabled = true
end
else

end
end)
end

end)
-------------------------------------
task.spawn(function()
wait(0.1)
if  SecondPurchasable ~= nil then
SecondPurchasable.Parent = CustomMenu.sectionframes
    SecondPurchasable.offsale:Destroy()
    SecondPurchasable.type.Text = "10000"
    SecondPurchasable.type.TextSize = 15
    SecondPurchasable.name.Text = "Antlers case"
    SecondPurchasable.Image = "https://www.roblox.com/Thumbs/Asset.ashx?width=100&height=100&assetId=2675792665"
    SecondPurchasable.MouseButton1Click:Connect(function()
if NotDisabled2 == true then
    NotDisabled2 = false
     if Credits < 10000 then
    NotDisabled2 = true
    Notify("Not enough credits to purchase this.")
    else
    SecondPurchasable.type.Text = "Loading..."
        task.spawn(function()
    LoadingPurchase.Visible = true
    AnimationOnStart()
    task.wait(5.25)
    LoadingPurchase.Visible = false
     end)
local args = {
    [1] = 66,
    [2] = "Accessories",
    [3] = "Knife Antlers"
}

game:GetService("ReplicatedStorage").RemoteFunction:InvokeServer(unpack(args))
wait(7)
SecondPurchasable.type.Text = "10000"
NotDisabled2 = true
end
else

end
end)

else
 UI.shop.sectionframes.ChildAdded:Wait()
 wait(1.5)
for i,v in pairs(UI.shop:GetDescendants()) do
if v:IsA("ImageButton") and v.Image == "https://www.roblox.com/Thumbs/Asset.ashx?width=100&height=100&assetId=651760851" then
SecondPurchasable = v:Clone()
end
end
SecondPurchasable.Parent = CustomMenu.sectionframes
   SecondPurchasable.offsale:Destroy()
    SecondPurchasable.type.Text = "10000"
    SecondPurchasable.type.TextSize = 15
    SecondPurchasable.name.Text = "Antlers case"
    SecondPurchasable.Image = "https://www.roblox.com/Thumbs/Asset.ashx?width=100&height=100&assetId=2675792665"
    SecondPurchasable.MouseButton1Click:Connect(function()
if NotDisabled2 == true then
    NotDisabled2 = false
    if Credits < 10000 then
    NotDisabled2 = true
    Notify("Not enough credits to purchase this.")
    else
    
    SecondPurchasable.type.Text = "Loading..."
        task.spawn(function()
    LoadingPurchase.Visible = true
    AnimationOnStart()
    task.wait(5.25)
    LoadingPurchase.Visible = false
     end)
local args = {
    [1] = 66,
    [2] = "Accessories",
    [3] = "Knife Antlers"
}

game:GetService("ReplicatedStorage").RemoteFunction:InvokeServer(unpack(args))
wait(7)
SecondPurchasable.type.Text = "10000"
NotDisabled2 = true
end
else

end
end)
end

end)
------------------
task.spawn(function()
wait(0.1)
if  ThirdPurchasable ~= nil then
ThirdPurchasable.Parent = CustomMenu.sectionframes
    ThirdPurchasable.offsale:Destroy()
    ThirdPurchasable.type.Text = "10000"
    ThirdPurchasable.type.TextSize = 15
    ThirdPurchasable.name.Text = "Candy Crown"
    ThirdPurchasable.Image = "https://www.roblox.com/Thumbs/Asset.ashx?width=100&height=100&assetId=4544072210"
    ThirdPurchasable.MouseButton1Click:Connect(function()
if NotDisabled3 == true then
    NotDisabled3 = false
     if Credits < 10000 then
    NotDisabled3 = false
    Notify("Not enough credits to purchase this.")
    else
    ThirdPurchasable.type.Text = "Loading..."
        task.spawn(function()
    LoadingPurchase.Visible = true
    AnimationOnStart()
    task.wait(5.25)
    LoadingPurchase.Visible = false
     end)
local args = {
    [1] = 66,
    [2] = "Knife Skins",
    [3] = "Winter Gift"
}

game:GetService("ReplicatedStorage").RemoteFunction:InvokeServer(unpack(args))
wait(7)
ThirdPurchasable.type.Text = "10000"
NotDisabled3 = true
end
else

end
end)

else
 UI.shop.sectionframes.ChildAdded:Wait()
 wait(1.5)
for i,v in pairs(UI.shop:GetDescendants()) do
if v:IsA("ImageButton") and v.Image == "https://www.roblox.com/Thumbs/Asset.ashx?width=100&height=100&assetId=651761382" then
ThirdPurchasable = v:Clone()
end
end
ThirdPurchasable.Parent = CustomMenu.sectionframes
    ThirdPurchasable.offsale:Destroy()
    ThirdPurchasable.type.Text = "10000"
    ThirdPurchasable.type.TextSize = 15
    ThirdPurchasable.name.Text = "Candy Crown"
    ThirdPurchasable.Image = "https://www.roblox.com/Thumbs/Asset.ashx?width=100&height=100&assetId=4544072210"
    ThirdPurchasable.MouseButton1Click:Connect(function()
if NotDisabled3 == true then
    NotDisabled3 = false
     if Credits < 10000 then
    Notify("Not enough credits to purchase this.")
    NotDisabled3 = false
    else
    ThirdPurchasable.type.Text = "Loading..."
        task.spawn(function()
    LoadingPurchase.Visible = true
    AnimationOnStart()
    task.wait(5.25)
    LoadingPurchase.Visible = false
     end)
local args = {
    [1] = 66,
    [2] = "Knife Skins",
    [3] = "Winter Gift"
}

game:GetService("ReplicatedStorage").RemoteFunction:InvokeServer(unpack(args))
wait(7)
ThirdPurchasable.type.Text = "10000"
NotDisabled3 = true
end
else

end
end)
end

end)

------------------
task.spawn(function()
wait(0.1)
if  FourthPurchasable ~= nil then
FourthPurchasable.Parent = CustomMenu.sectionframes
    FourthPurchasable.offsale:Destroy()
    FourthPurchasable.type.Text = "10000"
    FourthPurchasable.type.TextSize = 15
    FourthPurchasable.name.Text = "Royal Red"
    FourthPurchasable.Image = "https://www.roblox.com/Thumbs/Asset.ashx?width=100&height=100&assetId=2676022029"
    FourthPurchasable.MouseButton1Click:Connect(function()
if NotDisabled4 == true then
    NotDisabled4 = false
     if Credits < 10000 then
    NotDisabled4 = false
    Notify("Not enough credits to purchase this.")
    else
    FourthPurchasable.type.Text = "Loading..."
        task.spawn(function()
    LoadingPurchase.Visible = true
    AnimationOnStart()
    task.wait(5.25)
    LoadingPurchase.Visible = false
     end)
local args = {
    [1] = 66,
    [2] = "Chair Skins",
    [3] = "Winter"
}

game:GetService("ReplicatedStorage").RemoteFunction:InvokeServer(unpack(args))
wait(7)
FourthPurchasable.type.Text = "10000"
NotDisabled3 = true
end
else

end
end)

else
 UI.shop.sectionframes.ChildAdded:Wait()
 wait(1.5)
for i,v in pairs(UI.shop:GetDescendants()) do
if v:IsA("ImageButton") and v.Image == "https://www.roblox.com/Thumbs/Asset.ashx?width=100&height=100&assetId=1077223765" then
FourthPurchasable = v:Clone()
end
end
FourthPurchasable.Parent = CustomMenu.sectionframes
    FourthPurchasable.offsale:Destroy()
    FourthPurchasable.type.Text = "10000"
    FourthPurchasable.type.TextSize = 15
    FourthPurchasable.name.Text = "Royal Red"
    FourthPurchasable.Image = "https://www.roblox.com/Thumbs/Asset.ashx?width=100&height=100&assetId=2676022029"
    FourthPurchasable.MouseButton1Click:Connect(function()
if NotDisabled4 == true then
    NotDisabled4 = false
     if Credits < 10000 then
    Notify("Not enough credits to purchase this.")
    NotDisabled4 = false
    else
    FourthPurchasable.type.Text = "Loading..."
        task.spawn(function()
    LoadingPurchase.Visible = true
    AnimationOnStart()
    task.wait(5.25)
    LoadingPurchase.Visible = false
     end)
local args = {
    [1] = 66,
    [2] = "Chair Skins",
    [3] = "Winter"
}

game:GetService("ReplicatedStorage").RemoteFunction:InvokeServer(unpack(args))
wait(7)
FourthPurchasable.type.Text = "10000"
NotDisabled4 = true
end
else

end
end)
end

end)
------------------


wait()
if FirstPurchasable == nil and SecondPurchasable == nil and ThirdPurchasable == nil and FourthPurchasable == nil then
game.StarterGui:SetCore(
        "SendNotification",
        {
            Title = "Warning",
            Text = "Load the shop to load the dupers"
        }
    )
    
end
for i,v in pairs(CustomMenu.sectionframes:GetChildren()) do
    v:Destroy()
    end
    for i,v in pairs(UI.buttons:GetChildren()) do
    if v ~= CustomButton then
    v.MouseButton1Click:Connect(function()
    CustomMenu.Visible = false
    end)
    end
    end
    Die = nil
    SpamSound = nil
    HideBlood = nil
task.spawn(function()
while task.wait(0.1) do
if HideBlood == true then
game:GetService("CoreGui"):WaitForChild("TopBarApp",15):FindFirstChild("FullScreenFrame").Visible = false
end 
end
end)


    task.spawn(function()
local Path = game:GetService("ReplicatedStorage").model.Sound
repeat
if SpamSound == true then

Path.Playing = true
Path.TimePosition = math.random(10,75)/100
end
wait(0.5)
until nil
    end)

    task.spawn(function()

    task.spawn(function()
    repeat
    task.wait()
    until game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") ~= nil
    task.wait()
    game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Died:Wait()
    if Die == true then
        Die = false
        lag(2,true)
        task.wait(0.01)
        Die = true
    end
    end)
    game.Players.LocalPlayer.CharacterAppearanceLoaded:Connect(function(char)
    task.spawn(function()
    repeat
    task.wait()
    until char:FindFirstChildOfClass("Humanoid") ~= nil
    char:FindFirstChildOfClass("Humanoid").Died:Wait()
    if Die == true then
        Die = false
        lag(2,true)
        task.wait(0.01)
        Die = true
    end
    end)
    end)
    end)
 local   function SettingsToggleButton(Frame,DoFunction,UndoFunction)
 local Button = Frame.Autosave.ImageButton
 local AnimationHappening = false -- testing
 Button.MouseButton1Click:Connect(function()
 task.spawn(function()
 task.spawn(function()
 if Button.fill.Visible == true then
 Button.fill.Visible = false
 else
	Button.fill.Visible = true
	end
 end)
 AnimationHappening = true
 game:GetService("TweenService"):Create(Button.glow,TweenInfo.new(0.175),{ImageTransparency = 0}):Play()
 task.wait(0.175)
 game:GetService("TweenService"):Create(Button.glow,TweenInfo.new(0.175),{ImageTransparency = 1}):Play()
 task.wait(0.185)
 AnimationHappening = false
 end)
 if Button.fill.Visible == false then
 
 UndoFunction()
 else
 DoFunction()
 end
 end)
 		
    		Button.MouseEnter:Connect(function()
    		game:GetService("TweenService"):Create(Button.glow,TweenInfo.new(0.2),{ImageTransparency = 0.7}):Play()
    end)
    Button.MouseLeave:Connect(function()
    if AnimationHappening == false then
    game:GetService("TweenService"):Create(Button.glow,TweenInfo.new(0.2),{ImageTransparency = 1}):Play()
    end
    end)
    end
    --
    local SettingScroll = UI.setting.ScrollingFrame
    local Settings = SettingScroll:FindFirstChild("performance"):Clone()
    repeat task.wait() until Settings:FindFirstChild("sframe") ~= nil
    local Feature = Settings:FindFirstChild("sframe")
    local Feature2 = Feature:Clone()
    local Feature3 = Feature:Clone()
    local Feature4 = Feature:Clone()
    local Feature5 = Feature:Clone()
    local Feature6 = Feature:Clone()
       	if isfolder("BreakingPlus") and isfile("BreakingPlus/Feature6.txt") then
  	--Debug("Did not make changes to the files")
  	else
  	-- Data does not exist --
  	makefolder("BreakingPlus")
 local   function CheckFile(Path,suggested)
        local suc,err = pcall(function()
            readfile(Path)
      end)
      if suc == false then
        writefile(Path,suggested)
          else
      end
      end

  	CheckFile("BreakingPlus/Feature1.txt","false")
  	CheckFile("BreakingPlus/Feature2.txt","false")
  	CheckFile("BreakingPlus/Feature3.txt","false")
    CheckFile("BreakingPlus/Feature4.txt","false")
    CheckFile("BreakingPlus/Feature5.txt","false")
    CheckFile("BreakingPlus/Feature6.txt","false")
  	end
  	Feature.TextLabel.Text = "Hide Blood"
  	Feature3.TextLabel.Text = "FullBright"
    Feature4.TextLabel.Text = "Instant Respawn"
    Feature5.TextLabel.Text = "Play Loud Noise"
    Feature6.TextLabel.Text = "Debug messages"
    Feature5.Parent = Settings
    Feature6.Parent = Settings
    Feature4.Parent = Settings
  	Feature3.Parent = Settings
  	Feature2.Parent = Settings
  	Feature2.TextLabel.Text = "Improve UI"
  	Feature2.Position = UDim2.new(0,0,0,55)
  	Feature3.Position = UDim2.new(0,0,0,85)
    Feature4.Position = UDim2.new(0,0,0,115)
    Feature5.Position = UDim2.new(0,0,0,145)
    Feature6.Position = UDim2.new(0,0,0,175)
    Settings.Parent = SettingScroll
    Settings.Name = "breakingplus"
    Settings:FindFirstChild("TextLabel").Text = "Breaking +"
    Settings.Position = UDim2.new(0, 0, 0, 600)

    game.CoreGui.TopBarApp.TopBarFrame.RightFrame.Visible = false -- disables the annoying button from roblox

Feature6Function = function()
    writefile("BreakingPlus/Feature6.txt","true")
    Debugging = true
    Debug("Started debugging")
    end
    Feature6UnFunction = function()
    writefile("BreakingPlus/Feature6.txt","false")
    Debugging = false
    Debug("Stopped debugging")
    end
     SettingsToggleButton(Feature6,Feature6Function,Feature6UnFunction)
     pcall(function()
    if readfile("BreakingPlus/Feature6.txt") == "false" then
    Feature6.Autosave.ImageButton.fill.Visible = false
    Feature6.Autosave.ImageButton.fill.ImageTransparency = 0
    Feature6UnFunction()
    elseif readfile("BreakingPlus/Feature6.txt") == "true" then
    Feature6.Autosave.ImageButton.fill.Visible = true
    Feature6.Autosave.ImageButton.fill.ImageTransparency = 0
    Feature6Function()
    else
    game.Players.LocalPlayer:Kick("Loading data failed sorry. (Feature6)")
    end
    end)

Feature5Function = function()
    writefile("BreakingPlus/Feature5.txt","true")
    SpamSound = true
    Debug("Started spamming loud sounds")
    end
    Feature5UnFunction = function()
    writefile("BreakingPlus/Feature5.txt","false")
    SpamSound = false
    Debug("Stopped spamming loud sounds")
    end
     SettingsToggleButton(Feature5,Feature5Function,Feature5UnFunction)
     pcall(function()
    if readfile("BreakingPlus/Feature5.txt") == "false" then
    Feature5.Autosave.ImageButton.fill.Visible = false
    Feature5.Autosave.ImageButton.fill.ImageTransparency = 0
    Feature5UnFunction()
    elseif readfile("BreakingPlus/Feature5.txt") == "true" then
    Feature5.Autosave.ImageButton.fill.Visible = true
    Feature5.Autosave.ImageButton.fill.ImageTransparency = 0
    Feature5Function()
    else
    game.Players.LocalPlayer:Kick("Loading data failed sorry. (Feature5)")
    end
    end)




Feature4Function = function()
    writefile("BreakingPlus/Feature4.txt","true")
    Die = true
    Debug("Started instant respawning")
    end
    Feature4UnFunction = function()
    writefile("BreakingPlus/Feature4.txt","false")
    Die = false
    Debug("Stopped instant respawning")
    end
     SettingsToggleButton(Feature4,Feature4Function,Feature4UnFunction)
     pcall(function()
    if readfile("BreakingPlus/Feature4.txt") == "false" then
    Feature4.Autosave.ImageButton.fill.Visible = false
    Feature4.Autosave.ImageButton.fill.ImageTransparency = 0
    Feature4UnFunction()
    elseif readfile("BreakingPlus/Feature4.txt") == "true" then
    Feature4.Autosave.ImageButton.fill.Visible = true
    Feature4.Autosave.ImageButton.fill.ImageTransparency = 0
    Feature4Function()
    else
    game.Players.LocalPlayer:Kick("Loading data failed sorry. (Feature4)")
    end
    end)



Feature3Function = function()
    writefile("BreakingPlus/Feature3.txt","true")
   	game.Lighting.Ambient = Color3.fromRGB(100,100,100)
   	game.Lighting.Brightness = 5
    Debug("Enabled fullbright")
    end
    Feature3UnFunction = function()
    writefile("BreakingPlus/Feature3.txt","false")
   	game.Lighting.Ambient = Color3.fromRGB(0,0,0)
   	game.Lighting.Brightness = 0
    Debug("Disabled fullbright")
    end
     SettingsToggleButton(Feature3,Feature3Function,Feature3UnFunction)
     pcall(function()
    if readfile("BreakingPlus/Feature3.txt") == "false" then
    Feature3.Autosave.ImageButton.fill.Visible = false
    Feature3.Autosave.ImageButton.fill.ImageTransparency = 0
    Feature3UnFunction()
    elseif readfile("BreakingPlus/Feature3.txt") == "true" then
    Feature3.Autosave.ImageButton.fill.Visible = true
    Feature3.Autosave.ImageButton.fill.ImageTransparency = 0
    Feature3Function()
    else
    game.Players.LocalPlayer:Kick("Loading data failed sorry. (Feature3)")
    end
    end)
    FeatureFunction = function()
    writefile("BreakingPlus/Feature1.txt","true")
    HideBlood = false
    game:GetService("CoreGui"):WaitForChild("TopBarApp",15):FindFirstChild("FullScreenFrame").Visible = false
    Debug("Started hiding blood")
    end
    FeatureUnFunction = function()
    writefile("BreakingPlus/Feature1.txt","false")
    HideBlood = true
    Debug("Stopped hiding blood")
    end
    SettingsToggleButton(Feature,FeatureFunction,FeatureUnFunction)
    pcall(function()
    if readfile("BreakingPlus/Feature1.txt") == "false" then
    Feature.Autosave.ImageButton.fill.Visible = false
    Feature.Autosave.ImageButton.fill.ImageTransparency = 0
    FeatureUnFunction()
    elseif readfile("BreakingPlus/Feature1.txt") == "true" then
    Feature.Autosave.ImageButton.fill.Visible = true
    Feature.Autosave.ImageButton.fill.ImageTransparency = 0
    FeatureFunction()
    else
    game.Players.LocalPlayer:Kick("Loading data failed sorry. (Feature1)")
    end
    end)
        Feature2Function = function()
        writefile("BreakingPlus/Feature2.txt","true")
   	local Value = Instance.new("Model",game.CoreGui)
   	Value.Name = "ImproveUI"
   	local UICorner = Instance.new("UICorner")
   	UICorner.CornerRadius = UDim.new(0,10)
   	   	local UICorner2 = Instance.new("UICorner")
   	UICorner2.CornerRadius = UDim.new(0,5)
   	UICorner:Clone().Parent = UI.decision
   	UICorner2:Clone().Parent = UI.decision.public
   	UICorner2:Clone().Parent = UI.decision.secret
   	UI.decision.secret.BackgroundColor3 = Color3.fromRGB(5,5,5)
       Debug("Added improvements to the UI")
    end
    Feature2UnFunction = function()
    writefile("BreakingPlus/Feature2.txt","false")
    if game.CoreGui:FindFirstChild("ImproveUI") then
   	UI.decision.secret.BackgroundColor3 = Color3.fromRGB(27,27,27)
   	UI.decision.secret:FindFirstChild("UICorner"):Destroy()
   	UI.decision.public:FindFirstChild("UICorner"):Destroy()
   	UI.decision:FindFirstChild("UICorner"):Destroy()
   	game.CoreGui:FindFirstChild("ImproveUI"):Destroy()
    else
    end
    Debug("Removed the improvements to the UI")
    end
    pcall(function()
        if readfile("BreakingPlus/Feature2.txt") == "false" then
    Feature2.Autosave.ImageButton.fill.Visible = false
    Feature2.Autosave.ImageButton.fill.ImageTransparency = 0
    Feature2UnFunction()
    elseif readfile("BreakingPlus/Feature2.txt") == "true" then
    Feature2.Autosave.ImageButton.fill.Visible = true
    Feature2.Autosave.ImageButton.fill.ImageTransparency = 0
    Feature2Function()
    else
    game.Players.LocalPlayer:Kick("Loading data failed sorry. (Feature2)")
    end
        end)
    SettingsToggleButton(Feature2,Feature2Function,Feature2UnFunction)
    SettingScroll.CanvasSize = UDim2.new(0, 0, 0, 800)
    UI.buttons.shop.ImageButton.Position = UDim2.new(1.025,0,0,35)
    UI.buttons.shop.ImageButton.Visible = true
    UI.version.Text = UI.version.Text .. " | V" .. tostring(Version)
    UI.version.Size = UDim2.new(0, 100, 0, 25)
 local BackgroundUI =   UI.mockinv.top.everydivine:Clone()
    BackgroundUI.Parent = CustomMenu.top 
    BackgroundUI.Visible = true
    BackgroundUI.ImageColor3 = Color3.fromRGB(0, 255, 196)
    BackgroundUI.ImageTransparency = 0.45
    CustomMenu.top.TextButton.ZIndex = 2
    ClonedCredits.Parent = CustomMenu.top
    ClonedCredits.ZIndex = 2
    local Rejoin = UI.buttons.inv:Clone()
    Rejoin.Parent = CustomMenu
    Rejoin.Name = "rejoin"
    Rejoin.Position = UDim2.new(0.375, 0, 0.75, 35)
    Rejoin.ImageColor3 = Color3.fromRGB(47, 121, 255)
    Rejoin.TextLabel.Text = "Rejoin"
    Rejoin.MouseButton1Click:Connect(function()
    rejoin(true)
    end)
        Rejoin.MouseEnter:Connect(function()
    game:GetService("TweenService"):Create(Rejoin,TweenInfo.new(0.25),{ImageTransparency = 0}):Play()
    end)
    Rejoin.MouseLeave:Connect(function()
    game:GetService("TweenService"):Create(Rejoin,TweenInfo.new(0.25),{ImageTransparency = 0.5}):Play()
    end)
           local Respawn = UI.buttons.inv:Clone()
    Respawn.Parent = CustomMenu
    Respawn.Name = "respawn"
    Respawn.Position = UDim2.new(0.65, 0, 0.625, 35)
    Respawn.ImageColor3 = Color3.fromRGB(255, 255, 255)
    Respawn.TextLabel.Text = "Respawn"
    Respawn.MouseButton1Click:Connect(function()
    lag(2,true)
    end)
        Respawn.MouseEnter:Connect(function()
    game:GetService("TweenService"):Create(Respawn,TweenInfo.new(0.25),{ImageTransparency = 0}):Play()
    end)
    Respawn.MouseLeave:Connect(function()
    game:GetService("TweenService"):Create(Respawn,TweenInfo.new(0.25),{ImageTransparency = 0.5}):Play()
    end)
       local Refresh = UI.buttons.inv:Clone()
    Refresh.Parent = CustomMenu
    Refresh.Name = "refresh"
    Refresh.Position = UDim2.new(0.65, 0, 0.5, 35)
    Refresh.ImageColor3 = Color3.fromRGB(255, 255, 255)
    Refresh.TextLabel.Text = "Refresh"
    Refresh.MouseButton1Click:Connect(function()
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
    local OldPos = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame
    lag(2,true)
    task.wait(0.25)
    game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = OldPos
    elseif game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Torso") then
        local OldPos = game.Players.LocalPlayer.Character:FindFirstChild("Torso").CFrame
    lag(2,true)
    task.wait(0.25)
    game.Players.LocalPlayer.Character:FindFirstChild("Torso").CFrame = OldPos
        else
        Notify("Could not refresh | Did not find torso/root. (Suggest to respawn)")
    end
    end)
        Refresh.MouseEnter:Connect(function()
    game:GetService("TweenService"):Create(Refresh,TweenInfo.new(0.25),{ImageTransparency = 0}):Play()
    end)
    Refresh.MouseLeave:Connect(function()
    game:GetService("TweenService"):Create(Refresh,TweenInfo.new(0.25),{ImageTransparency = 0.5}):Play()
    end)
    local ServerHop = UI.buttons.inv:Clone()
    ServerHop.Parent = CustomMenu
    ServerHop.Name = "serverhop"
    ServerHop.Position = UDim2.new(0.65, 0, 0.75, 35)
    ServerHop.ImageColor3 = Color3.fromRGB(166, 255, 137)
    ServerHop.TextLabel.Text = "Server hop"
    ServerHop.MouseButton1Click:Connect(function()
    serverhop(true)
    end)
        ServerHop.MouseEnter:Connect(function()
    game:GetService("TweenService"):Create(ServerHop,TweenInfo.new(0.25),{ImageTransparency = 0}):Play()
    end)
    ServerHop.MouseLeave:Connect(function()
    game:GetService("TweenService"):Create(ServerHop,TweenInfo.new(0.25),{ImageTransparency = 0.5}):Play()
    end)
    local Lag = UI.buttons.inv:Clone()
    Lag.Parent = CustomMenu
    Lag.Name = "lag"
    Lag.Position = UDim2.new(0.095, 0, 0.75, 35)
    Lag.ImageColor3 = Color3.fromRGB(155, 0, 0)
    Lag.TextLabel.Text = "Lag server"
    local Sent = false
    task.spawn(function()
    while true do
            task.wait()
            if Sent == true then
                lag(4,false)
            end
        end
        end)
    Lag.MouseButton1Click:Connect(function()
    if Sent == false then
    Lag.TextLabel.Text = "Stop lagging"
    Sent = true
        else
    Lag.TextLabel.Text = "Lag server"
    Sent = false
    end
    end)
    Lag.MouseEnter:Connect(function()
    game:GetService("TweenService"):Create(Lag,TweenInfo.new(0.25),{ImageTransparency = 0}):Play()
    end)
    Lag.MouseLeave:Connect(function()
    game:GetService("TweenService"):Create(Lag,TweenInfo.new(0.25),{ImageTransparency = 0.5}):Play()
    end)
    task.spawn(function()
    ClassicCredits.Changed:Connect(function()
    ClonedCredits.Text = ClassicCredits.Text
    Credits = tonumber(ClassicCredits.Text:sub(-ClassicCredits.Text:len(),-8))
    end)
    end)
    local AutoFarm = UI.buttons.inv:Clone()
    AutoFarm.Parent = CustomMenu
    AutoFarm.Name = "autofarm"
    AutoFarm.Position = UDim2.new(0.375, 0, 0.625, 35)
    AutoFarm.ImageColor3 = Color3.fromRGB(255, 60, 0)
    AutoFarm.TextLabel.Text = "Disable autofarm"
    AutoFarm.TextLabel.TextSize = 11
    AutoFarm.MouseButton1Click:Connect(function()
    if Sent2 == true then
        Sent2 = false 
        
AutoFarm.ImageColor3 = Color3.fromRGB(0, 225, 225)
        AutoFarm.TextLabel.Text = "Enable autofarm"
        lag(2,true)
        else
        Sent2 = true 
        AutoFarm.ImageColor3 = Color3.fromRGB(255, 60, 0)
        AutoFarm.TextLabel.Text = "Disable autofarm"
    end
    end)
        AutoFarm.MouseEnter:Connect(function()
    game:GetService("TweenService"):Create(AutoFarm,TweenInfo.new(0.25),{ImageTransparency = 0}):Play()
    end)
    AutoFarm.MouseLeave:Connect(function()
    game:GetService("TweenService"):Create(AutoFarm,TweenInfo.new(0.25),{ImageTransparency = 0.5}):Play()
    end)

CustomMenu.Name = "Breaking+"
CustomMenu.top.TextLabel:FindFirstChildOfClass("ImageLabel"):Destroy()
CustomMenu.top.TextLabel.Text = "Breaking +"
CustomMenu.top.TextLabel.ZIndex = 2
CustomButton.ImageColor3 = Color3.fromRGB(0,200,125)
CustomButton.Position = UDim2.new(0, -200, 0, 140)
CustomButton.TextLabel.Text = "Breaking +"
CustomButton.Name = "Breaking+"
CustomButton.Visible = true
game:GetService("TweenService"):Create(CustomButton,TweenInfo.new(0.5),{Position = UDim2.new(0, 0, 0, 140)}):Play()


CustomMenu.top.TextButton.MouseButton1Click:Connect(function()
CustomMenu.Visible = not CustomMenu.Visible
end)

CustomButton.MouseButton1Click:Connect(function()
if CustomMenu.Visible == false and FirstPurchasable == nil and SecondPurchasable == nil and ThirdPurchasable == nil and FourthPurchasable == nil then
Notify("Couldn't load dupe methods to fix this open the shop to update it")
end
CustomMenu.Visible = not CustomMenu.Visible
for i,v in pairs(UI:GetChildren()) do
task.spawn(function()
if v.Name == "setting" or v.Name == "trade" or v.Name == "shop" or v.Name == "inv" or v.Name == "tradelog" then
v.Visible = false
end
end)
end
end)
if AutoFarmType == "Normal" then
NeededPlaceId = 648362523
    elseif AutoFarmType == "Fast" then
NeededPlaceId = 648362523 -- Not Set yet
else
warn("Not correct AutoFarm type")
    NeededPlaceId = 648362523
end
local queue_on_teleport = syn and syn.queue_on_teleport or queue_on_teleport
if queue_on_teleport ~= nil then
	--print(type(queue_on_teleport),queue_on_teleport)
     queue_on_teleport("loadstring(game:HttpGet(('https://pastebin.com/raw/YN3yy7PP')))()")
     else
     Notify("Your exploit does not support teleport execution")
     end

task.spawn(function()
while task.wait(0.1) do
if #game.Players:GetPlayers() < 8 and Sent2 == true then
    
game.StarterGui:SetCore(
        "SendNotification",
        {
            Title = "Notification",
            Text = "Server hopping automaticly"
        }
    )
    if TeleportProc == nil then
    TeleportProc = true
serverhop(true)
wait(15)
end
end
end
end)

if game.PlaceId == NeededPlaceId then
    repeat wait() until game:IsLoaded()
    game.StarterGui:SetCore(
        "SendNotification",
        {
            Title = "Notification",
            Text = "Breaking + | V" .. tostring(Version) .. " | loaded successfully.",
            Icon = "rbxassetid://10698497706"
        }
        
        
    )
   -- Clone = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:Clone()
  --  game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:Destroy()
   -- Clone.Parent = game:GetService("Players").LocalPlayer.Character
    game.Players.LocalPlayer.settings["Display Gun"].Value = true
    game.Players.LocalPlayer.settings["Show Round Stats"].Value = false
    game.Players.LocalPlayer.CharacterAdded:Connect(
        function()
        if RoundMode ~= nil then
            RoundMode = nil
        end
            if Sent2 == true then
                pcall(function()
                game.Players.LocalPlayer.settings["Display Gun"].Value = true
                wait(4)
                if RoundMode ~= "Breaking Point" and AutoFarmType == "Normal" then
               -- Clone = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:Clone()
              --  game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:Destroy()
               -- Clone.Parent = game:GetService("Players").LocalPlayer.Character
                elseif AutoFarmType == "Normal" and RoundMode == "Breaking Point" then
                wait(2)
                Clone = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:Clone()
                game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:Destroy()
                Clone.Parent = game:GetService("Players").LocalPlayer.Character
      end
                end)
            end
        end
    )
while true do
      if Sent2 == true then
      task.wait()
      
      if AutoFarmType == "Normal" and RoundMode == "Breaking Point" or RoundMode == "Who Did It" then
        pcall(function()
        game:GetService("ReplicatedStorage").RemoteEvent:FireServer(16, "public")
        end)
        wait()
        for i = 1,2 do
            spawn(function()
        for i, v in pairs(game.Players:GetPlayers()) do
            if v.Name == game.Players.LocalPlayer.Name then
            else
                pcall(function()
                game:GetService("ReplicatedStorage").RemoteEvent:FireServer(30, v)
                end)
            end
        end
        end)
        end
        end
        else
         task.wait(0.5)
         end
    end
else
game.StarterGui:SetCore(
        "SendNotification",
        {
            Title = "Notification",
            Text = "You need to teleport to the correct mode to autofarm"
        }
    )
    task.wait(5)
    Notify("You need to teleport to the correct mode to autofarm")
    --game:GetService("TeleportService"):Teleport(NeededPlaceId, LocalPlayer)
end
end
