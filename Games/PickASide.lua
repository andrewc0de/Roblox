_G["xJ3kL9"] = not (_G["xJ3kL9"] and true or false)

local function zQ8nT5()
    local vH2rB7 = {}
    function vH2rB7:uY4nW3(qV5pT2)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Script";
            Text = qV5pT2;
            Icon = "";
            Duration = 5;
        })
    end
    return function(mY6kL1)
        vH2rB7:uY4nW3(mY6kL1)
    end
end

local oR9fJ8 = zQ8nT5()

oR9fJ8("Script status toggled to " .. (function(nD7mK3) return nD7mK3 and "true" or "false" end)(_G["xJ3kL9"]) .. ".")

local function wV0pH6()
    while (function() return _G["xJ3kL9"] == true end)() do 
        task.wait()
        if ((function()
            local bZ4lN2 = game:GetService("Players").LocalPlayer.PlayerGui.Gui.Status.Title.Text
            return bZ4lN2 == "Pick a Side!"
        end)()) then
            local fJ1kP8
            local aG7rL0 = math.random(1, 500)

            fJ1kP8 = (function(eL4bQ9)
                if eL4bQ9 % 2 == 0 then
                    return "Blue"
                else
                    return "Red"
                end
            end)(aG7rL0)

            local qY2mD1 = (function()
                return game.Workspace[fJ1kP8].Screen.Gui.Title.Text
            end)()

            oR9fJ8("Picked " .. fJ1kP8 .. " side with choice '" .. qY2mD1 .. "'.")

            local hC6sT4 = (function()
                return game.Workspace[fJ1kP8].Detect.CFrame * CFrame.new(0,10,0)
            end)()

            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = hC6sT4

            oR9fJ8("Waiting for new round...")

            local function waitForNewRound()
                repeat
                    task.wait()
                until game:GetService("Players").LocalPlayer.PlayerGui.Gui.Status.Title.Text ~= "Pick a Side!"
            end

            waitForNewRound()
        end
    end
end

wV0pH6()
