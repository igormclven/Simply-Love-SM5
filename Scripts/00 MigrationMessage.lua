local message= {}

function AddMigrationMessage(str)
	message[#message+1]= str
end

function ShowMigrationMessage()
	if #message > 0 then
		Warn("Migration message begins.")
		Warn(table.concat(message, "\n"))
		Warn("Migration message ends.")
		SCREENMAN:SystemMessage("Preferences migrated, check log for details.")
		message= {}
	end
end
