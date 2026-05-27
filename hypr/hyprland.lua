-- ============================================================
--  hyprland.lua  –  converted from hyprlang config
--  Wiki: https://wiki.hypr.land/Configuring/Start/
-- ============================================================
--
-- NOTE: A few dispatches (cyclenext, changegroupactive,
-- togglegroup, moveoutofgroup, lockactivegroup, centerwindow,
-- global) may need their exact Lua API names verified against
-- https://wiki.hypr.land/Configuring/Basics/Dispatchers/
-- If something doesn't work, replace with:
--   hl.dsp.exec_cmd("hyprctl dispatch <name> <args>")
-- ============================================================


-- ========================
-- COLOR SCHEME (default)
-- ========================
-- Resolved from your default.conf / scheme
-- Alpha-appended colours:
--   $primarye6           = rgba(c2c1ffe6)
--   $onSurfaceVariant11  = rgba(c8c5d111)
--   $surfaced4           = rgba(131317d4)
--   rgb($surfaceContainer) = rgb(201f23)

local activeWindowBorderColour   = "rgba(c2c1ffe6)"
local inactiveWindowBorderColour = "rgba(c8c5d111)"
local shadowColour               = "rgba(131317d4)"
local bgColour                   = "rgb(201f23)"

-- Group bar colours (from group.conf + default.conf)
--   $onPrimary    = 2a2a60
--   $primaryd4    = rgba(c2c1ffd4)
--   $outlined4    = rgba(918f9ad4)   ($outline = 918f9a)
--   $secondaryd4  = rgba(c6c4e0d4)
local groupBarTextColour         = "rgb(2a2a60)"
local groupBarActiveColour       = "rgba(c2c1ffd4)"
local groupBarInactiveColour     = "rgba(918f9ad4)"
local groupBarLockedActiveColour = "rgba(c2c1ffd4)"
local groupBarLockedInactiveColour = "rgba(c6c4e0d4)"


-- ========================
-- USER VARIABLES
-- ========================
local terminal     = "kitty"
local browser      = "google-chrome-stable"
local editor       = "codium"
local fileExplorer = "thunar"
local volumeStep   = 2
local cursorTheme  = "Bibata-Modern-Ice"
local cursorSize   = 20

-- Touchpad
local touchpadDisableTyping = true
local touchpadScrollFactor  = 0.3

-- Blur
local blurEnabled      = true
local blurSpecialWs    = false
local blurPopups       = true
local blurInputMethods = true
local blurSize         = 8
local blurPasses       = 2
local blurXray         = false

-- Shadow
local shadowEnabled     = true
local shadowRange       = 20
local shadowRenderPower = 3

-- Gaps
local workspaceGaps       = 20
local windowGapsIn        = 5
local windowGapsOut       = 10
local singleWindowGapsOut = 10

-- Window styling
local windowOpacity    = 0.95
local windowRounding   = 15
local windowBorderSize = 0

-- Script path
local wsaction = "~/.config/hypr/scripts/wsaction.fish"


-- ========================
-- MONITOR
-- ========================
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1.5,
})


-- ========================
-- ENVIRONMENT VARIABLES
-- ========================

-- Themes
hl.env("QT_QPA_PLATFORMTHEME",            "qtengine")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR",     "1")
hl.env("XCURSOR_THEME",                   cursorTheme)
hl.env("XCURSOR_SIZE",                    tostring(cursorSize))

-- Toolkit backends
hl.env("GDK_BACKEND",                    "wayland,x11")
hl.env("QT_QPA_PLATFORM",               "wayland;xcb")
hl.env("SDL_VIDEODRIVER",               "wayland,x11,windows")
hl.env("CLUTTER_BACKEND",               "wayland")
hl.env("ELECTRON_OZONE_PLATFORM_HINT",  "auto")

-- XDG
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE",    "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- Other
hl.env("_JAVA_AWT_WM_NONREPARENTING", "1")


-- ========================
-- AUTOSTART  (exec-once)
-- ========================
hl.on("hyprland.start", function()
    -- Keyring and auth
    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")

    -- Clipboard history
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    -- Auto-delete old trash
    hl.exec_cmd("trash-empty 30")

    -- Cursor
    hl.exec_cmd("hyprctl setcursor " .. cursorTheme .. " " .. tostring(cursorSize))
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme '" .. cursorTheme .. "'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-size "  .. tostring(cursorSize))

    -- Location / night light
    hl.exec_cmd("/usr/lib/geoclue-2.0/demos/agent")
    hl.exec_cmd("sleep 1 && gammastep")

    -- Bluetooth media
    hl.exec_cmd("mpris-proxy")

    -- Caelestia shell
    hl.exec_cmd("caelestia resizer -d")
    hl.exec_cmd("caelestia shell -d")

    -- Enter global submap (required for caelestia global keybinds)
    hl.exec_cmd("hyprctl dispatch submap global")

    -- Extras
    hl.exec_cmd("qs -c overview")
    hl.exec_cmd("udiskie")
    hl.exec_cmd("~/.config/com.ml4w.hyprlandsettings/hyprctl.sh")
end)


-- ========================
-- GENERAL CONFIG
-- ========================
hl.config({
    general = {
        layout          = "dwindle",
        allow_tearing   = false,
        gaps_workspaces = workspaceGaps,
        gaps_in         = windowGapsIn,
        gaps_out        = windowGapsOut,
        border_size     = windowBorderSize,
        col = {
            active_border   = activeWindowBorderColour,
            inactive_border = inactiveWindowBorderColour,
        },
    },

    dwindle = {
        preserve_split = true,
        smart_split    = false,
        smart_resizing = true,
    },

    decoration = {
        rounding         = windowRounding,
        active_opacity   = windowOpacity,
        inactive_opacity = windowOpacity,
        blur = {
            enabled           = blurEnabled,
            xray              = blurXray,
            special           = blurSpecialWs,
            ignore_opacity    = true,
            new_optimizations = true,
            popups            = blurPopups,
            input_methods     = blurInputMethods,
            size              = blurSize,
            passes            = blurPasses,
        },
        shadow = {
            enabled      = shadowEnabled,
            range        = shadowRange,
            render_power = shadowRenderPower,
            color        = shadowColour,
        },
    },

    animations = { enabled = true },

    input = {
        kb_layout          = "us",
        numlock_by_default = false,
        repeat_delay       = 250,
        repeat_rate        = 35,
        focus_on_close     = 1,
        touchpad = {
            natural_scroll       = true,
            disable_while_typing = touchpadDisableTyping,
            scroll_factor        = touchpadScrollFactor,
        },
    },

    binds = {
        scroll_event_delay = 0,
    },

    cursor = {
        hotspot_padding     = 1,
        no_hardware_cursors = true,
    },

    misc = {
        vrr                        = 1,
        animate_manual_resizes     = false,
        animate_mouse_windowdragging = false,
        disable_hyprland_logo      = true,
        force_default_wallpaper    = 0,
        on_focus_under_fullscreen  = 2,
        allow_session_lock_restore = true,
        middle_click_paste         = false,
        focus_on_activate          = true,
        session_lock_xray          = true,
        mouse_move_enables_dpms    = true,
        key_press_enables_dpms     = true,
        background_color           = bgColour,
    },

    debug = {
        error_position = 1,
    },

    xwayland = {
        force_zero_scaling = true,
    },

    render = {
        direct_scanout = false,
    },

    group = {
        col = {
            border_active          = activeWindowBorderColour,
            border_inactive        = inactiveWindowBorderColour,
            border_locked_active   = activeWindowBorderColour,
            border_locked_inactive = inactiveWindowBorderColour,
        },
        groupbar = {
            font_family              = "JetBrains Mono NF",
            font_size                = 15,
            gradients                = true,
            gradient_round_only_edges = false,
            gradient_rounding        = 5,
            height                   = 25,
            indicator_height         = 0,
            gaps_in                  = 3,
            gaps_out                 = 3,
            text_color               = groupBarTextColour,
            col = {
                active          = groupBarActiveColour,
                inactive        = groupBarInactiveColour,
                locked_active   = groupBarLockedActiveColour,
                locked_inactive = groupBarLockedInactiveColour,
            },
        },
    },

    scrolling = {
        fullscreen_on_one_column  = true,
        focus_fit_method          = 1,
        column_width              = 0.5,
        follow_focus              = true,
        follow_min_visible        = 0.0,
        explicit_column_widths    = { 0.35, 0.5, 0.65, 1.0 },
    },
})


-- ========================
-- ANIMATIONS
-- ========================
hl.curve("specialWorkSwitch", { type = "bezier", points = { {0.05, 0.7}, {0.1,  1   } } })
hl.curve("emphasizedAccel",   { type = "bezier", points = { {0.3,  0  }, {0.8,  0.15} } })
hl.curve("emphasizedDecel",   { type = "bezier", points = { {0.05, 0.7}, {0.1,  1   } } })
hl.curve("standard",          { type = "bezier", points = { {0.2,  0  }, {0,    1   } } })

hl.animation({ leaf = "layersIn",         enabled = true, speed = 5, bezier = "emphasizedDecel",   style = "slide" })
hl.animation({ leaf = "layersOut",        enabled = true, speed = 4, bezier = "emphasizedAccel",   style = "slide" })
hl.animation({ leaf = "fadeLayers",       enabled = true, speed = 5, bezier = "standard" })
hl.animation({ leaf = "windowsIn",        enabled = true, speed = 5, bezier = "emphasizedDecel" })
hl.animation({ leaf = "windowsOut",       enabled = true, speed = 3, bezier = "emphasizedAccel" })
hl.animation({ leaf = "windowsMove",      enabled = true, speed = 6, bezier = "standard" })
hl.animation({ leaf = "workspaces",       enabled = true, speed = 5, bezier = "standard" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 4, bezier = "specialWorkSwitch", style = "slidefadevert 15%" })
hl.animation({ leaf = "fade",             enabled = true, speed = 6, bezier = "standard" })
hl.animation({ leaf = "fadeDim",          enabled = true, speed = 6, bezier = "standard" })
hl.animation({ leaf = "border",           enabled = true, speed = 6, bezier = "standard" })


-- ========================
-- GESTURES
-- ========================
hl.config({
    gestures = {
        workspace_swipe_distance               = 700,
        workspace_swipe_cancel_ratio           = 0.15,
        workspace_swipe_min_speed_to_force     = 5,
        workspace_swipe_direction_lock         = true,
        workspace_swipe_direction_lock_threshold = 10,
        workspace_swipe_create_new             = true,
    },
})

-- Gesture actions
-- $workspaceSwipeFingers = 3, $gestureFingers = 3, $gestureFingersMore = 4
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "up",         action = "special", name = "special" })
hl.gesture({ fingers = 3, direction = "down",       action = "dispatcher", dispatcher = "exec", args = "caelestia toggle specialws" })
hl.gesture({ fingers = 4, direction = "down",       action = "dispatcher", dispatcher = "exec", args = "systemctl suspend" })


-- ========================
-- KEYBINDINGS
-- ========================
-- All binds were in `submap = global` in the original config.
-- The submap is entered at startup in the autostart section above.

-- ---- Launcher (caelestia global dispatches) ----
hl.bind("Super + Super_L", hl.dsp.global("caelestia:launcher"), { ignore = true })

local liOpts = { ignore = true, no_passthrough = true }
hl.bind("Super + catchall",   hl.dsp.global("caelestia:launcherInterrupt"), liOpts)
hl.bind("Super + mouse:272",  hl.dsp.global("caelestia:launcherInterrupt"), liOpts)
hl.bind("Super + mouse:273",  hl.dsp.global("caelestia:launcherInterrupt"), liOpts)
hl.bind("Super + mouse:274",  hl.dsp.global("caelestia:launcherInterrupt"), liOpts)
hl.bind("Super + mouse:275",  hl.dsp.global("caelestia:launcherInterrupt"), liOpts)
hl.bind("Super + mouse:276",  hl.dsp.global("caelestia:launcherInterrupt"), liOpts)
hl.bind("Super + mouse:277",  hl.dsp.global("caelestia:launcherInterrupt"), liOpts)
hl.bind("Super + mouse_up",   hl.dsp.global("caelestia:launcherInterrupt"), liOpts)
hl.bind("Super + mouse_down", hl.dsp.global("caelestia:launcherInterrupt"), liOpts)

-- ---- Misc shell binds ----
hl.bind("Ctrl+Alt + Delete", hl.dsp.global("caelestia:session"))
hl.bind("Ctrl+Alt + C",      hl.dsp.global("caelestia:clearNotifs"),  { locked = true })
hl.bind("Super + K",         hl.dsp.global("caelestia:showall"))
hl.bind("Super + L",         hl.dsp.global("caelestia:lock"))

-- Restore lock
hl.bind("Super+Alt + L", hl.dsp.exec_cmd("caelestia shell -d"), { locked = true })
hl.bind("Super+Alt + L", hl.dsp.global("caelestia:lock"),        { locked = true })

-- ---- Brightness ----
hl.bind("XF86MonBrightnessUp",   hl.dsp.global("caelestia:brightnessUp"),   { locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.global("caelestia:brightnessDown"), { locked = true })

-- ---- Media ----
hl.bind("Ctrl+Super + Space",  hl.dsp.global("caelestia:mediaToggle"), { locked = true })
hl.bind("XF86AudioPlay",       hl.dsp.global("caelestia:mediaToggle"), { locked = true })
hl.bind("XF86AudioPause",      hl.dsp.global("caelestia:mediaToggle"), { locked = true })
hl.bind("Ctrl+Super + Equal",  hl.dsp.global("caelestia:mediaNext"),   { locked = true })
hl.bind("XF86AudioNext",       hl.dsp.global("caelestia:mediaNext"),   { locked = true })
hl.bind("Ctrl+Super + Minus",  hl.dsp.global("caelestia:mediaPrev"),   { locked = true })
hl.bind("XF86AudioPrev",       hl.dsp.global("caelestia:mediaPrev"),   { locked = true })
hl.bind("XF86AudioStop",       hl.dsp.global("caelestia:mediaStop"),   { locked = true })

-- ---- Kill/restart shell ----
hl.bind("Ctrl+Super+Shift + R", hl.dsp.exec_cmd("qs -c caelestia kill"),                        { on_release = true })
hl.bind("Ctrl+Super+Alt + R",   hl.dsp.exec_cmd("qs -c caelestia kill; sleep .1; caelestia shell -d"), { on_release = true })

-- ---- Workspaces 1-10 ----
for i = 1, 10 do
    local key = tostring(i % 10)  -- 10 → key "0"
    hl.bind("Super + "              .. key, hl.dsp.exec_cmd(wsaction .. " workspace "         .. i))
    hl.bind("Ctrl+Super + "         .. key, hl.dsp.exec_cmd(wsaction .. " -g workspace "      .. i))
    hl.bind("Super+Alt + "          .. key, hl.dsp.exec_cmd(wsaction .. " movetoworkspace "   .. i))
    hl.bind("Ctrl+Super+Alt + "     .. key, hl.dsp.exec_cmd(wsaction .. " -g movetoworkspace " .. i))
end

-- ---- Workspace navigation ----
hl.bind("Super + mouse_down",       hl.dsp.focus({ workspace = "e-1" }))
hl.bind("Super + mouse_up",         hl.dsp.focus({ workspace = "e+1" }))
hl.bind("Ctrl+Super + right",       hl.dsp.focus({ workspace = "e+1" }), { repeating = true })
hl.bind("Ctrl+Super + left",        hl.dsp.focus({ workspace = "e-1" }), { repeating = true })
hl.bind("Super + Page_Up",          hl.dsp.focus({ workspace = "e-1" }), { repeating = true })
hl.bind("Super + Page_Down",        hl.dsp.focus({ workspace = "e+1" }), { repeating = true })
hl.bind("Ctrl+Super + mouse_down",  hl.dsp.focus({ workspace = "e-10" }))
hl.bind("Ctrl+Super + mouse_up",    hl.dsp.focus({ workspace = "e+10" }))

-- Toggle special workspace
hl.bind("Super + M", hl.dsp.exec_cmd("caelestia toggle specialws"))

-- ---- Move window to workspace ----
hl.bind("Super+Alt + Page_Up",       hl.dsp.window.move({ workspace = "e-1" }), { repeating = true })
hl.bind("Super+Alt + Page_Down",     hl.dsp.window.move({ workspace = "e+1" }), { repeating = true })
hl.bind("Super+Alt + mouse_down",    hl.dsp.window.move({ workspace = "e-1" }))
hl.bind("Super+Alt + mouse_up",      hl.dsp.window.move({ workspace = "e+1" }))
hl.bind("Ctrl+Super+Shift + right",  hl.dsp.window.move({ workspace = "e+1" }), { repeating = true })
hl.bind("Ctrl+Super+Shift + left",   hl.dsp.window.move({ workspace = "e-1" }), { repeating = true })
hl.bind("Ctrl+Super+Shift + up",     hl.dsp.window.move({ workspace = "special:special" }))
hl.bind("Ctrl+Super+Shift + down",   hl.dsp.window.move({ workspace = "e+0" }))
hl.bind("Super+Alt + S",             hl.dsp.window.move({ workspace = "special:special" }))

-- ---- Window groups ----
hl.bind("Alt + Tab",            hl.dsp.cyclenext(),                    { repeating = true })
hl.bind("Shift+Alt + Tab",      hl.dsp.cyclenext({ prev = true }),     { repeating = true })
hl.bind("Ctrl+Alt + Tab",       hl.dsp.changegroupactive("f"),         { repeating = true })
hl.bind("Ctrl+Shift+Alt + Tab", hl.dsp.changegroupactive("b"),         { repeating = true })
hl.bind("Super + Comma",        hl.dsp.togglegroup())
hl.bind("Super + U",            hl.dsp.moveoutofgroup())
hl.bind("Super+Shift + Comma",  hl.dsp.lockactivegroup("toggle"))

-- ---- Window focus ----
hl.bind("Super + left",  hl.dsp.focus({ direction = "left" }))
hl.bind("Super + right", hl.dsp.focus({ direction = "right" }))
hl.bind("Super + up",    hl.dsp.focus({ direction = "up" }))
hl.bind("Super + down",  hl.dsp.focus({ direction = "down" }))

-- ---- Window move ----
hl.bind("Super+Shift + left",  hl.dsp.window.move({ direction = "left" }))
hl.bind("Super+Shift + right", hl.dsp.window.move({ direction = "right" }))
hl.bind("Super+Shift + up",    hl.dsp.window.move({ direction = "up" }))
hl.bind("Super+Shift + down",  hl.dsp.window.move({ direction = "down" }))

-- ---- Window resize ----
hl.bind("Super + Minus",       hl.dsp.resizeactive("-10% 0"),  { repeating = true })
hl.bind("Super + Equal",       hl.dsp.resizeactive("10% 0"),   { repeating = true })
hl.bind("Super+Shift + Minus", hl.dsp.resizeactive("0 -10%"),  { repeating = true })
hl.bind("Super+Shift + Equal", hl.dsp.resizeactive("0 10%"),   { repeating = true })
hl.bind("Super+Alt + left",    hl.dsp.resizeactive("-10% 0"),  { repeating = true })
hl.bind("Super+Alt + right",   hl.dsp.resizeactive("10% 0"),   { repeating = true })
hl.bind("Super+Alt + up",      hl.dsp.resizeactive("0 -10%"),  { repeating = true })
hl.bind("Super+Alt + down",    hl.dsp.resizeactive("0 10%"),   { repeating = true })

-- ---- Mouse drag / resize ----
hl.bind("Super + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind("Super + Z",         hl.dsp.window.drag(),   { mouse = true })
hl.bind("Super + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("Super + X",         hl.dsp.window.resize(), { mouse = true })

-- ---- Center / resize exact ----
hl.bind("Ctrl+Super + Backslash",     hl.dsp.centerwindow(1))
hl.bind("Ctrl+Super+Alt + Backslash", hl.dsp.resizeactive("exact 55% 70%"))
hl.bind("Ctrl+Super+Alt + Backslash", hl.dsp.centerwindow(1))

-- ---- Window state ----
hl.bind("Super+Alt + Backslash", hl.dsp.exec_cmd("caelestia resizer pip"))
hl.bind("Super + P",             hl.dsp.window.pin())
hl.bind("Super + F",             hl.dsp.window.fullscreen(0))
hl.bind("Super+Alt + F",         hl.dsp.window.fullscreen(1))
hl.bind("Super+Alt + Space",     hl.dsp.window.float({ action = "toggle" }))
hl.bind("Super + Q",             hl.dsp.window.close())

-- ---- Special workspace toggles ----
hl.bind("Ctrl+Shift + Escape", hl.dsp.exec_cmd("caelestia toggle sysmon"))
hl.bind("Super + S",           hl.dsp.exec_cmd("caelestia toggle music"))
hl.bind("Super + D",           hl.dsp.exec_cmd("caelestia toggle communication"))
hl.bind("Super + R",           hl.dsp.exec_cmd("caelestia toggle todo"))

-- ---- App launchers ----
hl.bind("Super + T",       hl.dsp.exec_cmd("app2unit -- " .. terminal))
hl.bind("Super + W",       hl.dsp.exec_cmd("app2unit -- " .. browser))
hl.bind("Super + C",       hl.dsp.exec_cmd("app2unit -- " .. editor))
hl.bind("Super + E",       hl.dsp.exec_cmd("app2unit -- " .. fileExplorer))
hl.bind("Super+Alt + E",   hl.dsp.exec_cmd("app2unit -- nemo"))
hl.bind("Ctrl+Alt + Escape", hl.dsp.exec_cmd("app2unit -- qps"))
hl.bind("Ctrl+Alt + V",    hl.dsp.exec_cmd("app2unit -- pavucontrol"))

-- ---- Screenshots / recording ----
hl.bind("Print",             hl.dsp.exec_cmd("caelestia screenshot"),                 { locked = true })
hl.bind("Ctrl + Print",      hl.dsp.global("caelestia:screenshotFreeze"))
hl.bind("Ctrl+Alt + Print",  hl.dsp.global("caelestia:screenshot"))
hl.bind("Shift + Print",     hl.dsp.exec_cmd("caelestia screenshot -r"))
hl.bind("Super+Alt + R",     hl.dsp.exec_cmd("caelestia record -s"))
hl.bind("Ctrl+Alt + R",      hl.dsp.exec_cmd("caelestia record"))
hl.bind("Super+Shift+Alt + R", hl.dsp.exec_cmd("caelestia record -r"))
hl.bind("Super+Shift + C",   hl.dsp.exec_cmd("hyprpicker -a"))

-- ---- Volume ----
hl.bind("XF86AudioMicMute",  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86AudioMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),   { locked = true })
hl.bind("Super+Shift + M",   hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),   { locked = true })
hl.bind("XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ " .. volumeStep .. "%+"),
    { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ " .. volumeStep .. "%-"),
    { locked = true, repeating = true })

-- ---- Sleep ----
hl.bind("Super+Shift + L", hl.dsp.exec_cmd("systemctl suspend-then-hibernate"), { locked = true })

-- ---- Clipboard / emoji ----
hl.bind("Super + V",         hl.dsp.exec_cmd("pkill fuzzel || caelestia clipboard"))
hl.bind("Super+Alt + V",     hl.dsp.exec_cmd("pkill fuzzel || caelestia clipboard -d"))
hl.bind("Super + Period",    hl.dsp.exec_cmd("pkill fuzzel || caelestia emoji -p"))
hl.bind("Ctrl+Shift+Alt + V",
    hl.dsp.exec_cmd('sleep 0.5s && ydotool type -d 1 "$(cliphist list | head -1 | cliphist decode)"'),
    { locked = true })

-- ---- Lid switch ----
hl.bind("switch:on:Lid Switch",  hl.dsp.exec_cmd("hyprctl dispatch dpms off"), { locked = true })
hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("hyprctl dispatch dpms on"),  { locked = true })

-- ---- Misc ----
hl.bind("Super + TAB",   hl.dsp.exec_cmd("qs ipc -c overview call overview toggle"))
hl.bind("Super + A",     hl.dsp.exec_cmd("~/.local/bin/update-caelestia"))
hl.bind("Alt + Q",       hl.dsp.exec_cmd("kill -9 $(hyprctl activewindow -j | jq -r '.pid')"))

-- Test notification
hl.bind("Super+Alt + F12",
    hl.dsp.exec_cmd(
        "notify-send -u low -i dialog-information-symbolic 'Test notification'" ..
        " \"Here's a really long message to test truncation and wrapping\\n" ..
        "You can middle click or flick this notification to dismiss it!\"" ..
        " -a 'Shell' -A \"Test1=I got it!\" -A \"Test2=Another action\""
    ), { locked = true })


-- ========================
-- WINDOW RULES
-- ========================

-- General opacity for non-fullscreen windows
hl.window_rule({
    name    = "opacity-non-fullscreen",
    match   = { fullscreen = false },
    opacity = windowOpacity,
})

-- Opaque: apps that use native transparency or should be opaque
hl.window_rule({
    name    = "opaque-native",
    match   = { class = "foot|equibop|org%.quickshell|imv|swappy" },
    opacity = 1.0,
})

-- Center all floating non-xwayland windows
hl.window_rule({
    name   = "center-floating",
    match  = { float = true, xwayland = false },
    center = true,
})

-- Float: simple classes
local floatClasses = {
    "guifetch", "yad", "zenity", "wev",
    "org%.gnome%.FileRoller", "file%-roller",
    "blueman%-manager",
    "com%.github%.GradienceTeam%.Gradience",
    "feh", "imv", "system%-config%-printer", "org%.quickshell",
}
for _, cls in ipairs(floatClasses) do
    hl.window_rule({ name = "float-" .. cls, match = { class = cls }, float = true })
end

-- Float + size + center
hl.window_rule({
    name   = "nmtui",
    match  = { class = "foot", title = "nmtui" },
    float  = true, size = "60% 70%", center = true,
})
hl.window_rule({
    name   = "gnome-settings",
    match  = { class = "org%.gnome%.Settings" },
    float  = true, size = "70% 80%", center = true,
})
hl.window_rule({
    name   = "pavucontrol",
    match  = { class = "org%.pulseaudio%.pavucontrol|yad%-icon%-browser" },
    float  = true, size = "60% 70%", center = true,
})
hl.window_rule({
    name   = "nwg-look",
    match  = { class = "nwg%-look" },
    float  = true, size = "50% 60%", center = true,
})

-- Special workspaces
hl.window_rule({ name = "ws-sysmon",        match = { class = "btop" },                                                                          workspace = "special:sysmon" })
hl.window_rule({ name = "ws-music-class",   match = { class = "feishin|Spotify|Supersonic|Cider|com%.github%.th_ch%.youtube_music|Plexamp" },    workspace = "special:music" })
hl.window_rule({ name = "ws-music-title",   match = { initial_title = "Spotify Premium" },                                                       workspace = "special:music" })
hl.window_rule({ name = "ws-comms",         match = { class = "discord|equibop|vesktop|whatsapp" },                                              workspace = "special:communication" })
hl.window_rule({ name = "ws-todo",          match = { class = "org%.qbittorrent%.qBittorrent" },                                                 workspace = "special:todo" })

-- Dialogs (float by title)
local dialogTitles = {
    { "dialog-file",        "(Select|Open)( a)? (File|Folder)(s)?" },
    { "dialog-file-op",     "File (Operation|Upload)( Progress)?" },
    { "dialog-properties",  ".* Properties" },
    { "dialog-export-png",  "Export Image as PNG" },
    { "dialog-gimp-crash",  "GIMP Crash Debug" },
    { "dialog-save-as",     "Save As" },
    { "dialog-library",     "Library" },
}
for _, d in ipairs(dialogTitles) do
    hl.window_rule({ name = d[1], match = { title = d[2] }, float = true })
end

-- Picture-in-picture
hl.window_rule({ name = "pip-move",   match = { title = "Picture(-| )in(-| )[Pp]icture" }, move = "100%-w-2% 100%-w-3%" })
hl.window_rule({ name = "pip-aspect", match = { title = "Picture(-| )in(-| )[Pp]icture" }, keep_aspect_ratio = true })
hl.window_rule({ name = "pip-float",  match = { title = "Picture(-| )in(-| )[Pp]icture" }, float = true })
hl.window_rule({ name = "pip-pin",    match = { title = "Picture(-| )in(-| )[Pp]icture" }, pin = true })

-- Creative software (opaque)
hl.window_rule({
    name    = "opaque-creative",
    match   = { class = "krita|gimp|inkscape|darktable|resolve|kdenlive|shotcut|blender|godot" },
    opacity = 1.0,
})

-- Ueberzugpp
hl.window_rule({ name = "float-ueberzug",       match = { class = "^(ueberzugpp_.*)$" }, float = true })
hl.window_rule({ name = "no-focus-ueberzug",    match = { class = "^(ueberzugpp_.*)$" }, no_initial_focus = true })

-- Steam
hl.window_rule({ name = "rounding-steam",       match = { class = "steam" },                              rounding = 10 })
hl.window_rule({ name = "float-steam-friends",  match = { class = "steam", title = "Friends List" },      float = true })

-- Games (opaque + tearing + idle-inhibit)
hl.window_rule({ name = "opaque-games",       match = { class = "(steam_app_(default|[0-9]+))|gamescope" }, opacity = 1.0 })
hl.window_rule({ name = "immediate-games",    match = { class = "(steam_app_(default|[0-9]+))|gamescope" }, immediate = true })
hl.window_rule({ name = "idle-inhibit-games", match = { class = "(steam_app_(default|[0-9]+))|gamescope" }, idle_inhibit = "always" })

-- Minecraft launchers
hl.window_rule({ name = "float-atlauncher", match = { class = "com%-atlauncher%-App",  title = "ATLauncher Console" },      float = true })
hl.window_rule({ name = "float-pandora",    match = { class = "PandoraLauncher",        title = "Minecraft Game Output" },  float = true })

-- Autodesk Fusion 360
hl.window_rule({
    name     = "no-blur-fusion",
    match    = { class = "fusion360%.exe", title = "Fusion360|(Marking Menu)" },
    no_blur  = true,
})

-- XWayland popups
hl.window_rule({ name = "xwayland-no-dim",    match = { xwayland = true, title = "win[0-9]+" }, no_dim    = true })
hl.window_rule({ name = "xwayland-no-shadow", match = { xwayland = true, title = "win[0-9]+" }, no_shadow = true })
hl.window_rule({ name = "xwayland-rounding",  match = { xwayland = true, title = "win[0-9]+" }, rounding  = 10 })

-- Specific apps float + size
hl.window_rule({ name = "float-discord",  match = { class = "^discord$" },                      float = true, size = "1600 900" })
hl.window_rule({ name = "float-qbt",      match = { class = "^org%.qbittorrent%.qBittorrent$" }, float = true, size = "1280 720" })
hl.window_rule({ name = "float-songrec",  match = { class = "^re%.fossplant%.songrec$" },        float = true, size = "1280 720" })

-- Suppress maximize for all windows
hl.window_rule({
    name           = "suppress-maximize",
    match          = { class = ".*" },
    suppress_event = "maximize",
})


-- ========================
-- WORKSPACE RULES
-- ========================
hl.workspace_rule({ workspace = "w[tv1]s[false]", gapsout = singleWindowGapsOut })
hl.workspace_rule({ workspace = "f[1]s[false]",   gapsout = singleWindowGapsOut })


-- ========================
-- LAYER RULES
-- ========================
hl.layer_rule({ name = "fade-hyprpicker",  match = { namespace = "hyprpicker" },      animation = "fade" })
hl.layer_rule({ name = "fade-logout",      match = { namespace = "logout_dialog" },   animation = "fade" })
hl.layer_rule({ name = "fade-selection",   match = { namespace = "selection" },       animation = "fade" })
hl.layer_rule({ name = "fade-wayfreeze",   match = { namespace = "wayfreeze" },       animation = "fade" })

-- Fuzzel launcher
hl.layer_rule({ name = "popin-launcher",   match = { namespace = "launcher" },        animation = "popin 80%" })
hl.layer_rule({ name = "blur-launcher",    match = { namespace = "launcher" },        blur = true })

-- Caelestia shell
hl.layer_rule({ name = "no-anim-border",   match = { namespace = "caelestia-(border%-exclusion|area%-picker)" }, no_anim = true })
hl.layer_rule({ name = "fade-drawers",     match = { namespace = "caelestia-(drawers|background)" },             animation = "fade" })
hl.layer_rule({ name = "blur-drawers",     match = { namespace = "caelestia%-drawers" }, blur = true })
hl.layer_rule({ name = "alpha-drawers",    match = { namespace = "caelestia%-drawers" }, ignore_alpha = 0.57 })
