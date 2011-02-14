local T, C, L = unpack(Tukui) -- Import: T - functions, constants, variables; C - config; L - locales
if C["breakdown"].enable == false then return end

breakdown.update = function() 
	inInstance, instanceType = IsInInstance()
	isPveInstance = false
	isInCombat = UnitAffectingCombat("player")
	isMounted = IsMounted()
	if inInstance and (instanceType == "party" or instanceType == "raid") then isPveInstance = true end
	
	
	if isPveInstance and isInCombat then
		if TukuiMinimap then AutoSetWidget("Map", false) end
		if IsAddOnLoaded("Omen") then AutoSetWidget("Omen", true) end
	else
		if TukuiMinimap then AutoResetWidget("Map") end
		if IsAddOnLoaded("Omen") then AutoResetWidget("Omen") end
	end

	if isInCombat then
		if IsAddOnLoaded("Recount") then AutoSetWidget("Recount", false) end
	else
		if IsAddOnLoaded("Recount") then AutoResetWidget("Recount") end
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