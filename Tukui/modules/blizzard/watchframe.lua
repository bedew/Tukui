local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

local TukuiWatchFrame = CreateFrame("Frame", "TukuiWatchFrame", UIParent)
TukuiWatchFrame:RegisterEvent("PLAYER_ENTERING_WORLD")



-- to be compatible with blizzard option
local wideFrame = GetCVar("watchFrameWidth")

-- create our moving area
local TukuiWatchFrameAnchor = CreateFrame("Button", "TukuiWatchFrameAnchor", UIParent)
TukuiWatchFrameAnchor:SetFrameStrata("HIGH")
TukuiWatchFrameAnchor:SetFrameLevel(20)
TukuiWatchFrameAnchor:SetHeight(20)
TukuiWatchFrameAnchor:SetClampedToScreen(true)
TukuiWatchFrameAnchor:SetMovable(true)
TukuiWatchFrameAnchor:EnableMouse(false)
TukuiWatchFrameAnchor:SetTemplate("Default")
TukuiWatchFrameAnchor:SetBackdropBorderColor(0,0,0,0)
TukuiWatchFrameAnchor:SetBackdropColor(0,0,0,0)
TukuiWatchFrameAnchor.text = T.SetFontString(TukuiWatchFrameAnchor, C.media.uffont, 12)
TukuiWatchFrameAnchor.text:SetPoint("CENTER")
TukuiWatchFrameAnchor.text:SetText(L.move_watchframe)
TukuiWatchFrameAnchor.text:Hide()

local watchframebutton = CreateFrame("Frame","TukuiWatchFrameCollapseExpandButton", UIParent)
watchframebutton:CreatePanel("Default",21,19,"TOPRIGHT",UIParent, "TOPRIGHT",-((C["general"].widgetwidth - 25)+4+24),-12)
watchframebutton:SetFrameStrata(WatchFrameHeader:GetFrameStrata())
watchframebutton:SetFrameLevel(WatchFrameHeader:GetFrameLevel() + 1)
watchframebutton:FontString("text", C.media.font, 12)
watchframebutton.text:SetText("X")
watchframebutton.text:Point("CENTER", 1, 0)

-- set default position according to how many right bars we have
TukuiWatchFrameAnchor:SetPoint("TOPRIGHT", UIParent,  "TOPRIGHT", -C["general"].widgetwidth - 20,0)

-- width of the watchframe according to our Blizzard cVar.
if wideFrame == "1" then
	TukuiWatchFrame:SetWidth(350)
	TukuiWatchFrameAnchor:SetWidth(350)
else
	TukuiWatchFrame:SetWidth(250)
	TukuiWatchFrameAnchor:SetWidth(250)
end

local screenheight = T.getscreenheight
TukuiWatchFrame:SetParent(TukuiWatchFrameAnchor)
TukuiWatchFrame:SetHeight(screenheight / 1.6)
TukuiWatchFrame:ClearAllPoints()
TukuiWatchFrame:SetPoint("TOP")

local function init()
	TukuiWatchFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
	TukuiWatchFrame:RegisterEvent("CVAR_UPDATE")
	TukuiWatchFrame:SetScript("OnEvent", function(_,_,cvar,value)
		if cvar == "WATCH_FRAME_WIDTH_TEXT" then
			if not WatchFrame.userCollapsed then
				if value == "1" then
					TukuiWatchFrame:SetWidth(350)
					TukuiWatchFrameAnchor:SetWidth(350)
				else
					TukuiWatchFrame:SetWidth(250)
					TukuiWatchFrameAnchor:SetWidth(250)
				end
			end
			wideFrame = value
		end
	end)
	if C["general"].questwatchheight > 0 then
		TukuiWatchFrame:SetHeight(C["general"].questwatchheight)
	end
	
end

local function ResetWatchFrame()
	if GetNumQuestWatches() > 0 then
		RemoveQuestWatch(GetQuestIndexForWatch(1))
		WatchFrame_Update()
		QuestLog_Update()
		ResetWatchFrame()
	end
end

local function CleanWatchFrame()
	local i = 1
	while GetQuestLogTitle(i) do
		local questTitle, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID = GetQuestLogTitle(i)
		if ( not isHeader ) and ( isComplete) then
			if IsQuestWatched(i) then RemoveQuestWatch(i) end
	end
	i = i + 1
	end
	WatchFrame_Update()
	QuestLog_Update()
end

local function CleanByRegionWatchFrame()
	local i = 1
	local lastHeader = ""
	while GetQuestLogTitle(i) do
		local questTitle, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID = GetQuestLogTitle(i)
		if ( isHeader )  then
			lastHeader = questTitle
		elseif lastHeader == GetZoneText() then
			AddQuestWatch(i)
		else
			RemoveQuestWatch(i)
		end
		i = i + 1
	end
	WatchFrame_Update()
	QuestLog_Update()
end


local function SetExpandCollapseButtonText()
	if WatchFrame.collapsed then 
		TukuiWatchFrameCollapseExpandButton.text:SetText("-")
	else 
		TukuiWatchFrameCollapseExpandButton.text:SetText("X") 
	end 
end

local function CollapseWatchFrame()
	WatchFrame.userCollapsed = true
	WatchFrame_Collapse(WatchFrame)
	SetExpandCollapseButtonText()
end

local function ExpandWatchFrame()
	WatchFrame.userCollapsed = true
	WatchFrame_Expand(WatchFrame)
	SetExpandCollapseButtonText()
end

local function ToggleWatchFrame()
	if WatchFrame.collapsed then 
		ExpandWatchFrame()
	else
		CollapseWatchFrame()
	end
end



local function setup()	
	WatchFrame:SetParent(TukuiWatchFrame)
	WatchFrame:SetFrameStrata("MEDIUM")
	WatchFrame:SetFrameLevel(3)
	WatchFrame:SetClampedToScreen(false)
	WatchFrame:ClearAllPoints()
	WatchFrame.ClearAllPoints = function() end
	WatchFrame:SetPoint("TOPLEFT", 32,-8)
	WatchFrame:SetPoint("BOTTOMRIGHT", 4,0)
	WatchFrame.SetPoint = T.dummy

	WatchFrameTitle:SetParent(TukuiWatchFrame)
	
	
	SetExpandCollapseButtonText()
	watchframebutton:EnableMouse(true)
	watchframebutton:SetScript("OnMouseDown", function(self, button) 
	-- WatchFrameCollapseExpandButton:StyleButton()
		if button == "RightButton" then
			local menu = {
							{text = "Entferne alle Quests", func = function() ResetWatchFrame(); end, notCheckable = true },
							{text = "Entferne alle Abgeschlossenen Quest", func = function() CleanWatchFrame(); end, notCheckable = true},
							{text = "Zeige Quests f\195\188r " .. GetZoneText(), func = function() CleanByRegionWatchFrame(); end, notCheckable = true},
							{text = "Questlog", func = function() if QuestLogFrame:IsVisible() then QuestLogFrame:Hide() else QuestLogFrame:Show() end end, notCheckable = true},
						 }
			local menuFrame = CreateFrame("Frame", "DropdownMenuWatchFrameButton", UIParent, "UIDropDownMenuTemplate")

			-- Make the menu appear at the cursor: 
			EasyMenu(menu, menuFrame, "cursor", 0 , 0, "MENU");
		else
			ToggleWatchFrame()
		end
	end)
	
	
	WatchFrameTitle:Kill()
	WatchFrameCollapseExpandButton:Kill()
	
	--Autohide Watchframelog on entering Instance 
	local TmpFrame = CreateFrame("Frame", nil, parent)
	TmpFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	TmpFrame:SetScript("OnEvent", function(self, event, ...)
		if  event == "ZONE_CHANGED_NEW_AREA" then
			if IsInInstance() then 
				CollapseWatchFrame()
			end
		end
	end)
end

------------------------------------------------------------------------
-- Execute setup after we enter world
------------------------------------------------------------------------

local f = CreateFrame("Frame")
f:Hide()
f.elapsed = 0
f:SetScript("OnUpdate", function(self, elapsed)
	f.elapsed = f.elapsed + elapsed
	if f.elapsed > .5 then
		setup()
		f:Hide()
	end
end)
TukuiWatchFrame:SetScript("OnEvent", function() if not IsAddOnLoaded("Who Framed Watcher Wabbit") or not IsAddOnLoaded("Fux") then init() f:Show() end end)