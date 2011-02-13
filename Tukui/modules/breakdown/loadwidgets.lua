local T, C, L = unpack(Tukui) -- Import: T - functions, constants, variables; C - config; L - locales
if C["breakdown"].enable == false then return end

local breakdownHead = TukuiWidgetHead
local breakdownButton = TukuiWidgetButton
-- Init
--------------------------------------------------

local lastitem = nil
local function InitWidget(title)
	widgetItem = breakdown:get(title)
	
	
	
	widgetItem.hideframe:SetWidth(breakdownHead:GetWidth())
	widgetItem.hideframe:SetHeight(widgetItem.frame:GetHeight())
	widgetItem.hideframe:ClearAllPoints()
	if not lastitem then
		widgetItem.hideframe:SetPoint("TOPLEFT", breakdownHead, "BOTTOMLEFT", 0 , - C["breakdown"].widgetspace)
		widgetItem.hideframe:SetParent(breakdownHead)
	else
		widgetItem.hideframe:SetPoint("TOPLEFT", lastitem.hideframe, "BOTTOMLEFT", 0 , - C["breakdown"].widgetspace)
		widgetItem.hideframe:SetParent(lastitem.hideframe)
	end
	
	if widgetItem.expand then
		breakdown:expand(title)
	else
		breakdown:collapse(title)
	end
	lastitem = widgetItem
end

local isInit = false
local function InitWidgets()
	if not isInit then
		local count = 0
		for title, widgetItem in pairs(breakdown.items) do
			InitWidget(title)
			count = count +1
		end
		-- print("Breakdown init. Found " .. count .. " widget(s)")
	end
	
	isInit = true
end

local TmpFrame = CreateFrame("Frame", nil, parent)
TmpFrame:RegisterEvent("PLAYER_LOGIN")
TmpFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		self:UnregisterEvent("PLAYER_LOGIN")
		InitWidgets()
	end
end)
