local a=loadstring(game:HttpGet("https://raw.githubusercontent.com/andrewc0de/Roblox/main/Dependencies/venyx.lua"))()local b=a.new("Frontlines - andrewcode",5013109572)local c={Background=Color3.fromRGB(24,24,24),Glow=Color3.fromRGB(0,0,0),Accent=Color3.fromRGB(10,10,10),LightContrast=Color3.fromRGB(20,20,20),DarkContrast=Color3.fromRGB(14,14,14),TextColor=Color3.fromRGB(255,255,255)}local d=b:addPage("Main",5012544693)local e=d:addSection("ESP Settings")local f=loadstring(game:HttpGet("https://raw.githubusercontent.com/andrewc0de/Roblox/main/Dependencies/ESP.lua"))()f:Toggle(true)f.Boxes=false;f.Names=false;f.Tracers=false;f.Players=false;f.FaceCamera=true;e:addToggle("ESP Master Switch",true,function(g)f:Toggle(g)end)e:addToggle("Show Boxes",false,function(g)f.Boxes=g end)e:addToggle("Show Names",false,function(g)f.Names=g end)e:addToggle("Show Tracers",false,function(g)f.Tracers=g end)e:addToggle("Face Camera",true,function(g)f.FaceCamera=g end)f:AddObjectListener(workspace,{Name="soldier_model",Type="Model",Color=Color3.fromRGB(255,0,4),PrimaryPart=function(h)local i=h:FindFirstChild("HumanoidRootPart").Position;local j;repeat for k,l in pairs(workspace:GetChildren())do if l:IsA("BasePart")then local m=(l.Position-i).Magnitude;if m<=3 then j=l;break end end end;task.wait()until j;return j end,Validator=function(h)task.wait(1)if h:FindFirstChild("friendly_marker")then return false end;return true end,CustomName="🤤",IsEnabled="enemy"})local n=d:addSection("ESP Targets")f.enemy=true;n:addToggle("Show Players",true,function(g)f.enemy=g end)local o=Vector3.new(10,10,10)local p=1;local q=true;local function r(s)task.wait(1)if s.Name=="soldier_model"and s:IsA("Model")and not s:FindFirstChild("friendly_marker")then if q then game.StarterGui:SetCore("SendNotification",{Title="Script",Text="[Warning] New Enemy Spawned! Applied hitboxes.",Icon="",Duration=3})end;local i=s:FindFirstChild("HumanoidRootPart").Position;for k,l in pairs(workspace:GetChildren())do if l:IsA("BasePart")then local m=(l.Position-i).Magnitude;if m<=5 then l.Transparency=p;l.Size=o end end end end end;local t;local u=true;local v=d:addSection("Hitbox Settings")v:addToggle("Enable Hitboxes",true,function(g)u=g;if u then t=game.Workspace.DescendantAdded:Connect(r)else t:Disconnect()end end)v:addSlider("Hitbox Size",10,0,50,function(w)o=Vector3.new(w,w,w)for k,x in pairs(workspace:GetDescendants())do if x.Name=="soldier_model"and x:IsA("Model")and not x:FindFirstChild("friendly_marker")then local i=x:FindFirstChild("HumanoidRootPart").Position;for k,l in pairs(workspace:GetChildren())do if l:IsA("BasePart")then local m=(l.Position-i).Magnitude;if m<=5 then l.Transparency=p;l.Size=o end end end end end end)v:addSlider("Hitbox Transparency (Greater = more)",100,0,100,function(w)p=w/100;for k,x in pairs(workspace:GetDescendants())do if x.Name=="soldier_model"and x:IsA("Model")and not x:FindFirstChild("friendly_marker")then local i=x:FindFirstChild("HumanoidRootPart").Position;for k,l in pairs(workspace:GetChildren())do if l:IsA("BasePart")then local m=(l.Position-i).Magnitude;if m<=5 then l.Transparency=p;l.Size=o end end end end end end)task.wait(1)for k,x in pairs(workspace:GetDescendants())do if x.Name=="soldier_model"and x:IsA("Model")and not x:FindFirstChild("friendly_marker")then local i=x:FindFirstChild("HumanoidRootPart").Position;for k,l in pairs(workspace:GetChildren())do if l:IsA("BasePart")then local m=(l.Position-i).Magnitude;if m<=5 then l.Transparency=p;l.Size=o end end end end end;local y=b:addPage("Settings",5012544693)local z=y:addSection("Settings")z:addKeybind("Toggle Keybind",Enum.KeyCode.End,function()b:toggle()end)z:addButton("Copy Discord link",function()setclipboard('https://discord.gg/4gdBU887Te')end)local A=y:addSection("Colors")for y,B in pairs(c)do A:addColorPicker(y,B,function(C)b:setTheme(y,C)end)end;b:SelectPage(b.pages[1],true)b:Notify("This shit made by andrewcode!","Join my Discord in the settings page !!!")
