-- Github: https://github.com/RealLinen
-- Discord: linenhs
newcclosure = typeof(newcclosure) == "function" and newcclosure or (function(...) return ... end)
local function Initialize(name)
    name = type(name) == "string" and name or "hookmt"
    
end

-- Bypass Adonsis Anti-Cheat
loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixeluted/adoniscries/main/Source.lua"))()

-- : Middle Man
local __indexHook = function(isexploit, defaultvalue, Self, Key)
    -- defaultvalue: function
    -- isexploit: boolean, checks if call was from exploit or not
    if isexploit then
        --print("Aye", Self:GetFullName(), Key)
    end
    return defaultvalue()
end
local __newindexHook = function(isexploit, defaultvalue, Self, Key, Value)
    -- defaultvalue: function
    -- isexploit: boolean, checks if call was from exploit or not
    if isexploit then
        --print(Self, Key, Value)
    end
    return defaultvalue()
end
local __namecallHook = function(isexploit, defaultvalue, Self, namecallmethod, ...)
    -- defaultvalue: function
    -- isexploit: boolean, checks if call was from exploit or not
    local args = {...}
    --[[
        Remote:FireServer("hello", "hi")
        Self = Remote [ Instance ]
        FireServer = namecallmethod
        "hello" and "hi" = args [ They're just inside of tables, so like {"hello", "hi"} ]
        ------------- Remember, this is just an example. Scripts in games will fire with different args/arguments or different namecallmethod with different Instances
    ]]
    return defaultvalue()
end


-- Hooking rblox calls
getgenv()["hookmt"] = getgenv()["hookmt"] or {
    player = game:GetService("Players").LocalPlayer,
    teleportservice = game:GetService("TeleportService"),
}
getgenv()["hookmt"].oldIndex = getgenv()["hookmt"].oldIndex or hookmetamethod(game, "__index", newcclosure(function(...)
    local Args = {...}
    local defaultvalue = newcclosure(function(...)
        local otherargs = {...}
        if #otherargs <= 0 then
            otherargs = Args
        end
        return getgenv()["hookmt"].oldIndex(unpack(otherargs))
    end)
    return newcclosure((getgenv()["hookmt"]["__index"] or __indexHook))((checkcaller or function() return false end)(), defaultvalue, ...)
end))
getgenv()["hookmt"].oldNewIndex = getgenv()["hookmt"].oldNewIndex or hookmetamethod(game, "__newindex", newcclosure(function(...)
    local Args = {...}
    local defaultvalue = newcclosure(function(...)
        local otherargs = {...}
        if #otherargs <= 0 then
            otherargs = Args
        end
        return getgenv()["hookmt"].oldNewIndex(unpack(otherargs))
    end)
    return newcclosure((getgenv()["hookmt"]["__newindex"] or __newindexHook))((checkcaller or function() return false end)(), defaultvalue, ...)
end))
getgenv()["hookmt"].oldNamecall = getgenv()["hookmt"].oldNamecall or hookmetamethod(game, "__namecall", newcclosure(function(Self, ...)
    local Args = {...}
    local defaultvalue = newcclosure(function(...)
        local otherargs = {...}
        if #otherargs <= 0 then
            otherargs = Args
        end
        return getgenv()["hookmt"].oldNamecall(Self, unpack(otherargs))
    end)
    return newcclosure((getgenv()["hookmt"]["__namecall"] or __namecallHook))((checkcaller or function() return false end)(), defaultvalue, Self, (getnamecallmethod or function() return "" end)(), ...)
end))

-- Finalize Hooks, you can customize this by making ur own functions
getgenv()["hookmt"]["__index"] = __indexHook
getgenv()["hookmt"]["__newindex"] = __newindexHook
getgenv()["hookmt"]["__namecall"] = __namecallHook
getgenv()["hookmt"]["rejoin"] = function(jobid)
    if typeof(jobid) == "boolean" or jobid == nil then
        -- Rejoin same server
        getgenv()["hookmt"].teleportservice:TeleportToPlaceInstance(game.PlaceId, game.JobId, getgenv()["hookmt"]["player"])
    elseif typeof(jobid) == "string" then
        -- Join to custom JobId
        getgenv()["hookmt"].teleportservice:TeleportToPlaceInstance(game.PlaceId, jobid, getgenv()["hookmt"]["player"])
    end
end
return Initialize

-- To return custom values, define it inside of defaultvalues. For example:
-- Lets say Self was the Humanoid and we were on the __newindex [ setting a value ]
-- defaultvalues(Self, "WalkSpeed", 50)
