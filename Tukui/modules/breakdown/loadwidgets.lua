local T, C, L = unpack(Tukui) -- Import: T - functions, constants, variables; C - config; L - locales
if C["breakdown"].enable == false then return end


-- Init
--------------------------------------------------

local lastitem = nil
local function InitWidget(title)
	widgetItem = breakdown:get(title)
	
	
	widgetItem.hideframe:ClearAllPoints()
	widgetItem.hideframe:SetWidth(widgetHead:GetWidth())
	widgetItem.hideframe:SetHeight(widgetItem.frame:GetHeight())
	if not lastitem then
		widgetItem.hideframe:SetPoint("TOPLEFT", wC.headframe, "BOTTOMLEFT", 0 , - wC.widgetspace)
		widgetItem.hideframe:SetParent(wC.headframe)
	else
		widgetItem.hideframe:SetPoint("TOPLEFT", lastitem.hideframe, "BOTTOMLEFT", 0 , - wC.widgetspace)
		widgetItem.hideframe:SetParent(lastitem.hideframe)
	end
	
	widgetItem.expand = widgetItem.frame:IsVisible()
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
		print("Breakdown init. Found " .. count .. " widget(s)")
	end
	
	isInit = true
end

local TmpFrame = CreateFrame("Frame")
TmpFrame:RegisterEvent("PLAYER_ALIVE")
TmpFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_ALIVE" then
		self:UnregisterEvent("PLAYER_ALIVE")
		InitWidgets()
	end
end)
