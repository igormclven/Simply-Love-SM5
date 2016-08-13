local t = Def.ActorFrame{}

if SL_Config:get_data().RainbowMode then
	t[#t+1] = Def.Quad{
		InitCommand=function(self) self:FullScreen():Center():diffuse( Color.White ) end
	}
end

t[#t+1] = LoadActor( THEME:GetPathB("", "_shared background normal"))

return t
