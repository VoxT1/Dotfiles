--  _   ___     __
-- | \ | \ \   / /  Noctivox
-- |  \| |\ \ / /   https://www.github.com/VoxT1
-- | |\  | \ V /    https://www.twitter.com/VoxNoctivox
-- |_| \_|  \_/     nv#9827
--
-- My XMonad configuration, derived from Derek Taylor (DistroTube).
--
-- Base
import XMonad
import System.Directory
import System.IO (hPutStrLn)
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W

-- Actions
import XMonad.Actions.CopyWindow (kill1)
import XMonad.Actions.CycleWS (Direction1D(..), moveTo, shiftTo, WSType(..), nextScreen, prevScreen)
import XMonad.Actions.GridSelect
import XMonad.Actions.MouseResize
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Actions.WithAll (sinkAll, killAll)
import qualified XMonad.Actions.Search as S

-- Data
import Data.Char (isSpace, toUpper)
import Data.Maybe (fromJust)
import Data.Monoid
import Data.Maybe (isJust)
import Data.Tree
import qualified Data.Map as M

-- Hooks
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.EwmhDesktops  -- for some fullscreen events, also for xcomposite in obs.
import XMonad.Hooks.ManageDocks (avoidStruts, docksEventHook, manageDocks, ToggleStruts(..))
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat, doCenterFloat)
import XMonad.Hooks.ServerMode
import XMonad.Hooks.SetWMName
import XMonad.Hooks.WorkspaceHistory

-- Layouts
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile
import XMonad.Layout.ThreeColumns

-- Layouts modifiers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.ShowWName
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import XMonad.Layout.WindowNavigation
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))

-- Utilities
import XMonad.Util.Dmenu
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)
import XMonad.Util.SpawnOnce

{- Sets the mod key; mod4Mask is Super -}
myModMask :: KeyMask
myModMask = mod4Mask

{- Sets font -}
myFont :: String
myFont = "xft:Mononoki:regular:size=14:antialias=true:hinting=true"

{- Sets the default terminal -}
myTerminal :: String
myTerminal = "alacritty"

{- Sets the default web browser -}
myBrowser :: String
myBrowser = "brave-bin"

{- Sets default file manager -}
myFileManager :: String
myFileManager = "nemo"

{- Makes Emacs keybinds easier to type -}
myEmacs :: String
myEmacs = "emacsclient -c -a 'emacs' "

myEditor :: String
myEditor = "emacs"                           -- Sets Emacs as editor
--myEditor = myTerminal ++ " -e nvim "         -- Sets Neovim as editor

{- Window border width -}
myBorderWidth :: Dimension
myBorderWidth = 2

{- Normal border color -}
myNormColor :: String
myNormColor   = "#282c34"     -- Dracula
--myNormColor     = "#2D4952"   -- Doom One
--myNormColor     = "#74434A"   -- Red

{- Focused border color -}
myFocusColor :: String
myFocusColor = "#C691E9"      -- Dracula
--myFocusColor = "#7EA6F8"      -- Doom One
--myFocusColor = "#FF5D73"      -- Red

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

myStartupHook :: X ()
myStartupHook = do
    --spawnOnce "xrandr --output DP-0 --mode 3440x1440 --rate 144 &" -- Xrandr (3440x1440 DP)
    --spawnOnce "xrandr --output HDMI-0 --mode 1920x1080 --rate 60 &" -- Xrandr (1080p HDMI
    spawnOnce "xrandr --output DisplayPort-0 --mode 3440x1440 --rate 144 --pos 0x1440 --output DisplayPort-1 --mode 3440x1440 --rate 144 --pos 1700x0&"
    --spawnOnce "xrandr --output DP-0 --mode 3440x1440 --rate 144 --pos 1440x720 --output DP-2 --mode 3440x1440 --rate 144 --rotate right --pos 0x0 &"
    spawnOnce "picom --experimental-backend &"          -- Compositor
    spawnOnce "clipmenud &"                             -- Clipboard manager
    spawnOnce "dunst &"                                 -- Notification daemon
    spawnOnce "/usr/bin/gentoo-pipewire-launcher &"     -- Pipewire
    spawnOnce "/usr/bin/emacs --daemon &"               -- Emacs daemon for the emacsclient
    spawnOnce "nitrogen --restore &"                    -- Sets wallpaper
    spawnOnce "xsetroot -cursor_name left_ptr"          -- Fixes cursor
    --spawnOnce "trayer --edge top --align right --widthtype request --padding 6 --SetDockType true --SetPartialStrut true --expand true --transparent true --alpha 0 --tint 0x282c34 --height 24 &"    --Doom One
    --spawnOnce "trayer --edge top --align right --widthtype request --padding 6 --SetDockType true --SetPartialStrut true --expand true --transparent true --alpha 0 --tint 0xE7E7E7 --height 24 &"    --Light
    spawnOnce "trayer --edge top --align right --widthtype request --padding 6 --SetDockType true --SetPartialStrut true --expand true --transparent true --alpha 0 --tint 0x13131F --height 24 &"      --Dark
    spawnOnce "nm-applet &"                             -- Network Manager applet
    setWMName "Xmonad"

myColorizer :: Window -> Bool -> X (String, String)
myColorizer = colorRangeFromClassName
                  (0x28,0x2c,0x34)      -- lowest inactive bg
                  (0x28,0x2c,0x34)      -- highest inactive bg
                  (0xc7,0x92,0xea)      -- active bg
                  (0xc0,0xa7,0x9a)      -- inactive fg
                  (0x28,0x2c,0x34)      -- active fg

-- gridSelect Menu Layout
mygridConfig :: p -> GSConfig Window
mygridConfig colorizer = (buildDefaultGSConfig myColorizer)
    { gs_cellheight   = 40
    , gs_cellwidth    = 200
    , gs_cellpadding  = 6
    , gs_originFractX = 0.5
    , gs_originFractY = 0.5
    , gs_font         = myFont
    }

spawnSelected' :: [(String, String)] -> X ()
spawnSelected' lst = gridselect conf lst >>= flip whenJust spawn
    where conf = def
                   { gs_cellheight   = 40
                   , gs_cellwidth    = 200
                   , gs_cellpadding  = 6
                   , gs_originFractX = 0.5
                   , gs_originFractY = 0.5
                   , gs_font         = myFont
                   }

myAppGrid = [ ("Alacritty", "alacritty")
                 , ("Deadbeef", "deadbeef")
                 , ("Emacs", "emacsclient -c -a emacs")
                 , ("Firefox", "firefox")
                 , ("Gimp", "gimp")
                 , ("LibreOffice Writer", "lowriter")
                 , ("OBS", "obs")
                 , ("Thunar", "thunar")
                 ]

myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "terminal" spawnTerm findTerm manageTerm
                , NS "mocp" spawnMocp findMocp manageMocp
                , NS "calculator" spawnCalc findCalc manageCalc
                ]
  where
    spawnTerm  = myTerminal ++ " -t scratchpad"
    findTerm   = title =? "scratchpad"
    manageTerm = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnMocp  = myTerminal ++ " -t mocp -e mocp"
    findMocp   = title =? "mocp"
    manageMocp = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w 
    spawnCalc  = "qalculate-gtk"
    findCalc   = className =? "Qalculate-gtk"
    manageCalc = customFloating $ W.RationalRect l t w h
               where
                 h = 0.5
                 w = 0.4
                 t = 0.75 -h
                 l = 0.70 -w

{- Makes setting the spacingRaw simpler to write. The spacingRaw module adds a configurable amount of space around windows. -}
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

{- Below is a variation of the above except no borders are applied if fewer than two windows. So a single window has no gaps. -}
mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

{- Defining a bunch of layouts, many that I don't use.
limitWindows n sets maximum number of windows displayed for layout.
mySpacing n sets the gap size around the windows. -}
tall     = renamed [Replace "tall"]
           $ smartBorders
           $ windowNavigation
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing 8
           $ ResizableTall 1 (3/100) (1/2) []
monocle  = renamed [Replace "monocle"]
           $ smartBorders
           $ windowNavigation
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 20 Full
floats   = renamed [Replace "floats"]
           $ smartBorders
           $ limitWindows 20 simplestFloat
grid     = renamed [Replace "grid"]
           $ smartBorders
           $ windowNavigation
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing 8
           $ mkToggle (single MIRROR)
           $ Grid (16/10)
spirals  = renamed [Replace "spirals"]
           $ smartBorders
           $ windowNavigation
           $ subLayout [] (smartBorders Simplest)
           $ mySpacing' 8
           $ spiral (6/7)
threeCol = renamed [Replace "threeCol"]
           $ smartBorders
           $ windowNavigation
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 7
           $ mySpacing 8
           $ ThreeCol 1 (3/100) (1/2)
threeRow = renamed [Replace "threeRow"]
           $ smartBorders
           $ windowNavigation
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 7
           -- Mirror takes a layout and rotates it by 90 degrees.
           -- So we are applying Mirror to the ThreeCol layout.
           $ Mirror
           $ ThreeCol 1 (3/100) (1/2)

{- Theme for showWName which prints current workspace when you change workspaces. -}
myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
    { swn_font              = "xft:mononoki:bold:size=50"
    , swn_fade              = 1.0
    , swn_bgcolor           = "#1c1f24"
    , swn_color             = "#ffffff"
    }

{-The layout hook -}
myLayoutHook = avoidStruts $ mouseResize $ windowArrange $ T.toggleLayouts floats
               $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
             where
               {- Replace first line layout to set default; the rest will be cycled through. -}
               myDefaultLayout =     withBorder myBorderWidth threeCol 
                                 ||| spirals 
                                 ||| tall
                                 ||| grid
                                 ||| noBorders monocle
                                 ||| floats
                                 ||| threeRow
myWorkspaces = [" 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 "]
--myWorkspaces = [" I ", " II ", " III ", " IV ", " V ", " VI ", " VII ", " VIII ", " IX "]
--myWorkspaces = [" WRITING ", " WWW ", " CHAT ", " GAME ", " SCHOOL ", " MUS ", " 7 ", " 8 ", " 9 "]
myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..] -- (,) == \x y -> (x,y)

clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
    where i = fromJust $ M.lookup ws myWorkspaceIndices

myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll

     {- Float Rules -}
     [ className =? "confirm"         --> doCenterFloat
     , className =? "file_progress"   --> doCenterFloat
     , className =? "dialog"          --> doCenterFloat
     , className =? "download"        --> doFloat
     , className =? "error"           --> doFloat
     , className =? "notification"    --> doFloat
     , className =? "pinentry-gtk-2"  --> doFloat
     , className =? "splash"          --> doFloat
     , className =? "toolbar"         --> doFloat
     , className =? "Yad"             --> doCenterFloat
     , className =? "MultiMC"       --> doCenterFloat
     --, title =? "Oracle VM VirtualBox Manager"  --> doCenterFloat
     , className =? "Deadbeef"                  --> doCenterFloat
     , className =? "Pavucontrol"               --> doCenterFloat
     , className =? "Leafpad"                   --> doCenterFloat
     , className =? "Gedit"                     --> doCenterFloat
     , className =? "Nemo"                      --> doCenterFloat
     , title =? "Image Viewer"                  --> doCenterFloat
     , title =? "Virtual Machine Manager"	--> doCenterFloat
     , title =? "Nitrogen"                      --> doCenterFloat
     , title =? "galculator"                    --> doCenterFloat
     , title =? "Sign in to Minecraft"          --> doCenterFloat
     , title =? "Minecraft Launcher"            --> doCenterFloat
     -- , className =? "Steam"                     --> doCenterFloat

     {- Shift Rules-}
     --, title =? "Alacritty"                     --> doShift ( myWorkspaces !! 0 )
     --, title =? "Mozilla Firefox"               --> doShift ( myWorkspaces !! 1 )
     --, title =? "LibreWolf"                     --> doShift ( myWorkspaces !! 1 )
     --, title =? "Spotify"                       --> doShift ( myWorkspaces !! 6 )
     --, className =? "Deadbeef"                  --> doShift ( myWorkspaces !! 6 )
     --, className =? "Steam"                     --> doShift ( myWorkspaces !! 3 )
     --, title =? "Discord"                       --> doShift ( myWorkspaces !! 2 )
     --, className =? "mpv"                       --> doShift ( myWorkspaces !! 7 )
     --, className =? "Gimp"                      --> doShift ( myWorkspaces !! 8 )
     --, className =? "VirtualBox Manager"        --> doShift ( myWorkspaces !! 4 )
     
     , (className =? "firefox" <&&> resource =? "Dialog") --> doCenterFloat  -- Float Firefox Dialog
     , isFullscreen -->  doFullFloat
     ] <+> namedScratchpadManageHook myScratchPads

myKeys :: [(String, X ())]
myKeys =
        {- XMonad -}
        [ ("M-x c", spawn "xmonad --recompile")         -- Recompiles Xmonad
        , ("M-x r", spawn "xmonad --restart")           -- Restarts Xmonad
        , ("M-x q", io exitSuccess)                     -- Quits Xmonad
        , ("M-x w", spawn "nitrogen")                   -- Pick Wallpaper
        , ("M-x t", spawn "lxappearance")               -- Theme editor

        , ("M-<Escape>", spawn "i3lock -c 1E1F29")      -- Locks screen

        , ("M1-q", kill1)                               -- Kill the currently focused client
        , ("M1-S-q", killAll)                           -- Kill all windows on current workspace

        {- Dmenu Things -}
        , ("M-<Return>", spawn "dmenu_run -p 'Execute:'")      -- Dmenu
        , ("M1-<Space> v", spawn "clipmenu")                            -- Clipmenu
        , ("M1-<Space> c", spawn "$HOME/.scripts/dmenu/dm-configs")     -- Edit config files
        , ("M1-<Space> p", spawn "$HOME/.scripts/dmenu/dm-portage")     -- Run portage actions
        , ("M1-<Space> k", spawn "$HOME/.scripts/dmenu/dm-power")       -- Power menu

        {- Useful Programs -}
        , ("M1-<Return>", spawn (myTerminal))           -- Terminal
        , ("M1-b", spawn (myBrowser))                   -- Browser
        , ("M1-S-b", spawn "firefox-bin")               -- Firefox
        , ("M1-h", spawn (myFileManager))               -- File Manager
        , ("M1-d", spawn ("discord --ignore-gpu-blocklist --disable-features=UseOzonePlatform --enable-features=VaapiVideoDecoder --use-gl=desktop --enable-gpu-rasterization --enable-zero-copy --no-sandbox"))
        , ("M1-c", spawn ("galculator"))
        , ("<Print>", spawn ("flameshot gui"))

        {- Writing -}
        , ("M1-w e", spawn ("emacs"))
        , ("M1-w l", spawn ("leafpad"))
        , ("M1-w o", spawn ("libreoffice"))
        , ("M1-w v", spawn ("vscode"))

        {- Games -}
        , ("M1-g s", spawn ("steam"))
        , ("M1-g m", spawn ("multimc"))

        {- Music -}
        , ("M1-m s", spawn ("spotify"))
        , ("M1-m d", spawn ("deadbeef"))
        , ("M1-m p", spawn ("pavucontrol"))
        , ("M1-m m", spawn ("musescore"))

        {- Virtualization -}
        , ("M1-v v", spawn ("virt-manager"))
	, ("M1-v b", spawn ("virtualbox"))

        {- Workspaces --}
        --, ("M-.", nextScreen)  -- Switch focus to next monitor
        --, ("M-,", prevScreen)  -- Switch focus to prev monitor
        , ("M-.", moveTo Next nonNSP)
        , ("M-,", moveTo Prev nonNSP)
        , ("M-S-.", shiftTo Next nonNSP >> moveTo Next nonNSP)  -- Shifts focused window to next ws
        , ("M-S-,", shiftTo Prev nonNSP >> moveTo Prev nonNSP)  -- Shifts focused window to prev ws

        {- Floating Windows -}
        , ("M-f", sendMessage (T.Toggle "floats"))      -- Toggles my 'floats' layout
        , ("M-t", withFocused $ windows . W.sink)       -- Push floating window back to tile
        , ("M-S-t", sinkAll)                            -- Push ALL floating windows to tile

        {- Grid Select -}
        , ("C-g g", spawnSelected' myAppGrid)                 -- grid select favorite apps
        , ("C-g t", goToSelected $ mygridConfig myColorizer)  -- goto selected window
        , ("C-g b", bringSelected $ mygridConfig myColorizer) -- bring selected window

        {- Window Navigation -}
        , ("M-C-j", windows W.focusDown)    -- Move focus to the next window
        , ("M-C-k", windows W.focusUp)      -- Move focus to the prev window
        , ("M-C-S-j", windows W.swapDown)   -- Swap focused window with next window
        , ("M-C-S-k", windows W.swapUp)     -- Swap focused window with prev window
        
        --, ("M-C-h", windows W.focusDown)    -- Move focus to the next window
        --, ("M-C-t", windows W.focusUp)      -- Move focus to the prev window
        --, ("M-C-S-h", windows W.swapDown)   -- Swap focused window with next window
        --, ("M-C-S-t", windows W.swapUp)     -- Swap focused window with prev window

        , ("M-C-m", windows W.focusMaster)      -- Move focus to the master window
        , ("M-S-<Return>", windows W.swapMaster)     -- Swap the focused window and the master window
        , ("M-<Backspace>", promote)            -- Moves focused window to master, others maintain order
        , ("M-S-<Tab>", rotSlavesDown)          -- Rotate all windows except master and keep focus in place
        , ("M-C-<Tab>", rotAllDown)             -- Rotate all the windows in the current stack

        {- Layouts -}
        , ("M-<Tab>", sendMessage NextLayout)                                           -- Switch to next layout
        --, ("M-<Space>", sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts)   -- Toggles noborder/full

        {- Volume -}
        , ("M-<Up>", spawn ("pactl set-sink-volume @DEFAULT_SINK@ +5%"))
        , ("M-C-<Up>", spawn ("pactl set-sink-volume @DEFAULT_SINK@ +10%"))

        , ("M-<Down>", spawn ("pactl set-sink-volume @DEFAULT_SINK@ -5%"))
        , ("M-C-<Down>", spawn ("pactl set-sink-volume @DEFAULT_SINK@ -10%"))

        , ("M-m", spawn ("pactl set-sink-mute @DEFAULT_SINK@ toggle"))

        {- Increase/decrease windows in the master pane or the stack -}
        --, ("M-S-<Up>", sendMessage (IncMasterN 1))      -- Increase # of clients master pane
        --, ("M-S-<Down>", sendMessage (IncMasterN (-1))) -- Decrease # of clients master pane
        --, ("M-C-<Up>", increaseLimit)                   -- Increase # of windows
        --, ("M-C-<Down>", decreaseLimit)                 -- Decrease # of windows

        {- Resizing Windows -}
        , ("M-C-h", sendMessage Shrink)                   -- Shrink horiz window width
        , ("M-C-l", sendMessage Expand)                   -- Expand horiz window width
        
        --, ("M-C-S-d", sendMessage Shrink)                 -- Shrink horiz window width
        --, ("M-C-S-n", sendMessage Expand)                 -- Expand horiz window width

        --, ("M-M1-j", sendMessage MirrorShrink)          -- Shrink vert window width
        --, ("M-M1-k", sendMessage MirrorExpand)          -- Expand vert window width
        ]

    {- The following are needed for named scratchpads. -}
          where nonNSP          = WSIs (return (\ws -> W.tag ws /= "NSP"))
                nonEmptyNonNSP  = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "NSP"))
-- END_KEYS

main :: IO ()
main = do
    {- Launching xmobar on each monitor -}
    xmproc0 <- spawnPipe "xmobar -x 0 /home/vox/.config/xmobar/xmobarrc"
    xmproc1 <- spawnPipe "xmobar -x 1 /home/vox/.config/xmobar/xmobarrc1"
    --xmproc2 <- spawnPipe "xmobar -x 2 /home/vox/.config/xmobar/xmobarrc"

    {- The xmonad, ya know...what the WM is named after! -}
    xmonad $ ewmh def
        { manageHook         = myManageHook <+> manageDocks
        , handleEventHook    = docksEventHook
                               {- Uncomment this line to enable fullscreen support on things like YouTube/Netflix.
                               This works perfect on SINGLE monitor systems. On multi-monitor systems,
                               it adds a border around the window if screen does not have focus. So, my solution
                               is to use a keybinding to toggle fullscreen noborders instead.  (M-<Space>)
                               <+> fullscreenEventHook -}
        , modMask            = myModMask
        , terminal           = myTerminal
        , startupHook        = myStartupHook
        , layoutHook         = showWName' myShowWNameTheme $ myLayoutHook
        , workspaces         = myWorkspaces
        , borderWidth        = myBorderWidth
        , normalBorderColor  = myNormColor
        , focusedBorderColor = myFocusColor
        , logHook = dynamicLogWithPP $ namedScratchpadFilterOutWorkspacePP $ xmobarPP
              -- the following variables beginning with 'pp' are settings for xmobar.
              { ppOutput = \x -> hPutStrLn xmproc0 x                          -- xmobar on monitor 1
                              >> hPutStrLn xmproc1 x                          -- xmobar on monitor 2
--                              >> hPutStrLn xmproc2 x                           xmobar on monitor 3
              , ppCurrent = xmobarColor "#c792ea" "" . wrap "<box type=Bottom width=2 mb=2 color=#c792ea>" "</box>"         -- Current workspace
              , ppVisible = xmobarColor "#c792ea" "" . clickable              -- Visible but not current workspace
              , ppHidden = xmobarColor "#82AAFF" "" . wrap "<box type=Top width=2 mt=2 color=#82AAFF>" "</box>" . clickable -- Hidden workspaces
              , ppHiddenNoWindows = xmobarColor "#82AAFF" ""  . clickable     -- Hidden workspaces (no windows)
              , ppTitle = xmobarColor "#b3afc2" "" . shorten 60               -- Title of active window
              , ppSep =  "<fc=#666666> <fn=1>|</fn> </fc>"                    -- Separator character
              , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"            -- Urgent workspace
              , ppExtras  = [windowCount]                                     -- # of windows current workspace
              , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]                    -- order of things in xmobar
              }
        } `additionalKeysP` myKeys
