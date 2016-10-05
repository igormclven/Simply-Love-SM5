local SL_PlayerOptions = {
	JudgmentGraphic = "Love",
	BackgroundFilter = "Off",
	Vocalization = "None",
	HideTargets = false,
	HideSongBG = false,
	HideCombo = false,
	HideLifebar = false,
	HideScore = false,
	ColumnFlashOnMiss = false,
	SubtractiveScoring = false,
	MeasureCounter = "None",
	TargetStatus="Disabled",
	TargetBar=11,

	settings_migrated_from_5_0 = false,
}

local RemovalReasons = {
	NoteSkin = "Saved in profile in 5.1.",
}

local OptionConversions= {
	Mini= function(pn, config_data, value)
		-- ... every time you store a number as a string, I delay a release.
		local value_as_number= tonumber(value:sub(1, -2)) * .01
		local zoom= 1 - (value_as_number  * .5)
		notefield_prefs_config:get_data(pn).zoom= zoom
		notefield_prefs_config:set_dirty(pn)
		AddMigrationMessage("Converted Mini '" .. value .. "' to zoom '" .. zoom .. "'.")
	end,
	SpeedModType= function(pn, config_data, value)
		local type_conv= {M= "maximum", C= "constant", x= "multiple"}
		notefield_prefs_config:get_data(pn).speed_type= type_conv[value]
		notefield_prefs_config:set_dirty(pn)
		AddMigrationMessage("Converted SpeedModType ".. value .. " to " .. type_conv[value] .. ".")
	end,
	SpeedMod= function(pn, config_data, value)
		notefield_prefs_config:get_data(pn).speed_mod= value
		notefield_prefs_config:set_dirty(pn)
	end,
}

SL_PlayerConfig = create_lua_config{name= "SL PlayerOptions", file= "SL_PlayerOptions", default= SL_PlayerOptions}

local function SL_LoadProfile(profile, dir, pn)
	local old_config_path= dir .. THEME:GetThemeDisplayName() .. " UserPrefs.lua"
	if pn then
		SL_PlayerConfig:load(pn)
		local config_data= SL_PlayerConfig:get_data(pn)
		if not config_data.settings_migrated_from_5_0 then
			if FILEMAN:DoesFileExist(old_config_path) then
				AddMigrationMessage("Found old SL config for " .. pn)
				local old_config= lua.load_config_lua(old_config_path)
				if type(old_config) == "table" then
					for field, value in pairs(old_config) do
						if config_data[field] ~= nil then
							config_data[field]= value
						elseif OptionConversions[field] then
							OptionConversions[field](pn, config_data, value)
						elseif RemovalReasons[field] then
							AddMigrationMessage("Player option removed: " .. RemovalReasons[field])
						else
							AddMigrationMessage("Player option removed, unknown reason.")
						end
					end
				else
					AddMigrationMessage("Config file did not contain a table, ignoring.")
				end
			end
			config_data.settings_migrated_from_5_0 = true
			SL_PlayerConfig:set_dirty(pn)
			SL_PlayerConfig:save(pn)
			notefield_prefs_config:save(pn)
		end
	end
end

add_profile_load_callback(SL_LoadProfile)
add_profile_save_callback(standard_lua_config_profile_save(SL_PlayerConfig))

------------------------------------------------------------
-- Helper Functions for PlayerOptions
------------------------------------------------------------

local function JudgmentGraphicList()
	-- Allow users to artbitrarily add new judgment graphics to /Graphics/_judgments/
	-- without needing to modify this script;
	-- instead of hardcoding a list of judgment fonts, get directory listing via FILEMAN.
	local path = THEME:GetPathG("","_judgments/Competitive")
	if SL.Global.GameMode == "StomperZ" then
		path = THEME:GetPathG("", "_judgments/StomperZ")
	end

	local files = FILEMAN:GetDirListing(path .. "/")
	local judgmentGraphics = {}

	for k,filename in ipairs(files) do

		-- A user might put something that isn't a suitable judgment graphic
		-- into /Graphics/_judgments/ (also sometimes hidden files like .DS_Store show up here).
		-- Do our best to filter out such files now.
		if string.match(filename, " %dx%d") then
			-- use regexp to get only the name of the graphic, stripping out the extension
			local name = filename:gsub(" %dx%d", ""):gsub(" %(doubleres%)", ""):gsub(".png", "")

			-- The 3_9 graphic is a special case;
			-- we want it to appear in the options with a period (3.9 not 3_9).
			if name == "3_9" then name = "3.9" end

			-- Dynamically fill the table.
			-- Love is a special case; it should always be first.
			if name == "Love" then
				table.insert(judgmentGraphics, 1, name)
			else
				judgmentGraphics[#judgmentGraphics+1] = name
			end
		end
	end

	-- always have "None" appear last
	judgmentGraphics[#judgmentGraphics+1] = "None"

	return judgmentGraphics
end

local function VocalizationList()
	-- Allow users to artbitrarily add new vocalizations to ./Simply Love/Other/Vocalize/
	-- and have those vocalizations be automatically detected
	local files = FILEMAN:GetDirListing(GetVocalizeDir() , true, false)
	local vocalizations = { "None" }

	for k,dir in ipairs(files) do
		-- Dynamically fill the table.
		vocalizations[#vocalizations+1] = dir
	end

	if #vocalizations > 1 then
		vocalizations[#vocalizations+1] = "Random"
		vocalizations[#vocalizations+1] = "Blender"
	end
	return vocalizations
end

local TargetBarChoices= {
	'C-', 'C', 'C+', 'B-', 'B', 'B+', 'A-', 'A', 'A+', 'S-', 'S', 'S+', '☆', '☆☆', '☆☆☆', '☆☆☆☆', 'Machine best', 'Personal best' }
-- TODO:  Fix TargetBar menu to show the grade choices instead of numbers. -kyz

function SL_GetPlayerOptionsMenu()
	return {
		nesty_options.choices_config_val(SL_PlayerConfig, "JudgmentGraphic", JudgmentGraphicList()),
		nesty_options.choices_config_val(SL_PlayerConfig, "BackgroundFilter", { 'Off','Dark','Darker','Darkest' }),
		nesty_options.choices_config_val(SL_PlayerConfig, "Vocalization", VocalizationList()),
		nesty_options.bool_config_val(SL_PlayerConfig, "HideTargets"),
		nesty_options.bool_config_val(SL_PlayerConfig, "HideSongBG"),
		nesty_options.bool_config_val(SL_PlayerConfig, "HideCombo"),
		nesty_options.bool_config_val(SL_PlayerConfig, "HideLifebar"),
		nesty_options.bool_config_val(SL_PlayerConfig, "HideScore"),
		nesty_options.bool_config_val(SL_PlayerConfig, "ColumnFlashOnMiss"),
		nesty_options.bool_config_val(SL_PlayerConfig, "SubtractiveScoring"),
		nesty_options.choices_config_val(SL_PlayerConfig, "MeasureCounter", { "None", "8th", "12th", "16th", "24th", "32nd" }),
		nesty_options.choices_config_val(SL_PlayerConfig, "TargetStatus", { 'Disabled', 'Bars', 'Target', 'Both' }),
		nesty_options.float_config_val(SL_PlayerConfig, "TargetBar", 0, 0, 0, 1, #TargetBarChoices),
	}
end

function ApplyMods(pn)
	local playeroptions = GAMESTATE:GetPlayerState(pn):get_player_options_no_defect("ModsLevel_Preferred")
	local mods= SL_PlayerConfig:get_data(pn)
	playeroptions:Dark(mods.HideTargets and 1 or 0)
	playeroptions:Cover(mods.HideSongBG and 1 or 0)
end

local preferred_option_names= {
	"LifeSetting", "DrainSetting", "BatteryLives",
	"Boost", "Brake", "Wave", "Expand", "Boomerang", "Drunk", "Dizzy",
	"Confusion", "Mini", "Tiny", "Flip", "Invert", "Tornado", "Tipsy", "Bumpy",
	"Beat", "Xmode", "Twirl", "Roll", "Hidden", "HiddenOffset", "Sudden",
	"SuddenOffset", "Stealth", "Blink", "RandomVanish", "Reverse", "Split",
	"Alternate", "Cross", "Centered", "RandomSpeed",
	"Dark", "Blind", "Cover",
	"RandAttack", "NoAttack", "PlayerAutoPlay",
	"Tilt", "Skew",
	"Passmark",
	"TurnNone", "Mirror", "Backwards", "Left", "Right", "Shuffle",
	"SoftShuffle", "SuperShuffle", "NoHolds", "NoRolls", "NoMines", "Little",
	"Wide", "Big", "Quick", "BMRize", "Skippy", "Mines", "AttackMines", "Echo",
	"Stomp", "Planted", "Floored", "Twister", "HoldRolls", "NoJumps",
	"NoHands", "NoLifts", "NoFakes", "NoQuads", "NoStretch", "MuteOnError",
	"FailSetting", "MinTNSToHideNotes",
}
function GetPreferredOptionLevels(pn)
	local option_values= {}
	local options=GAMESTATE:GetPlayerState(pn):get_player_options_no_defect("ModsLevel_Preferred")
	for name in ivalues(preferred_option_names) do
		option_values[name]= options[name](options)
	end
	return option_values
end

function RestorePreferredOptionLevels(pn, option_values)
	local options=GAMESTATE:GetPlayerState(pn):get_player_options_no_defect("ModsLevel_Preferred")
	for name, value in pairs(option_values) do
		options[name](options, value)
	end
end

------------------------------------------------------------
-- Define what custom OptionRows there are, and override the
-- generic OptionRow (defined later, below) for each as necessary.

local Overrides = {
	-------------------------------------------------------------------------
	DecentsWayOffs = {
		Choices = function() return { "On", "Decents Only", "Off" } end,
		OneChoiceForAllPlayers = true,
		LoadSelections = function(self, list, pn)
			local choice = SL.Global.ActiveModifiers.DecentsWayOffs or "On"
			local i = FindInTable(choice, self.Choices) or 1
			list[i] = true
		end,
		SaveSelections = function(self, list, pn)

			local mods = SL.Global.ActiveModifiers

			for i=1,#self.Choices do
				if list[i] then
					mods.DecentsWayOffs = self.Choices[i]
				end
			end

			if list[2] then
				PREFSMAN:SetPreference("TimingWindowSecondsW4", SL.Preferences[SL.Global.GameMode].TimingWindowSecondsW4)
				PREFSMAN:SetPreference("TimingWindowSecondsW5", SL.Preferences[SL.Global.GameMode].TimingWindowSecondsW4)
			elseif list[3] then
				PREFSMAN:SetPreference("TimingWindowSecondsW4", SL.Preferences[SL.Global.GameMode].TimingWindowSecondsW3)
				PREFSMAN:SetPreference("TimingWindowSecondsW5", SL.Preferences[SL.Global.GameMode].TimingWindowSecondsW3)
			else
				PREFSMAN:SetPreference("TimingWindowSecondsW4", SL.Preferences[SL.Global.GameMode].TimingWindowSecondsW4)
				PREFSMAN:SetPreference("TimingWindowSecondsW5", SL.Preferences[SL.Global.GameMode].TimingWindowSecondsW5)
			end
		end
	},
	-------------------------------------------------------------------------
}
