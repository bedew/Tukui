local T, C, L = unpack(Tukui) -- Import: T - functions, constants, variables; C - config; L - locales
if C["breakdown"].enable == false then return end

breakdown.update = function() 
	inInstance, instanceType = IsInInstance()
	
	if (inInstance and (instanceType == "party" or instanceType == "raid")) or UnitAffectingCombat("player") then
		AutoSetWidget("Map", false)
	else
		AutoResetWidget("Map")
	end

	if UnitAffectingCombat("player") then
		AutoSetWidget("Recount", false)	
		AutoSetWidget("Omen", true)
	else
		AutoResetWidget("Omen")
		AutoResetWidget("Recount")
	end


end


local TmpFrame = CreateFrame("Frame", nil, parent)
TmpFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
TmpFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
TmpFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
TmpFrame:SetScript("OnEvent", function(self, event, ...)
	breakdown:update()
	if  event == "ZONE_CHANGED_NEW_AREA" then
		if IsInInstance() then 
			--Closing Wachtframe when entering Instance
			WatchFrame.userCollapsed = true
			WatchFrame_Collapse(WatchFrame)
		end
	end
end)