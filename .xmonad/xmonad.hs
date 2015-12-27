--
-- File     : ~/.xmonad/xmonad.hs (for Xmonad >= 0.9)
-- Author   : Thayer Williams
-- Website  : http://cinderwick.ca/
-- Desc     : A simple, mouse-friendly xmonad config geared towards
--            netbooks and other low-resolution devices.
--
--            dzen is used for statusbar rendering, with optional mouse
--            integration provided by xdotool:
--
--             * left-click workspace num to go to that ws
--             * left-click layout to cycle next layout
--             * left-click window title to cycle next window
--             * middle-click window title to kill focused window
--
 
import XMonad
import XMonad.Actions.CycleWindows -- classic alt-tab
import XMonad.Actions.CycleWS      -- cycle thru WS', toggle last WS
import XMonad.Actions.DwmPromote   -- swap master like dwm
import XMonad.Hooks.DynamicLog     -- statusbar 
import XMonad.Hooks.EwmhDesktops   -- fullscreenEventHook fixes chrome fullscreen
import XMonad.Hooks.ManageDocks    -- dock/tray mgmt
import XMonad.Hooks.UrgencyHook    -- window alert bells 
import XMonad.Layout.Named         -- custom layout names
import XMonad.Layout.NoBorders     -- smart borders on solo clients
import XMonad.Util.EZConfig        -- append key/mouse bindings
import XMonad.Util.Run(spawnPipe)  -- spawnPipe and hPutStrLn
import System.IO                   -- hPutStrLn scope
 
import qualified XMonad.StackSet as W   -- manageHook rules
 
main = do
        status <- spawnPipe myDzenStatus    -- xmonad status on the left
        conky  <- spawnPipe myDzenConky     -- conky stats on the right
        spawn "xset -b"
        spawn "xscreensaver -no-splash"
        spawn "xrandr --auto"
        spawn "redshift"
        spawn "xmodmap -e \"keycode 135 = Super_L\""
        xmonad $ withUrgencyHook NoUrgencyHook $ defaultConfig 
            { modMask            = mod4Mask
            , terminal           = "urxvtcd"
            , borderWidth        = 2
            , normalBorderColor  = "#dddddd"
            , focusedBorderColor = "#ff0000"
--          , handleEventHook    = fullscreenEventHook -- Only in darcs xmonad-contrib
            , workspaces = myWorkspaces
            , layoutHook = myLayoutHook
            , manageHook = manageDocks <+> myManageHook
                            <+> manageHook defaultConfig
            , logHook    = myLogHook status
            } `additionalKeys` myKeys


myKeys = [ ((mod4Mask .|. shiftMask,  xK_l ), spawn "xscreensaver-command -lock")
         , ((0, xK_Print                   ), spawn "scrot")
         , ((mod4Mask              , xK_F1 ), spawn "iceweasel")
         , ((mod4Mask              , xK_F2 ), spawn "google-chrome")
         , ((mod4Mask              , xK_F5 ), spawn "xrandr --output LVDS --mode 1280x768 --pos 0x0 --rotate normal --output CRT1 --mode 1440x900 --pos 1280x0 --rotate normal")
         , ((mod4Mask              , xK_F10), spawn "amixer set Master toggle")
         , ((mod4Mask .|. shiftMask, xK_a  ), spawn "amixer set Master 5%-")
         , ((mod4Mask .|. shiftMask, xK_s  ), spawn "amixer set Master 5%+ unmute")
         ] 
 
-- Tags/Workspaces
-- clickable workspaces via dzen/xdotool
myWorkspaces            :: [String]
myWorkspaces            = clickable . (map dzenEscape) $ ["1","2","3","4","5"]
 
  where clickable l     = [ "^ca(1,xdotool key super+" ++ show (n) ++ ")" ++ ws ++ "^ca()" |
                            (i,ws) <- zip [1..] l,
                            let n = i ]
 
-- Layouts
-- the default layout is fullscreen with smartborders applied to all
myLayoutHook = avoidStruts $ smartBorders ( tiled ||| full ||| mtiled )
  where
    tiled   = named "T" $ Tall 1 (5/100) (2/(1+(toRational(sqrt(5)::Double))))
    full    = named "X" $ Full
    mtiled  = named "M" $ Mirror tiled
    -- sets default tile as: Tall nmaster (delta) (golden ratio)
 
-- Window management
--
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Vlc"            --> doFloat
    , className =? "Gimp"           --> doFloat
    , className =? "XCalc"          --> doFloat
    , className =? "Iceweasel"      --> doF (W.shift (myWorkspaces !! 1)) -- send to ws 2
    , className =? "Nautilus"       --> doF (W.shift (myWorkspaces !! 2)) -- send to ws 3
    , className =? "Gimp"           --> doF (W.shift (myWorkspaces !! 3)) -- send to ws 4
    , className =? "stalonetray"    --> doIgnore
    ]
 
-- Statusbar 
--
myLogHook h = dynamicLogWithPP $ myDzenPP { ppOutput = hPutStrLn h }
 
myDzenStatus = "dzen2 -w '320' -ta 'l'" ++ myDzenStyle
myDzenConky  = "conky -c ~/.xmonad/conkyrc | dzen2 -x '320' -w '2500' -ta 'r'" ++ myDzenStyle
myDzenStyle  = " -h '20' -fg '#777777' -bg '#222222' -fn 'arial:bold:size=11'"
 
myDzenPP  = dzenPP
    { ppCurrent = dzenColor "#3399ff" "" . wrap " " " "
    , ppHidden  = dzenColor "#dddddd" "" . wrap " " " "
    , ppHiddenNoWindows = dzenColor "#777777" "" . wrap " " " "
    , ppUrgent  = dzenColor "#ff0000" "" . wrap " " " "
    , ppSep     = "     "
    , ppLayout  = dzenColor "#aaaaaa" "" . wrap "^ca(1,xdotool key super+space)· " " ·^ca()"
    , ppTitle   = dzenColor "#ffffff" "" 
                    . wrap "^ca(1,xdotool key super+k)^ca(2,xdotool key super+shift+c)"
                           "                          ^ca()^ca()" . shorten 20 . dzenEscape
    }
 
