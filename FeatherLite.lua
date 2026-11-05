-- FeatherLite
-- started from Eazvy's Apple UI lib, rewrote most of it since then
-- docs are in the README

local FeatherLite = { Version = "2.0.0", Flags = {} }

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local FAMILY = "rbxasset://fonts/families/BuilderSans.json"
local FONTS = {
    Regular = Font.new(FAMILY, Enum.FontWeight.Regular),
    Medium = Font.new(FAMILY, Enum.FontWeight.Medium),
    Semi = Font.new(FAMILY, Enum.FontWeight.SemiBold),
    Bold = Font.new(FAMILY, Enum.FontWeight.Bold),
}

local function rgb(r, g, b) return Color3.fromRGB(r, g, b) end

FeatherLite.Themes = {
    Dark = {
        Window = rgb(30, 30, 32), Sidebar = rgb(40, 40, 43), Card = rgb(44, 44, 47), Field = rgb(58, 58, 62),
        Separator = rgb(60, 60, 64), Stroke = rgb(72, 72, 77), Text = rgb(245, 245, 247), SubText = rgb(152, 152, 157),
        Faint = rgb(108, 108, 114), Accent = rgb(10, 132, 255), OnAccent = rgb(255, 255, 255), Track = rgb(72, 72, 76),
        Knob = rgb(255, 255, 255), Hover = rgb(255, 255, 255), Danger = rgb(255, 69, 58),
    },
    Light = {
        Window = rgb(246, 246, 248), Sidebar = rgb(232, 232, 237), Card = rgb(255, 255, 255), Field = rgb(236, 236, 241),
        Separator = rgb(226, 226, 231), Stroke = rgb(210, 210, 216), Text = rgb(29, 29, 31), SubText = rgb(110, 110, 115),
        Faint = rgb(160, 160, 166), Accent = rgb(0, 122, 255), OnAccent = rgb(255, 255, 255), Track = rgb(214, 214, 220),
        Knob = rgb(255, 255, 255), Hover = rgb(0, 0, 0), Danger = rgb(255, 59, 48),
    },
    Midnight = {
        Window = rgb(15, 18, 30), Sidebar = rgb(21, 25, 41), Card = rgb(27, 32, 51), Field = rgb(38, 44, 68),
        Separator = rgb(42, 49, 74), Stroke = rgb(54, 62, 92), Text = rgb(232, 236, 255), SubText = rgb(141, 150, 184),
        Faint = rgb(96, 105, 140), Accent = rgb(110, 140, 255), OnAccent = rgb(255, 255, 255), Track = rgb(52, 60, 90),
        Knob = rgb(255, 255, 255), Hover = rgb(255, 255, 255), Danger = rgb(255, 92, 110),
    },
    ["OLED Black"] = {
        Window = rgb(0, 0, 0), Sidebar = rgb(10, 10, 11), Card = rgb(20, 20, 22), Field = rgb(34, 34, 37),
        Separator = rgb(34, 34, 37), Stroke = rgb(46, 46, 50), Text = rgb(255, 255, 255), SubText = rgb(142, 142, 147),
        Faint = rgb(96, 96, 100), Accent = rgb(10, 132, 255), OnAccent = rgb(255, 255, 255), Track = rgb(50, 50, 54),
        Knob = rgb(255, 255, 255), Hover = rgb(255, 255, 255), Danger = rgb(255, 69, 58),
    },
}
FeatherLite.ThemeOrder = { "Dark", "Light", "Midnight", "OLED Black" }

local BADGES = {
    rgb(10, 132, 255), rgb(94, 92, 230), rgb(191, 90, 242), rgb(255, 55, 95),
    rgb(255, 159, 10), rgb(48, 209, 88), rgb(100, 210, 255), rgb(255, 69, 58),
}
local SHADOW = "rbxassetid://6015897843"
local PLUME_VANE, PLUME_SHAFT = "rbxassetid://109028262244405", "rbxassetid://124588188115353"

FeatherLite.Icons = {
    Combat = 119168694531898, Player = 127505433136549, Visuals = 84745516177083, World = 93371680357706,
    Teleport = 85674376575351, Misc = 110695217426888, Settings = 87862881290117, Config = 105363416845572,
    Search = 79488727439532,
}
local function iconFor(v)
    if type(v) == "number" then return "rbxassetid://" .. v end
    if type(v) ~= "string" or v == "" then return nil end
    for name, id in pairs(FeatherLite.Icons) do
        if string.lower(name) == string.lower(v) then return "rbxassetid://" .. id end
    end
    if string.find(v, "^rbxasset") or string.find(v, "^http") then return v end
    return nil
end
local STRIPES = { rgb(97, 187, 70), rgb(253, 184, 39), rgb(245, 130, 31), rgb(224, 58, 62), rgb(150, 61, 151), rgb(0, 157, 220) }

local function make(class, props, kids)
    local inst = Instance.new(class)
    if props then
        for k, v in pairs(props) do
            if k ~= "Parent" then inst[k] = v end
        end
    end
    if kids then
        for _, k in ipairs(kids) do k.Parent = inst end
    end
    if props and props.Parent then inst.Parent = props.Parent end
    return inst
end

local function tw(inst, t, props, style, dir, delay)
    local tween = TweenService:Create(inst, TweenInfo.new(t, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out, 0, false, delay or 0), props)
    tween:Play()
    return tween
end

local function corner(r) return make("UICorner", { CornerRadius = r == "full" and UDim.new(1, 0) or UDim.new(0, r) }) end
local function pad(t, r, b, l)
    return make("UIPadding", { PaddingTop = UDim.new(0, t), PaddingRight = UDim.new(0, r), PaddingBottom = UDim.new(0, b), PaddingLeft = UDim.new(0, l) })
end
local function list(dir, padding, props)
    local p = props or {}
    p.FillDirection = dir == "x" and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical
    p.Padding = UDim.new(0, padding or 0)
    p.SortOrder = Enum.SortOrder.LayoutOrder
    return make("UIListLayout", p)
end

-- the old apple rainbow. hard color stops on a gradient, kinda hacky
local function stripes()
    local keys = {}
    for i, c in ipairs(STRIPES) do
        table.insert(keys, ColorSequenceKeypoint.new((i - 1) / 6, c))
        table.insert(keys, ColorSequenceKeypoint.new(i == #STRIPES and 1 or (i / 6 - 0.001), c))
    end
    return make("UIGradient", { Color = ColorSequence.new(keys), Rotation = 90 })
end

local function safe(fn, ...)
    if type(fn) ~= "function" then return end
    local args = table.pack(...)
    task.spawn(function()
        local ok, err = pcall(fn, table.unpack(args, 1, args.n))
        if not ok then warn("[FeatherLite] " .. tostring(err)) end
    end)
end

local SHORT_KEYS = {
    LeftShift = "LShift", RightShift = "RShift", LeftControl = "LCtrl", RightControl = "RCtrl",
    LeftAlt = "LAlt", RightAlt = "RAlt", Return = "Enter", Backquote = "`", Insert = "Ins",
    PageUp = "PgUp", PageDown = "PgDn", Delete = "Del",
}
local function keyName(k)
    if typeof(k) ~= "EnumItem" then return "None" end
    return SHORT_KEYS[k.Name] or k.Name
end
local function toKey(v)
    if typeof(v) == "EnumItem" then return v end
    if type(v) == "string" then
        local ok, k = pcall(function() return Enum.KeyCode[v] end)
        if ok then return k end
    end
    return nil
end

local function encode(v)
    local t = typeof(v)
    if t == "Color3" then return { __c = v:ToHex() } end
    if t == "EnumItem" then return { __k = v.Name } end
    if t == "table" then
        local o = {}
        for k, x in pairs(v) do o[k] = encode(x) end
        return o
    end
    return v
end
local function decode(v)
    if type(v) ~= "table" then return v end
    if v.__c then
        local ok, c = pcall(Color3.fromHex, v.__c)
        return ok and c or nil
    end
    if v.__k then return toKey(v.__k) end
    local o = {}
    for k, x in pairs(v) do o[k] = decode(x) end
    return o
end

local FS = {}
local hasFS = type(writefile) == "function" and type(readfile) == "function"
function FS.ensure(path)
    if not hasFS or type(makefolder) ~= "function" then return end
    local cur = ""
    for part in string.gmatch(path, "[^/]+") do
        cur = cur == "" and part or (cur .. "/" .. part)
        local ok, exists = pcall(function() return isfolder and isfolder(cur) end)
        if not (ok and exists) then pcall(makefolder, cur) end
    end
end
function FS.read(path)
    if not hasFS then return nil end
    local ok, res = pcall(readfile, path)
    if ok and type(res) == "string" then return res end
    return nil
end
function FS.write(path, data)
    if hasFS then pcall(writefile, path, data) end
end
function FS.delete(path)
    if type(delfile) == "function" then pcall(delfile, path) end
end
function FS.json(path)
    local raw = FS.read(path)
    if not raw then return nil end
    local ok, res = pcall(HttpService.JSONDecode, HttpService, raw)
    return ok and res or nil
end
function FS.configs(dir)
    local names = {}
    if type(listfiles) ~= "function" then return names end
    local ok, files = pcall(listfiles, dir)
    if not ok or type(files) ~= "table" then return names end
    for _, f in ipairs(files) do
        local n = string.match(f, "([^/\\]+)%.json$")
        if n then table.insert(names, n) end
    end
    table.sort(names)
    return names
end

local env = (getgenv and getgenv()) or _G
env.FeatherLiteWindows = env.FeatherLiteWindows or {}
local registry = env.FeatherLiteWindows

local function parentGui(gui)
    if gethui then
        local ok, holder = pcall(gethui)
        if ok and typeof(holder) == "Instance" then
            gui.Parent = holder
            return
        end
    end
    if syn and syn.protect_gui then pcall(syn.protect_gui, gui) end
    if not pcall(function() gui.Parent = game:GetService("CoreGui") end) or not gui.Parent then
        gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
end

function FeatherLite:Window(opts)
    opts = opts or {}
    if opts.KeepPrevious ~= true then
        for i = #registry, 1, -1 do
            pcall(function() registry[i]:Unload(true) end)
        end
    end

    local title = tostring(opts.Title or "FeatherLite")
    local subtitle = opts.Subtitle and tostring(opts.Subtitle) or nil
    local folder = tostring(opts.Folder or ("FeatherLite/" .. (title:gsub("[^%w%-_ ]", ""))))
    local configDir = folder .. "/configs"
    FS.ensure(configDir)
    local prefs = FS.json(folder .. "/settings.json") or {}

    local Window = { Flags = {}, Title = title }
    FeatherLite.Flags = Window.Flags

    local conns, unloadFns, themed, hooks = {}, {}, {}, {}
    local toggles, binds, searchItems, tabs = {}, {}, {}, {}
    local alive, visible, animating = true, false, false
    local themeName = prefs.Theme or opts.Theme or "Dark"
    if not FeatherLite.Themes[themeName] then themeName = "Dark" end
    local theme = FeatherLite.Themes[themeName]
    local alpha = tonumber(prefs.Transparency) or 0
    local userScale = tonumber(prefs.Scale) or 1
    local menuKey = toKey(prefs.MenuKey) or opts.Key or Enum.KeyCode.RightShift
    local notifyOn = prefs.Notifications ~= false
    local lastBuild = os.clock()
    local listening

    local function on(signal, fn)
        local c = signal:Connect(fn)
        table.insert(conns, c)
        return c
    end

    -- anything that changes with the theme goes through T, otherwise SetTheme misses it
    local function T(inst, map)
        table.insert(themed, { inst, map })
        for prop, role in pairs(map) do inst[prop] = theme[role] end
        return inst
    end
    local function hook(fn)
        table.insert(hooks, fn)
        fn(false)
    end

    local function mark(parent, px, props)
        local z = props and props.ZIndex or 4
        local holder = make("Frame", { Size = UDim2.fromOffset(px, px), BackgroundTransparency = 1, ZIndex = z })
        for k, v in pairs(props or {}) do holder[k] = v end
        local vane = make("ImageLabel", {
            Parent = holder, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Image = PLUME_VANE,
            ImageColor3 = rgb(255, 255, 255), ScaleType = Enum.ScaleType.Fit, ZIndex = z,
        }, { stripes() })
        local shaft = T(make("ImageLabel", {
            Parent = holder, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Image = PLUME_SHAFT,
            ScaleType = Enum.ScaleType.Fit, ZIndex = z + 1,
        }), { ImageColor3 = "Text" })
        holder.Parent = parent
        return holder, vane, shaft
    end

    local function savePrefs()
        FS.write(folder .. "/settings.json", HttpService:JSONEncode({
            Theme = themeName, Transparency = alpha, Scale = userScale,
            MenuKey = menuKey.Name, Notifications = notifyOn, Float = prefs.Float,
        }))
    end

    local gui = make("ScreenGui", {
        Name = "FeatherLite_" .. string.sub(HttpService:GenerateGUID(false), 1, 8),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 999,
    })
    parentGui(gui)

    local size = opts.Size or Vector2.new(1034, 624)
    local MIN_W, MIN_H, SIDEBAR_W = 640, 420, 220
    local MOBILE = opts.Mobile
    if MOBILE == nil then MOBILE = UIS.TouchEnabled and not UIS.KeyboardEnabled end
    Window.Mobile = MOBILE
    if MOBILE then
        SIDEBAR_W = 66
        MIN_W, MIN_H = 360, 240
    end
    local userSized = false
    local ROW_H = MOBILE and 46 or 36

    local root = make("Frame", {
        Name = "Window", Parent = gui, AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(size.X, size.Y),
        BackgroundTransparency = 1, Visible = false,
    })
    local fitScale = make("UIScale", { Parent = root })
    local body = make("Frame", {
        Parent = root, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
    })
    local popScale = make("UIScale", { Parent = body })
    local shadow = make("ImageLabel", {
        Parent = body, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 3),
        Size = UDim2.new(1, 40, 1, 40), BackgroundTransparency = 1, Image = SHADOW,
        ImageColor3 = rgb(0, 0, 0), ImageTransparency = 0.7, ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450), ZIndex = 0,
    })
    local main = make("Frame", {
        Name = "Main", Parent = body, Size = UDim2.fromScale(1, 1), ClipsDescendants = true, ZIndex = 1,
    }, { corner(12) })
    T(main, { BackgroundColor3 = "Window" })
    T(make("UIStroke", { Parent = main, Transparency = 0.35, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }), { Color = "Stroke" })

    local function screenFit()
        local area = gui.AbsoluteSize
        if area.X < 2 or area.Y < 2 then return userScale end
        local s = math.min(userScale, (area.X - 24) / root.Size.X.Offset, (area.Y - 24) / root.Size.Y.Offset)
        return math.clamp(s, 0.35, 2)
    end
    local toastScale
    -- mobile sizing was annoying to get right, careful changing this
    local function fit()
        if MOBILE then
            local area = gui.AbsoluteSize
            local s = math.max(userScale, 0.35)
            if area.X > 2 and area.Y > 2 then
                local maxW, maxH = (area.X - 16) / s, (area.Y - 16) / s
                local w, h
                if userSized then
                    w, h = math.min(root.Size.X.Offset, maxW), math.min(root.Size.Y.Offset, maxH)
                else
                    w, h = maxW * 0.85, maxH * 0.85
                end
                w, h = math.floor(math.max(MIN_W, w)), math.floor(math.max(MIN_H, h))
                if root.Size.X.Offset ~= w or root.Size.Y.Offset ~= h then root.Size = UDim2.fromOffset(w, h) end
            end
            fitScale.Scale = s
        else
            fitScale.Scale = screenFit()
        end
        if toastScale then
            local area = gui.AbsoluteSize
            toastScale.Scale = math.clamp(math.min(1, (area.X - 32) / 320), 0.5, 1)
        end
    end
    on(gui:GetPropertyChangedSignal("AbsoluteSize"), fit)

    local sidebar = make("Frame", {
        Name = "Sidebar", Parent = main, Size = UDim2.new(0, SIDEBAR_W, 1, 0), BorderSizePixel = 0, ZIndex = 2,
    }, { corner(12) })
    T(sidebar, { BackgroundColor3 = "Sidebar" })
    local sidebarFill = make("Frame", {
        Parent = sidebar, Position = UDim2.new(1, -12, 0, 0), Size = UDim2.new(0, 12, 1, 0), BorderSizePixel = 0,
    })
    T(sidebarFill, { BackgroundColor3 = "Sidebar" })
    T(make("Frame", { Parent = sidebar, Position = UDim2.new(1, -1, 0, 0), Size = UDim2.new(0, 1, 1, 0), BorderSizePixel = 0, ZIndex = 3 }), { BackgroundColor3 = "Separator" })

    local function applyAlpha()
        main.BackgroundTransparency = alpha
        sidebar.BackgroundTransparency = alpha
        sidebarFill.BackgroundTransparency = alpha
    end
    applyAlpha()

    local lights = make("Frame", {
        Parent = sidebar, Position = UDim2.fromOffset(16, 16), Size = UDim2.fromOffset(60, 14),
        BackgroundTransparency = 1, ZIndex = 4, Visible = not MOBILE,
    }, { list("x", 8, { VerticalAlignment = Enum.VerticalAlignment.Center }) })
    local glyphs = {}
    local function light(color, glyph, glyphColor, order)
        local b = make("TextButton", {
            Parent = lights, Size = UDim2.fromOffset(13, 13), BackgroundColor3 = color, Text = "",
            AutoButtonColor = false, LayoutOrder = order, ZIndex = 4,
        }, { corner("full") })
        table.insert(glyphs, make("TextLabel", {
            Parent = b, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = glyph,
            FontFace = FONTS.Bold, TextSize = 11, TextColor3 = glyphColor, TextTransparency = 1, ZIndex = 5,
        }))
        return b
    end
    light(rgb(254, 188, 46), "", rgb(120, 70, 0), 1)
    light(rgb(40, 200, 64), "", rgb(0, 90, 15), 2)

    local brandMark = mark(sidebar, MOBILE and 30 or 24, {
        Position = MOBILE and UDim2.fromOffset(18, 14) or UDim2.fromOffset(15, subtitle and 46 or 41), ZIndex = 4,
    })
    local brandScale = make("UIScale", { Parent = brandMark })
    on(brandMark.MouseEnter, function()
        tw(brandScale, 0.3, { Scale = 1.15 }, Enum.EasingStyle.Back)
        tw(brandMark, 0.5, { Rotation = -12 }, Enum.EasingStyle.Back)
    end)
    on(brandMark.MouseLeave, function()
        tw(brandScale, 0.3, { Scale = 1 })
        tw(brandMark, 0.4, { Rotation = 0 })
    end)
    T(make("TextLabel", {
        Parent = sidebar, Position = UDim2.fromOffset(46, 44), Size = UDim2.new(1, -62, 0, 20),
        BackgroundTransparency = 1, Text = title, FontFace = FONTS.Semi, TextSize = 16, Visible = not MOBILE,
        TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 4,
    }), { TextColor3 = "Text" })
    local searchY = 74
    if subtitle then
        T(make("TextLabel", {
            Parent = sidebar, Position = UDim2.fromOffset(46, 63), Size = UDim2.new(1, -62, 0, 16),
            BackgroundTransparency = 1, Text = subtitle, FontFace = FONTS.Regular, TextSize = 12, Visible = not MOBILE,
            TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 4,
        }), { TextColor3 = "SubText" })
        searchY = 90
    end

    local searchField = make("Frame", {
        Parent = sidebar, Position = UDim2.fromOffset(12, searchY), Size = UDim2.new(1, -24, 0, 34), ZIndex = 4,
        Visible = not MOBILE,
    }, { corner(8) })
    T(searchField, { BackgroundColor3 = "Field" })
    local searchStroke = T(make("UIStroke", { Parent = searchField, Transparency = 1, Thickness = 1.5 }), { Color = "Accent" })
    T(make("ImageLabel", {
        Parent = searchField, AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 9, 0.5, 0), Size = UDim2.fromOffset(14, 14),
        BackgroundTransparency = 1, Image = iconFor("Search"), ScaleType = Enum.ScaleType.Fit, ZIndex = 5,
    }), { ImageColor3 = "SubText" })
    local searchBox = make("TextBox", {
        Parent = searchField, Position = UDim2.fromOffset(28, 0), Size = UDim2.new(1, -34, 1, 0),
        BackgroundTransparency = 1, Text = "", PlaceholderText = "Search", ClearTextOnFocus = false,
        FontFace = FONTS.Regular, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
    })
    T(searchBox, { TextColor3 = "Text", PlaceholderColor3 = "Faint" })
    on(searchBox.Focused, function() tw(searchStroke, 0.2, { Transparency = 0.2 }) end)
    on(searchBox.FocusLost, function() tw(searchStroke, 0.25, { Transparency = 1 }) end)

    local tabScroll = make("ScrollingFrame", {
        Parent = sidebar, Position = UDim2.fromOffset(0, MOBILE and 58 or searchY + 46),
        Size = UDim2.new(1, 0, 1, -(MOBILE and 58 or searchY + 46) - (MOBILE and 66 or 58)),
        BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 0, CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y, ZIndex = 4,
    })
    local highlight = make("Frame", {
        Parent = tabScroll, Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -20, 0, ROW_H),
        BorderSizePixel = 0, BackgroundTransparency = 1, ZIndex = 4,
    }, { corner(7) })
    T(highlight, { BackgroundColor3 = "Accent" })
    local tabHolder = make("Frame", {
        Parent = tabScroll, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1, ZIndex = 5,
    }, { list("y", 2), pad(0, 10, 8, 10) })
    local sideItems = {}

    T(make("Frame", {
        Parent = sidebar, Position = UDim2.new(0, 12, 1, MOBILE and -62 or -56), Size = UDim2.new(1, -24, 0, 1), BorderSizePixel = 0, ZIndex = 4,
    }), { BackgroundColor3 = "Separator" })
    local settingsRow = make("TextButton", {
        Parent = sidebar, Position = UDim2.new(0, 10, 1, MOBILE and -54 or -48), Size = UDim2.new(1, -20, 0, MOBILE and 46 or 40),
        Text = "", AutoButtonColor = false, BackgroundTransparency = 1, ZIndex = 4,
    }, { corner(7) })
    T(settingsRow, { BackgroundColor3 = "Accent" })

    local content = make("Frame", {
        Parent = main, Position = UDim2.fromOffset(SIDEBAR_W, 0), Size = UDim2.new(1, -SIDEBAR_W, 1, 0),
        BackgroundTransparency = 1, ClipsDescendants = true, ZIndex = 2,
    })
    local header = make("Frame", { Parent = content, Size = UDim2.new(1, 0, 0, 58), BackgroundTransparency = 1, ZIndex = 3 })
    local pageTitle = make("TextLabel", {
        Parent = header, Position = UDim2.fromOffset(26, 4), Size = UDim2.new(1, -52, 1, -4), BackgroundTransparency = 1,
        Text = "", FontFace = FONTS.Bold, TextSize = 22, TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 3,
    })
    T(pageTitle, { TextColor3 = "Text" })
    local CLOSE = MOBILE and 38 or 32
    pageTitle.Size = UDim2.new(1, -(60 + CLOSE), 1, -4)
    local closeBtn = make("TextButton", {
        Parent = header, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -18, 0.5, 2),
        Size = UDim2.fromOffset(CLOSE, CLOSE), BackgroundColor3 = rgb(255, 95, 87), Text = "",
        AutoButtonColor = false, ZIndex = 6,
    }, { corner("full") })
    for _, rot in ipairs({ 45, -45 }) do
        make("Frame", {
            Parent = closeBtn, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(math.floor(CLOSE * 0.42), 2), Rotation = rot,
            BackgroundColor3 = rgb(255, 255, 255), BorderSizePixel = 0, ZIndex = 7,
        }, { corner("full") })
    end
    local closeScale = make("UIScale", { Parent = closeBtn })
    local headerLine = make("Frame", {
        Parent = header, Position = UDim2.new(0, 0, 1, -1), Size = UDim2.new(1, 0, 0, 1),
        BorderSizePixel = 0, BackgroundTransparency = 1, ZIndex = 3,
    })
    T(headerLine, { BackgroundColor3 = "Separator" })
    local pages = make("Frame", {
        Parent = content, Position = UDim2.fromOffset(0, 58), Size = UDim2.new(1, 0, 1, -58),
        BackgroundTransparency = 1, ClipsDescendants = true, ZIndex = 2,
    })

    local grip = make("TextButton", {
        Parent = content, AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -3, 1, -3),
        Size = UDim2.fromOffset(18, 18), BackgroundTransparency = 1, Text = "", ZIndex = 6,
    })
    for i, len in ipairs({ 11, 6 }) do
        T(make("Frame", {
            Parent = grip, AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromOffset(18 - (i == 1 and 7 or 4), 18 - (i == 1 and 7 or 4)),
            Size = UDim2.fromOffset(len, 1.5), Rotation = -45, BorderSizePixel = 0, ZIndex = 6,
        }), { BackgroundColor3 = "Faint" })
    end

    if MOBILE then
        grip.Size = UDim2.fromOffset(34, 34)
        for _, line in ipairs(grip:GetChildren()) do
            line.Position = UDim2.fromOffset(line.Position.X.Offset + 14, line.Position.Y.Offset + 14)
            line.Size = UDim2.fromOffset(line.Size.X.Offset + 4, 2)
        end
    end

    local function dragZone(zone)
        on(zone.InputBegan, function(input)
            local kind = input.UserInputType
            if kind ~= Enum.UserInputType.MouseButton1 and kind ~= Enum.UserInputType.Touch then return end
            local start, startPos = input.Position, root.Position
            local move
            move = UIS.InputChanged:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseMovement or i == input then
                    local d = i.Position - start
                    root.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
                end
            end)
            table.insert(conns, move)
            local done
            done = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    move:Disconnect()
                    done:Disconnect()
                end
            end)
        end)
    end
    dragZone(header)
    dragZone(make("Frame", { Parent = sidebar, Size = UDim2.new(1, 0, 0, MOBILE and 56 or 42), BackgroundTransparency = 1, ZIndex = 3 }))

    local function clampSize(w, h)
        local area = gui.AbsoluteSize
        local maxW = math.max(MIN_W, (area.X - 20) / math.max(userScale, 0.35))
        local maxH = math.max(MIN_H, (area.Y - 20) / math.max(userScale, 0.35))
        return math.clamp(w, MIN_W, maxW), math.clamp(h, MIN_H, maxH)
    end
    on(grip.InputBegan, function(input)
        local kind = input.UserInputType
        if kind ~= Enum.UserInputType.MouseButton1 and kind ~= Enum.UserInputType.Touch then return end
        local start, startSize, startPos = input.Position, root.Size, root.Position
        local move
        move = UIS.InputChanged:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseMovement or i == input then
                local d = (i.Position - start) / fitScale.Scale
                local w, h = clampSize(startSize.X.Offset + d.X, startSize.Y.Offset + d.Y)
                userSized = true
                root.Size = UDim2.fromOffset(w, h)
                -- window is anchored in the middle so we nudge it by half the size change. lazy but it works
                local dw, dh = (w - startSize.X.Offset) * fitScale.Scale, (h - startSize.Y.Offset) * fitScale.Scale
                root.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + dw / 2, startPos.Y.Scale, startPos.Y.Offset + dh / 2)
            end
        end)
        table.insert(conns, move)
        local done
        done = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                move:Disconnect()
                done:Disconnect()
            end
        end)
    end)

    local toastHolder = make("Frame", {
        Parent = gui, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -16, 0, 16),
        Size = UDim2.new(0, 320, 1, -32), BackgroundTransparency = 1, ZIndex = 50,
    }, { list("y", 8, { HorizontalAlignment = Enum.HorizontalAlignment.Right }) })
    toastScale = make("UIScale", { Parent = toastHolder })
    fit()
    local toastOrder = 0

    function Window:Notify(o)
        if not alive or not notifyOn then return end
        if type(o) ~= "table" then o = { Title = tostring(o) } end
        local duration = tonumber(o.Duration) or 5
        toastOrder -= 1
        local wrap = make("Frame", {
            Parent = toastHolder, Size = UDim2.new(0, 300, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1, LayoutOrder = toastOrder, ZIndex = 50,
        })
        local card = make("TextButton", {
            Parent = wrap, Position = UDim2.fromOffset(340, 0), Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y, Text = "", AutoButtonColor = false, ZIndex = 51,
        }, { corner(12), pad(12, 14, 14, 18) })
        T(card, { BackgroundColor3 = "Card" })
        T(make("UIStroke", { Parent = card, Transparency = 0.3, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }), { Color = "Stroke" })
        local bar = make("Frame", {
            Parent = card, Position = UDim2.new(0, -10, 0, 2), Size = UDim2.new(0, 3, 1, -4), BorderSizePixel = 0, ZIndex = 52,
        }, { corner("full") })
        T(bar, { BackgroundColor3 = "Accent" })
        local inner = make("Frame", {
            Parent = card, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, ZIndex = 52,
        }, { list("y", 3) })
        T(make("TextLabel", {
            Parent = inner, Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, Text = tostring(o.Title or "Notice"),
            FontFace = FONTS.Semi, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
            LayoutOrder = 1, ZIndex = 52,
        }), { TextColor3 = "Text" })
        if o.Text or o.Content then
            T(make("TextLabel", {
                Parent = inner, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
                Text = tostring(o.Text or o.Content), FontFace = FONTS.Regular, TextSize = 13, TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 2, ZIndex = 52,
            }), { TextColor3 = "SubText" })
        end
        local progress = make("Frame", {
            Parent = card, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, -4, 1, 10),
            Size = UDim2.new(1, 4, 0, 2), BorderSizePixel = 0, BackgroundTransparency = 0.5, ZIndex = 52,
        }, { corner("full") })
        T(progress, { BackgroundColor3 = "Accent" })
        tw(card, 0.45, { Position = UDim2.fromOffset(0, 0) }, Enum.EasingStyle.Back)
        tw(progress, duration, { Size = UDim2.new(0, 0, 0, 2) }, Enum.EasingStyle.Linear)
        local gone = false
        local function dismiss()
            if gone then return end
            gone = true
            tw(card, 0.3, { Position = UDim2.fromOffset(340, 0) }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
            task.delay(0.28, function()
                local h = wrap.AbsoluteSize.Y / math.max(toastScale.Scale, 0.01)
                wrap.AutomaticSize = Enum.AutomaticSize.None
                wrap.Size = UDim2.new(0, 300, 0, h)
                tw(wrap, 0.25, { Size = UDim2.new(0, 300, 0, 0) })
                task.delay(0.26, function() wrap:Destroy() end)
            end)
        end
        card.MouseButton1Click:Connect(dismiss)
        task.delay(duration, dismiss)
    end

    function Window:Dialog(o)
        if not alive then return end
        o = o or {}
        local overlay = make("TextButton", {
            Parent = main, Size = UDim2.fromScale(1, 1), Text = "", AutoButtonColor = false,
            BackgroundColor3 = rgb(0, 0, 0), BackgroundTransparency = 1, ZIndex = 40,
        }, { corner(12) })
        tw(overlay, 0.25, { BackgroundTransparency = 0.45 })
        local card = make("Frame", {
            Parent = overlay, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.new(0, 340, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, ZIndex = 41,
        }, { corner(14), pad(20, 20, 18, 20), list("y", 8) })
        T(card, { BackgroundColor3 = "Card" })
        T(make("UIStroke", { Parent = card, Transparency = 0.3, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }), { Color = "Stroke" })
        local s = make("UIScale", { Parent = card, Scale = 0.85 })
        tw(s, 0.35, { Scale = 1 }, Enum.EasingStyle.Back)
        T(make("TextLabel", {
            Parent = card, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
            Text = tostring(o.Title or "Are you sure?"), FontFace = FONTS.Bold, TextSize = 17, TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 1, ZIndex = 42,
        }), { TextColor3 = "Text" })
        if o.Text then
            T(make("TextLabel", {
                Parent = card, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
                Text = tostring(o.Text), FontFace = FONTS.Regular, TextSize = 14, TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 2, ZIndex = 42,
            }), { TextColor3 = "SubText" })
        end
        local row = make("Frame", {
            Parent = card, Size = UDim2.new(1, 0, 0, 44), BackgroundTransparency = 1, LayoutOrder = 3, ZIndex = 42,
        }, { list("x", 8, { HorizontalAlignment = Enum.HorizontalAlignment.Right, VerticalAlignment = Enum.VerticalAlignment.Bottom }) })
        local closed = false
        local function close(cb)
            if closed then return end
            closed = true
            tw(s, 0.18, { Scale = 0.9 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            tw(overlay, 0.2, { BackgroundTransparency = 1 })
            task.delay(0.16, function() card.Visible = false end)
            task.delay(0.22, function() overlay:Destroy() end)
            safe(cb)
        end
        local buttons = o.Buttons or { { Text = "OK", Primary = true } }
        for i, b in ipairs(buttons) do
            local primary = b.Primary or b.Danger
            local btn = make("TextButton", {
                Parent = row, Size = UDim2.new(0, 0, 0, 38), AutomaticSize = Enum.AutomaticSize.X, Text = tostring(b.Text or "OK"),
                FontFace = FONTS.Semi, TextSize = 15, AutoButtonColor = false, LayoutOrder = i, ZIndex = 43,
            }, { corner(9), pad(0, 20, 0, 20) })
            T(btn, { BackgroundColor3 = b.Danger and "Danger" or (primary and "Accent" or "Field"), TextColor3 = primary and "OnAccent" or "Text" })
            local bs = make("UIScale", { Parent = btn })
            btn.MouseButton1Down:Connect(function() tw(bs, 0.1, { Scale = 0.95 }) end)
            btn.MouseButton1Up:Connect(function() tw(bs, 0.15, { Scale = 1 }) end)
            btn.MouseLeave:Connect(function() tw(bs, 0.15, { Scale = 1 }) end)
            btn.MouseButton1Click:Connect(function() close(b.Callback) end)
        end
    end

    local FLOAT = MOBILE and 62 or 54
    local savedFloat = type(prefs.Float) == "table" and prefs.Float
    -- the little floating button on mobile. you can drag it around
    local pill = make("TextButton", {
        Parent = gui, AnchorPoint = Vector2.new(0.5, 0.5),
        Position = savedFloat and UDim2.fromOffset(tonumber(savedFloat[1]) or 0, tonumber(savedFloat[2]) or 0) or UDim2.new(0.5, 0, 0, 60),
        Size = UDim2.fromOffset(FLOAT, FLOAT), Text = "", AutoButtonColor = false, Visible = false, ZIndex = 60,
    }, { corner("full") })
    T(pill, { BackgroundColor3 = "Card" })
    T(make("UIStroke", { Parent = pill, Transparency = 0.25, Thickness = 1.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }), { Color = "Stroke" })
    make("ImageLabel", {
        Parent = pill, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 3),
        Size = UDim2.new(1, 24, 1, 24), BackgroundTransparency = 1, Image = SHADOW, ImageColor3 = rgb(0, 0, 0),
        ImageTransparency = 0.75, ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(49, 49, 450, 450), ZIndex = 59,
    })
    mark(pill, math.floor(FLOAT * 0.56), { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), ZIndex = 61 })
    local pillScale = make("UIScale", { Parent = pill, Scale = 0 })

    local function clampFloat()
        local area = gui.AbsoluteSize
        if area.X < 2 then return end
        local c = pill.AbsolutePosition + pill.AbsoluteSize / 2
        if pill.AbsoluteSize.X < 1 then return end
        local half = FLOAT / 2 + 6
        local x = math.clamp(c.X, half, area.X - half)
        local y = math.clamp(c.Y, half, area.Y - half)
        pill.Position = UDim2.fromOffset(x, y)
    end
    on(pill.MouseEnter, function() if pillScale.Scale > 0.5 then tw(pillScale, 0.25, { Scale = 1.08 }, Enum.EasingStyle.Back) end end)
    on(pill.MouseLeave, function() if pillScale.Scale > 0.5 then tw(pillScale, 0.25, { Scale = 1 }) end end)
    on(pill.InputBegan, function(input)
        local kind = input.UserInputType
        if kind ~= Enum.UserInputType.MouseButton1 and kind ~= Enum.UserInputType.Touch then return end
        local start, startPos, moved = input.Position, pill.Position, false
        tw(pillScale, 0.12, { Scale = 0.9 })
        local move
        move = UIS.InputChanged:Connect(function(i)
            if i == input or i.UserInputType == Enum.UserInputType.MouseMovement then
                local d = i.Position - start
                if moved or d.Magnitude > 8 then
                    moved = true
                    pill.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
                end
            end
        end)
        table.insert(conns, move)
        local done
        done = input.Changed:Connect(function()
            if input.UserInputState ~= Enum.UserInputState.End then return end
            move:Disconnect()
            done:Disconnect()
            tw(pillScale, 0.35, { Scale = 1 }, Enum.EasingStyle.Back)
            if moved then
                clampFloat()
                local c = pill.AbsolutePosition + pill.AbsoluteSize / 2
                prefs.Float = { math.floor(c.X), math.floor(c.Y) }
                savePrefs()
            else
                Window:Toggle(true)
            end
        end)
    end)

    local function showPill(state)
        if state then
            pill.Visible = true
            task.defer(clampFloat)
            pillScale.Scale = 0
            tw(pillScale, 0.45, { Scale = 1 }, Enum.EasingStyle.Back)
        else
            tw(pillScale, 0.2, { Scale = 0 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            task.delay(0.2, function() if visible then pill.Visible = false end end)
        end
    end

    function Window:Toggle(state, fromButton)
        if not alive or animating then return end
        if state == nil then state = not visible end
        if state == visible then return end
        visible = state
        animating = true
        if state then
            showPill(false)
            root.Visible = true
            popScale.Scale = 0.88
            shadow.ImageTransparency = 1
            tw(popScale, 0.42, { Scale = 1 }, Enum.EasingStyle.Back)
            tw(shadow, 0.4, { ImageTransparency = 0.7 })
            task.delay(0.3, function() animating = false end)
        else
            searchBox:ReleaseFocus()
            tw(popScale, 0.2, { Scale = 0.88 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            tw(shadow, 0.18, { ImageTransparency = 1 })
            task.delay(0.2, function()
                if not visible then root.Visible = false end
                animating = false
            end)
            if MOBILE then showPill(true) end
        end
    end
    function Window:IsVisible() return visible end
    on(closeBtn.MouseEnter, function() tw(closeScale, 0.25, { Scale = 1.1 }, Enum.EasingStyle.Back) end)
    on(closeBtn.MouseLeave, function() tw(closeScale, 0.2, { Scale = 1 }) end)
    on(closeBtn.MouseButton1Down, function() tw(closeScale, 0.1, { Scale = 0.88 }) end)
    on(closeBtn.MouseButton1Click, function()
        closeScale.Scale = 1
        Window:Toggle(false)
    end)

    on(root:GetPropertyChangedSignal("Size"), fit)

    on(UIS.InputBegan, function(input)
        if listening then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local k = input.KeyCode
                if k == Enum.KeyCode.Escape or k == Enum.KeyCode.Backspace then k = nil end
                listening(k)
            end
            return
        end
        if input.UserInputType ~= Enum.UserInputType.Keyboard or UIS:GetFocusedTextBox() then return end
        if input.KeyCode == menuKey then
            Window:Toggle()
            return
        end
        for _, b in ipairs(binds) do
            if b.key == input.KeyCode then b.press(true) end
        end
    end)
    on(UIS.InputEnded, function(input)
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        for _, b in ipairs(binds) do
            if b.key == input.KeyCode then b.press(false) end
        end
    end)

    -- click it, press a key. esc or backspace clears
    local function keycap(parent, key, changed, props)
        local cap = make("TextButton", {
            Parent = parent, AnchorPoint = Vector2.new(1, 0.5), Position = props and props.Position or UDim2.new(1, 0, 0.5, 0),
            Size = UDim2.new(0, 0, 0, 30), AutomaticSize = Enum.AutomaticSize.X, Text = keyName(key),
            FontFace = FONTS.Medium, TextSize = 13, AutoButtonColor = false, ZIndex = 4,
        }, { corner(6), pad(0, 9, 0, 9), make("UISizeConstraint", { MinSize = Vector2.new(42, 30) }) })
        T(cap, { BackgroundColor3 = "Field", TextColor3 = "SubText" })
        local stroke = T(make("UIStroke", { Parent = cap, Transparency = 0.4, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }), { Color = "Separator" })
        local state = { key = key }
        local pulse
        function state.set(k)
            state.key = k
            cap.Text = keyName(k)
        end
        on(cap.MouseButton1Click, function()
            if listening then return end
            cap.Text = "..."
            tw(stroke, 0.2, { Color = theme.Accent, Transparency = 0 })
            pulse = TweenService:Create(cap, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { TextTransparency = 0.7 })
            pulse:Play()
            listening = function(k)
                listening = nil
                if pulse then pulse:Cancel() end
                cap.TextTransparency = 0
                tw(stroke, 0.25, { Color = theme.Separator, Transparency = 0.4 })
                local final = changed(k)
                if final ~= nil then k = final end
                state.set(k)
            end
        end)
        return cap, state
    end

    local current
    local settingsTab
    local function sideY(target)
        local y = 0
        for _, it in ipairs(sideItems) do
            if it.inst == target then return y end
            if it.inst.Visible then y += it.height + 2 end
        end
        return y
    end

    local function refreshTabColors(animate)
        for _, t in ipairs(tabs) do
            local col = (t == current) and theme.OnAccent or theme.Text
            if animate then tw(t.label, 0.25, { TextColor3 = col }) else t.label.TextColor3 = col end
        end
        if settingsTab then
            local sel = current == settingsTab
            local col = sel and theme.OnAccent or theme.Text
            if animate then
                tw(settingsTab.label, 0.25, { TextColor3 = col })
                tw(settingsRow, 0.25, { BackgroundTransparency = sel and 0 or 1 })
            else
                settingsTab.label.TextColor3 = col
                settingsRow.BackgroundTransparency = sel and 0 or 1
            end
        end
    end

    local function moveHighlight(animate)
        if not current or current == settingsTab or not current.button.Visible then
            tw(highlight, 0.2, { BackgroundTransparency = 1 })
            return
        end
        local goal = UDim2.fromOffset(10, sideY(current.button))
        if animate and highlight.BackgroundTransparency < 1 then
            tw(highlight, 0.35, { Position = goal })
        else
            highlight.Position = goal
        end
        tw(highlight, 0.2, { BackgroundTransparency = 0 })
    end

    local function selectTab(tab)
        if current == tab then return end
        local old = current
        current = tab
        if old then old.page.Visible = false end
        tab.page.Visible = true
        tab.page.Position = UDim2.fromOffset(22, 0)
        tw(tab.page, 0.38, { Position = UDim2.fromOffset(0, 0) })
        for i, g in ipairs(tab.groups) do
            g.lift.PaddingTop = UDim.new(0, 14)
            tw(g.lift, 0.4, { PaddingTop = UDim.new(0, 0) }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, math.min(i - 1, 6) * 0.04)
        end
        pageTitle.Text = tab.name
        pageTitle.TextTransparency = 1
        pageTitle.Position = UDim2.fromOffset(36, 4)
        tw(pageTitle, 0.3, { TextTransparency = 0, Position = UDim2.fromOffset(26, 4) })
        headerLine.BackgroundTransparency = tab.page.CanvasPosition.Y > 2 and 0 or 1
        moveHighlight(true)
        refreshTabColors(true)
    end

    local function applySearch()
        local q = string.lower(searchBox.Text)
        local function hit(s) return q == "" or string.find(string.lower(s), q, 1, true) ~= nil end
        for _, t in ipairs(tabs) do
            local tabHit = hit(t.name)
            local any = tabHit
            for _, g in ipairs(t.groups) do
                local groupHit = tabHit or hit(g.name)
                local groupAny = false
                for _, item in ipairs(g.items) do
                    local show = groupHit or hit(item.name)
                    item.row.Visible = show
                    groupAny = groupAny or show
                end
                g.frame.Visible = groupAny or (q == "")
                any = any or groupAny
            end
            t.button.Visible = any
            t.matches = any
        end
        for _, it in ipairs(sideItems) do
            if it.header then
                local show = false
                for _, t in ipairs(it.header) do show = show or t.button.Visible end
                it.inst.Visible = show
            end
        end
        if current and current ~= settingsTab and not current.matches then
            for _, t in ipairs(tabs) do
                if t.matches then selectTab(t) break end
            end
        end
        task.defer(moveHighlight, true)
    end
    on(searchBox:GetPropertyChangedSignal("Text"), applySearch)

    local groupMeta = {}
    groupMeta.__index = groupMeta

    local function makePage()
        local page = make("ScrollingFrame", {
            Parent = pages, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0,
            CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y,
            ScrollBarThickness = 3, Visible = false, ZIndex = 2,
        }, { list("y", 18), pad(4, 24, 26, 24) })
        T(page, { ScrollBarImageColor3 = "Faint" })
        on(page:GetPropertyChangedSignal("CanvasPosition"), function()
            if current and current.page == page then
                local want = page.CanvasPosition.Y > 2 and 0 or 1
                if headerLine.BackgroundTransparency ~= want then tw(headerLine, 0.2, { BackgroundTransparency = want }) end
            end
        end)
        return page
    end

    local tabMeta = {}
    tabMeta.__index = function(self, key)
        if tabMeta[key] then return tabMeta[key] end
        if groupMeta[key] and key ~= "__index" then
            -- lets you do Tab:Toggle{} without making a group first
            return function(t, ...)
                if not t._auto then t._auto = t:Group(nil) end
                return groupMeta[key](t._auto, ...)
            end
        end
        return nil
    end

    function tabMeta:Group(name)
        local o = type(name) == "table" and name or { Name = name }
        local g = setmetatable({ tab = self, name = o.Name and tostring(o.Name) or "", items = {}, count = 0 }, groupMeta)
        self.order += 1
        g.frame = make("Frame", {
            Parent = self.page, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1, LayoutOrder = self.order, ZIndex = 2,
        }, { list("y", 7) })
        g.lift = make("UIPadding", { Parent = g.frame })
        if g.name ~= "" then
            T(make("TextLabel", {
                Parent = g.frame, Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, Text = g.name,
                FontFace = FONTS.Semi, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left,
                LayoutOrder = 1, ZIndex = 2,
            }, { pad(0, 0, 0, 4) }), { TextColor3 = "SubText" })
        end
        g.card = make("Frame", {
            Parent = g.frame, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 2, ZIndex = 2,
        }, { corner(10), list("y", 0) })
        T(g.card, { BackgroundColor3 = "Card" })
        T(make("UIStroke", { Parent = g.card, Transparency = 0.45, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }), { Color = "Separator" })
        if o.Description then
            T(make("TextLabel", {
                Parent = g.frame, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
                Text = tostring(o.Description), FontFace = FONTS.Regular, TextSize = 12, TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 3, ZIndex = 2,
            }, { pad(0, 4, 0, 4) }), { TextColor3 = "Faint" })
        end
        table.insert(self.groups, g)
        lastBuild = os.clock()
        return g
    end

    function Window:Tab(o)
        if type(o) ~= "table" then o = { Name = o } end
        local tab = setmetatable({ name = tostring(o.Name or "Tab"), groups = {}, order = 0 }, tabMeta)
        tab.page = makePage()
        local idx = #tabs + 1

        if not MOBILE and o.Group and o.Group ~= "" and (not tabs[#tabs] or tabs[#tabs].groupName ~= o.Group) then
            local h = make("TextLabel", {
                Parent = tabHolder, Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, Text = tostring(o.Group),
                FontFace = FONTS.Semi, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Bottom, LayoutOrder = #sideItems + 1, ZIndex = 5,
            }, { pad(0, 0, 4, 8) })
            T(h, { TextColor3 = "Faint" })
            table.insert(sideItems, { inst = h, height = 26, header = {} })
        end
        tab.groupName = o.Group
        local headerItem
        for i = #sideItems, 1, -1 do
            if sideItems[i].header then headerItem = sideItems[i] break end
        end
        if headerItem and o.Group then table.insert(headerItem.header, tab) end

        local btn = make("TextButton", {
            Parent = tabHolder, Size = UDim2.new(1, 0, 0, ROW_H), Text = "", AutoButtonColor = false,
            BackgroundTransparency = 1, LayoutOrder = #sideItems + 1, ZIndex = 5,
        }, { corner(7) })
        T(btn, { BackgroundColor3 = "Hover" })
        local badge = make("Frame", {
            Parent = btn, AnchorPoint = MOBILE and Vector2.new(0.5, 0.5) or Vector2.new(0, 0.5),
            Position = MOBILE and UDim2.fromScale(0.5, 0.5) or UDim2.new(0, 7, 0.5, 0),
            Size = MOBILE and UDim2.fromOffset(32, 32) or UDim2.fromOffset(24, 24),
            BackgroundColor3 = o.Color or BADGES[(idx - 1) % #BADGES + 1], ZIndex = 6,
        }, { corner(6) })
        local badgeScale = make("UIScale", { Parent = badge })
        local icon = iconFor(o.Icon) or iconFor(tab.name)
        if icon then
            make("ImageLabel", {
                Parent = badge, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
                Size = MOBILE and UDim2.fromOffset(20, 20) or UDim2.fromOffset(16, 16),
                BackgroundTransparency = 1, Image = icon, ScaleType = Enum.ScaleType.Fit, ZIndex = 7,
            })
        else
            make("TextLabel", {
                Parent = badge, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
                Text = string.upper(string.sub(tab.name, 1, 1)), FontFace = FONTS.Bold, TextSize = MOBILE and 16 or 13,
                TextColor3 = rgb(255, 255, 255), ZIndex = 7,
            })
        end
        tab.label = make("TextLabel", {
            Parent = btn, Position = UDim2.fromOffset(40, 0), Size = UDim2.new(1, -46, 1, 0), BackgroundTransparency = 1,
            Visible = not MOBILE, Text = tab.name, FontFace = FONTS.Medium, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd, TextColor3 = theme.Text, ZIndex = 6,
        })
        tab.button = btn
        table.insert(sideItems, { inst = btn, height = ROW_H, tab = tab })
        table.insert(tabs, tab)

        on(btn.MouseEnter, function()
            if current ~= tab then tw(btn, 0.15, { BackgroundTransparency = 0.94 }) end
            tw(badgeScale, 0.2, { Scale = 1.1 }, Enum.EasingStyle.Back)
        end)
        on(btn.MouseLeave, function()
            tw(btn, 0.2, { BackgroundTransparency = 1 })
            tw(badgeScale, 0.2, { Scale = 1 })
        end)
        on(btn.MouseButton1Click, function()
            tw(btn, 0.2, { BackgroundTransparency = 1 })
            badgeScale.Scale = 0.85
            tw(badgeScale, 0.35, { Scale = 1 }, Enum.EasingStyle.Back)
            selectTab(tab)
        end)
        if not current or current == settingsTab and #tabs == 1 then selectTab(tab) end
        lastBuild = os.clock()
        return tab
    end

    local function register(o, obj)
        if o.Flag then
            Window.Flags[o.Flag] = obj
        end
        lastBuild = os.clock()
    end

    local function newRow(g, o, controlWidth)
        g.count += 1
        local row = make("Frame", {
            Parent = g.card, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1, LayoutOrder = g.count, ZIndex = 2,
        })
        if g.count > 1 then
            T(make("Frame", {
                Parent = row, Position = UDim2.fromOffset(16, 0), Size = UDim2.new(1, -16, 0, 1), BorderSizePixel = 0, ZIndex = 4,
            }), { BackgroundColor3 = "Separator" })
        end
        local hover = make("Frame", {
            Parent = row, Position = UDim2.fromOffset(4, 3), Size = UDim2.new(1, -8, 1, -6),
            BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 2,
        }, { corner(7) })
        T(hover, { BackgroundColor3 = "Hover" })
        local stack = make("Frame", {
            Parent = row, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1, ZIndex = 3,
        }, { list("y", 0) })
        -- whole line is a button so tapping the name works too
        local line = make("TextButton", {
            Parent = stack, Size = UDim2.new(1, 0, 0, MOBILE and 58 or 52), AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1, Text = "", AutoButtonColor = false, LayoutOrder = 1, ZIndex = 3,
        }, { list("x", 12, { VerticalAlignment = Enum.VerticalAlignment.Center }), pad(10, 16, 10, 16) })
        local textBlock = make("Frame", {
            Parent = line, Size = UDim2.new(1, -(controlWidth + 12), 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1, LayoutOrder = 1, ZIndex = 3,
        }, { list("y", 2) })
        local name = make("TextLabel", {
            Parent = textBlock, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
            Text = tostring(o.Name or o.Title or ""), FontFace = FONTS.Medium, TextSize = 15, TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 1, ZIndex = 3,
        })
        T(name, { TextColor3 = "Text" })
        local desc
        if o.Description then
            desc = make("TextLabel", {
                Parent = textBlock, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
                Text = tostring(o.Description), FontFace = FONTS.Regular, TextSize = 13, TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 2, ZIndex = 3,
            })
            T(desc, { TextColor3 = "SubText" })
        end
        local ctrl = make("Frame", {
            Parent = line, Size = UDim2.fromOffset(controlWidth, 28), BackgroundTransparency = 1, LayoutOrder = 2, ZIndex = 3,
        })
        local fold = make("Frame", {
            Parent = stack, Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, ClipsDescendants = true,
            Visible = false, LayoutOrder = 2, ZIndex = 3,
        })
        on(row.MouseEnter, function() tw(hover, 0.15, { BackgroundTransparency = theme == FeatherLite.Themes.Light and 0.97 or 0.965 }) end)
        on(row.MouseLeave, function() tw(hover, 0.25, { BackgroundTransparency = 1 }) end)
        table.insert(g.items, { name = name.Text, row = row })
        local function tap(fn) on(line.MouseButton1Click, fn) end
        return { row = row, line = line, name = name, desc = desc, ctrl = ctrl, fold = fold, hover = hover, tap = tap }
    end

    local function openFold(r, height, state)
        if state then
            r.fold.Visible = true
            tw(r.fold, 0.32, { Size = UDim2.new(1, 0, 0, height) })
        else
            tw(r.fold, 0.25, { Size = UDim2.new(1, 0, 0, 0) }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            task.delay(0.25, function()
                if r.fold.Size.Y.Offset < 1 then r.fold.Visible = false end
            end)
        end
    end

    local function chevron(parent, pos)
        local holder = make("Frame", {
            Parent = parent, AnchorPoint = Vector2.new(1, 0.5), Position = pos, Size = UDim2.fromOffset(10, 10),
            BackgroundTransparency = 1, ZIndex = 5,
        })
        local a = make("Frame", { Parent = holder, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(3, 5), Size = UDim2.fromOffset(6, 1.6), Rotation = 45, BorderSizePixel = 0, ZIndex = 5 })
        local b = make("Frame", { Parent = holder, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(7, 5), Size = UDim2.fromOffset(6, 1.6), Rotation = -45, BorderSizePixel = 0, ZIndex = 5 })
        T(a, { BackgroundColor3 = "SubText" })
        T(b, { BackgroundColor3 = "SubText" })
        return function(open)
            tw(a, 0.3, { Rotation = open and -45 or 45 })
            tw(b, 0.3, { Rotation = open and 45 or -45 })
        end
    end

    function groupMeta:Toggle(o)
        o = o or {}
        local hasBind = o.Keybind ~= nil and not MOBILE
        local r = newRow(self, o, hasBind and 122 or 54)
        local value = o.Default == true
        local track = make("TextButton", {
            Parent = r.ctrl, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0),
            Size = UDim2.fromOffset(52, 31), Text = "", AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 4,
        }, { corner("full") })
        local knob = make("Frame", {
            Parent = track, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 15.5, 0.5, 0),
            Size = UDim2.fromOffset(27, 27), BorderSizePixel = 0, ZIndex = 5,
        }, { corner("full") })
        T(knob, { BackgroundColor3 = "Knob" })
        make("UIStroke", { Parent = knob, Color = rgb(0, 0, 0), Transparency = 0.88, Thickness = 1 })

        local function render(animate)
            local x = value and 36.5 or 15.5
            local col = value and theme.Accent or theme.Track
            if animate then
                tw(track, 0.25, { BackgroundColor3 = col }, Enum.EasingStyle.Quad)
                tw(knob, 0.12, { Size = UDim2.fromOffset(34, 27) }, Enum.EasingStyle.Quad)
                tw(knob, 0.36, { Position = UDim2.new(0, x, 0.5, 0) }, Enum.EasingStyle.Back)
                task.delay(0.12, function() tw(knob, 0.2, { Size = UDim2.fromOffset(27, 27) }, Enum.EasingStyle.Quad) end)
            else
                track.BackgroundColor3 = col
                knob.Position = UDim2.new(0, x, 0.5, 0)
            end
        end
        hook(function() render(false) end)

        local obj = { Type = "Toggle" }
        function obj:Set(v, silent)
            v = v == true
            if v == value then return end
            value = v
            render(true)
            if not silent then safe(o.Callback, value) end
        end
        function obj:Get() return value end
        function obj:Toggle() obj:Set(not value) end
        on(track.MouseButton1Click, function() obj:Toggle() end)
        r.tap(function() obj:Toggle() end)

        if hasBind then
            local entry = { key = toKey(o.Keybind) }
            local _, cap = keycap(r.ctrl, entry.key, function(k) entry.key = k end, { Position = UDim2.new(1, -62, 0.5, 0) })
            function entry.press(down)
                if not down then return end
                obj:Toggle()
            end
            table.insert(binds, entry)
            function obj:SetBind(k) entry.key = toKey(k); cap.set(entry.key) end
            function obj:GetBind() return entry.key end
        end
        if value then safe(o.Callback, true) end
        table.insert(toggles, obj)
        register(o, obj)
        return obj
    end

    function groupMeta:Slider(o)
        o = o or {}
        local min, max = tonumber(o.Min) or 0, tonumber(o.Max) or 100
        if max <= min then max = min + 1 end
        local step = tonumber(o.Step or o.Increment) or 1
        local decimals = o.Decimals or (step < 1 and #(tostring(step):match("%.(%d+)") or "") or 0)
        local suffix = o.Suffix and tostring(o.Suffix) or ""
        local r = newRow(self, o, 266)
        local value = math.clamp(tonumber(o.Default) or min, min, max)

        local box = make("TextBox", {
            Parent = r.ctrl, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0),
            Size = UDim2.fromOffset(64, 32), Text = "", FontFace = FONTS.Medium, TextSize = 14,
            ClearTextOnFocus = false, ZIndex = 4,
        }, { corner(6) })
        T(box, { BackgroundColor3 = "Field", TextColor3 = "Text" })
        local bar = make("Frame", {
            Parent = r.ctrl, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -80, 0.5, 0),
            Size = UDim2.fromOffset(178, 6), BorderSizePixel = 0, ZIndex = 4,
        }, { corner("full") })
        T(bar, { BackgroundColor3 = "Track" })
        local fill = make("Frame", { Parent = bar, Size = UDim2.fromScale(0, 1), BorderSizePixel = 0, ZIndex = 5 }, { corner("full") })
        T(fill, { BackgroundColor3 = "Accent" })
        local knob = make("Frame", {
            Parent = bar, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0, 0.5),
            Size = UDim2.fromOffset(20, 20), BorderSizePixel = 0, ZIndex = 6,
        }, { corner("full") })
        T(knob, { BackgroundColor3 = "Knob" })
        make("UIStroke", { Parent = knob, Color = rgb(0, 0, 0), Transparency = 0.82 })
        local hit = make("TextButton", {
            Parent = bar, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.new(1, 24, 0, 44), BackgroundTransparency = 1, Text = "", ZIndex = 7,
        })

        local function fmt(v) return string.format("%." .. decimals .. "f", v) end
        local function render(animate)
            local a = (value - min) / (max - min)
            box.Text = fmt(value) .. suffix
            if animate then
                tw(fill, 0.12, { Size = UDim2.fromScale(a, 1) }, Enum.EasingStyle.Quad)
                tw(knob, 0.12, { Position = UDim2.fromScale(a, 0.5) }, Enum.EasingStyle.Quad)
            else
                fill.Size = UDim2.fromScale(a, 1)
                knob.Position = UDim2.fromScale(a, 0.5)
            end
        end

        local obj = { Type = "Slider" }
        function obj:Set(v, silent)
            v = tonumber(v)
            if not v then render(false) return end
            v = math.clamp(min + math.floor((v - min) / step + 0.5) * step, min, max)
            v = tonumber(fmt(v))
            if v == value then render(true) return end
            value = v
            render(true)
            if not silent then safe(o.Callback, value) end
        end
        function obj:Get() return value end

        local dragging = false
        local function fromX(x)
            local a = math.clamp((x - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1)
            obj:Set(min + a * (max - min))
        end
        on(hit.InputBegan, function(input)
            local kind = input.UserInputType
            if kind ~= Enum.UserInputType.MouseButton1 and kind ~= Enum.UserInputType.Touch then return end
            dragging = true
            tw(knob, 0.2, { Size = UDim2.fromOffset(26, 26) }, Enum.EasingStyle.Back)
            fromX(input.Position.X)
            local move
            move = UIS.InputChanged:Connect(function(i)
                if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i == input) then fromX(i.Position.X) end
            end)
            table.insert(conns, move)
            local done
            done = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    move:Disconnect()
                    done:Disconnect()
                    tw(knob, 0.2, { Size = UDim2.fromOffset(20, 20) })
                end
            end)
        end)
        on(hit.MouseEnter, function() if not dragging then tw(knob, 0.15, { Size = UDim2.fromOffset(23, 23) }) end end)
        on(hit.MouseLeave, function() if not dragging then tw(knob, 0.15, { Size = UDim2.fromOffset(20, 20) }) end end)
        on(box.Focused, function() box.Text = fmt(value) end)
        on(box.FocusLost, function()
            local n = tonumber((box.Text:gsub("[^%d%.%-]", "")))
            if n then obj:Set(n) else render(false) end
        end)
        render(false)
        if o.Default ~= nil then safe(o.Callback, value) end
        register(o, obj)
        return obj
    end

    function groupMeta:Dropdown(o)
        o = o or {}
        local multi = o.Multi == true
        local options = {}
        for _, v in ipairs(o.Options or o.Values or {}) do table.insert(options, tostring(v)) end
        local r = newRow(self, o, 210)
        local selected = {}
        local single
        if multi then
            for _, v in ipairs(type(o.Default) == "table" and o.Default or {}) do selected[tostring(v)] = true end
        elseif o.Default ~= nil then
            single = tostring(o.Default)
        end

        local field = make("TextButton", {
            Parent = r.ctrl, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0),
            Size = UDim2.fromOffset(210, 36), Text = "", AutoButtonColor = false, ZIndex = 4,
        }, { corner(7) })
        T(field, { BackgroundColor3 = "Field" })
        local fieldStroke = T(make("UIStroke", { Parent = field, Transparency = 0.4, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }), { Color = "Separator" })
        local shown = make("TextLabel", {
            Parent = field, Position = UDim2.fromOffset(11, 0), Size = UDim2.new(1, -34, 1, 0), BackgroundTransparency = 1,
            Text = "", FontFace = FONTS.Regular, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 5,
        })
        T(shown, { TextColor3 = "Text" })
        local flip = chevron(field, UDim2.new(1, -10, 0.5, 0))

        local listFrame = make("ScrollingFrame", {
            Parent = r.fold, Position = UDim2.fromOffset(14, 0), Size = UDim2.new(1, -28, 1, -10),
            BackgroundTransparency = 1, BorderSizePixel = 0, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 2, ZIndex = 4,
        }, { list("y", 2) })
        T(listFrame, { ScrollBarImageColor3 = "Faint" })

        local obj = { Type = "Dropdown" }
        local open = false
        local optionButtons = {}
        local function isOn(v) if multi then return selected[v] == true end return single == v end
        local function display()
            if multi then
                local picked = {}
                for _, v in ipairs(options) do if selected[v] then table.insert(picked, v) end end
                shown.Text = #picked == 0 and "None" or (#picked <= 2 and table.concat(picked, ", ") or (#picked .. " selected"))
            else
                shown.Text = single or "Select"
            end
        end
        local function paint(animate)
            for v, b in pairs(optionButtons) do
                local sel = isOn(v)
                local goalText = sel and theme.Accent or theme.Text
                if animate then
                    tw(b.label, 0.2, { TextColor3 = goalText })
                    tw(b.dot, 0.3, { Size = sel and UDim2.fromOffset(7, 7) or UDim2.fromOffset(0, 0) }, Enum.EasingStyle.Back)
                else
                    b.label.TextColor3 = goalText
                    b.dot.Size = sel and UDim2.fromOffset(7, 7) or UDim2.fromOffset(0, 0)
                end
            end
            display()
        end
        local function foldHeight() return math.min(#options, 6) * 40 + 10 end

        local function fire()
            if multi then safe(o.Callback, obj:Get()) else safe(o.Callback, single) end
        end
        local function build()
            for _, b in pairs(optionButtons) do b.button:Destroy() end
            optionButtons = {}
            for i, v in ipairs(options) do
                local b = make("TextButton", {
                    Parent = listFrame, Size = UDim2.new(1, -4, 0, 38), Text = "", AutoButtonColor = false,
                    BackgroundTransparency = 1, LayoutOrder = i, ZIndex = 5,
                }, { corner(6) })
                T(b, { BackgroundColor3 = "Hover" })
                local label = make("TextLabel", {
                    Parent = b, Position = UDim2.fromOffset(12, 0), Size = UDim2.new(1, -40, 1, 0), BackgroundTransparency = 1,
                    Text = v, FontFace = FONTS.Regular, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 6,
                })
                local dot = make("Frame", {
                    Parent = b, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(1, -16, 0.5, 0),
                    Size = UDim2.fromOffset(0, 0), BorderSizePixel = 0, ZIndex = 6,
                }, { corner("full") })
                T(dot, { BackgroundColor3 = "Accent" })
                b.MouseEnter:Connect(function() tw(b, 0.12, { BackgroundTransparency = 0.94 }) end)
                b.MouseLeave:Connect(function() tw(b, 0.2, { BackgroundTransparency = 1 }) end)
                b.MouseButton1Click:Connect(function()
                    if multi then
                        selected[v] = not selected[v] or nil
                        paint(true)
                        fire()
                    else
                        if single ~= v then
                            single = v
                            paint(true)
                            fire()
                        end
                        obj:Close()
                    end
                end)
                optionButtons[v] = { button = b, label = label, dot = dot }
            end
            paint(false)
            if open then openFold(r, foldHeight(), true) end
        end

        function obj:Open()
            open = true
            flip(true)
            tw(fieldStroke, 0.2, { Color = theme.Accent, Transparency = 0 })
            openFold(r, foldHeight(), true)
        end
        function obj:Close()
            open = false
            flip(false)
            tw(fieldStroke, 0.2, { Color = theme.Separator, Transparency = 0.4 })
            openFold(r, 0, false)
        end
        function obj:Set(v, silent)
            if multi then
                selected = {}
                if type(v) == "table" then
                    for k, x in pairs(v) do
                        if type(k) == "number" then selected[tostring(x)] = true elseif x then selected[tostring(k)] = true end
                    end
                end
            else
                single = v ~= nil and tostring(v) or nil
            end
            paint(true)
            if not silent then fire() end
        end
        function obj:Get()
            if multi then
                local out = {}
                for _, v in ipairs(options) do if selected[v] then table.insert(out, v) end end
                return out
            end
            return single
        end
        function obj:SetOptions(newOptions, keep)
            options = {}
            for _, v in ipairs(newOptions or {}) do table.insert(options, tostring(v)) end
            if not keep then
                local valid = {}
                for _, v in ipairs(options) do valid[v] = true end
                if multi then
                    for k in pairs(selected) do if not valid[k] then selected[k] = nil end end
                elseif single and not valid[single] then
                    single = nil
                end
            end
            build()
        end
        function obj:GetOptions() return table.clone(options) end
        on(field.MouseButton1Click, function() if open then obj:Close() else obj:Open() end end)
        r.tap(function() if open then obj:Close() else obj:Open() end end)
        hook(function() paint(false) end)
        build()
        if (multi and next(selected)) or single then fire() end
        register(o, obj)
        return obj
    end

    function groupMeta:ColorPicker(o)
        o = o or {}
        local color = typeof(o.Default) == "Color3" and o.Default or Color3.new(1, 1, 1)
        local h, s, v = color:ToHSV()
        local r = newRow(self, o, 60)
        local swatch = make("TextButton", {
            Parent = r.ctrl, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0),
            Size = UDim2.fromOffset(56, 32), Text = "", AutoButtonColor = false, BackgroundColor3 = color, ZIndex = 4,
        }, { corner(7) })
        T(make("UIStroke", { Parent = swatch, Transparency = 0.2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }), { Color = "Stroke" })

        local area = make("Frame", { Parent = r.fold, Position = UDim2.fromOffset(14, 2), Size = UDim2.new(1, -28, 0, 140), BackgroundTransparency = 1, ZIndex = 4 })
        local sv = make("TextButton", {
            Parent = area, Size = UDim2.fromOffset(190, 132), Text = "", AutoButtonColor = false, ZIndex = 4,
        }, { corner(8) })
        make("Frame", { Parent = sv, Size = UDim2.fromScale(1, 1), BackgroundColor3 = rgb(255, 255, 255), ZIndex = 5 }, {
            corner(8), make("UIGradient", { Transparency = NumberSequence.new(0, 1) }),
        })
        make("Frame", { Parent = sv, Size = UDim2.fromScale(1, 1), BackgroundColor3 = rgb(0, 0, 0), ZIndex = 6 }, {
            corner(8), make("UIGradient", { Rotation = 90, Transparency = NumberSequence.new(1, 0) }),
        })
        local svCursor = make("Frame", {
            Parent = sv, AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(14, 14), BackgroundTransparency = 1, ZIndex = 7,
        }, { corner("full"), make("UIStroke", { Color = rgb(255, 255, 255), Thickness = 2 }) })
        local hue = make("TextButton", {
            Parent = area, Position = UDim2.fromOffset(202, 0), Size = UDim2.fromOffset(16, 132), Text = "",
            AutoButtonColor = false, BackgroundColor3 = rgb(255, 255, 255), ZIndex = 4,
        }, { corner(8) })
        local keys = {}
        for i = 0, 6 do table.insert(keys, ColorSequenceKeypoint.new(i / 6, Color3.fromHSV(i / 6, 1, 1))) end
        make("UIGradient", { Parent = hue, Rotation = 90, Color = ColorSequence.new(keys) })
        local hueCursor = make("Frame", {
            Parent = hue, AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(1, 6, 0, 6), BackgroundColor3 = rgb(255, 255, 255), ZIndex = 5,
        }, { corner("full"), make("UIStroke", { Color = rgb(0, 0, 0), Transparency = 0.6 }) })
        local hex = make("TextBox", {
            Parent = area, Position = UDim2.fromOffset(232, 0), Size = UDim2.fromOffset(100, 30), Text = "",
            FontFace = FONTS.Medium, TextSize = 14, ClearTextOnFocus = false, ZIndex = 4,
        }, { corner(7) })
        T(hex, { BackgroundColor3 = "Field", TextColor3 = "Text" })
        local preview = make("Frame", { Parent = area, Position = UDim2.fromOffset(232, 38), Size = UDim2.fromOffset(100, 30), ZIndex = 4 }, { corner(7) })
        T(make("UIStroke", { Parent = preview, Transparency = 0.3 }), { Color = "Stroke" })

        local obj = { Type = "ColorPicker" }
        local function render()
            color = Color3.fromHSV(h, s, v)
            swatch.BackgroundColor3 = color
            preview.BackgroundColor3 = color
            sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
            svCursor.Position = UDim2.fromScale(s, 1 - v)
            hueCursor.Position = UDim2.fromScale(0.5, h)
            hex.Text = "#" .. string.upper(color:ToHex())
        end
        function obj:Set(c, silent)
            if typeof(c) ~= "Color3" then return end
            h, s, v = c:ToHSV()
            render()
            if not silent then safe(o.Callback, color) end
        end
        function obj:Get() return color end

        local function dragOn(target, apply)
            on(target.InputBegan, function(input)
                local kind = input.UserInputType
                if kind ~= Enum.UserInputType.MouseButton1 and kind ~= Enum.UserInputType.Touch then return end
                apply(input.Position)
                local move
                move = UIS.InputChanged:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseMovement or i == input then apply(i.Position) end
                end)
                table.insert(conns, move)
                local done
                done = input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        move:Disconnect()
                        done:Disconnect()
                    end
                end)
            end)
        end
        dragOn(sv, function(p)
            s = math.clamp((p.X - sv.AbsolutePosition.X) / sv.AbsoluteSize.X, 0, 1)
            v = 1 - math.clamp((p.Y - sv.AbsolutePosition.Y) / sv.AbsoluteSize.Y, 0, 1)
            render()
            safe(o.Callback, color)
        end)
        dragOn(hue, function(p)
            h = math.clamp((p.Y - hue.AbsolutePosition.Y) / hue.AbsoluteSize.Y, 0, 0.999)
            render()
            safe(o.Callback, color)
        end)
        on(hex.FocusLost, function()
            local ok, c = pcall(Color3.fromHex, (hex.Text:gsub("#", "")))
            if ok and c then obj:Set(c) else render() end
        end)
        local open = false
        local function flipOpen()
            open = not open
            openFold(r, open and 148 or 0, open)
        end
        on(swatch.MouseButton1Click, flipOpen)
        r.tap(flipOpen)
        render()
        register(o, obj)
        return obj
    end

    function groupMeta:Input(o)
        o = o or {}
        local r = newRow(self, o, 220)
        local field = make("Frame", {
            Parent = r.ctrl, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0),
            Size = UDim2.fromOffset(220, 36), ZIndex = 4,
        }, { corner(7) })
        T(field, { BackgroundColor3 = "Field" })
        local stroke = T(make("UIStroke", { Parent = field, Transparency = 0.4, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }), { Color = "Separator" })
        local box = make("TextBox", {
            Parent = field, Position = UDim2.fromOffset(11, 0), Size = UDim2.new(1, -22, 1, 0), BackgroundTransparency = 1,
            Text = o.Default and tostring(o.Default) or "", PlaceholderText = o.Placeholder and tostring(o.Placeholder) or "",
            FontFace = FONTS.Regular, TextSize = 15, ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left,
            ClipsDescendants = true, ZIndex = 5,
        })
        r.tap(function() box:CaptureFocus() end)
        T(box, { TextColor3 = "Text", PlaceholderColor3 = "Faint" })
        if o.Numeric then
            on(box:GetPropertyChangedSignal("Text"), function()
                local clean = box.Text:gsub("[^%d%.%-]", "")
                if clean ~= box.Text then box.Text = clean end
            end)
        end
        on(box.Focused, function() tw(stroke, 0.2, { Color = theme.Accent, Transparency = 0, Thickness = 1.5 }) end)
        local obj = { Type = "Input" }
        on(box.FocusLost, function(enter)
            tw(stroke, 0.25, { Color = theme.Separator, Transparency = 0.4, Thickness = 1 })
            safe(o.Callback, o.Numeric and tonumber(box.Text) or box.Text, enter)
        end)
        function obj:Set(t, silent)
            box.Text = tostring(t or "")
            if not silent then safe(o.Callback, o.Numeric and tonumber(box.Text) or box.Text, false) end
        end
        function obj:Get() return o.Numeric and tonumber(box.Text) or box.Text end
        register(o, obj)
        return obj
    end

    function groupMeta:Keybind(o)
        o = o or {}
        local r = newRow(self, o, 110)
        local entry = { key = toKey(o.Default) }
        local cap
        if MOBILE then
            local run = make("TextButton", {
                Parent = r.ctrl, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0),
                Size = UDim2.fromOffset(72, 36), Text = "Run", FontFace = FONTS.Semi, TextSize = 15,
                AutoButtonColor = false, ZIndex = 4,
            }, { corner(9) })
            T(run, { BackgroundColor3 = "Field", TextColor3 = "Accent" })
            local rs = make("UIScale", { Parent = run })
            local function fireRun()
                tw(rs, 0.08, { Scale = 0.92 })
                task.delay(0.08, function() tw(rs, 0.25, { Scale = 1 }, Enum.EasingStyle.Back) end)
                entry.press(true)
                task.delay(0.1, function() entry.press(false) end)
            end
            on(run.MouseButton1Click, fireRun)
            r.tap(fireRun)
            cap = { set = function() end }
        end
        if not MOBILE then local _; _, cap = keycap(r.ctrl, entry.key, function(k)
            if k == nil and o.AllowNone == false then return entry.key end
            entry.key = k
            safe(o.Changed, k)
            return k
        end) end
        function entry.press(down)
            if o.Hold then
                safe(o.Callback, down)
            elseif down then
                safe(o.Callback)
            end
        end
        table.insert(binds, entry)
        local obj = { Type = "Keybind" }
        function obj:Set(k)
            entry.key = toKey(k)
            cap.set(entry.key)
        end
        function obj:Get() return entry.key end
        register(o, obj)
        return obj
    end

    function groupMeta:Button(o, callback)
        if type(o) ~= "table" then o = { Name = o, Callback = callback } end
        local r = newRow(self, o, 14)
        r.row.ClipsDescendants = true
        T(r.name, { TextColor3 = o.Danger and "Danger" or "Accent" })
        local arrow = make("Frame", {
            Parent = r.ctrl, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0),
            Size = UDim2.fromOffset(10, 10), BackgroundTransparency = 1, ZIndex = 5,
        })
        for i, rot in ipairs({ 45, -45 }) do
            T(make("Frame", {
                Parent = arrow, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(5, i == 1 and 3 or 7),
                Size = UDim2.fromOffset(6, 1.6), Rotation = rot, BorderSizePixel = 0, ZIndex = 5,
            }), { BackgroundColor3 = "Faint" })
        end
        local hit = make("TextButton", {
            Parent = r.row, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", ZIndex = 8,
        })
        local nameScale = make("UIScale", { Parent = r.name })
        on(hit.MouseButton1Down, function() tw(nameScale, 0.1, { Scale = 0.97 }) end)
        on(hit.MouseButton1Up, function() tw(nameScale, 0.2, { Scale = 1 }, Enum.EasingStyle.Back) end)
        on(hit.MouseLeave, function() tw(nameScale, 0.2, { Scale = 1 }) end)
        on(hit.InputBegan, function(input)
            local kind = input.UserInputType
            if kind ~= Enum.UserInputType.MouseButton1 and kind ~= Enum.UserInputType.Touch then return end
            local total = fitScale.Scale * popScale.Scale
            local x = (input.Position.X - r.row.AbsolutePosition.X) / total
            local y = (input.Position.Y - r.row.AbsolutePosition.Y) / total
            local ripple = make("Frame", {
                Parent = r.row, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(x, y),
                Size = UDim2.fromOffset(0, 0), BackgroundColor3 = o.Danger and theme.Danger or theme.Accent,
                BackgroundTransparency = 0.82, BorderSizePixel = 0, ZIndex = 2,
            }, { corner("full") })
            local d = r.row.AbsoluteSize.X / total * 2.2
            tw(ripple, 0.6, { Size = UDim2.fromOffset(d, d), BackgroundTransparency = 1 }, Enum.EasingStyle.Quad)
            task.delay(0.62, function() ripple:Destroy() end)
        end)
        on(hit.MouseButton1Click, function() safe(o.Callback) end)
        on(hit.MouseEnter, function() tw(r.hover, 0.15, { BackgroundTransparency = theme == FeatherLite.Themes.Light and 0.97 or 0.965 }) end)
        on(hit.MouseLeave, function() tw(r.hover, 0.25, { BackgroundTransparency = 1 }) end)
        local obj = { Type = "Button" }
        function obj:SetText(t) r.name.Text = tostring(t) end
        lastBuild = os.clock()
        return obj
    end

    function groupMeta:Label(text)
        local o = type(text) == "table" and text or { Text = text }
        local r = newRow(self, { Name = tostring(o.Text or "") }, 0)
        r.name.FontFace = FONTS.Regular
        r.name.TextSize = 14
        T(r.name, { TextColor3 = "SubText" })
        local obj = { Type = "Label" }
        function obj:Set(t) r.name.Text = tostring(t) end
        function obj:Get() return r.name.Text end
        return obj
    end

    function groupMeta:Paragraph(o)
        o = type(o) == "table" and o or { Title = tostring(o) }
        local r = newRow(self, { Name = o.Title or "", Description = o.Text or o.Content or "" }, 0)
        r.name.FontFace = FONTS.Semi
        local obj = { Type = "Paragraph" }
        function obj:Set(t) if r.desc then r.desc.Text = tostring(t) end end
        function obj:SetTitle(t) r.name.Text = tostring(t) end
        return obj
    end

    function Window:SetTheme(name)
        if not FeatherLite.Themes[name] then return end
        themeName = name
        theme = FeatherLite.Themes[name]
        for i = #themed, 1, -1 do
            local inst, map = themed[i][1], themed[i][2]
            if inst.Parent == nil then
                table.remove(themed, i)
            else
                local goal = {}
                for prop, role in pairs(map) do goal[prop] = theme[role] end
                tw(inst, 0.35, goal, Enum.EasingStyle.Quad)
            end
        end
        for _, fn in ipairs(hooks) do fn(true) end
        refreshTabColors(true)
    end
    function Window:GetTheme() return themeName end

    function Window:SetTransparency(a)
        alpha = math.clamp(tonumber(a) or 0, 0, 0.8)
        applyAlpha()
    end

    function Window:SaveConfig(name)
        name = tostring(name or ""):gsub("[^%w%-_ ]", "")
        if name == "" then return false end
        local data = { flags = {}, binds = {} }
        for flag, el in pairs(Window.Flags) do
            if el.Get then data.flags[flag] = encode(el:Get()) end
            if el.GetBind then data.binds[flag] = encode(el:GetBind()) end
        end
        FS.write(configDir .. "/" .. name .. ".json", HttpService:JSONEncode(data))
        return true
    end

    function Window:LoadConfig(name)
        local data = FS.json(configDir .. "/" .. tostring(name) .. ".json")
        if type(data) ~= "table" then return false end
        for flag, v in pairs(data.flags or {}) do
            local el = Window.Flags[flag]
            if el and el.Set then pcall(el.Set, el, decode(v)) end
        end
        for flag, k in pairs(data.binds or {}) do
            local el = Window.Flags[flag]
            if el and el.SetBind then pcall(el.SetBind, el, decode(k)) end
        end
        return true
    end

    function Window:ListConfigs() return FS.configs(configDir) end

    function Window:OnUnload(fn) table.insert(unloadFns, fn) end

    function Window:Unload(instant)
        if not alive then return end
        for _, t in ipairs(toggles) do
            if t:Get() then t:Set(false) end
        end
        for _, fn in ipairs(unloadFns) do safe(fn) end
        alive = false
        listening = nil
        for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
        table.clear(conns)
        local i = table.find(registry, Window)
        if i then table.remove(registry, i) end
        if instant then
            gui:Destroy()
            return
        end
        tw(popScale, 0.22, { Scale = 0.85 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        tw(shadow, 0.2, { ImageTransparency = 1 })
        tw(pillScale, 0.2, { Scale = 0 })
        task.delay(0.24, function() gui:Destroy() end)
    end

    settingsTab = setmetatable({ name = "Settings", groups = {}, order = 0 }, tabMeta)
    settingsTab.page = makePage()
    settingsTab.button = settingsRow
    settingsTab.matches = true
    do
        local badge = make("Frame", {
            Parent = settingsRow, AnchorPoint = MOBILE and Vector2.new(0.5, 0.5) or Vector2.new(0, 0.5),
            Position = MOBILE and UDim2.fromScale(0.5, 0.5) or UDim2.new(0, 7, 0.5, 0),
            Size = MOBILE and UDim2.fromOffset(32, 32) or UDim2.fromOffset(24, 24), BackgroundColor3 = rgb(142, 142, 147), ZIndex = 5,
        }, { corner(6) })
        local gear = make("ImageLabel", {
            Parent = badge, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
            Size = MOBILE and UDim2.fromOffset(20, 20) or UDim2.fromOffset(16, 16),
            BackgroundTransparency = 1, Image = iconFor("Settings"), ScaleType = Enum.ScaleType.Fit, ZIndex = 6,
        })
        local gearScale = make("UIScale", { Parent = badge })
        settingsTab.label = make("TextLabel", {
            Parent = settingsRow, Position = UDim2.fromOffset(40, 0), Size = UDim2.new(1, -46, 1, 0), BackgroundTransparency = 1,
            Visible = not MOBILE, Text = "Settings", FontFace = FONTS.Medium, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left,
            TextColor3 = theme.Text, ZIndex = 5,
        })
        on(settingsRow.MouseEnter, function()
            tw(gearScale, 0.2, { Scale = 1.1 }, Enum.EasingStyle.Back)
            tw(gear, 0.6, { Rotation = gear.Rotation + 90 }, Enum.EasingStyle.Back)
        end)
        on(settingsRow.MouseLeave, function() tw(gearScale, 0.2, { Scale = 1 }) end)
        on(settingsRow.MouseButton1Click, function()
            gearScale.Scale = 0.85
            tw(gearScale, 0.35, { Scale = 1 }, Enum.EasingStyle.Back)
            selectTab(settingsTab)
        end)
    end

    local appearance = settingsTab:Group("Appearance")
    appearance:Dropdown({
        Name = "Theme", Options = FeatherLite.ThemeOrder, Default = themeName,
        Callback = function(v)
            if v and v ~= themeName then
                Window:SetTheme(v)
                savePrefs()
            end
        end,
    })
    appearance:Slider({
        Name = "Transparency", Description = "How see-through the window background is.",
        Min = 0, Max = 60, Step = 5, Suffix = "%", Default = math.floor(alpha * 100 + 0.5),
        Callback = function(v)
            Window:SetTransparency(v / 100)
            savePrefs()
        end,
    })
    appearance:Slider({
        Name = "Menu size", Min = 70, Max = 130, Step = 5, Suffix = "%", Default = math.floor(userScale * 100 + 0.5),
        Callback = function(v)
            userScale = v / 100
            fit()
            savePrefs()
        end,
    })

    local menu = settingsTab:Group("Menu")
    if not MOBILE then menu:Keybind({
        Name = "Menu key", Description = "Opens and closes this window.", Default = menuKey, AllowNone = false,
        Changed = function(k)
            if k then
                menuKey = k
                savePrefs()
            end
        end,
    }) end
    menu:Toggle({
        Name = "Notifications", Default = notifyOn,
        Callback = function(v)
            notifyOn = v
            savePrefs()
        end,
    })
    -- unload shouldnt turn notifications off
    table.remove(toggles, #toggles)

    local configs = settingsTab:Group({ Name = "Configs", Description = "Configs save every setting of the script (not these menu settings)." })
    local cfgName = configs:Input({ Name = "Name", Placeholder = "my config" })
    local cfgList = configs:Dropdown({ Name = "Saved configs", Options = Window:ListConfigs() })
    local autoFile = folder .. "/autoload.txt"
    configs:Button({
        Name = "Save",
        Callback = function()
            local name = cfgName:Get() ~= "" and cfgName:Get() or cfgList:Get()
            if Window:SaveConfig(name) then
                cfgList:SetOptions(Window:ListConfigs(), true)
                cfgList:Set(name, true)
                Window:Notify({ Title = "Config saved", Text = tostring(name) })
            else
                Window:Notify({ Title = "Type a name first" })
            end
        end,
    })
    configs:Button({
        Name = "Load",
        Callback = function()
            local name = cfgList:Get()
            if name and Window:LoadConfig(name) then
                Window:Notify({ Title = "Config loaded", Text = name })
            else
                Window:Notify({ Title = "Pick a saved config first" })
            end
        end,
    })
    configs:Button({
        Name = "Delete", Danger = true,
        Callback = function()
            local name = cfgList:Get()
            if not name then return end
            Window:Dialog({
                Title = "Delete " .. name .. "?",
                Buttons = { { Text = "Cancel" }, { Text = "Delete", Danger = true, Callback = function()
                    FS.delete(configDir .. "/" .. name .. ".json")
                    cfgList:SetOptions(Window:ListConfigs())
                end } },
            })
        end,
    })
    local autoName = FS.read(autoFile)
    configs:Toggle({
        Name = "Load on start", Description = "Loads the selected config the next time the script runs.",
        Default = autoName ~= nil and autoName ~= "",
        Callback = function(v)
            local name = cfgList:Get()
            if v and name then
                FS.write(autoFile, name)
            elseif not v then
                FS.write(autoFile, "")
            end
        end,
    })
    table.remove(toggles, #toggles)

    local script = settingsTab:Group("Script")
    script:Button({
        Name = "Unload", Danger = true, Description = "Turns every feature off and removes the menu.",
        Callback = function()
            Window:Dialog({
                Title = "Unload " .. title .. "?",
                Text = "Every feature is turned off and the menu is removed.",
                Buttons = { { Text = "Cancel" }, { Text = "Unload", Danger = true, Callback = function() Window:Unload() end } },
            })
        end,
    })

    -- waits until the script stops adding stuff, then loads the config. hacky but fine
    if autoName and autoName ~= "" then
        task.spawn(function()
            while alive and os.clock() - lastBuild < 0.6 do task.wait(0.2) end
            if alive and Window:LoadConfig(autoName) then
                cfgList:Set(autoName, true)
                Window:Notify({ Title = "Config loaded", Text = autoName })
            end
        end)
    end

    task.spawn(function()
        if opts.Splash ~= false then
            local splash = make("Frame", {
                Parent = gui, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromOffset(320, 178), BackgroundTransparency = 1, ZIndex = 70,
            }, { corner(16) })
            T(splash, { BackgroundColor3 = "Window" })
            local sScale = make("UIScale", { Parent = splash, Scale = 0.9 })
            local sStroke = T(make("UIStroke", { Parent = splash, Transparency = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }), { Color = "Stroke" })
            local plume, vane, shaft = mark(splash, 44, {
                AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 30), ZIndex = 71, Rotation = -25,
            })
            local plumeScale = make("UIScale", { Parent = plume, Scale = 0.6 })
            vane.ImageTransparency, shaft.ImageTransparency = 1, 1
            local word = make("TextLabel", {
                Parent = splash, Position = UDim2.fromOffset(0, 80), Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1,
                Text = title, FontFace = FONTS.Bold, TextSize = 30, TextTransparency = 1, ZIndex = 71,
            })
            T(word, { TextColor3 = "Text" })
            local sub = make("TextLabel", {
                Parent = splash, Position = UDim2.fromOffset(0, 118), Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1,
                Text = subtitle or "Loading", FontFace = FONTS.Regular, TextSize = 13, TextTransparency = 1, ZIndex = 71,
            })
            T(sub, { TextColor3 = "SubText" })
            local barBack = make("Frame", {
                Parent = splash, AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 148), Size = UDim2.fromOffset(180, 4),
                BorderSizePixel = 0, BackgroundTransparency = 1, ZIndex = 71,
            }, { corner("full") })
            T(barBack, { BackgroundColor3 = "Track" })
            local barFill = make("Frame", { Parent = barBack, Size = UDim2.fromScale(0, 1), BorderSizePixel = 0, ZIndex = 72 }, { corner("full") })
            T(barFill, { BackgroundColor3 = "Accent" })

            tw(sScale, 0.5, { Scale = 1 }, Enum.EasingStyle.Back)
            tw(splash, 0.3, { BackgroundTransparency = 0 })
            tw(sStroke, 0.3, { Transparency = 0.35 })
            tw(barBack, 0.3, { BackgroundTransparency = 0 })
            tw(vane, 0.4, { ImageTransparency = 0 })
            tw(shaft, 0.4, { ImageTransparency = 0 })
            tw(plumeScale, 0.7, { Scale = 1 }, Enum.EasingStyle.Back)
            tw(plume, 0.9, { Rotation = 0 }, Enum.EasingStyle.Elastic)
            word.Position = UDim2.fromOffset(0, 90)
            tw(word, 0.5, { TextTransparency = 0, Position = UDim2.fromOffset(0, 80) }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0.15)
            tw(sub, 0.5, { TextTransparency = 0 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0.25)
            tw(barFill, 1.1, { Size = UDim2.fromScale(1, 1) }, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0.2)
            task.wait(1.45)
            tw(sScale, 0.25, { Scale = 0.92 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            for _, x in ipairs({ splash, barBack, barFill }) do tw(x, 0.25, { BackgroundTransparency = 1 }) end
            tw(sStroke, 0.25, { Transparency = 1 })
            tw(word, 0.2, { TextTransparency = 1 })
            tw(sub, 0.2, { TextTransparency = 1 })
            tw(vane, 0.2, { ImageTransparency = 1 })
            tw(shaft, 0.2, { ImageTransparency = 1 })
            task.wait(0.22)
            splash:Destroy()
        end
        if alive then
            if not current then selectTab(settingsTab) end
            Window:Toggle(true)
        end
    end)

    table.insert(registry, Window)
    return Window
end

return FeatherLite
