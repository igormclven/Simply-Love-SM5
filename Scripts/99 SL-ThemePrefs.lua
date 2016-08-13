local SL_CustomPrefs = {
	AllowFailingOutOfSet = true,
	NumberOfContinuesAllowed = 0,
	MusicWheelStyle = "ITG",
	AllowDanceSolo = false,
	DefaultGameMode = "Competitive",
	AutoStyle = "none",
	VisualTheme = "Hearts",
	RainbowMode = false,
	-- - - - - - - - - - - - - - - - - - - -
	-- SimplyLoveColor saves the theme color for the next time
	-- the StepMania application is started.
		-- a nice pinkish-purple, by default
	SimplyLoveColor = 3,
	-- - - - - - - - - - - - - - - - - - - -
	-- MenuTimer values for various screens
	ScreenSelectMusicMenuTimer = 300,
	ScreenPlayerOptionsMenuTimer = 90,
	ScreenEvaluationMenuTimer = 60,
	ScreenEvaluationSummaryMenuTimer = 60,
	ScreenNameEntryMenuTimer = 60,
	-- - - - - - - - - - - - - - - - - - - -
	-- Enable/Disable Certain Screens
	AllowScreenSelectProfile = false,
	AllowScreenSelectColor = true,
	AllowScreenEvalSummary = true,
	AllowScreenGameOver = true,
	AllowScreenNameEntry = true,

	settings_migrated_from_theme_prefs = false,
}

SL_Config = create_lua_config{name= "SL Config", file= "SL_Config", default= SL_CustomPrefs}
SL_Config:load()

local RemovalReasons= {
	HideStockNoteSkins= "Obsoleted by Shown Noteskins menu provided in 5.1",
	TimingWindowAdd= "Didn't vyhd explain that TimingWindowAdd is only needed on machines running a pre-r16 version of actual ITG?",
}

local ConfigData= SL_Config:get_data()
if not ConfigData.settings_migrated_from_theme_prefs then
	local file = IniFile.ReadFile("Save/ThemePrefs.ini")
	local sl_section= file["Simply Love"]
	local migration_message= {}
	if sl_section then
		AddMigrationMessage("Found Simply Love section in ThemePrefs.")
		for field, value in pairs(sl_section) do
			AddMigrationMessage("Found pref '" .. field .. "' type '" .. type(value) .. "' value '" .. tostring(value) .. "'")
			if ConfigData[field] ~= nil then
				if type(value) == type(ConfigData[field]) then
					AddMigrationMessage("Migrated successfully.")
					ConfigData[field]= value
				else
					AddMigrationMessage("Types do not match, not migrating.")
				end
			else
				if RemovalReasons[field] then
					AddMigrationMessage("Pref removed: " .. RemovalReasons[field])
				else
					AddMigrationMessage("Pref removed, unknown reason.")
				end
			end
		end
		AddMigrationMessage("Finished processing ThemePrefs section.")
	end
	ConfigData.settings_migrated_from_theme_prefs= true
	SL_Config:set_dirty()
	SL_Config:save()
end

local function SL_TimerConfig(timer_name, min)
	return nesty_options.float_config_val(SL_Config, timer_name, 0, 1, 2, min, 450)
end

function SL_GetThemePrefsMenu()
	return {
		nesty_options.choices_config_val(SL_Config, "AutoStyle", {"none", "single", "versus", "double"}),
		nesty_options.choices_config_val(SL_Config, "DefaultGameMode", {"Casual", "Competitive", "StomperZ", "Marathon"}),
		nesty_options.bool_config_val(SL_Config, "AllowFailingOutOfSet"),
		nesty_options.float_config_val(SL_Config, "NumberOfContinuesAllowed", 0, 0, 1, 0, 9),
		nesty_options.choices_config_val(SL_Config, "MusicWheelStyle", {"ITG", "IIDX"}),
		-- TODO: Music wheel speed
		nesty_options.bool_config_val(SL_Config, "AllowScreenSelectProfile"),
		nesty_options.bool_config_val(SL_Config, "AllowScreenSelectColor"),
		nesty_options.bool_config_val(SL_Config, "AllowScreenEvalSummary"),
		nesty_options.bool_config_val(SL_Config, "AllowScreenNameEntry"),
		nesty_options.bool_config_val(SL_Config, "AllowScreenGameOver"),
		nesty_options.bool_config_val(SL_Config, "AllowDanceSolo"),
		nesty_options.choices_config_val(SL_Config, "VisualTheme", {"Hearts", "Arrows"}),
		nesty_options.bool_config_val(SL_Config, "RainbowMode"),

		nesty_options.float_config_val(SL_Config, "SimplyLoveColor", 0, 0, 1, 1, 12),
		SL_TimerConfig("ScreenSelectMusicMenuTimer", 60),
		SL_TimerConfig("ScreenPlayerOptionsMenuTimer", 30),
		SL_TimerConfig("ScreenEvaluationMenuTimer", 15),
		SL_TimerConfig("ScreenEvaluationSummaryMenuTimer", 30),
		SL_TimerConfig("ScreenNameEntryMenuTimer", 15),
	}
end
