-- Base
import XMonad
import System.IO (hClose, hPutStr, hPutStrLn)
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W

-- Actions
import XMonad.Actions.CopyWindow (kill1)
import XMonad.Actions.CycleWS (Direction1D(..), moveTo, shiftTo, toggleWS, WSType(..), nextScreen, prevScreen)
import XMonad.Actions.MouseResize
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Actions.WithAll (sinkAll, killAll)

-- Data
import Data.Char (isSpace, toUpper)
import Data.Maybe (fromJust, isJust, catMaybes, fromMaybe)
import Data.Monoid
import qualified Data.Map as M

-- xresrouces
import Data.Bifunctor (bimap, second)
import Data.List as DL
import System.IO.Unsafe (unsafePerformIO)
import XMonad.Core (installSignalHandlers)

-- Hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops  -- for some fullscreen events, also for xcomposite in obs.
import XMonad.Hooks.ManageDocks (avoidStruts, docks, manageDocks, ToggleStruts(..))
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat, doCenterFloat)
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP

-- Layouts
import XMonad.Layout.SimplestFloat
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Magnifier (magnifiercz)

-- Layouts modifiers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))
import XMonad.Layout.NoBorders (noBorders, smartBorders, withBorder)
import XMonad.Layout.Renamed (renamed, Rename(Replace))
import XMonad.Layout.Spacing (smartSpacing, decWindowSpacing, incWindowSpacing, decScreenSpacing, incScreenSpacing)

-- Utilities
import XMonad.Util.EZConfig (additionalKeysP, mkNamedKeymap)
import XMonad.Util.Hacks (windowedFullscreenFixEventHook, javaHack)
import XMonad.Util.NamedActions
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)
import XMonad.Util.SpawnOnce

myModMask :: KeyMask
myModMask = mod4Mask        -- Sets modkey to super/windows key

myFont :: String
myFont = "xft:JetBrainsMono Nerd Font Mono:regular:size=10:antialias=true:hinting=true"

myTerminal :: String
myTerminal = "st"    -- Sets default terminal

myEmacs :: String
myEmacs = "emacsclient -c -a 'emacs' "  -- Makes emacs keybindings easier to type

myCode :: String
myCode = "code"  -- Sets emacs as editor

-- myVim :: String
-- myVim = myTerminal ++ " -e vim "    -- Sets vim as editor

myBorderWidth :: Dimension
myBorderWidth = 2           -- Sets border width for windows

normfgcolor :: String
normfgcolor = xProp "*.normfgcolor"
normbgcolor :: String
normbgcolor = xProp "*.normbgcolor"
selfgcolor :: String
selfgcolor = xProp "*.selfgcolor"
selbgcolor :: String
selbgcolor = xProp "*.selbgcolor"
normbordercolor :: String
normbordercolor = xProp "*.normbordercolor"
selbordercolor :: String
selbordercolor = xProp "*.selbordercolor"
sepcolor :: String
sepcolor = "#5b6268"
accentcolor :: String
accentcolor = xProp "*.accentcolor"
urgcolor :: String
urgcolor = "#da8548"

-- setting colors for tabs layout and tabs sublayout.
myTabTheme = def { fontName            = myFont
                 , activeColor         = selbgcolor
                 , inactiveColor       = normbgcolor
                 , activeBorderColor   = selbordercolor
                 , inactiveBorderColor = normbordercolor
                 , activeTextColor     = selfgcolor
                 , inactiveTextColor   = normfgcolor
                 }

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

myStartupHook :: X ()
myStartupHook = do
  spawnOnce "/usr/bin/emacs --daemon &"
  spawnOnce "lxsession &"
  spawnOnce "notify-send 'Xmonad system ready' &"
  spawnOnce "sleep 5 && xmodmap -e 'pointer = 1 2 3 4 5 6 7 8 9 10' &"
  -- setWMName "LG3D"
  -- spawnOnce "trayer --edge top --align right --widthtype percent --transparent true --alpha 0 --tint 0x000000 --width 1.2 --height 22 &"
  -- spawnOnce "nm-applet &"
  -- spawnOnce "volumeicon"

{- Defining a bunch of layouts, many that I don't use. limitWindows n sets
maximum number of windows displayed for layout. mySpacing n sets the gap size
around the windows.
-}
tall     = renamed [Replace "[tall]="]
           $ limitWindows 5
           $ addTabs shrinkText myTabTheme
           -- $ subLayout [] (smartBorders Simplest)
           $ smartSpacing 4
           $ ResizableTall 1 (3/100) (1/2) []
monocle  = renamed [Replace "[mono]"]
           $ addTabs shrinkText myTabTheme
           -- $ subLayout [] (smartBorders Simplest)
           $ Full
floats   = renamed [Replace "<F><"]
           $ simplestFloat
thrColMagn = renamed [Replace "|magn]|"]
           $ magnifiercz 1.3
           $ limitWindows 7
           $ addTabs shrinkText myTabTheme
           -- $ subLayout [] (smartBorders Simplest)
           $ ThreeCol 1 (3/100) (1/2)
thrRowMagn = renamed [Replace "=Magn="]
           $ magnifiercz 1.3
           $ limitWindows 7
           $ addTabs shrinkText myTabTheme
           -- $ subLayout [] (smartBorders Simplest)
           $ Mirror
           $ ThreeCol 1 (3/100) (1/2)
tabs     = renamed [Replace "_tabs_"]
           $ tabbed shrinkText myTabTheme

-- The layout hook
myLayoutHook = avoidStruts
               $ mouseResize
               $ T.toggleLayouts floats
               $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
  where
    myDefaultLayout = smartBorders
                    $ withBorder myBorderWidth
                    $ tall
                    -- $ configurableNavigation noNavigateBorders tall
                    ||| noBorders tabs
                    ||| floats
                    ||| thrColMagn
                    ||| thrRowMagn
                    ||| noBorders monocle

-- myWorkspaces = [" 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 ", " 10 "]
myWorkspaces = ["main", "int", "str", "arr", "imp", "type", "mus", "vid", "func", "utl"]
-- myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
-- myWorkspaces =
--         " 1 : <fn=2>\xf111</fn> " :
--         " 2 : <fn=2>\xf1db</fn> " :
--         " 3 : <fn=2>\xf192</fn> " :
--         " 4 : <fn=2>\xf025</fn> " :
--         " 5 : <fn=2>\xf03d</fn> " :
--         " 6 : <fn=2>\xf1e3</fn> " :
--         " 7 : <fn=2>\xf07b</fn> " :
--         " 8 : <fn=2>\xf21b</fn> " :
--         " 9 : <fn=2>\xf21e</fn> " :
--         []
myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..] -- (,) == \x y -> (x,y)

clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
    where i = fromJust $ M.lookup ws myWorkspaceIndices

myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
  -- 'doFloat' forces a window to float.  Useful for dialog boxes and such.
  -- using 'doShift ( myWorkspaces !! 7)' sends program to workspace 8!
  -- I'm doing it this way because otherwise I would have to write out the full
  -- name of my workspaces and the names would be very long if using clickable workspaces.
  [ className =? "confirm"         --> doFloat
  , className =? "file_progress"   --> doFloat
  , className =? "dialog"          --> doFloat
  , className =? "download"        --> doFloat
  , className =? "error"           --> doFloat
  , className =? "Xfce-polkit"     --> doCenterFloat
  , className =? "notification"    --> doFloat
  , className =? "pinentry-gtk-2"  --> doFloat
  , className =? "splash"          --> doFloat
  , className =? "toolbar"         --> doFloat
  , className =? "Yad"             --> doCenterFloat
  , className =? "Microsoft-edge"  --> doShift ( myWorkspaces !! 1 )
  , (className =? "Microsoft-edge" <&&> resource =? "Dialog") --> doFloat
  , isFullscreen -->  doFullFloat] -- <+> namedScratchpadManageHook myScratchPads

subtitle' ::  String -> ((KeyMask, KeySym), NamedAction)
subtitle' x = ((0,0), NamedAction $ map toUpper
                      $ sep ++ "\n-- " ++ x ++ " --\n" ++ sep)
  where
    sep = replicate (6 + length x) '-'

showKeybindings :: [((KeyMask, KeySym), NamedAction)] -> NamedAction
showKeybindings x = addName "Show Keybindings" $ io $ do
  h <- spawnPipe $ "yad --text-info --fontname='JetBrainsMono Nerd Font 12' --fore=#46d9ff back=#282c36 --center --geometry=1200x750 --title \"XMonad keybindings\""
  --hPutStr h (unlines $ showKm x) -- showKM adds ">>" before subtitles
  hPutStr h (unlines $ showKmSimple x) -- showKmSimple doesn't add ">>" to subtitles
  hClose h
  return ()

myKeys :: XConfig l0 -> [((KeyMask, KeySym), NamedAction)]
myKeys c =
    --(subtitle "Custom Keys":) $ mkNamedKeymap c $
    let subKeys str ks = subtitle' str : mkNamedKeymap c ks in
    subKeys "Xmonad Essentials"
    [ ("M-C-r", addName "Recompile XMonad"      $ spawn "xmonad --recompile")
    , ("M-S-<F5>", addName "Restart XMonad"     $ spawn "xmonad --restart")
    , ("M-S-q", addName "Quit XMonad"           $ io exitSuccess)
    , ("M-x",   addName "Quit XMonad"           $ spawn "dm-logout")
    , ("M-q",   addName "Kill focused window"   $ kill1)
    , ("M-S-q", addName "Kill all windows on WS"$ killAll)
    , ("M-d",   addName "Run prompt"            $ spawn "dm_run.py")
    , ("M-S-b", addName "Toggle bar show/hide"  $ sendMessage ToggleStruts)
    ]

    ^++^ subKeys "Switch to workspace"
    [ ("M-1", addName "Switch to workspace 1"   $ windows $ W.greedyView $ myWorkspaces !! 0)
    , ("M-2", addName "Switch to workspace 2"   $ windows $ W.greedyView $ myWorkspaces !! 1)
    , ("M-3", addName "Switch to workspace 3"   $ windows $ W.greedyView $ myWorkspaces !! 2)
    , ("M-4", addName "Switch to workspace 4"   $ windows $ W.greedyView $ myWorkspaces !! 3)
    , ("M-5", addName "Switch to workspace 5"   $ windows $ W.greedyView $ myWorkspaces !! 4)
    , ("M-6", addName "Switch to workspace 6"   $ windows $ W.greedyView $ myWorkspaces !! 5)
    , ("M-7", addName "Switch to workspace 7"   $ windows $ W.greedyView $ myWorkspaces !! 6)
    , ("M-8", addName "Switch to workspace 8"   $ windows $ W.greedyView $ myWorkspaces !! 7)
    , ("M-9", addName "Switch to workspace 9"   $ windows $ W.greedyView $ myWorkspaces !! 8)
    , ("M-0", addName "Switch to workspace 10"  $ windows $ W.greedyView $ myWorkspaces !! 9)
    ]

    ^++^ subKeys "Send window to workspace"
    [ ("M-S-1", addName "Send to workspace 1"   $ windows $ W.shift $ myWorkspaces !! 0)
    , ("M-S-2", addName "Send to workspace 2"   $ windows $ W.shift $ myWorkspaces !! 1)
    , ("M-S-3", addName "Send to workspace 3"   $ windows $ W.shift $ myWorkspaces !! 2)
    , ("M-S-4", addName "Send to workspace 4"   $ windows $ W.shift $ myWorkspaces !! 3)
    , ("M-S-5", addName "Send to workspace 5"   $ windows $ W.shift $ myWorkspaces !! 4)
    , ("M-S-6", addName "Send to workspace 6"   $ windows $ W.shift $ myWorkspaces !! 5)
    , ("M-S-7", addName "Send to workspace 7"   $ windows $ W.shift $ myWorkspaces !! 6)
    , ("M-S-8", addName "Send to workspace 8"   $ windows $ W.shift $ myWorkspaces !! 7)
    , ("M-S-9", addName "Send to workspace 9"   $ windows $ W.shift $ myWorkspaces !! 8)
    , ("M-S-0", addName "Send to workspace 10"  $ windows $ W.shift $ myWorkspaces !! 9)
    ]

    ^++^ subKeys "Move window to WS and go there"
    [ ("M-S-<Page_Up>", addName "Move window to next WS"    $ shiftTo Next nonNSP >> moveTo Next nonNSP)
    , ("M-S-<Page_Down>", addName "Move window to prev WS"  $ shiftTo Prev nonNSP >> moveTo Prev nonNSP)
    ]

    ^++^ subKeys "Window navigation"
    [ ("M-j", addName "Move focus to next window"               $ windows W.focusDown)
    , ("M-k", addName "Move focus to prev window"               $ windows W.focusUp)
    , ("M-m", addName "Move focus to master window"             $ windows W.focusMaster)
    , ("M-S-j", addName "Swap focused window with next window"  $ windows W.swapDown)
    , ("M-S-k", addName "Swap focused window with prev window"  $ windows W.swapUp)
    , ("M-S-m", addName "Swap focused window with master window"$ windows W.swapMaster)
    , ("M-<Backspace>", addName "Move focused window to master" $ promote)
    , ("M-S-,", addName "Rotate all windows except master"      $ rotSlavesDown)
    , ("M-S-.", addName "Rotate all windows current stack"      $ rotAllDown)
    ]

    {- | Dmenu scripts (dmscripts)
    In Xmonad and many tiling window managers, M-p is the default keybinding to
    launch dmenu_run, so I've decided to use M-p plus KEY for these dmenu scripts.
    -}
    ^++^ subKeys "Dmenu scripts"
    [ ("M-p h", addName "List all dmscripts"    $ spawn "dm-hub")
    , ("M-p b", addName "Set background"        $ spawn "dm-setbg")
    , ("M-p c", addName "Edit config files"     $ spawn "dm-confedit")
    , ("M-p m", addName "View manpages"         $ spawn "dm-man")
    , ("M-p o", addName "Store and copy notes"  $ spawn "dm-note")
    , ("M-p x", addName "Logout Menu"           $ spawn "dm-logout")
    , ("M-p r", addName "Listen to online radio"$ spawn "dm-radio")
    , ("M-p s", addName "Record Screen"         $ spawn "dm-record")
    , ("M-p w", addName "Search various engines"$ spawn "dm-websearch")
    , ("M-p n", addName "Connect Wifi"          $ spawn "dm-wifi")
    , ("M-p p", addName "Pick Color"            $ spawn "gpick -s")
    , ("M-p z", addName "Open Zotero"           $ spawn "zotero-snap")
    ]

    ^++^ subKeys "Favorite programs"
    [ ("M-<Return>", addName "Launch terminal"  $ spawn myTerminal)
    , ("M-b", addName "Launch web browser"      $ spawn "microsoft-edge")
    , ("M-e", addName "Launch file manager"     $ spawn "thunar")
    , ("M-s", addName "Launch file manager"     $ spawn "flameshot gui")
    , ("M-M1-h", addName "Launch htop"          $ spawn (myTerminal ++ " -e htop"))
    ]

    ^++^ subKeys "Monitors"
    [ ("M-.", addName "Switch focus to next monitor"    $ nextScreen)
    , ("M-,", addName "Switch focus to prev monitor"    $ prevScreen)
    ]

    -- Switch layouts
    ^++^ subKeys "Switch layouts"
    [ ("M-<Tab>", addName "Switch to next layout"   $ sendMessage NextLayout)
    , ("M-f", addName "Toggle noborders/full"       $ sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts)
    ]

    -- Window resizing
    ^++^ subKeys "Window resizing"
    [ ("M-h", addName "Shrink window"               $ sendMessage Shrink)
    , ("M-l", addName "Expand window"               $ sendMessage Expand)
    , ("M-M1-j", addName "Shrink window vertically" $ sendMessage MirrorShrink)
    , ("M-M1-k", addName "Expand window vertically" $ sendMessage MirrorExpand)
    ]

    -- Floating windows
    ^++^ subKeys "Floating windows"
    [ ("M-S-<Space>", addName "Toggle float layout" $ sendMessage (T.Toggle "floats"))
    , ("M-t", addName "Sink a floating window"      $ withFocused $ windows . W.sink)
    , ("M-S-t", addName "Sink all floated windows"  $ sinkAll)
    ]

    -- Increase/decrease spacing (gaps)
    ^++^ subKeys "Window spacing (gaps)"
    [ ("M-g j", addName "Decrease window spacing" $ decWindowSpacing 4)
    , ("M-g k", addName "Increase window spacing" $ incWindowSpacing 4)
    , ("M-g h", addName "Decrease screen spacing" $ decScreenSpacing 4)
    , ("M-g l", addName "Increase screen spacing" $ incScreenSpacing 4)
    ]

    -- Increase/decrease windows in the master pane or the stack
    ^++^ subKeys "Increase/decrease windows in master pane or the stack"
    [ ("M-S-<Up>", addName "Increase clients in master pane"   $ sendMessage (IncMasterN 1))
    , ("M-S-<Down>", addName "Decrease clients in master pane" $ sendMessage (IncMasterN (-1)))
    , ("M-=", addName "Increase max # of windows for layout"   $ increaseLimit)
    , ("M--", addName "Decrease max # of windows for layout"   $ decreaseLimit)
    ]

    {- | Sublayouts
    This is used to push windows to tabbed sublayouts, or pull them out of it.
    -}
    -- ^++^ subKeys "Sublayouts"
    -- [ ("M-C-h", addName "pullGroup L"           $ sendMessage $ pullGroup L)
    -- , ("M-C-l", addName "pullGroup R"           $ sendMessage $ pullGroup R)
    -- , ("M-C-k", addName "pullGroup U"           $ sendMessage $ pullGroup U)
    -- , ("M-C-j", addName "pullGroup D"           $ sendMessage $ pullGroup D)
    -- , ("M-C-m", addName "MergeAll"              $ withFocused (sendMessage . MergeAll))
    -- , ("M-C-u", addName "UnMerge"               $ withFocused (sendMessage . UnMerge))
    -- , ("M-C-/", addName "UnMergeAll"            $ withFocused (sendMessage . UnMergeAll))
    -- , ("M-C-.", addName "Switch focus next tab" $ onGroup W.focusUp')
    -- , ("M-C-,", addName "Switch focus prev tab" $ onGroup W.focusDown')
    -- ]

    {- | Scratchpads
    Toggle show/hide these programs. They run on a hidden workspace.
    When you toggle them to show, it brings them to current workspace.
    Toggle them to hide and it sends them back to hidden workspace (NSP).
    -}
    -- ^++^ subKeys "Scratchpads"
    -- [ ("M-` 1", addName "Toggle scratchpad terminal"   $ namedScratchpadAction myScratchPads "terminal")
    -- , ("M-` 2", addName "Toggle scratchpad mocp"       $ namedScratchpadAction myScratchPads "mocp")
    -- , ("M-` 3", addName "Toggle scratchpad calculator" $ namedScratchpadAction myScratchPads "calculator")
    -- ]

    -- Controls for mocp music player (SUPER-u followed by a key)
    ^++^ subKeys "Mocp music player"
    [ ("M-u p", addName "mocp play"                $ spawn "mocp --play")
    , ("M-u l", addName "mocp next"                $ spawn "mocp --next")
    , ("M-u h", addName "mocp prev"                $ spawn "mocp --previous")
    , ("M-u <Space>", addName "mocp toggle pause"  $ spawn "mocp --toggle-pause")
    ]

    -- Emacs (SUPER-e followed by a key)
    ^++^ subKeys "Code Editor"
    [ ("M-c c", addName "VS Code"                   $ spawn myCode)
    , ("M-c e", addName "Emacsclient"               $ spawn myEmacs)
    , ("M-c a", addName "Emacsclient EMMS (music)"  $ spawn (myEmacs ++ "--eval '(emms)' --eval '(emms-play-directory-tree \"~/Music/\")'"))
    , ("M-c b", addName "Emacsclient Ibuffer"       $ spawn (myEmacs ++ "--eval '(ibuffer)'"))
    , ("M-c d", addName "Emacsclient Dired"         $ spawn (myEmacs ++ "--eval '(dired nil)'"))
    , ("M-c m", addName "Mousepad"                  $ spawn "mousepad")
    ]

    -- Multimedia Keys
    ^++^ subKeys "Multimedia keys"
    [ ("<XF86AudioMute>", addName "Toggle audio mute"   $ spawn "volumecontrol.sh -o m")
    , ("<XF86AudioLowerVolume>", addName "Lower volume" $ spawn "volumecontrol.sh -o d")
    , ("<XF86AudioRaiseVolume>", addName "Raise volume" $ spawn "volumecontrol.sh -o i")
    , ("<XF86MonBrightnessDown>", addName "Raise vol"   $ spawn "brightnesscontrol.sh d")
    , ("<XF86MonBrightnessUp>", addName "Raise vol"     $ spawn "brightnesscontrol.sh i")
    , ("<Print>", addName "Take screenshot"             $ spawn "flameshotgui")
    ]

    -- Workspace
    ^++^ subKeys "Workspace"
    [ ("M1-<Tab>", addName "Cycle with last WS" $ toggleWS) ]

    -- The following lines are needed for named scratchpads.
  where
    nonNSP          = WSIs (return (\ws -> W.tag ws /= "NSP"))
    nonEmptyNonNSP  = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "NSP"))

getFromXres :: String -> IO String
getFromXres key = fromMaybe "" . findValue key <$> runProcessWithInput "xrdb" ["-query"] ""
  where
    findValue :: String -> String -> Maybe String
    findValue xresKey xres =
      snd <$> (
                DL.find ((== xresKey) . fst)
                $ catMaybes
                $ splitAtColon
                <$> lines xres
              )

    splitAtColon :: String -> Maybe (String, String)
    splitAtColon str = splitAtTrimming str <$> (DL.elemIndex ':' str)

    splitAtTrimming :: String -> Int -> (String, String)
    splitAtTrimming str idx = bimap trim trim . (second tail) $ splitAt idx str

    trim :: String -> String
    trim = DL.dropWhileEnd (isSpace) . DL.dropWhile (isSpace)

xProp :: String -> String
xProp = unsafePerformIO . getFromXres

main :: IO ()
main = do
  -- Launching three instances of xmobar on their monitors.
  -- xmproc0 <- spawnPipe ("xmobar -x 0 $HOME/.xmobarrc ")
  xmproc0 <- spawnPipe ("~/.cabal/bin/xmobar -x 0 $HOME/.xmobarrc " ++ "-B" ++ normbgcolor ++ " -F" ++ normfgcolor)
  -- xmproc0 <- spawnPipe ("xmobar -x 0 $HOME/.xmobarrc -B '#555555' -F '#000000'")
  -- the xmonad, ya know...what the WM is named after!
  xmonad $ addDescrKeys' ((mod4Mask, xK_F1), showKeybindings) myKeys $ ewmh $ docks $ def
    { manageHook         = myManageHook <+> manageDocks
    -- , handleEventHook    = windowedFullscreenFixEventHook <> swallowEventHook (className =? "Alacritty"  <||> className =? "st-256color" <||> className =? "XTerm") (return True) <> trayerPaddingXmobarEventHook
    , handleEventHook    = windowedFullscreenFixEventHook
    , modMask            = myModMask
    , terminal           = myTerminal
    , startupHook        = myStartupHook
    , layoutHook         = myLayoutHook
    , workspaces         = myWorkspaces
    , borderWidth        = myBorderWidth
    , normalBorderColor  = normbordercolor
    , focusedBorderColor = selbordercolor
    -- , logHook = dynamicLogWithPP $  filterOutWsPP [scratchpadWorkspaceTag] $ xmobarPP
    , logHook = dynamicLogWithPP $ xmobarPP
        { ppOutput = \x -> hPutStrLn xmproc0 x   -- xmobar on monitor 1
        , ppCurrent = xmobarColor normfgcolor "" . wrap "[" "]"
          -- Visible but not current workspace
        , ppVisible = xmobarColor selfgcolor "" . clickable
          -- Hidden workspace
        -- , ppHidden = xmobarColor selbgcolor "" . wrap "*" "" . clickable
        , ppHidden = xmobarColor accentcolor "" . wrap "~" "" . clickable
          -- Hidden workspaces (no windows)
        -- , ppHiddenNoWindows = xmobarColor selbgcolor "" . clickable
        -- , ppHiddenNoWindows = xmobarColor selbgcolor "" . clickable
          -- Title of active window
        , ppTitle = xmobarColor normfgcolor "" . shorten 60
          -- Separator character
        , ppSep =  "<fc=" ++ sepcolor ++ "> <fn=1>|</fn> </fc>"
          -- Urgent workspace
        , ppUrgent = xmobarColor urgcolor "" . wrap "!" "!"
          -- Adding # of windows on current workspace to the bar
        , ppExtras  = [windowCount]
          -- order of things in xmobar
        , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
        }
    }
