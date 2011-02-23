local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

if not C["general"].autohideonfight then return end

local autohideFrames = {	
						TukuiChatBackgroundRight, 
						TukuiChatBackgroundLeft,
						TukuiBar5,
						ChatFrame1Tab,ChatFrame2Tab,ChatFrame3Tab,ChatFrame4Tab
						}
						
						
local function hideFrames()
	for i, frame in pairs(autohideFrames) do
		frame:Hide()
	end
end


local function showFrames()
	for i, frame in pairs(autohideFrames) do
		frame:Show()
	end
end						
						
local autohide = CreateFrame('Frame')
-- autohide:RegisterEvent('PLAYER_ENTERING_WORLD')
autohide:RegisterEvent("PLAYER_REGEN_ENABLED")
autohide:RegisterEvent("PLAYER_REGEN_DISABLED")
autohide:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_ENTERING_WORLD" then
	elseif event == "PLAYER_REGEN_DISABLED" then
		--OnFight
		hideFrames()
	elseif event == "PLAYER_REGEN_ENABLED" then
		-- OnFightEnds
		showFrames()
	end
	
end)

--[[
local function PlayerFrame_AnimPos(self, fraction)
  return "TOPLEFT", UIParent, "TOPLEFT", -19, fraction*140-4;
end
 
local PlayerFrameAnimTable = {
  totalTime = 0.3,
  updateFunc = "SetPoint",
  getPosFunc = PlayerFrame_AnimPos,
  }
function PlayerFrame_AnimateOut(self)
  self.inSeat = false;
  self.animFinished = false;
  self.inSequence = true;
  SetUpAnimation(PlayerFrame, PlayerFrameAnimTable, PlayerFrame_AnimFinished, false)
end
 
function PlayerFrame_AnimFinished(self)
  self.animFinished = true;
  PlayerFrame_UpdateArt(self);
end
 
function PlayerFrame_UpdateArt(self)
  if ( self.animFinished and self.inSeat and self.inSequence) then
    SetUpAnimation(PlayerFrame, PlayerFrameAnimTable, PlayerFrame_SequenceFinished, true)
    if ( UnitHasVehicleUI("player") ) then
      PlayerFrame_ToVehicleArt(self, UnitVehicleSkin("player"));
    else
      PlayerFrame_ToPlayerArt(self);
    end
  end
end
--]]