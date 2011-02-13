local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
if not(IsAddOnLoaded("Omen")) then return end

local Omen = _G.Omen
local OmenWidth = 200
local OmenHeight =  80

local function StyleOmen()
	Omen.Anchor:SetUserPlaced(nil)
	Omen:UpdateBarTextureSettings()
	Omen:UpdateBarLabelSettings()
	Omen:UpdateTitleBar()
	Omen:UpdateBackdrop()
	Omen:ReAnchorBars()
	Omen:ReAnchorLabels()
	Omen:ResizeBars()
	Omen.Anchor:SetWidth(OmenWidth)
	Omen.Anchor:SetHeight(OmenHeight)	
	OmenBarList:SetTemplate("Transparent")
	Omen.Title:Hide()
end

local TmpFrame = CreateFrame("Frame", nil, parent)
TmpFrame:RegisterEvent("PLAYER_LOGIN")
TmpFrame:SetScript("OnEvent", function(self, event, addon, ...)
	if event == "PLAYER_LOGIN" then
		self:UnregisterEvent("PLAYER_LOGIN")
		StyleOmen()
	end
end)





