-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
-- Menu
require("menu")
--libs
require("lib")

vicious = require("vicious")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.add_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init(awful.util.getdir("config") .. "/themes/sky/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "terminal"
editor = "vim"
browser = "chromium"
-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.a
tags_name = { 1, "Y", "U", "I", "O娱乐", "P聊天", "7网页", "8编辑", "9终端", "扯淡"}
tags_layout = {
  awful.layout.suit.tile,
  awful.layout.suit.tile,
  awful.layout.suit.tile,
  awful.layout.suit.tile,
  awful.layout.suit.tile,
  awful.layout.suit.tile,
  awful.layout.suit.tile,
  awful.layout.suit.tile,
  awful.layout.suit.tile,
  awful.layout.suit.floating,
}
tags = {}
revtags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag( tags_name, s, tags_layout)
    revtags[s] = {}
    for i, t in ipairs(tags[s]) do
    revtags[s][t] = i
    end
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "编辑配置", "gvim" .. " " .. awesome.conffile },
   { "重新载入", awesome.restart },
   { "注销", awesome.quit }
}
powermenu = { 
    {"关机(&D)","dbus-send --system --print-reply  --dest=org.freedesktop.ConsoleKit /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Stop"},
    {"重启(&R)","dbus-send --system --print-reply  --dest=org.freedesktop.ConsoleKit /org/freedesktop/ConsoleKit/Manager  org.freedesktop.ConsoleKit.Manager.Restart"},
    {"挂起(&S)","systemctl suspend"}
}
mymainmenu = awful.menu({ items = { { "Awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "应用(&M)", xdgmenu },
                                    { "Chromium", browser ,"/usr/share//icons/hicolor/16x16/apps/chromium.png" },
                                    { "Thunderbird", "thunderbird ", "/usr/share//icons/hicolor/16x16/apps/thunderbird.png" },
                                    { "Pidgin", "pidgin","/usr/share//icons/hicolor/16x16/apps/pidgin.png" },
                                    { "&Osd", "osdlyrics","/usr/share//icons/hicolor/64x64/apps/osdlyrics.png" },
                                    { "&CherryTree", "cherrytree ", "///usr/share/icons/hicolor/scalable/apps/cherrytree.png" },
                                    { "&hotot" , "hotot-gtk3","/usr/share//icons/hicolor/22x22/apps/hotot.png" },
                                    { "&WPS" , "/home/maplebeats/Software/wps-office/wps","/usr/share//icons/hicolor/22x22/apps/evince.png" },
                                    { "&dmusic" , "/home/maplebeats/Software/deepin/deepin-music-player-1+git201209111106/dmusic","/home/maplebeats/Software/deepin/deepin-music-player-1+git201209111106/debian/deepin-music-player.png" },
                                    { "&GoldenDict", "goldendict", "///usr/share/pixmaps/goldendict.png" },
                                    { "&Firefox", "firefox ", "/usr/share//icons/hicolor/16x16/apps/firefox.png" },
                                    { "&Thunar", "thunar","/usr/share//icons/hicolor/16x16/apps/Thunar.png" },
                                    { "&VIM", "gvim -f ", "/usr/share/pixmaps/gvim.png" },
                                    { "&XBMC", "xbmc", "/usr/share//icons/hicolor/48x48/apps/xbmc.png" },
                                    { "电源(&P)", powermenu}
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

memwidget = widget({ type = "textbox" })
vicious.register(memwidget, vicious.widgets.mem, '<span color="#90ee90">$1%</span>', 5)
batwidget = widget({ type = "textbox" })
vicious.register(batwidget, vicious.widgets.bat, '<span color="#0000ff">$1$2%</span>', 5, 'BAT0')
cpuwidget = widget({ type = "textbox" })
vicious.register(cpuwidget, vicious.widgets.cpu, '<span color="#ffffff">$1%</span>')
--wifiwidget = widget({ type = "textbox" })
--vicious.register(wifiwidget, vicious.widgets.wifi,"<span color='red'>${ssid}</span>")

cputempwidget = widget({ type = "textbox" })
cputempwidget_clock = timer({ timeout = 10 })
cputempwidget_clock:add_signal("timeout", function()
    local fc = ''
    local bt = ''
    local b = ''
    local b = io.popen("acpi -b")
    local f = io.popen("sensors")
    for line in b:lines() do
        bt = line:match('%d+%%')
        if bt then break end
    end
    b:close()
    for line in f:lines() do
        fc = line:match('^Core 0:%s+[+-](%S+)')
        if fc then break end
    end
    f:close()
    if bt and tonumber(bt:match('%d+')) < 9 then
        naughty.notify({title="警告", text="电池电量不足", preset=naughty.config.presets.critical})
    end
    if fc and tonumber(fc:match('%d+')) > 79 then
        naughty.notify({title="警告", text="CPU 温度已超过 72℃！", preset=naughty.config.presets.critical})
    end
    cputempwidget.text = '<span color="#add8e6">' .. fc .. '</span>'
end)
cputempwidget_clock:start()

-- {{{2 Volume Control by 百合
function volume (mode, widget)
  cardid  = 0
  channel = "Master"
  if mode == "update" then
    local volume = io.popen("pamixer --get-volume"):read("*all")
    --local fd = io.popen("amixer -c " .. cardid .. " -- sget " .. channel)
    --local status = fd:read("*all")
    --fd:close()
    --local volume = string.match(status, "(%d?%d?%d)%%")
    volume = string.format("% 3d", volume)

    local muted = io.popen("pamixer --get-mute"):read("*all")
    --status = string.match(status, "%[(o[^%]]*)%]")
    --if string.find(status, "on", 1, true) then
 	--    volume = '♫' .. volume .. "%"
    --else
 	--    volume = '♫' .. volume .. "<span color='red'>M</span>"
    --end
    if muted == "false" then
      volume = '♫' .. volume .. "%"
    else
      volume = '♫' .. volume .. "<span color='red'>M</span>"
    end
    widget.text = volume
  elseif mode == "up" then
    io.popen("pamixer --increase 5"):read("*all")
    --io.popen("amixer -q -c " .. cardid .. " sset " .. channel .. " 5%+"):read("*all")
    volume("update", widget)
  elseif mode == "down" then
    io.popen("pamixer --decrease 5"):read("*all")
    --io.popen("amixer -q -c " .. cardid .. " sset " .. channel .. " 5%-"):read("*all")
    volume("update", widget)
  else
    io.popen("pamixer --toggle-mute"):read("*all")
    --io.popen("amixer -c " .. cardid .. " sset " .. channel .. " toggle"):read("*all")
    volume("update", widget)
  end
end
volume_clock = timer({ timeout = 10 })
volume_clock:add_signal("timeout", function () volume("update", tb_volume) end)
volume_clock:start()

tb_volume = widget({ type = "textbox", name = "tb_volume", align = "right" })
tb_volume:buttons(awful.util.table.join(
  awful.button({ }, 4, function () volume("up", tb_volume) end),
  awful.button({ }, 5, function () volume("down", tb_volume) end),
  awful.button({ }, 3, function () awful.util.spawn("pavucontrol") end),
  awful.button({ }, 1, function () volume("mute", tb_volume) end)
))
volume("update", tb_volume)

function capslock(widget)
    os.execute("sleep .2")
    local s = io.popen("xset -q")
    local ss = ''
    local sn = ''
    for line in s:lines() do
        ss = line:match('Caps Lock:%s*%l*%s*')
        sn = line:match('Num Lock:%s*%l*%s*')
        if ss and sn then break end
    end
    local sss = string.gsub(ss,"Caps Lock:%s*(%l*)%s*","%1")
    local sns = string.gsub(sn,"Num Lock:%s*(%l*)%s*","%1")
    widget.text = "<span color='red'>" .. sss:upper() .."</span>" .. "<span color='#FFFF00'>" .. sns:upper() .. "</span>"
end
        
caps_lock = widget({ type = "textbox", name = "caps_lock" ,align = "right" })
capslock(caps_lock)

--分割符
split = widget({ type = "textbox"})
split.text = "<span color='green'>^</span>"

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
--                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle)
--                    awful.button({ modkey }, 3, awful.client.toggletag),
--                    awful.button({ }, 4, awful.tag.viewnext),
--                    awful.button({ }, 5, awful.tag.viewprev)
                   )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
--          mylauncher,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        --mylayoutbox[s],
        mytextclock,
        s == 1 and mysystray or nil,
        split,
        batwidget,
        split,
        tb_volume,
        split,
        memwidget,
        split,
        cpuwidget,
        split,
        cputempwidget,
        split,
        caps_lock,
        --wifiwidget,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
   awful.button({ }, 3, function () mymainmenu:toggle() end),
   awful.button({ }, 4, awful.tag.viewnext),
  awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),
    --绑定tag{1..6}
    awful.key({ modkey,    }, "y", function () awful.tag.viewonly(tags[1][2])    end),
    awful.key({ modkey,    }, "u", function () awful.tag.viewonly(tags[1][3])    end),
    awful.key({ modkey,    }, "i", function () awful.tag.viewonly(tags[1][4])    end),
    awful.key({ modkey,    }, "o", function () awful.tag.viewonly(tags[1][5])   end),
    awful.key({ modkey,    }, "p", function () awful.tag.viewonly(tags[1][6])   end),

    -- Standard program
        -- 找一个终端来XX
    awful.key({ modkey,           }, "Return", function () 
            lib.run_or_raise("terminal --role=TempTerm", { role = "TempTerm" })
            end),
        -- 普通终端
    --awful.key({ modkey,           }, "t", function ()
   --       awful.util.spawn(terminal)
  --        end),

    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),

    -- {{3 音量
    awful.key({ }, 'XF86AudioRaiseVolume', function () volume("up", tb_volume) end),
    awful.key({ }, 'XF86AudioLowerVolume', function () volume("down", tb_volume) end),
    awful.key({ }, 'XF86AudioMute', function () volume("mute", tb_volume) end),
    --截图
    awful.key({ }, "Print", function () 
                awful.util.spawn("deepin-scrot")
                --os.execute("sleep 1")
                --client.focus.fullscreen = true
                --os.execute("sleep .5")
                end),
    -- {{{3 sdcv,活该过不了四级
    awful.key({ modkey }, "d", function ()
    local f = io.popen("xsel -p")
    local new_word = f:read("*a")
    f:close()

    if frame ~= nil then
      naughty.destroy(frame)
      frame = nil
      if old_word == new_word then
      return
      end
    end
    old_word = new_word

    local fc = ""
    local f = io.popen("sdcv -n --utf8-output '"..new_word.."'")
    for line in f:lines() do
      fc = fc .. line .. '\n'
    end
    f:close()
    frame = naughty.notify({ text = fc, timeout = 5, width = 320 })
    end),
    --无线键盘多媒体按键
        --切换fx
    awful.key({ }, 'XF86HomePage', function () 
            lib.run_or_raise("firefox", { name="Vimperator" }) 
            end),
    awful.key({ }, 'XF86Mail', function ()
            awful.tag.viewonly(tags[1][4])
            awful.util.spawn("thunderbird") 
            end),
    awful.key({ }, 'XF86Calculator', function () awful.util.spawn("thunar") end),
    awful.key({ }, 'XF86PowerOff', function () awful.util.spawn("xset dpms force off") end),
    awful.key({ }, 'Caps_Lock', function ()  capslock(caps_lock) end),
    awful.key({ }, 'Num_Lock', function ()  capslock(caps_lock) end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "a",    function (c) c.above = not c.above    end),
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,           }, "c",      function (c) c:kill()                         end),
    --awful.key({ "Mod1",           }, "F4",     function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m", function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    --娱乐
    { rule = { class = "Smplayer" },callback = awful.placement.centered,
      properties = { tag = tags[1][5] , switchtotag = true } },
    { rule = { class = "Mplayer"},
      properties = { tag =tags[1][5], floating = false } },
    { rule = { class = "Rhythmbox" },
      properties = { tag = tags[1][5] , floating = true } },
    { rule = { class = "Audacious" },
      properties = { tag = tags[1][5] ,floating = true } },
    { rule = { class = "Vlc" },
      properties = { tag = tags[1][5] , switchtotag = true } },
    --deepin播放器
    { rule ={ instance = "deepin.py" },
      properties = { tag = tags[1][5], floating = true } },
    --聊天
    { rule = { class = "Pidgin" },
      properties = { tag = tags[1][6] } },
    { rule = { name= "Buddy List" },
      properties = { floating = true} },
    { rule = { class = "Hotot" },
      properties = { tag = tags[1][3] ,switchtotag = true } },
    { rule = { class = "Thunderbird" },
      properties = { tag = tags[1][4] } },
    { rule = { class = "Lightread" },
      properties = { tag = tags[1][4] } },
    { rule = { class = "Skype" },
      properties = { tag = tags[1][6] , floating = true } },
    { rule = { class = "Qtqq" },
      properties = { tag = tags[1][6] , floating = true } },
    --终端
    { rule = { class = "Terminal" },
       properties = { tag = tags[1][9] , switchtotag = true } },
    --网页
    { rule = { class = "Chromium" },
      properties = { tag= tags[1][7] , switchtotag = true ,floating = true} },
    { rule = { class = "Firefox"},
      properties = { tag = tags[1][7] , floating=true } },
   --编程
   --{ rule = { class = "Gvim" },
   --properties = { tag = tags[1][8] , switchtotag = true } },
    { rule = { class = "Eric5" },
      properties = { tag = tags[1][8] , switchtotag = true } },
    { rule = { class = "Qt-creator"},
      properties = { tag = tags[1][8] } },
    --扯淡
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    --flash全屏
    { rule ={ instance = "plugin-container" },
      properties = { floating = true } },
    { rule ={ instance = "Flashplayer" },
      properties = { floating = true } },
    { rule ={ class="DeepinScrot.py" },
      properties = { floating = true ,fullscreen = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- Autorun programs
autorun = true
autorunApps = 
{ 
    "fcitx",
    "dropboxd",
    "thunar --daemon",
    "proxy.sh"
}

if autorun then
    for app = 1, #autorunApps do
        awful.util.spawn_with_shell(autorunApps[app])
    end end

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c)
                               c.border_color = beautiful.border_focus
                               c.opacity = 1
                           end)
client.add_signal("unfocus", function(c) 
                                 c.border_color = beautiful.border_normal 
                                 c.opacity = 1
                             end)
-- }}}
