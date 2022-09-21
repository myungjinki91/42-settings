#!/usr/bin/env zsh

pkill -u "${USER}" -f "^/System/Applications/System Preferences.app/Contents/MacOS/System Preferences$" 2>/dev/null

defaults write ~/Library/Preferences/ByHost/.GlobalPreferences InitialKeyRepeat 15
defaults write ~/Library/Preferences/ByHost/.GlobalPreferences KeyRepeat 2
defaults write ~/Library/Preferences/ByHost/.GlobalPreferences AppleLanguages -array ko-US en-US
defaults write ~/Library/Preferences/ByHost/.GlobalPreferences AppleLocale ko-US
defaults write ~/Library/Preferences/ByHost/.GlobalPreferences AppleMeasurementUnits Inches
defaults write ~/Library/Preferences/ByHost/.GlobalPreferences AppleTemperatureUnit Fahrenheit
defaults write ~/Library/Preferences/ByHost/.GlobalPreferences NSLinguisticDataAssetsRequested -array en en_US ko ko_US
defaults write ~/Library/Preferences/ByHost/.GlobalPreferences AppleInterfaceStyle Dark;

defaults read ~/Library/Preferences/ByHost/.GlobalPreferences

defaults write ~/Library/Preferences/.GlobalPreferences InitialKeyRepeat 15
defaults write ~/Library/Preferences/.GlobalPreferences KeyRepeat 2
defaults write ~/Library/Preferences/.GlobalPreferences AppleLanguages -array ko-US en-US
defaults write ~/Library/Preferences/.GlobalPreferences AppleLocale ko-US
defaults write ~/Library/Preferences/.GlobalPreferences AppleMeasurementUnits Inches
defaults write ~/Library/Preferences/.GlobalPreferences AppleTemperatureUnit Fahrenheit
defaults write ~/Library/Preferences/.GlobalPreferences NSLinguisticDataAssetsRequested -array en en_US ko ko_US
defaults write ~/Library/Preferences/.GlobalPreferences AppleInterfaceStyle Dark;

defaults read ~/Library/Preferences/.GlobalPreferences

pkill -u "${USER}" -l "^/usr/sbin/cfprefsd agent$" 2>/dev/null
pkill -u "${USER}" -f "^/System/Library/CoreServices/Finder.app/Contents/MacOS/Finder$" 2>/dev/null
sleep 1
