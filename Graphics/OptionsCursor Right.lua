return Def.ActorFrame {
	InitCommand= function(self) self:setsize(2, 26) end,
	Def.Quad {
		Name="CursorRight";
		InitCommand=cmd(zoomto,2,26;);
	}
};
