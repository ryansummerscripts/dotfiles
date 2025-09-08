#!/usr/bin/env bash

clear

# RS Dotfiles v1.0 (For Mac Studio/Desktops)
# Updated 09/08/2025

# Note:
# - For Intel, just comment out the last 3 lines under 'Apple Intelligence'.
# - For VM's using UTM, enabling/disabling Time Machine Auto Backup does not work.
#   If not using UTM & you want to disable Time Machine Auto Backup, uncomment the line below under '💾 [Disks]'.

# Colors and formatting
BO=$'\033[1m'
GR=$'\033[1;32m'
RE=$'\033[1;31m'
BL=$'\033[1;34m'
YE=$'\033[1;33m'
CY=$'\033[1;36m'
NC=$'\033[0m'

# Function to test if Terminal has Full Disk Access
has_full_disk_access() {
    # Example: reading ~/Library/Mail requires FDA
    test -r "$HOME/Library/Mail"
}

# Close System Preferences/Settings first before opening it again
osascript -e 'tell application "System Preferences" to quit'
sleep 1

# prompt to allow Terminal Full Disk Access
open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"

# Wait until Terminal is granted Full Disk Access
echo "🔑 ${GR}Waiting for Terminal to be granted Full Disk Access...${NC}"
until has_full_disk_access; do
    sleep 2
done
echo
echo "✅ ${GR}Terminal now has Full Disk Access.${NC}"

# Close System Preferences/Settings again to prevent them from overriding settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until this script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
echo

# ====== Writing of new preferences starts here ======
echo "🆕 [NEW for macOS Sequoia 15]"
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false
defaults write com.apple.WindowManager EnableTilingByEdgeDrag -bool false
defaults write com.apple.WindowManager EnableTopTilingByEdgeDrag -bool false
defaults write com.apple.WindowManager EnableTilingOptionAccelerator -bool true
defaults write com.apple.WindowManager EnableTiledWindowMargins -bool false 
defaults write com.apple.Passwords EnableMenuBarExtra -bool true

# disable Apple Intelligence
# key is different on each machine
# example: defaults write com.apple.CloudSubscriptionFeatures.optIn 1234567890 -bool false
# so we dynamically get key from domain by assuming default value is true
for key in $(defaults read com.apple.CloudSubscriptionFeatures.optIn 2>/dev/null | grep -E "^\s+[0-9]+ = 1;" | awk '{print $1}'); do
    defaults write com.apple.CloudSubscriptionFeatures.optIn "$key" -bool false
done

defaults write com.apple.assistant.support "Search Queries Data Sharing Status" -int 2 
defaults write com.apple.universalaccess closeViewZoomScreenShareEnabledKey -bool true 
defaults write com.apple.universalaccess closeViewZoomIndividualDisplays -bool true
# defaults write com.apple.controlcenter EnergyModeModule -int 9   # for laptops only
defaults write com.apple.bird com.apple.clouddocs.unshared.moveOut.suppress 1 # for macOS Sequoia only - for older macOS's use 'defaults write com.apple.finder FXEnableRemoveFromICloudDriveWarning -bool true'


echo "♿️ [Accessibility] ⚠️  ${YE}(Terminal requires Full Disk Access to writ3 changes)${NC}"
defaults write com.apple.universalaccess closeViewHotkeysEnabled -bool true
defaults write com.apple.universalaccess closeViewPanningMode -bool false
defaults write com.apple.universalaccess closeViewZoomFocusFollowModeKey -bool true
defaults write com.apple.universalaccess closeViewZoomFocusMovement -bool false

echo "⚓️ [Dock]"
defaults write com.apple.dock showhidden -bool true 
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-time-modifier -float 0.0
defaults write com.apple.dock autohide-delay -float 0.0
defaults write com.apple.dock mineffect -string scale
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock show-recents -bool false
# defaults write com.apple.dock show-process-indicators -bool true   # depreciated/on by default now
defaults write com.apple.dock tilesize -int 36
defaults write com.apple.dock persistent-apps -array

echo "🔄 [Automatic Updates]"
# softwareupdate schedule -string off   # not sure if this works anymore so we use the commands below
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool false
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool false
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate ConfigDataInstall -bool false
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall -bool false
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticallyInstallMacOSUpdates -bool false

echo "⚙️  [System & UI]"
defaults write NSGlobalDomain AppleWindowTabbingMode -string always
defaults write NSGlobalDomain AppleShowScrollBars -string Always
defaults write NSGlobalDomain AppleScrollerPagingBehavior -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain NSCloseAlwaysConfirmsChanges -bool true
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool true
defaults -currentHost write com.apple.universalcontrol Disable -bool true
# defaults write com.apple.dashboard mcx-disabled -bool true    # depreciated/no longer used on newer macOS's
# sudo launchctl /System/Library/LaunchAgents/com.apple.notificationcenterui unload # depreciated/no longer used on newer macOS's

echo "🪄 [Animations]"
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
defaults write com.apple.finder DisableAllAnimations -bool true
defaults write NSGlobalDomain QLPanelAnimationDuration -float 0.0
defaults write com.apple.dock expose-animation-duration -float 0.1
# defaults write NSGlobalDomain com.apple.springing.delay -float 0.2    # enable if desired

echo "💾 [Disks]"
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.DiskUtility SidebarShowAllDevices -bool true
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
# defaults write /Library/Preferences/com.apple.TimeMachine AutoBackup -bool false    # doesn't work on UTM VMs

echo "📁 [Finder]"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults com.apple.finder NSWindowTabbingShoudShowTabBarKey-com.apple.finder.TBrowserWindow -bool true
chflags nohidden ~/Library
defaults write com.apple.finder FinderSpawnTab -bool true
defaults write com.apple.finder NewWindowTarget -string PfDe
# defaults write com.apple.finder NewWindowTargetPath file://${HOME}/Desktop/    # not necessary unless choosing a location other than the desktop
defaults write com.apple.finder FXPreferredViewStyle -string Nlsv
defaults write com.apple.finder FXDefaultSearchScope -string SCcf
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 1
# defaults write com.apple.finder AppleShowAllFiles -bool true    # doesn't seem to be persistent on newer macOS's so i just use ⇧ ⌘ . to manually show hidden files
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# defaults write com.apple.finder FXEnableRemoveFromICloudDriveWarning -bool true    # depreciated/for older macOS's
defaults write com.apple.finder ShowRecentTags -bool false
defaults write com.apple.finder SidebarWidth -int 143
defaults write com.apple.finder FK_SidebarWidth -int 143
# Expand/collapse the following File Info panes:

# add custom keyboard shortcuts for all apps - this needs more testing
# defaults write com.apple.finder NSUserKeyEquivalents '{
#     "Get Info" = "@~i";
#     "Show Inspector" = "@i"; 
#     "Show Next Tab" = "@~\\U2192";
#     "Show Previous Tab" = "@~\\U2190";
# }'

# customize the Get Info panes
defaults write com.apple.finder FXInfoPanesExpanded -dict \
    General -bool true \
    Comments -bool false \
    MetaData -bool true \
    Name -bool true \
    OpenWith -bool true \
    Preview -bool false \
    Privileges -bool true

# Toolbar icons - specific to my prefs so it's commented out
# defaults write com.apple.finder 'NSToolbar Configuration Browser' '{
#     "TB Default Item Identifiers" =     (
#         "com.apple.finder.BACK",
#         "com.apple.finder.SWCH",
#         NSToolbarSpaceItem,
#         "com.apple.finder.ARNG",
#         "com.apple.finder.SHAR",
#         "com.apple.finder.LABL",
#         "com.apple.finder.ACTN",
#         NSToolbarSpaceItem,
#         "com.apple.finder.SRCH"
#     );
#     "TB Display Mode" = 2;
#     "TB Icon Size Mode" = 1;
#     "TB Is Shown" = 1;
#     "TB Item Identifiers" =     (
#         "com.apple.finder.BACK",
#         "com.apple.finder.loc ",
#         "com.apple.finder.AirD",
#         "com.apple.finder.CNCT",
#         "com.apple.finder.NFLD",
#         "com.apple.finder.SHAR",
#         "com.apple.finder.SWCH",
#         NSToolbarSpaceItem,
#         "com.apple.finder.ACTN",
#         NSToolbarSpaceItem,
#         "com.apple.finder.SRCH"
#     );
#     "TB Size Mode" = 1;
# }'

# Show item info near icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandatandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

# Show item info below the icons on the desktop
/usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set FK_StandardViewSettings:IconViewSettings:labelOnBottom true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set StandardViewSettings:IconViewSettings:labelOnBottom true" ~/Library/Preferences/com.apple.finder.plist

# Enable sort-by-name for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy name" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy name" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy name" ~/Library/Preferences/com.apple.finder.plist

# Set text size to 14
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:textSize 14" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:textSize 12" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:textSize 12" ~/Library/Preferences/com.apple.finder.plist

# Increase the size of icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 72" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 64" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 72" ~/Library/Preferences/com.apple.finder.plist

# Increase grid spacing for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 71" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 54" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 71" ~/Library/Preferences/com.apple.finder.plist


echo "📸 [Screencapture, Photo & Video]"
defaults write com.apple.screencapture disable-shadow -bool true
defaults write com.apple.screencapture type -string jpg
defaults write com.apple.screencapture show-thumbnail -bool false
defaults write com.apple.screencapture showsClicks -bool true
# defaults write com.apple.screencapture showsCursor -bool false    # I don't use this but it's possible to show the cursor during screenshots if desired
defaults write com.apple.QuickTimePlayerX MGPlayMovieOnOpen -bool true
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true
defaults write com.apple.screencapture include-date -bool false

echo "🖱️  [Mouse]"
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
defaults write NSGlobalDomain com.apple.mouse.scaling -int 5
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode -string TwoButton

echo "💻 [TrackPad]"
defaults write NSGlobalDomain com.apple.trackpad.scaling -int 3
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true

echo "⌨️  [Keyboard]"
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain AppleKeyboardUIMode -int 2
defaults write com.apple.HIToolbox AppleFnUsageType -int 2
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

echo "📋 [Menu Bar & Control Center] ${YE}(To prevent clutter, I hide all and just use Control Center 👍)${NC}"
defaults write NSGlobalDomain AppleMenuBarVisibleInFullscreen -bool true
# defaults -currentHost write com.apple.controlcenter "NSStatusItem Visible BentoBox" -bool true    # Control Center is shown by default in menu bar, but it's possible to hide it if desired
defaults -currentHost write com.apple.controlcenter WiFi -int 8   # off by default anyway
defaults -currentHost write com.apple.controlcenter Bluetooth -int 8    # off by default anyway
defaults -currentHost write com.apple.controlcenter AirDrop -int 8    # off by default anyway
defaults -currentHost write com.apple.controlcenter FocusModes -int 8   # Don't Show Focus in menu bar. - Use '-int 18' for 'Always Show in Menu Bar' or '-int 2' for 'Show When Active' (Default)
defaults -currentHost write com.apple.controlcenter StageManager -int 8
defaults -currentHost write com.apple.controlcenter ScreenMirroring -int 8
defaults -currentHost write com.apple.controlcenter Display -int 8
defaults -currentHost write com.apple.controlcenter Sound -int 8
defaults -currentHost write com.apple.controlcenter NowPlaying -int 8
defaults -currentHost write com.apple.controlcenter AccessibilityShortcuts -int 9
defaults write com.apple.controlcenter MusicRecognition -int 12
defaults write com.apple.controlcenter Hearing -int 8
defaults write com.apple.controlcenter VoiceControl -int 8
defaults -currentHost write com.apple.controlcenter UserSwitcher -int 8
defaults -currentHost write com.apple.controlcenter Siri -int 8
defaults write com.apple.menuextra.clock ShowSeconds -bool true

defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.TimeMachine" -bool true
/usr/libexec/PlistBuddy -c "Add :menuExtras: string '/System/Library/CoreServices/Menu Extras/TimeMachine.menu'" ~/Library/Preferences/com.apple.systemuiserver.plist

# Show VPN in Menu Bar - only works if you already have a VPN configuration set up
# commented out for now as I usually run this script before installing a VPN
# defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.vpn" -bool true
# /usr/libexec/PlistBuddy -c "Add :menuExtras: string '/System/Library/CoreServices/Menu Extras/VPN.menu'" ~/Library/Preferences/com.apple.systemuiserver.plist

defaults write com.apple.TextInputMenu visible -bool true
sudo defaults write /Library/Preferences/com.apple.RemoteManagement.plist LoadRemoteManagementMenuExtra -bool true

# uncomment for laptops
# echo "📋 [Menu Bar & Control Center] (For Laptops Only)"
# defaults -currentHost com.apple.controlcenter Battery -int 3    # always shown
# defaults -currentHost com.apple.controlcenter BatteryShowPercentage -int 1    # always shown
# defaults -currentHost com.apple.controlcenter KeyboardBrightness -int 3    # always shown

echo "📶 [Connectivity]"
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true
defaults -currentHost write com.apple.controlcenter AirplayReceiverEnabled -bool false

echo "📝 [TextEdit]"
defaults write com.apple.TextEdit NSWindowTabbingShoudShowTabBarKey-NSWindow-DocumentWindowController-DocumentWindowController-VT-FS -int 1
defaults write com.apple.TextEdit NSShowAppCentricOpenPanelInsteadOfUntitledFile -bool false
defaults write com.apple.TextEdit RichText -bool false
defaults write com.apple.TextEdit NSNavPanelExpandedStateForSaveMode -bool true
defaults write com.apple.TextEdit NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write com.apple.TextEdit NSNavPanelFileListModeForSaveMode2 -int 2
defaults write com.apple.TextEdit NSNavPanelFileLastListModeForSaveModeKey -int 2
defaults write com.apple.TextEdit NSFixedPitchFontSize -int 14

echo "👾 [Terminal]"
defaults write com.apple.Terminal NSWindowTabbingShoudShowTabBarKey-TTWindow-TTWindowController-TTWindowController-VT-FS -int 1

echo "🗜️  [Archive Utility]"
defaults write com.apple.archiveutility dearchive-move-after "~/.Trash"
defaults write com.apple.archiveutility archive-move-after "~/.Trash"
defaults write com.apple.archiveutility dearchive-reveal-after -bool false

echo "🌐 [Safari - General] ⚠️  ${YE}(Terminal requires Full Disk Access to read/write changes)${NC}"
defaults write ~/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari AlwaysShowTabBar -int 1
defaults write ~/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari ShowOverlayStatusBar -bool true
defaults write ~/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari ShowFavoritesBar-v2 -bool true
defaults write ~/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari AlwaysRestoreSessionAtLaunch -bool true
defaults write ~/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari NewWindowBehavior -int 1
defaults write ~/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari NewTabBehavior -int 1
defaults write ~/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari AutoOpenSafeDownloads -bool false

echo "[Safari - Tabs]"
defaults write ~/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari EnableNarrowTabs -bool false
defaults write ~/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari ShowStandaloneTabBar -bool true
defaults write ~/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari CloseTabsAutomatically -bool false
defaults write ~/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari OpenNewTabsInFront -bool false

echo "[Safari - AutoFill]"
defaults write ~/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari AutoFillFromAddressBook -bool false
defaults write ~/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari AutoFillPasswords -bool false
defaults write ~/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari AutoFillCreditCardData -bool false
defaults write ~/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari AutoFillMiscellaneousForms -bool false

echo "[Safari - Search]"
defaults write ~/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari SearchProviderShortName -string DuckDuckGo
defaults write ~/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari PrivateSearchEngineUsesNormalSearchEngineToggle -bool true
defaults write ~/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari SuppressSearchSuggestions -bool true
defaults write ~/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari WebsiteSpecificSearchEnabled -bool false
defaults write ~/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari PreloadTopHit -bool false
defaults write ~/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari ShowFavoritesUnderSmartSearchField -bool false
defaults write ~/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari PrivateSearchEngineUsesNormalSearchEngineToggle -bool true

echo "[Safari - Security]"
defaults write com.apple.Safari.SafeBrowsing SafeBrowsingEnabled -bool true
defaults write ~/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari WarnAboutFraudulentWebsites -bool true
defaults write ~/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari UseHTTPSOnly -bool true
defaults write ~/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari PrivateBrowsingRequiresAuthentication -bool true
defaults write ~/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari CanPromptForPushNotifications -bool false

echo "[Safari - Advanced]"
defaults write ~/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari ShowFullURLInSmartSearchField -bool true
defaults write ~/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari EnableEnhancedPrivacyInRegularBrowsing -bool true
defaults write ~/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari WebKitPreferences.privateClickMeasurementEnabled -bool false
defaults write com.apple.Safari.SandboxBroker ShowDevelopMenu -bool true

# Disable custom Spotlight items from being indexed    # 1=on, 0=off
echo "🔍 [Spotlight]"
defaults write com.apple.spotlight orderedItems -array \
'{"enabled" = 1;"name" = "APPLICATIONS";}' \
'{"enabled" = 0;"name" = "MENU_EXPRESSION";}' \
'{"enabled" = 0;"name" = "CONTACT";}' \
'{"enabled" = 0;"name" = "MENU_CONVERSION";}' \
'{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
'{"enabled" = 0;"name" = "DOCUMENTS";}' \
'{"enabled" = 0;"name" = "EVENT_TODO";}' \
'{"enabled" = 0;"name" = "DIRECTORIES";}' \
'{"enabled" = 0;"name" = "FONTS";}' \
'{"enabled" = 0;"name" = "IMAGES";}' \
'{"enabled" = 0;"name" = "MESSAGES";}' \
'{"enabled" = 0;"name" = "MOVIES";}' \
'{"enabled" = 0;"name" = "MUSIC";}' \
'{"enabled" = 0;"name" = "MENU_OTHER";}' \
'{"enabled" = 0;"name" = "PDF";}' \
'{"enabled" = 0;"name" = "PRESENTATIONS";}' \
'{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}' \
'{"enabled" = 0;"name" = "SPREADSHEETS";}' \
'{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
'{"enabled" = 0;"name" = "TIPS";}' \
'{"enabled" = 0;"name" = "BOOKMARKS";}' \
'{"enabled" = 0;"name" = "SOURCE";}'
sleep 1

# Load new settings before rebuilding the index
killall mds > /dev/null 2>&1
sleep 1

# Make sure indexing is enabled for the main volume
sudo mdutil -i on / > /dev/null
sleep 1

# Rebuild the index from scratch
sudo mdutil -E / > /dev/null
sleep 1

# Keka (Install First) - needs more testing so it's commented out
# defaults write com.aone.keka # fix array syntax
#     "com.aone.keka" =     {
#         7zzComposeOnCompression = 1;
#         7zzDecomposeOnExtraction = 1;
#         ActivateOnNewOperation = 1;
#         AlreadyLovedKeka = 0;
#         AlreadyShownLoved = 0;
#         AlwaysAskCompressionPassword = 0;
#         AppearanceCustomDockTile = 1;
#         AppearanceDifferentiateTasksCountInDock = 0;
#         AppearanceShowDockIcon = 1;
#         AppearanceSquishFaceInDock = 1;
#         ApplyQuarantineAfterExtraction = 1;
#         ArchiveSingle = 0;
#         AskZipUsingAES = 0;
#         BackgroundQoSOnBattery = 0;
#         CalculateMD5 = 0;
#         CloseController = 1;
#         CreateSFX = 0;
#         CustomNameMultipleFiles = "";
#         CustomNameSingleFile = "";
#         DMGFormat = 0;
#         DefaultActionToPerform = 0;
#         DefaultAppDialog = 0;
#         DefaultExtractLocationController = 2;
#         DefaultExtractLocationSet = "";
#         DefaultFormat = ZIP;
#         DefaultMethod = 3;
#         DefaultNameController = 1;
#         DefaultSaveLocationController = 1;
#         DefaultSaveLocationSet = "";
#         DefaultSoundCompression = 1;
#         DefaultSoundExtraction = 2;
#         DeleteAfterCompression = 1;
#         DeleteAfterExtraction = 1;
#         DevLog = 0;
#         DevLogAll = 0;
#         DevLogNotifications = 0;
#         DevLogReader = 0;
#         DevSaveLog = 0;
#         Encryption = 1;
#         ExcludeMacForks = 1;
#         ExportPassword = 0;
#         ExtractOnIntermediateFolder = 0;
#         ExtractionExcludeMacForks = 0;
#         ExtractionFolderRenameExtension = 1;
#         ExtractionPreselectedEncoding = "utf-8";
#         FallbackOption = 0;
#         FinderAfterCompression = 0;
#         FinderAfterExtraction = 0;
#         ForceHFSDMG = 1;
#         ForceTarballOnCompressionOnly = 1;
#         GrowlBlocksExit = 1;
#         IgnoreGZIPName = 0;
#         KeepExtension = 0;
#         KekaAskBeforeCancel = 1;
#         KekaLaunchTimes = 289;
#         LastLogsCompressionDate = "2025-08-23 04:03:34 +0000";
#         Legacy19007zSupport = 1;
#         LetsMoveDialog = 0;
#         LimitThreads = 0;
#         MaximumThreads = 0;
#         NSNavPanelExpandedSizeForOpenMode = "{800, 448}";
#         NSNavPanelExpandedSizeForSaveMode = "{800, 448}";
#         NSOSPLastRootDirectory = {length = 1352, bytes = 0x626f6f6b 48050000 00000410 30000000 ... 0c040000 00000000 };
#         "NSToolbar Configuration AdvancedWindowToolbar" =         {
#             "TB Display Mode" = 2;
#             "TB Icon Size Mode" = 1;
#             "TB Is Shown" = 1;
#             "TB Size Mode" = 1;
#         };
#         "NSToolbar Configuration PreferencesWindowToolbar" =         {
#             "TB Display Mode" = 1;
#             "TB Icon Size Mode" = 1;
#             "TB Is Shown" = 1;
#             "TB Size Mode" = 1;
#         };
#         "NSWindow Frame AdvancedWindow" = "{{1452, 1155}, {336, 408}}";
#         "NSWindow Frame NSNavPanelAutosaveName" = "560 1535 800 448 0 1080 1920 1055 ";
#         "NSWindow Frame PreferencesWindow" = "903 393 679 353 0 0 1920 1055 ";
#         "NSWindow Frame SUStatusFrame" = "760 1770 400 135 0 1080 1920 1055 ";
#         "NSWindow Frame SUUpdateAlert" = "650 492 620 398 0 0 1920 1055 ";
#         "NSWindow Frame TasksWindow" = "598 452 404 80 0 0 1920 1055 ";
#         OldServicesChecked = 1;
#         QoS = "-1";
#         QueueCompression = 1;
#         QueueCompressionLimit = 1;
#         QueueExtraction = 1;
#         QueueExtractionLimit = 2;
#         QueueGlobal = 1;
#         QueueGlobalLimit = 2;
#         RemoveBadPasswordExtraction = 1;
#         RemoveIncompleteExtraction = 0;
#         RemoveKekaQuarantineIfPossible = 1;
#         ResizableWindows = 0;
#         RetryPassword = 1;
#         ReusePassword = 1;
#         SUAutomaticallyUpdate = 1;
#         SUEnableAutomaticChecks = 0;
#         SUHasLaunchedBefore = 1;
#         SULastCheckTime = "2025-08-05 19:46:39 +0000";
#         SUSendProfileInfo = 0;
#         SelectedMethod = 3;
#         SelectedTab = ZIP;
#         SelectedTabDefaults = 1000;
#         SetAsDefaultApp = 0;
#         SetModificationDateAfterExtraction = 0;
#         ShowCompressionPassword = 0;
#         ShowExtractionPassword = 0;
#         SilentlyIgnoreTrailingGarbage = 0;
#         SkipQuarantineSlowdownDetection = 0;
#         SolidArchive = 1;
#         SparkleDialog = 1;
#         TarballSupport = 1;
#         UnifiedToolbar = 1;
#         UnrarWithP7ZIP = 0;
#         UnzipWithUNAR = 1;
#         Use7zz = 1;
#         UseCustomNameWithMultipleFiles = 1;
#         UseDefaultPasswordOnAdvancedWindow = 0;
#         UseDefaultPasswordOnCompressions = 0;
#         UseDefaultPasswordOnExtractions = 0;
#         UseGrowl = 1;
#         UseHapticFeedback = 1;
#         UseISO9660 = 0;
#         UseLongTarballExtension = 1;
#         UseMultithreadLzip = 1;
#         UseParentName = 0;
#         VerifyCompression = 0;
#         Version = 5613;
#         WelcomeWindowSafeDelay = "0.03";
#         ZipUsingAES = 1;
#     };

# Kill affected applications
echo "🔄 ${BO}Restarting Services...${NC}"
sleep 2
killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true
killall ControlCenter 2>/dev/null || true
killall UniversalAccessApp 2>/dev/null || true
killall cfprefsd 2>/dev/null || true
sleep 2
echo
echo "✅ ${GR}Done. Note that some of these changes require a restart"
echo "   in order to take effect.${NC}"
