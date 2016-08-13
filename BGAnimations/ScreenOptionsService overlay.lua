return Def.Actor{
	BeginCommand=function(self)
		--HACK: Handle ThemePrefsRows' lack of support for ExportOnChange and SaveSelections.
		-- I should really just move to kyzentun's preference system...
		MESSAGEMAN:Broadcast("BackgroundImageChanged")
	end
}
