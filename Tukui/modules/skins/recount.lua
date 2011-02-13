local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
if not(IsAddOnLoaded("Recount")) then return end

local Recount = _G.Recount
local RecountWidth = 200
local RecountHeight = 100

local function StyleRecount()
		Recount.MainWindow:SetTemplate("Transparent")
		
		Recount.db.profile.MainWindow.Buttons.CloseButton = false;  
		Recount:SetupMainWindowButtons()
		
		Recount.MainWindow:SetWidth(RecountWidth)
		Recount.MainWindow:SetHeight(RecountHeight)
				
			
		Recount.db.profile.Locked = true;
		Recount:LockWindows(true)
		
end

local TmpFrame = CreateFrame("Frame", nil, parent)
TmpFrame:RegisterEvent("PLAYER_LOGIN")
TmpFrame:SetScript("OnEvent", function(self, event, addon, ...)
	if event == "PLAYER_LOGIN" then
		self:UnregisterEvent("PLAYER_LOGIN")
		StyleRecount()
	end
end)

