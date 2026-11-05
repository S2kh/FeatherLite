# FeatherLite

A mac style UI library for Roblox scripts. Sidebar with tabs on the left, settings-style cards on the right, a few themes, configs, and a mobile layout.

It started as [Eazvy's Apple UI library](https://github.com/Eazvy/UILibs/tree/main/Librarys/Apple). Most of it got rewritten since, but that's where it comes from, so credit to Eazvy.

```lua
local FeatherLite = loadstring(game:HttpGet("https://raw.githubusercontent.com/S2kh/FeatherLite/main/FeatherLite.lua"))()
```

There's an example that works in any game:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/S2kh/FeatherLite/main/Example.lua"))()
```

## Making a window

```lua
local Window = FeatherLite:Window({
    Title = "My Script",
    Subtitle = "v1.0",               -- optional
    Key = Enum.KeyCode.RightShift,   -- opens and closes the menu, players can change it in Settings
    Folder = "MyScript",             -- where configs get saved, defaults to FeatherLite/<Title>
    Size = Vector2.new(860, 580),
    Splash = true,                   -- set false to skip the loading screen
    Theme = "Dark",                  -- Dark, Light, Midnight or OLED Black
    Mobile = nil,                    -- leave nil to detect it, or force true/false
})
```

The red button in the top right closes the menu and the menu key opens it again. You can drag the window by the top and resize it from the bottom right corner. Unload is in Settings.

Window functions:

- `Window:Tab({Name, Group, Icon, Color})` adds a tab. `Group` puts it under a heading in the sidebar.
- `Window:Notify({Title, Text, Duration})` shows a notification in the top right.
- `Window:Dialog({Title, Text, Buttons = {{Text, Callback, Primary, Danger}}})` opens a popup inside the window.
- `Window:Toggle(state)` shows or hides it, `Window:IsVisible()` tells you which.
- `Window:SetTheme(name)` and `Window:GetTheme()`.
- `Window:SaveConfig(name)`, `Window:LoadConfig(name)`, `Window:ListConfigs()`.
- `Window:OnUnload(fn)` runs your cleanup when someone unloads the script.
- `Window:Unload()` turns every toggle off and removes the menu.
- `Window.Flags[flag]` gets you any element that has a `Flag`.

## Tabs and groups

```lua
local Tab = Window:Tab({ Name = "Combat", Group = "Main" })
local Aim = Tab:Group("Aim")
-- or Tab:Group({ Name = "Aim", Description = "small text under the group" })
```

Elements go inside a group. If you call them on the tab directly (`Tab:Toggle{...}`) they go in a group with no heading.

## Icons

Tabs called Combat, Player, Visuals, World, Teleport or Misc pick their icon automatically. You can also set one yourself:

```lua
Window:Tab({ Name = "Aimbot", Icon = "Combat" })   -- one of the built in icons
Window:Tab({ Name = "Farm", Icon = 1234567890 })   -- or any image id
```

The built in ones are Combat, Player, Visuals, World, Teleport, Misc, Settings, Config and Search. The pngs are in [`icons/`](icons). Tabs without an icon just show their first letter.

## Elements

They all take a table. Give something a `Flag` and it gets saved in configs. `Description` puts a smaller line of text under the name.

| Element | Options | What you get back |
|---|---|---|
| `Toggle` | `Name, Description, Default, Flag, Keybind, Callback(on)` | `:Set(v, silent)`, `:Get()`, `:Toggle()`, `:SetBind(key)` |
| `Slider` | `Name, Min, Max, Default, Step, Suffix, Flag, Callback(v)` | `:Set(v, silent)`, `:Get()` |
| `Dropdown` | `Name, Options, Default, Multi, Flag, Callback(v)` | `:Set(v)`, `:Get()`, `:SetOptions(list)`, `:Open()`, `:Close()` |
| `ColorPicker` | `Name, Default, Flag, Callback(color)` | `:Set(color)`, `:Get()` |
| `Input` | `Name, Placeholder, Default, Numeric, Flag, Callback(text, enter)` | `:Set(text)`, `:Get()` |
| `Keybind` | `Name, Default, Hold, Flag, Callback(), Changed(key)` | `:Set(key)`, `:Get()` |
| `Button` | `Name, Description, Danger, Callback()` | `:SetText(t)` |
| `Label` | text | `:Set(t)` |
| `Paragraph` | `Title, Text` | `:Set(t)`, `:SetTitle(t)` |

Putting `Keybind = Enum.KeyCode.X` on a toggle adds a little key button next to the switch. Click it and press a key to change it, esc or backspace clears it. Multi dropdowns give you a list of whatever's picked.

## Settings

Every window gets a Settings page at the bottom of the sidebar with the theme, window transparency, menu size, menu key, notifications, configs (save, load, delete, load on start) and an unload button. Those settings get remembered per script.

## Mobile

On phones and tablets (or with `Mobile = true`) the sidebar turns into a column of icons, keybinds turn into Run buttons, and the window opens at 85% of the screen. You can still move and resize it. When it's closed there's a round Feather button you can tap to open it again, and you can drag that button wherever you want.

## Search

The search box in the sidebar filters tabs and options by name while you type.
