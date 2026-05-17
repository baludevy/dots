------------------
---- MONITORS ----
------------------

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1.25,
})

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
    hl.exec_cmd(os.getenv("HOME") .. "/.local/scripts/launch-waybar.sh")
    hl.exec_cmd("mako")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
end)

---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout = "hu",
        touchpad = {
            natural_scroll     = true,
            scroll_factor      = 0.5,
            tap_to_click       = true,
            clickfinger_behavior = true,
        },
    },
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "up",         action = "special" })

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod  = "SUPER"
local terminal = "kitty"
local menu     = "pgrep -x wofi && pkill wofi || wofi --show drun"

hl.bind(mainMod .. " + RETURN",       hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SPACE",        hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + W",            hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + W",    hl.dsp.exec_cmd("pkill -USR2 waybar"))
hl.bind(mainMod .. " + SHIFT + Q",    hl.dsp.exit())
hl.bind(mainMod .. " + F",            hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + S",            hl.dsp.window.float({ action = "toggle", resizeactive = true, exact = {1280, 720} }))
hl.bind(mainMod .. " + l",            hl.dsp.exec_cmd("hyprlock"))

-- Volumes
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("/home/balu/dots/config/eww/scripts/osd.sh volume up"),    { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("/home/balu/dots/config/eww/scripts/osd.sh volume down"),  { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("/home/balu/dots/config/eww/scripts/osd.sh volume mute"),  { locked = true })

-- Brightness
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("/home/balu/dots/config/eww/scripts/osd.sh brightness up"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("/home/balu/dots/config/eww/scripts/osd.sh brightness down"), { locked = true, repeating = true })

-- Power Profile
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("/home/balu/dots/config/eww/scripts/osd.sh power"), { locked = true })

-- Screenshot
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + U",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + U", hl.dsp.window.move({ workspace = "special:magic" }))

-- Focus movement (vim-style)
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Window movement (vim-style)
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))

-- Workspace switching and moving windows
for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i,              hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. i,      hl.dsp.window.move({ workspace = i }))
end

-- Mouse binds
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Lid switch
hl.bind("switch:on:Lid Switch",  hl.dsp.exec_cmd("hyprlock && systemctl suspend"), { locked = true })
hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd('hyprctl keyword monitor "eDP-1, preferred, auto, 1.25"'), { locked = true })

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.window_rule({ name = "float-xdg-portal",      match = { class = "^(xdg-desktop-portal-gtk)$" }, float = true, size = { 1000, 600 }, })
hl.window_rule({ name = "float-file-roller",      match = { class = "^(org.gnome.FileRoller)$" },   float = true, size = { 1000, 600 }, })
hl.window_rule({ name = "float-pavucontrol",      match = { class = "^(pavucontrol)$" },             float = true, size = { 1000, 600 }, })
hl.window_rule({ name = "float-open-file",        match = { title = "^(Open File)$" },               float = true, size = { 1000, 600 }, })
hl.window_rule({ name = "float-save-as",          match = { title = "^(Save As)$" },                 float = true, size = { 1000, 600 },  })
hl.window_rule({ name = "float-file-op-progress", match = { title = "^(File Operation Progress)$" }, float = true, size = { 1000, 600 }, })
hl.window_rule({ name = "float-wifi-password-prompt", match = { title = "^(Wi-Fi Password Prompt)$" }, float = true, size = { 1000, 600 }, })
hl.window_rule({ name= "float-size-kitty", match = { class = "kitty" }, size = { 1280, 720 }, })

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in    = 4,
        gaps_out   = 6,
        border_size = 0,
    },
    decoration = {
        rounding = 10,
        blur = {
            enabled            = true,
            size               = 16,
            passes             = 3,
            new_optimizations  = true,
            popups_ignorealpha = 0.1,
	    xray	       = false,
        },
    },
    animations = {
        enabled = true,
    },
    misc = {
        disable_hyprland_logo = true,
    },
    xwayland = {
        force_zero_scaling = true,
    },
    debug = {
        vfr = true,
    },
})

-- Curves
hl.curve("pace",      { type = "bezier", points = { {0.46, 1},    {0.29, 0.99} } })
hl.curve("overshot",  { type = "bezier", points = { {0.13, 0.99}, {0.29, 1.1}  } })
hl.curve("md3_decel", { type = "bezier", points = { {0.05, 0.7},  {0.1, 1}     } })

-- Animations
hl.animation({ leaf = "windowsIn",        enabled = true, speed = 6,  bezier = "md3_decel", style = "slide" })
hl.animation({ leaf = "windowsOut",       enabled = true, speed = 10,  bezier = "md3_decel", style = "slide" })
hl.animation({ leaf = "windowsMove",      enabled = true, speed = 6,  bezier = "md3_decel", style = "slide" })
hl.animation({ leaf = "fade",             enabled = true, speed = 1,  bezier = "md3_decel" })
hl.animation({ leaf = "workspaces",       enabled = true, speed = 5,  bezier = "md3_decel", style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 8,  bezier = "md3_decel", style = "slide" })
hl.animation({ leaf = "border",           enabled = true, speed = 10, bezier = "md3_decel" })

---------------------
---- LAYER RULES ----
---------------------

hl.layer_rule({ name = "blur-waybar", match = { namespace = "waybar" }, blur = true })

hl.layer_rule({ name = "blur-kitty", match = { namespace = "kitty" }, blur = true })

hl.layer_rule({ name = "blur-mako",   match = { class = "mako" },       blur = true })
hl.layer_rule({ name = "mako-alpha",  match = { class = "mako" },       ignore_alpha = 0.1 })

hl.layer_rule({ name = "blur-wofi",  match = { class = "wofi" },       ignore_alpha = 0.1 })
hl.layer_rule({ name = "anim-wofi",  match = { class = "wofi" },       animation = "popin 80%" })
