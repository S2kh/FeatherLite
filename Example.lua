-- FeatherLite example, should work in any game
local FeatherLite = loadstring(game:HttpGet("https://raw.githubusercontent.com/S2kh/FeatherLite/main/FeatherLite.lua"))()

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local Window = FeatherLite:Window({
    Title = "FeatherLite",
    Subtitle = "Example script",
    Key = Enum.KeyCode.RightShift,
})

local function humanoid()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

-- Player
local Player = Window:Tab({ Name = "Player", Group = "Main" })

local speedGroup = Player:Group("Speed")
local speed = 16
local speedToggle = speedGroup:Toggle({
    Name = "Custom WalkSpeed", Description = "Walk faster than normal.", Flag = "SpeedOn", Keybind = Enum.KeyCode.V,
    Callback = function(on)
        local h = humanoid()
        if h then h.WalkSpeed = on and speed or 16 end
    end,
})
speedGroup:Slider({
    Name = "Speed", Min = 16, Max = 120, Default = 16, Flag = "Speed",
    Callback = function(v)
        speed = v
        if speedToggle:Get() then
            local h = humanoid()
            if h then h.WalkSpeed = v end
        end
    end,
})
speedGroup:Dropdown({
    Name = "Preset", Options = { "Walk", "Jog", "Sprint" }, Default = "Walk", Flag = "SpeedPreset",
    Callback = function(v)
        local presets = { Walk = 16, Jog = 28, Sprint = 50 }
        if presets[v] and Window.Flags.Speed then Window.Flags.Speed:Set(presets[v]) end
    end,
})

local jumpGroup = Player:Group("Jumping")
local jumpConn
jumpGroup:Toggle({
    Name = "Infinite jump", Description = "Jump again while you are in the air.", Flag = "InfJump",
    Callback = function(on)
        if jumpConn then jumpConn:Disconnect() jumpConn = nil end
        if on then
            jumpConn = UserInputService.JumpRequest:Connect(function()
                local h = humanoid()
                if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
            end)
        end
    end,
})
jumpGroup:Slider({
    Name = "Jump power", Min = 50, Max = 200, Default = 50, Step = 5, Flag = "JumpPower",
    Callback = function(v)
        local h = humanoid()
        if h then
            h.UseJumpPower = true
            h.JumpPower = v
        end
    end,
})

local charGroup = Player:Group("Character")
charGroup:Button({
    Name = "Reset character", Description = "Asks first.",
    Callback = function()
        Window:Dialog({
            Title = "Reset character?",
            Text = "Your character will respawn.",
            Buttons = {
                { Text = "Cancel" },
                { Text = "Reset", Danger = true, Callback = function()
                    local h = humanoid()
                    if h then h.Health = 0 end
                end },
            },
        })
    end,
})
charGroup:Input({
    Name = "Hip height", Placeholder = "2", Numeric = true, Flag = "HipHeight",
    Callback = function(v)
        local h = humanoid()
        if h and v then h.HipHeight = math.clamp(v, 0, 20) end
    end,
})

-- Teleport
local Teleport = Window:Tab({ Name = "Teleport", Group = "Main" })
local tp = Teleport:Group("Players")
local function playerNames()
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(names, p.Name) end
    end
    return names
end
local target = tp:Dropdown({ Name = "Player", Options = playerNames() })
tp:Button({
    Name = "Refresh list",
    Callback = function() target:SetOptions(playerNames()) end,
})
tp:Button({
    Name = "Teleport to player",
    Callback = function()
        local other = target:Get() and Players:FindFirstChild(target:Get())
        local theirRoot = other and other.Character and other.Character:FindFirstChild("HumanoidRootPart")
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if theirRoot and myRoot then
            myRoot.CFrame = theirRoot.CFrame * CFrame.new(0, 0, 3)
        else
            Window:Notify({ Title = "Pick a player first" })
        end
    end,
})

-- Visuals
local Visuals = Window:Tab({ Name = "Visuals", Group = "World" })
local light = Visuals:Group({ Name = "Lighting", Description = "Changes only what you see." })
local saved, brightConn = {}, nil
light:Toggle({
    Name = "Fullbright", Flag = "Fullbright",
    Callback = function(on)
        if on then
            saved = { Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime, FogEnd = Lighting.FogEnd, GlobalShadows = Lighting.GlobalShadows }
            brightConn = RunService.RenderStepped:Connect(function()
                Lighting.Brightness = 2
                Lighting.ClockTime = 14
                Lighting.FogEnd = 1e6
                Lighting.GlobalShadows = false
            end)
        else
            if brightConn then brightConn:Disconnect() brightConn = nil end
            for k, v in pairs(saved) do Lighting[k] = v end
        end
    end,
})
light:ColorPicker({
    Name = "Ambient colour", Default = Lighting.Ambient, Flag = "Ambient",
    Callback = function(c) Lighting.Ambient = c end,
})

local camera = Visuals:Group("Camera")
camera:Slider({
    Name = "Field of view", Min = 30, Max = 120, Default = 70, Flag = "FOV",
    Callback = function(v) workspace.CurrentCamera.FieldOfView = v end,
})
camera:Dropdown({
    Name = "Hide", Description = "Pick several.", Multi = true, Options = { "Shadows", "Fog", "Clouds" }, Flag = "Hide",
    Callback = function(list)
        local hide = {}
        for _, v in ipairs(list) do hide[v] = true end
        Lighting.GlobalShadows = not hide.Shadows
        if hide.Fog then Lighting.FogEnd = 1e6 end
        local clouds = workspace.Terrain:FindFirstChildOfClass("Clouds")
        if clouds then clouds.Enabled = not hide.Clouds end
    end,
})

-- Misc
local Misc = Window:Tab({ Name = "Misc", Group = "Other" })
local tools = Misc:Group("Tools")
tools:Keybind({
    Name = "Print position", Default = Enum.KeyCode.P,
    Callback = function()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then Window:Notify({ Title = "Position", Text = tostring(root.Position) }) end
    end,
})
tools:Button({
    Name = "Test notification",
    Callback = function()
        Window:Notify({ Title = "Hello", Text = "Notifications slide in here and fade out after a few seconds." })
    end,
})
tools:Button({
    Name = "Rejoin",
    Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer) end,
})
local about = Misc:Group("About")
about:Paragraph({ Title = "FeatherLite", Text = "RightShift opens and closes the menu. Settings is at the bottom left." })

local charConn = LocalPlayer.CharacterAdded:Connect(function(char)
    local h = char:WaitForChild("Humanoid", 10)
    if h and speedToggle:Get() then h.WalkSpeed = speed end
end)

-- unload already turns the toggles off, this is for your own connections
Window:OnUnload(function()
    charConn:Disconnect()
end)

Window:Notify({ Title = "Loaded", Text = "FeatherLite example is ready." })
