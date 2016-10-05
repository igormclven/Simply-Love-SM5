# TODO

## Theme stuff for dbk2
* Icons in Graphics/menu_icons need to be redrawn.
* ScreenThemeOptions needs styling on the menu.
* ScreenNestyPlayerOptions needs styling on the menu.
* ScreenEditMenu needs styling on the menu.  The actors on the screen are now provided by the theme, so the workarounds used in the underlay should not be necessary.
* ScreenEdit option_menu needs styling on the menu.
* Resolve whether TimingWindowAdd needs to be in SL_Config.
* Figure out a good solution for showing players a message when their profile has been migrated to the lua config system.

## Theme stuff for kyz
* Translation strings for ScreenThemeOptions and ScreenNestyPlayerOptions.
* Add a ScreenEdit overlay that allows toggling slow music rate and adjusting scroll speed with hot keys.
* Handle the DecentsWayOffs preference.
* Move ColumnFlashOnMiss to NoteColumn layers so it can stick to the columns properly when mods occur.  (Mini handling is broken for the moment)
* Move ScreenFilter to NoteField layers so it can stick to the field properly when mods occur.
* Put hold judgments in NoteColumn layers if they're used.
* JudgmentGraphic needs to be fixed.
* Convert OptionRowLongAndMarathonTime options.
* Menu timer on ScreenNestyPlayerOptions.

## Engine stuff
* The engine needs a way for the theme to create noteskin actors.
* Add a way to show the grade values for the target bar in the nesty menu.
* Add time support to adjustable_float.
* Better custom actors in nesty option items so that little heart can be put in without writing a custom item class.
* Show newfield prefs in mods string.


# DONE

* Added MigrationMessage script for handling messages related to migrating prefs.
* Moved ThemePrefs to lua config system.  Object named SL_Config.  Old theme config is loaded and migrated.
* Moved ActiveModifiers player options to SL_PlayerConfig.  Old player options are loaded securely so it can't be exploited by djpohly when migrating.
* Added ScreenNestyPlayerOptions to replace ScreenPlayerOptions.  Simply Love's special options are in a submenu.
* Changed ScreenThemeOptions to be a nesty menu in lua to fit with the lua config theme prefs.
* Changed code that tried to protect preferred player options to use the PlayerOptions functions instead of the string format because fetching the string format triggers defective mode.
* Use SongOptions to change MusicRate instead of ApplyGameCommand in ScreenEditMenu underlay.
* Updated RollingNumbers on ScreenEval in accordance with prophecy.
* OptionsCursor parts use setsize on the ActorFrame because the nesty cursor code uses zooming to resize.
* Removed SL-CustomProfiles script.  Special loading function for handling migration is in SL-PlayerOptions.
* Removed CustomOptionRow function as it is no longer needed.
