-- ShowMigrationMessage is called to handle any migration message that was
-- logged during profile loading.   Players can't look at the log file on
-- the arcade machine, so maybe the message should show more for them? -Kyz
ShowMigrationMessage()
reset_needs_defective_field_for_all_players()


local t = Def.ActorFrame{
	ChangeStepsMessageCommand=function(self, params)
		self:playcommand("StepsHaveChanged", {Direction=params.Direction, Player=params.Player})
	end
}

-- Each file contains the code for a particular screen element.
-- I've made this table ordered so that I can specificy
-- a desired draworder later below.

local files = {
	-- make the MusicWheel appear to cascade down
	"./MusicWheelAnimation.lua",
	-- Apply player modifiers from profile
	"./PlayerModifiers.lua",
	-- Graphical Banner
	"./Banner.lua",
	-- Song Artist, BPM, Duration (Referred to in other themes as "PaneDisplay")
	"./SongDescription.lua",
	-- Difficulty Blocks
	"./StepsDisplayList/Grid.lua",
	-- a folder of Lua files to be loaded twice (once for each player)
	"./PerPlayer",
	-- MenuTimer code for preserving SSM's timer value
	"./MenuTimer.lua",
	-- overlay for sorting the MusicWheel, hidden by default
	"./SortMenu/default.lua"
}

for index, file in ipairs(files) do
	t[#t+1] = LoadActor(file)..{
		InitCommand=cmd(draworder, index)
	}
end

return t
