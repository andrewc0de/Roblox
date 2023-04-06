-- Created by Linen#3485
-- Thread: https://v3rmillion.net/showthread.php?tid=1202609&pid=8453989#pid8453989
-- HookMT V2
-- You can use this in ur paid/free scripts, just dont remove the line all the way below

if type(HookMT)=="table" then
    local ev = HookMT["Events"]
    if type(ev)=="table" then -- remove the cache you added
        for i,v in next, ev do
            pcall(function() v:Destroy() end)
            pcall(function() v:Disconnect() end)
            pcall(function() v:Remove() end)
            pcall(function() v = nil end)
        end
    end
end
getgenv().HookMT = {
    Hooks = {
        ["__index"] = {},
        ["__namecall"] = {},
        ["__locked"] = {},
        ["__newindex"] = {}
    },
    Events = {},
    Loaded = type(HookMT)=="table" and HookMT["Loaded"] or false
}
HookMT.addCache = function(ev, name)
    local cacheName = name or #HookMT["Events"]+1
    HookMT["Events"][cacheName] = ev
    getgenv().hookmt = HookMT
    return ev, cacheName
end
HookMT.getCache = function(name)
    return HookMT["Events"][name]
end
HookMT.deleteCache = function(name)
    local ev = HookMT["Events"][name]
    if ev then
        pcall(function() ev:Destroy() end)
        pcall(function() ev:Disconnect() end)
        pcall(function() ev:Remove() end)
        HookMT["Events"][name] = nil
        return true
    end
    return false
end
HookMT.removeCache = HookMT.deleteCache
HookMT.delCache = HookMT.deleteCache
HookMT.rmvCache = HookMT.deleteCache
--=========================== Dont worry, the lines below doesn't hack you or some shit, but dont remove it as its required to make this NOT LAG
setmetatable(getgenv().HookMT, { __metatable = "\60\32\76\105\110\101\32\49\57\56\32\69\114\114\111\114\32\111\110\32\103\97\109\101\46\87\111\114\107\115\112\97\99\101\46\67\97\109\101\114\97\46\83\99\114\105\112\116\32\62" })
if HookMT["Loaded"] then return("< ".."\72\111\111\107\77\84\32\105\115\32\97\108\114\101\97\100\121\32\108\111\97\100\101\100".." >") end;HookMT["Loaded"] = true -- dont Remove this line
--===========================
local getEmpty = function()return ;end
local _getEmpty = function()return;end
local oldIndex;oldIndex=hookmetamethod(game, "__index", newcclosure(function(Self, Index, ...)
    local Args = {...};
    local function defaultValue()
        return oldIndex(Self, Index, unpack(Args)) 
    end
    --~~~~~~~~~~~~~~~~~~~~~~~~
    local __indexHooks = rawget(rawget(HookMT, "Hooks"), "__index")
    local __lockedHooks = rawget(rawget(HookMT, "Hooks"), "__locked")
    if checkcaller() then

        local lowered = tostring(Index) or nil
        if lowered then lowered = lowered:lower()
            if lowered=="hook" or lowered=="sethook" then
                return function (str, func)
                    if type(func)=="nil" then return "The second argument must be included!"; end
                    rawset(__indexHooks, Self, { Self, str , func })
                    return ("Successfully hooked! All __index calls on %s will be logged! To unhook/stop logging just do: %s:unhook()\n|| Arguments Passed: \n    (query -> function, Self -> Object being hooked, Index -> Self[Index], defaultValue -> a function, will return the value of Self[Index] , ... -> extra_arguments)\n-------------------------------------------------------------"):format((type(Self)=="table") and "table: 0x18fxf23510" or tostring(Self), (type(Self)=="table") and "table: 0x18fxf23510" or tostring(Self))
                end
            end
            if lowered=="removehook" or lowered=="deletehook" or lowered=="destroyhook" or lowered=="resethook" or lowered=="rmvhook" or lowered=="unhook" then
                return function ()
                    rawset(__indexHooks, Self, nil)
                    return ("Successfully unhooked __index logs for %s! "):format((type(Self)=="table") and "table: 0x18fxf23510" or tostring(Self))
                end
            end
            if lowered=="lock" or lowered=="lockvalue" then
                return function (str, func)
                    if type(func)=="nil" then return "The second argument must be included!"; end
                    rawset(__lockedHooks, Self, { Self, str , func })
                    return ("Successfully locked those calls to that value")
                end
            end
            if lowered=="removelock" or lowered=="deletelock" or lowered=="destroylock" or lowered=="resetlock" or lowered=="rmvlock" or lowered=="unlock" then
                return function ()
                    rawset(__lockedHooks, Self, nil)
                    return "Successfully unlocked!"
                end
            end
        end

    end
    --~~~~~~~~~~~~~~~~~~~~~~~~
    local isSelfHooked = rawget(__indexHooks, Self)
    if type(isSelfHooked)=="table" and isSelfHooked[1] then 
        
        local a1, a2, a3 = isSelfHooked[1], isSelfHooked[2], isSelfHooked[3]
        if type(a2)=="string" and type(a3)~="nil" then
            if typeof(Self)=="Instance" and typeof(a1)=="Instance" and (Self==a1) then
                local fullInstName = ((Self:GetFullName()).."."..tostring(typeof(Index)=="Instance" and Index:GetFullName() or Index)):lower()
                local fullSelfName = ((a1:GetFullName()).."."..a2):lower()
                if fullSelfName==fullInstName then
                    if type(a3)=="function" then
                        local result = nil
                        local query = function(...) result = {...} end
                        local rs, en = pcall(a3, query, Self, Index, defaultValue, ...)
                        if rs and type(en)~="nil" and en~=(function()return ; end)() then return en end
                        if type(result)=="table" then return unpack(result) end
                    end
                    return a3
                end
            end
        end
    end
    --~~~~~~~~~~~~~~~~~~~~~~~~
    return defaultValue()
end))
-- __namecall methods 
local oldNamecall;oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(Self, ...)
    local Args = {...};
    local function defaultValue()
        return oldNamecall(Self, unpack(Args)) 
    end
    --~~~~~~~~~~~~~~~~~~~~~~~~
    local Index = getnamecallmethod()
    local __namecallHooks = rawget(rawget(HookMT, "Hooks"), "__namecall")

    if checkcaller() and tostring(Index) then local lowered = tostring(Index):lower();local _Arg = Args;
        if lowered=="sethook" or lowered=="hook" then
            rawset(__namecallHooks, Self, type(__namecallHooks[Self])=="table" and __namecallHooks[Self] or {})

            local arg1 = _Arg[1];
            local arg2 = _Arg[2];if type(arg1)=="nil" or type(arg2)~="function" then return "Invalid Usage! example usage: workspace:"..Index.."( "..string.format([[EventName -> string, function, etc, ValueToReturn -> (function, boolean, value, etc/anything)]]).." )" end
            ---------------------
            __namecallHooks[Self][arg1] = arg2
            return "Successfully __namecall hooked!"
        end
        if lowered=="removehook" or lowered=="deletehook" or lowered=="destroyhook" or lowered=="resethook" or lowered=="rmvhook" or lowered=="unhook" then
            rawset(__namecallHooks, Self, type(__namecallHooks[Self])=="table" and __namecallHooks[Self] or {})

            local arg1 = _Arg[1];if not arg1 then return "Invalid Usage! example usage: workspace:"..Index.."( "..string.format([[EventName]]).." )" end
            __namecallHooks[Self][arg1] = nil
            return "Successfully removed __namecall hooked!"
        end
    end
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    local indT = rawget(__namecallHooks, Self)
    if type(indT)=="table" then
        for i,v in next, indT do
            i = (typeof(i)=="string" or typeof(i)=="number") and i or (typeof(i)=="function") and i() or i
            local indexFound = v
            if type(indexFound)=="function" then 
                local gotten = nil
                local endit = function(...) gotten = {...} end
                local suc,err = pcall(indexFound, endit, Self, defaultValue, ...);
                if type(gotten)=="table" then  
                    return oldNamecall(Self, unpack(gotten))
                end
                if suc and type(err)~="nil" then return oldNamecall(Self, err) end
            end
            if type(indexFound)=="nil" or type(indexFound) then return defaultValue() end
            if type(indexFound)~="nil" and indexFound~=getEmpty() and indexFound~=_getEmpty() then
                return oldNamecall(Self, indexFound)
            end
        end
    end
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    return defaultValue()
end))
-- __newindex methods [ for locking ]
local oldNewIndex;oldNewIndex = hookmetamethod(game, "__newindex", newcclosure(function(Self, Index, NewIndex, ...)
    local Args = {...};
    local function defaultValue()
        return oldNewIndex(Self, Index, NewIndex, unpack(Args)) 
    end
    --~~~~~~~~~~~~~~~~~~~~~~~~
    local __indexHooks = rawget(rawget(HookMT, "Hooks"), "__index")
    local __lockedHooks = rawget(rawget(HookMT, "Hooks"), "__locked")

    local isSelfLocked = rawget(__lockedHooks, Self)
    if type(isSelfLocked)~="nil" then
        local a1, a2, a3 = isSelfLocked[1], isSelfLocked[2], isSelfLocked[3]
        if type(a2)=="string" and type(a3)~="nil" then
            if typeof(Self)=="Instance" and typeof(a1)=="Instance" and (Self==a1) then
                local fullInstName = ((Self:GetFullName()).."."..tostring(typeof(Index)=="Instance" and Index:GetFullName() or Index)):lower()
                local fullSelfName = ((a1:GetFullName()).."."..a2):lower()
                if fullSelfName==fullInstName then
                    return oldNewIndex(Self, Index, a3, ...)
                end
            end
        end
    end
    --~~~~~~~~~~~~~~~~~~~~~~~~
    return defaultValue()
end))

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|||||||||||||||||||||||||||
getgenv().hookmt = HookMT
print("< HookMT API Loaded >")
print("|~~~~~~~~~~=================~~~~~~~~~~|")
