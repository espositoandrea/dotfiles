import           System.Exit
import           System.IO

import qualified Codec.Binary.UTF8.String            as UTF8
import           XMonad hiding ((|||))
import XMonad.Layout.LayoutCombinators
import XMonad.Hooks.WorkspaceHistory
import XMonad.Hooks.FadeInactive
import XMonad.Util.WorkspaceCompare
import XMonad.Actions.GroupNavigation
import           XMonad.Actions.CycleWS
import           XMonad.Actions.SpawnOn
import           XMonad.Config.Azerty
import           XMonad.Config.Desktop
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.EwmhDesktops
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.ManageHelpers          (doCenterFloat,
                                                      doFullFloat, isDialog,
                                                      isFullscreen)
import           XMonad.Hooks.SetWMName
import           XMonad.Hooks.UrgencyHook
import           XMonad.Util.EZConfig
import           XMonad.Util.NamedScratchpad
import           XMonad.Util.Run                     (spawnPipe)

import           XMonad.Layout.Gaps
import           XMonad.Layout.ResizableTile
import           XMonad.Layout.Spacing
---import XMonad.Layout.NoBorders
import           XMonad.Layout.Cross                 (simpleCross)
import           XMonad.Layout.Fullscreen            (fullscreenFull)
import           XMonad.Layout.IndependentScreens
import           XMonad.Layout.MultiToggle
import           XMonad.Layout.MultiToggle.Instances
import           XMonad.Layout.Spiral                (spiral)
import           XMonad.Layout.ThreeColumns
import           XMonad.Util.SpawnOnce               (spawnOnce)


import           XMonad.Layout.CenteredMaster        (centerMaster)

import           Control.Monad                       (liftM2)
import qualified DBus                                as D
import qualified DBus.Client                         as D
import qualified Data.ByteString                     as B
import qualified Data.Map                            as M
import           Graphics.X11.ExtraTypes.XF86
import qualified XMonad.StackSet                     as W


myStartupHook = do
    spawn "$HOME/.xmonad/scripts/autostart.sh"
    spawnOnce "/usr/bin/emacs --daemon &" -- emacs daemon
    setWMName "LG3D"

-- colours
normBord = "#4c566a"
focdBord = "red" -- "#5e81ac"
fore     = "#DEE3E0"
back     = "#282c34"
winType  = "#c678dd"

--mod4Mask= super key
--mod1Mask= alt key
--controlMask= ctrl key
--shiftMask= shift key

myTerminal = "st"
myBrowser = "brave-browser"
myFileManager = "st -e ranger"
myModMask = mod4Mask
encodeCChar = map fromIntegral . B.unpack
myFocusFollowsMouse = True
myBorderWidth = 2
-- myWorkspaces    = ["\61612","\61899","\61947","\61635","\61502","\61501","\61705","\61564","\62150","\61872"]
-- myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]
myWorkspaces    = ["main","web","music","chat","5","6","7","8","9"]

myBaseConfig = desktopConfig

myLogHook :: X ()
myLogHook = fadeInactiveLogHook fadeAmount
    where fadeAmount = 1.0

-- window manipulations
myManageHook = composeAll . concat $
  [ [isDialog --> doCenterFloat]
  , [className =? c --> doCenterFloat | c <- myCFloats]
  , [title =? t --> doFloat | t <- myTFloats]
  , [resource =? r --> doFloat | r <- myRFloats]
  , [resource =? i --> doIgnore | i <- myIgnores]
  ]
  where
    myCFloats = ["Arandr", "Arcolinux-tweak-tool.py", "Arcolinux-welcome-app.py", "Galculator", "feh", "mpv", "Xfce4-terminal"]
    myTFloats = ["Downloads", "Save As..."]
    myRFloats = []
    myIgnores = ["desktop_window"]
    -- my1Shifts = ["Chromium", "Vivaldi-stable", "Firefox"]
    -- my2Shifts = []
    -- my3Shifts = ["Inkscape"]
    -- my4Shifts = []
    -- my5Shifts = ["Gimp", "feh"]
    -- my6Shifts = ["vlc", "mpv"]
    -- my7Shifts = ["Virtualbox"]
    -- my8Shifts = ["Thunar"]
    -- my9Shifts = []
    -- my10Shifts = ["discord"]

myScratchpads :: [NamedScratchpad]
myScratchpads =
  [ NS "terminal" (myTerminal ++  " -t scratchpad")  (title =? "scratchpad") smallRectFloating
  , NS "obs" ("obs")  (className =? "obs") mediumRectFloating
  , NS "music" ("spotify")  (className =? "Spotify") mediumRectFloating
  ]
  where
    smallRectFloating = customFloating $ W.RationalRect (2/6) (2/6) (2/6) (2/6)
    mediumRectFloating = customFloating $ W.RationalRect (1/4) (1/4) (1/2) (1/2)


myLayout = spacingRaw True (Border 0 5 5 5) True (Border 5 5 5 5) True $ avoidStruts $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) $ tiled ||| Mirror tiled ||| spiral (6/7)  ||| ThreeColMid 1 (3/100) (1/2) ||| Full
    where
        tiled = Tall nmaster delta tiled_ratio
        nmaster = 1
        delta = 3/100
        tiled_ratio = 1/2


myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
  -- mod-button1, Set the window to floating mode and move by dragging
  [ ((modMask, 1), (\w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster))
  -- mod-button2, Raise the window to the top of the stack
  , ((modMask, 2), (\w -> focus w >> windows W.shiftMaster))
  -- mod-button3, Set the window to floating mode and resize by dragging
  , ((modMask, 3), (\w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster))
  ]


-- keys config

myKeys :: [((KeyMask, KeySym), X ())]
myKeys =
  [ ((mod4Mask , xK_x), spawn $ "arcolinux-logout" )
  , ((mod4Mask .|. shiftMask , xK_q ), kill)
  , ((mod4Mask .|. shiftMask , xK_r ), spawn $ "xmonad --recompile && xmonad --restart")
  , ((mod4Mask .|. shiftMask , xK_l ), spawn $ "dm-tool lock")
  -- Apps
  , ((mod4Mask , xK_b ), spawn myBrowser)
  , ((mod4Mask , xK_n ), spawn myFileManager)
  -- Screenshots
  , ((noModMask, xK_Print), spawn $ "scrot -e 'mv $f /tmp && xclip -sel clip -t image/png -i /tmp/$n'")
  , ((shiftMask, xK_Print), spawn $ "sleep 0.2; scrot -sfe 'mv $f /tmp && xclip -sel clip -t image/png -i /tmp/$n'")
  , ((controlMask, xK_Print), spawn $ "scrot -ue 'mv $f /tmp && xclip -sel clip -t image/png -i /tmp/$n'")
  , ((mod4Mask, xK_Print), spawn $ "scrot -e 'mv $f ~/Pictures'")
  , ((mod4Mask .|. controlMask, xK_Print), spawn $ "scrot -ue 'mv $f ~/Pictures'")
  , ((mod4Mask .|. shiftMask, xK_Print), spawn $ "sleep 0.2; scrot -sfe 'mv $f ~/Pictures'")
  -- Media Keys
  , ((0, 0x1008FF11), spawn "amixer -q sset Master 2%-")
  , ((0, 0x1008FF13), spawn "amixer -q sset Master 2%+")
  , ((0, 0x1008FF12), spawn "amixer -D pulse set Master toggle")
  -- Named Scratchpads
  , ((mod4Mask, xK_s), namedScratchpadAction myScratchpads "terminal")
  , ((mod4Mask, xK_o), namedScratchpadAction myScratchpads "obs")
  , ((mod4Mask, xK_a), namedScratchpadAction myScratchpads "music")
  ]

main :: IO ()
main = do
  dbus <- D.connectSession
  D.requestName dbus (D.busName_ "org.xmonad.Log")
      [ D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue ]

  xmproc <- spawnPipe "xmobar $HOME/.xmobarrc"
  xmonad . ewmh $
    myBaseConfig
      { startupHook = myStartupHook
      , layoutHook = gaps [(U,35), (D,5), (R,5), (L,5)] $ myLayout ||| layoutHook myBaseConfig
      , terminal = myTerminal
      , manageHook = manageSpawn <+> myManageHook <+> manageHook myBaseConfig <+> namedScratchpadManageHook myScratchpads
      , modMask = myModMask
      , borderWidth = myBorderWidth
      , handleEventHook    = handleEventHook myBaseConfig <+> fullscreenEventHook
      , focusFollowsMouse = myFocusFollowsMouse
      , workspaces = myWorkspaces
      , focusedBorderColor = focdBord
      , normalBorderColor = normBord
      , mouseBindings = myMouseBindings
      , logHook = workspaceHistoryHook <+> myLogHook <+> dynamicLogWithPP xmobarPP
                    { ppOutput = \x -> hPutStrLn xmproc x
                    , ppCurrent = xmobarColor "#98be65" "" . wrap "[" "]" -- Current workspace
                    , ppVisible = xmobarColor "#98be65" ""                -- Visible but not current workspace
                    , ppHidden = xmobarColor "#82AAFF" "" -- . wrap "*" ""   -- Hidden workspaces in xmobar
                    , ppHiddenNoWindows = xmobarColor "#c792ea" ""        -- Hidden workspaces (no windows)
                    , ppTitle = xmobarColor "#b3afc2" "" . shorten 60     -- Title of active window in xmobar
                    , ppSep =  "<fc=#666666> <fn=1>|</fn> </fc>"          -- Separators in xmobar
                    , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"  -- Urgent workspace
                    }
      } `additionalKeys` myKeys
