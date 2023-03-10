
-- init
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/MagikManz/Venyx-UI-Library/main/source.lua"))()

local ui = UI.new("Dino Smells")

local tab = ui:Tab("Wally sucks")
ui:Tab("Fuck"):Section("Wally needs to get friends")

local section = tab:Section("Nexure is a loser")

section:Toggle("Juniortrackob", false, function(toggle)
	print("yea", toggle)
end)

tab:Toggle("You can also have toggles with no tab", false, function(toggle)
	print("mhm", toggle)
end)

section:Slider("Yoo kikitob stinks", 0, 900, 100, function(value)
	print(value)
end)

tab:ColourPicker("da colour picker (3dsboy08 has huge feet)", Color3.new(1, 1, 1), function(colour)
	print("ayy", colour)
end)


local section1 = tab:Section("Another section!")
section1:Dropdown("Target", {"Head", "Torso", "Right Arm", "Left Arm", "Right Leg", "Left Leg"}, "Head", function(selected)
	print(selected, "uhuh")
end)

section:Key("Key", Enum.UserInputType.MouseButton2, function(key)
	warn("sub")
end)
