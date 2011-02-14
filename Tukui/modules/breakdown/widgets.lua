-- Default Widgets for Breakdown
-- Author: bedew
-- Description: Shows basic use of breakdown class
----------------------------------------------------------------------------------------------------
local T, C, L = unpack(Tukui) -- Import: T - functions, constants, variables; C - config; L - locales
if C["breakdown"].enable == false then return end


-- Right Breakdown
-------------------------------------------------


--create(name, widgetDirection, widgetSize, widgetSpace, automodusEnableOnLogin)
local breakdownright = breakdown.create("breakdownright","BOTTOM", 200, 4, true)

do
	--Add Minimap
	if TukuiMinimap then
		breakdownright:add({["title"] = "Map", frame = TukuiMinimap, expand = true})
	end

	--Add Recount
	if IsAddOnLoaded("Recount") then
		breakdownright:add({title = "Recount", frame = Recount.MainWindow, resize = function() Recount:ResizeMainWindow() end, expand = true})
	end

	--Add Omen
	if IsAddOnLoaded("Omen") then
		breakdownright:add({title = "Omen", frame = Omen.Anchor, resize = function() end})
	end
end
--init(AnchorPoint, AnchorFrame, AnchorFramePoint, offsetX, offsetY)
breakdownright:init("TOPLEFT", TukuiWidgetHead, "BOTTOMLEFT", 0, -4)

--initButton(buttonFrame, formatButton)
breakdownright:initButton(TukuiWidgetButton,true)

--function for automaticaly expand/collapse widgets
local breakdownrightUpdate = function(breakdown) 
	inInstance, instanceType = IsInInstance()
	isPveInstance = false
	isInCombat = UnitAffectingCombat("player")
	isMounted = IsMounted()
	if inInstance and (instanceType == "party" or instanceType == "raid") then isPveInstance = true end
	
	
	if isPveInstance and isInCombat then
		if TukuiMinimap then breakdown:AutoSetWidget("Map", false) end
		if IsAddOnLoaded("Omen") then breakdown:AutoSetWidget("Omen", true) end
	else
		if TukuiMinimap then breakdown:AutoResetWidget("Map") end
		if IsAddOnLoaded("Omen") then breakdown:AutoResetWidget("Omen") end
	end

	if isInCombat then
		if IsAddOnLoaded("Recount") then breakdown:AutoSetWidget("Recount", false) end
	else
		if IsAddOnLoaded("Recount") then breakdown:AutoResetWidget("Recount") end
	end
end
--initAutofunction(autoUpdateFunction, events)
breakdownright:initAutofunction(breakdownrightUpdate, {"ZONE_CHANGED_NEW_AREA","PLAYER_REGEN_ENABLED","PLAYER_REGEN_DISABLED"})