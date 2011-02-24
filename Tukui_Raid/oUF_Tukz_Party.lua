local ADDON_NAME, ns = ...
local oUF = oUFTukui or oUF
assert(oUF, "Tukui was unable to locate oUF install.")



ns._Objects = {}
ns._Headers = {}

local T, C, L = unpack(Tukui) -- Import: T - functions, constants, variables; C - config; L - locales
if not C["unitframes"].enable == true then return end

local font2 = C["media"].uffont
local font1 = C["media"].font



local function Shared(self, unit)
	self.colors = T.oUF_colors
	self:RegisterForClicks("AnyUp")
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	
	self.menu = T.SpawnMenu
	
	self:SetBackdrop({bgFile = C["media"].blank, insets = {top = -T.mult, left = -T.mult, bottom = -T.mult, right = -T.mult}})
	self:SetBackdropColor(0.1, 0.1, 0.1)
	
	self:SetTemplate("Default")
	
	local health = CreateFrame('StatusBar', nil, self)
	health:Height(22)
	health:SetPoint("TOPLEFT",1,-1)
	health:SetPoint("TOPRIGHT",-1,1)
	health:SetStatusBarTexture(C["media"].normTex)
	self.Health = health

	health.bg = self.Health:CreateTexture(nil, 'BORDER')
	health.bg:SetAllPoints(self.Health)
	health.bg:SetTexture(C["media"].blank)
	health.bg:SetTexture(0.3, 0.3, 0.3)
	health.bg.multiplier = (0.3)
	self.Health.bg = health.bg
	
	health.PostUpdate = T.PostUpdatePetColor
	health.frequentUpdates = true
	
	if C.unitframes.unicolor == true then
		health.colorDisconnected = false
		health.colorClass = false
		health:SetStatusBarColor(.3, .3, .3, 1)
		health.bg:SetVertexColor(.1, .1, .1, 1)		
	else
		health.colorDisconnected = true	
		health.colorClass = true
		health.colorReaction = true			
	end
	
	health.value = T.SetFontString(health, font1, 12)
	health.value:Point("RIGHT", health, "RIGHT", -4, 0)
	health.PostUpdate = T.PostUpdateHealth
	
	
	local power = CreateFrame("StatusBar", nil, self)
	power:Height(7)
	power:Point("TOPLEFT", health, "BOTTOMLEFT", 0, -1)
	power:SetPoint("TOPRIGHT", health, "BOTTOMRIGHT", 0, -1)
	power:SetStatusBarTexture(C["media"].normTex)
	self.Power = power
	
	power.frequentUpdates = true
	power.colorDisconnected = true

	power.bg = self.Power:CreateTexture(nil, "BORDER")
	power.bg:SetAllPoints(power)
	power.bg:SetTexture(C["media"].normTex)
	power.bg:SetAlpha(1)
	power.bg.multiplier = 0.4
	self.Power.bg = power.bg
	
	if C.unitframes.unicolor == true then
		power.colorClass = true
		power.bg.multiplier = 0.1				
	else
		power.colorPower = true
	end
		
	local name = health:CreateFontString(nil, 'OVERLAY')
	name:SetFont(font2, 13*T.raidscale, "THINOUTLINE")
	name:Point("LEFT", self, "TOPLEFT", 5, 0)
	self:Tag(name, '[Tukui:namemedium] [Tukui:diffcolor][level] [Tukui:dead][Tukui:afk]')
	self.Name = name
	
	if C["unitframes"].showsymbols == true then
		RaidIcon = health:CreateTexture(nil, 'OVERLAY')
		RaidIcon:Height(14*T.raidscale)
		RaidIcon:Width(14*T.raidscale)
		RaidIcon:SetPoint("CENTER", self, "CENTER")
		RaidIcon:SetTexture("Interface\\AddOns\\Tukui\\medias\\textures\\raidicons.blp") -- thx hankthetank for texture
		self.RaidIcon = RaidIcon
	end
	
	if C["unitframes"].aggro == true then
		table.insert(self.__elements, T.UpdateThreat)
		self:RegisterEvent('PLAYER_TARGET_CHANGED', T.UpdateThreat)
		self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', T.UpdateThreat)
		self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', T.UpdateThreat)
    end
	
	local LFDRole = health:CreateTexture(nil, "OVERLAY")
    LFDRole:Height(14*T.raidscale)
    LFDRole:Width(14*T.raidscale)
	LFDRole:Point("CENTER", self, "TOPLEFT", -self:GetHeight(), 0)
	--LFDRole:SetTexture("Interface\\AddOns\\Tukui\\medias\\textures\\lfdicons.blp")
	LFDRole:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES")
	self.LFDRole = LFDRole
	
	self.DebuffHighlightAlpha = 1
	self.DebuffHighlightBackdrop = true
	self.DebuffHighlightFilter = true

	if C["unitframes"].showsmooth == true then
		health.Smooth = true
	end
	
	if C["unitframes"].showrange == true then
		local range = {insideAlpha = 1, outsideAlpha = C["unitframes"].raidalphaoor}
		self.Range = range
	end
	
	
	local portraitbg = CreateFrame("Frame", nil, self)
	portraitbg:SetTemplate("Default")
	portraitbg:SetHeight(self:GetHeight())
	portraitbg:SetWidth(self:GetHeight())
	portraitbg:ClearAllPoints()
	portraitbg:SetPoint("TOPRIGHT",self,"TOPLEFT",-2,0)
	
	local portrait = CreateFrame("PlayerModel", nil, portraitbg)
	portrait:ClearAllPoints()
	portrait:SetPoint("TOPLEFT", 1,1)
	portrait:SetPoint("BOTTOMRIGHT",-1,1)
    self.Portrait = portrait

	local ReadyCheck = portrait:CreateTexture(nil, "OVERLAY")
	ReadyCheck:Height(18*T.raidscale)
	ReadyCheck:Width(18*T.raidscale)
	ReadyCheck:SetPoint('CENTER')
	self.ReadyCheck = ReadyCheck
	
	return self
end


oUF:RegisterStyle('TukuiDpsP05', Shared)
oUF:Factory(function(self)
	oUF:SetActiveStyle("TukuiDpsP05")

	local raid = self:SpawnHeader("oUF_TukuiDpsP05", nil, "party", 
		'oUF-initialConfigFunction', [[
			local header = self:GetParent()
			self:SetWidth(header:GetAttribute('initial-width'))
			self:SetHeight(header:GetAttribute('initial-height'))
		]],
		'initial-width', T.Scale(120),
		'initial-height', T.Scale(32),
		"showParty", true, 
		"showPlayer", C["unitframes"].showplayerinparty, 
		"showRaid", false, 
		"point", "BOTTOM",
		"yOffset", T.Scale(12)
	)
	raid:SetPoint('BOTTOMLEFT', UIParent, 40, 320)
	
	local pets = {} 
		pets[1] = oUF:Spawn('partypet1', 'oUF_TukuiPartyPet1') 
		pets[1]:SetPoint('BOTTOMLEFT', raid, 'TOPLEFT', 0, 20)
		pets[1]:SetSize(T.Scale(120*T.raidscale), T.Scale(16*T.raidscale))
	for i =2, 4 do 
		pets[i] = oUF:Spawn('partypet'..i, 'oUF_TukuiPartyPet'..i) 
		pets[i]:SetPoint('BOTTOM', pets[i-1], 'TOP', 0, -8)
		pets[i]:SetSize(T.Scale(120*T.raidscale), T.Scale(16*T.raidscale))
	end
	
	local RaidMove = CreateFrame("Frame")
	RaidMove:RegisterEvent("PLAYER_LOGIN")
	RaidMove:RegisterEvent("RAID_ROSTER_UPDATE")
	RaidMove:RegisterEvent("PARTY_LEADER_CHANGED")
	RaidMove:RegisterEvent("PARTY_MEMBERS_CHANGED")
	RaidMove:SetScript("OnEvent", function(self)
		if InCombatLockdown() then
			self:RegisterEvent("PLAYER_REGEN_ENABLED")
		else
			self:UnregisterEvent("PLAYER_REGEN_ENABLED")
			local numraid = GetNumRaidMembers()
			local numparty = GetNumPartyMembers()
			if numparty > 0 and numraid == 0 or numraid > 0 and numraid <= 5 then
				for i,v in ipairs(pets) do v:Enable() end
			else
				for i,v in ipairs(pets) do v:Disable() end
			end
		end
	end)
end)