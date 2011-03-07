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
	
	-- self:SetBackdrop({bgFile = C["media"].blank, insets = {top = -T.mult, left = -T.mult, bottom = -T.mult, right = -T.mult}})
	-- self:SetBackdropColor(0.1, 0.1, 0.1)
	
	-- self:SetTemplate("Default")
	
	
	if unit == "partytarget" then
	-- backdrop for every units
	self:SetBackdrop(backdrop)
	self:SetBackdropColor(0, 0, 0)

	-- this is the glow border
	self:CreateShadow("Default")
	
	------------------------------------------------------------------------
	--	Features we want for all units at the same time
	------------------------------------------------------------------------
	
	-- here we create an invisible frame for all element we want to show over health/power.
	local InvFrame = CreateFrame("Frame", nil, self)
	InvFrame:SetFrameStrata("HIGH")
	InvFrame:SetFrameLevel(5)
	InvFrame:SetAllPoints()
	
	-- symbols, now put the symbol on the frame we created above.
	local RaidIcon = InvFrame:CreateTexture(nil, "OVERLAY")
	RaidIcon:SetTexture("Interface\\AddOns\\Tukui\\medias\\textures\\raidicons.blp") -- thx hankthetank for texture
	RaidIcon:SetHeight(20)
	RaidIcon:SetWidth(20)
	RaidIcon:SetPoint("BOTTOM", 0, -11)
	self.RaidIcon = RaidIcon
	
		local health = CreateFrame('StatusBar', nil, self)
		health:Height(self:GetHeight())
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetStatusBarTexture(C["media"].normTex)

		health.frequentUpdates = true
		health.colorDisconnected = true
		if C["unitframes"].showsmooth == true then
			health.Smooth = true
		end
		health.colorClass = true
		
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
		healthBG:SetTexture(.1, .1, .1)

		health.value = T.SetFontString(health, font1,12, "OUTLINE")
		health.value:Point("LEFT", 2, 0)
		health.PostUpdate = T.PostUpdateHealth
				
		self.Health = health
		self.Health.bg = healthBG
		
		health.frequentUpdates = true
		if C["unitframes"].showsmooth == true then
			health.Smooth = true
		end
		
		if C["unitframes"].unicolor == true then
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(.3, .3, .3, 1)
			healthBG:SetVertexColor(.1, .1, .1, 1)		
		else
			health.colorDisconnected = true
			health.colorClass = true
			health.colorReaction = true	
		end
	
		
		
		-- names
		local Name = health:CreateFontString(nil, "OVERLAY")
		Name:SetPoint("BOTTOM", health, "TOP", 0, 0)
		Name:SetJustifyH("CENTER")
		Name:SetFont(font1, 12, "OUTLINE")
		Name:SetShadowColor(0, 0, 0)
		Name:SetShadowOffset(1.25, -1.25)
		
		self:Tag(Name, '[Tukui:getnamecolor][Tukui:namelong]')
		self.Name = Name
		
		
	else
	
		local portraitbg = CreateFrame("Frame", nil, self)
		-- portraitbg:SetTemplate("Default")
		portraitbg:SetHeight(self:GetHeight() * 1.20)
		portraitbg:SetWidth(self:GetHeight() * 1.20)
		portraitbg:ClearAllPoints()
		portraitbg:SetPoint("TOPLEFT",self,"TOPLEFT",-2,0)
		portraitbg:CreateShadow("Default")
	
		local portrait = CreateFrame("PlayerModel", nil, portraitbg)
		portrait:ClearAllPoints()
		portrait:SetPoint("TOPLEFT", 1,1)
		portrait:SetPoint("BOTTOMRIGHT",-1,1)
		self.Portrait = portrait
			
		
			
		local healthbg = CreateFrame('Frame', nil, self)
		--healthbg:SetBackdrop({bgFile = C["media"].blank, insets = {top = -T.mult, left = -T.mult, bottom = -T.mult, right = -T.mult}})
		--healthbg:SetBackdropColor(0.1, 0.1, 0.1)
		--healthbg:SetTemplate("Default")
		healthbg:SetPoint("TOPLEFT",portraitbg,"TOPRIGHT" , 4, 0)
		healthbg:SetPoint("TOPRIGHT",self,"TOPRIGHT" , -10, 0)
		healthbg:SetHeight(self:GetHeight() * 0.74)
		healthbg:CreateShadow("Default")
		self.healthbg = healthbg
		
		local health = CreateFrame('StatusBar', nil, healthbg)
		health:SetHeight(healthbg:GetHeight())
		health:SetPoint("TOPLEFT",0,-0)
		health:SetPoint("TOPRIGHT",0,0)
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
		health.value:Point("LEFT", health, "LEFT", 4, 0)
		health.PostUpdate = T.PostUpdateHealth
		
		local power = CreateFrame("StatusBar", nil, health)
		power:SetHeight(healthbg:GetHeight()  -8 )
		power:SetWidth(10)
		power:SetPoint("BOTTOMRIGHT", healthbg, "BOTTOMRIGHT", -4, 4)
	
		
		power:SetStatusBarTexture(C["media"].normTex)
		power:SetOrientation('VERTICAL')
		power.frequentUpdates = true
		power.colorDisconnected = true
		self.Power = power

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
			
		
		if C["unitframes"].showsymbols == true then
			RaidIcon = health:CreateTexture(nil, 'OVERLAY')
			RaidIcon:Height(14*T.raidscale)
			RaidIcon:Width(14*T.raidscale)
			RaidIcon:SetPoint("CENTER", healthbg, "CENTER")
			RaidIcon:SetTexture("Interface\\AddOns\\Tukui\\medias\\textures\\raidicons.blp") -- thx hankthetank for texture
			self.RaidIcon = RaidIcon
		end

		if C["unitframes"].showrange == true then
			local range = {insideAlpha = 1, outsideAlpha = C["unitframes"].raidalphaoor}
			self.Range = range
		end
			
		local name = health:CreateFontString(nil, 'OVERLAY')
		name:SetFont(font2, 13*T.raidscale, "THINOUTLINE")
		name:Point("BOTTOMLEFT", healthbg, "TOPLEFT", 2, 2)
		self:Tag(name, '[Tukui:getnamecolor][Tukui:namelong]   [Tukui:dead] [Tukui:afk]')
		self.Name = name
		
		if C["unitframes"].showsmooth == true then
			health.Smooth = true
		end
	
		if C["unitframes"].aggro == true then
			table.insert(self.__elements, T.UpdateThreat)
			self:RegisterEvent('PLAYER_TARGET_CHANGED', T.UpdateThreat)
			self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', T.UpdateThreat)
			self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', T.UpdateThreat)
		end
		
		local level = portrait:CreateFontString(nil, 'OVERLAY')
		level:SetFont(font2, 12, "THINOUTLINE")
		level:Point("BOTTOMRIGHT", portrait, "BOTTOMRIGHT", 1, 1)
		self:Tag(level, '[Tukui:diffcolor][level]')
		self.Level = level
		
		local LFDRole = portrait:CreateTexture(nil, "OVERLAY")
		LFDRole:Height(18*T.raidscale)
		LFDRole:Width(18*T.raidscale)
		LFDRole:Point("CENTER", portrait, "BOTTOMLEFT", 2, -6)
		--LFDRole:SetTexture("Interface\\AddOns\\Tukui\\medias\\textures\\lfdicons.blp")
		LFDRole:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES")
		LFDRole:SetBlendMode("DISABLE")
		self.LFDRole = LFDRole
		
	
		
		self.DebuffHighlightAlpha = 1
		self.DebuffHighlightBackdrop = true
		self.DebuffHighlightFilter = true

		
	
		
		local ReadyCheck = portrait:CreateTexture(nil, "OVERLAY")
		ReadyCheck:Height(18*T.raidscale)
		ReadyCheck:Width(18*T.raidscale)
		ReadyCheck:SetPoint('CENTER')
		self.ReadyCheck = ReadyCheck
		
		
		-- leader icon
		local Leader = portrait:CreateTexture(nil, "OVERLAY")
		Leader:Height(14)
		Leader:Width(14)
		Leader:Point("CENTER", portrait, "TOPLEFT", 2, 0)
		self.Leader = Leader
		
		
	
		local buffs = CreateFrame("Frame", nil, self)
		buffs:SetPoint("TOPLEFT", healthbg, "BOTTOMLEFT", 0, -4)
		buffs:SetHeight(21.5)
		buffs:SetWidth(self:GetWidth() / 2)
		buffs.size = 21.5
		buffs.num = 4
		buffs.spacing = 2
		buffs.initialAnchor = 'TOPLEFT'
		buffs.PostCreateIcon = T.PostCreateAura
		buffs.PostUpdateIcon = T.PostUpdateAura
		buffs.onlyShowPlayer = true
		self.Buffs = buffs	
		
		local debuffs = CreateFrame("Frame", nil, self)
		debuffs:SetHeight(21.5)
		debuffs:SetWidth(self:GetWidth() / 2)
		debuffs:SetPoint("TOPRIGHT", healthbg, "BOTTOMRIGHT", 2, -6)
		debuffs.size = 21.5	
		debuffs.num = 4
		debuffs.spacing = 2
		debuffs.initialAnchor = 'TOPRIGHT'
		debuffs["growth-y"] = "UP"
		debuffs["growth-x"] = "LEFT"
		debuffs.PostCreateIcon = T.PostCreateAura
		debuffs.PostUpdateIcon = T.PostUpdateAura
		--debuffs.onlyShowPlayer = true
		self.Debuffs = debuffs
		
		
		local CombatFeedbackText = T.SetFontString(health, font1, 12, "OUTLINE")
		CombatFeedbackText:SetPoint("RIGHT", health, "RIGHT", -14, 0)
		CombatFeedbackText.colors = {
			DAMAGE = {0.69, 0.31, 0.31},
			CRUSHING = {0.69, 0.31, 0.31},
			CRITICAL = {0.69, 0.31, 0.31},
			GLANCING = {0.69, 0.31, 0.31},
			STANDARD = {0.84, 0.75, 0.65},
			IMMUNE = {0.84, 0.75, 0.65},
			ABSORB = {0.84, 0.75, 0.65},
			BLOCK = {0.84, 0.75, 0.65},
			RESIST = {0.84, 0.75, 0.65},
			MISS = {0.84, 0.75, 0.65},
			HEAL = {0.33, 0.59, 0.33},
			CRITHEAL = {0.33, 0.59, 0.33},
			ENERGIZE = {0.31, 0.45, 0.63},
			CRITENERGIZE = {0.31, 0.45, 0.63},
		}
		self.CombatFeedbackText = CombatFeedbackText

		
		--HealPrediction
		local mhpb = CreateFrame('StatusBar', nil, self.Health)
		mhpb:SetPoint('TOPLEFT', self.Health:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
		mhpb:SetPoint('BOTTOMLEFT', self.Health:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
		if T.lowversion then
			mhpb:SetWidth(186)
		else
			mhpb:SetWidth(250)
		end
		mhpb:SetStatusBarTexture(normTex)
		mhpb:SetStatusBarColor(0, 1, 0.5, 0.25)
		mhpb:SetMinMaxValues(0,1)

		local ohpb = CreateFrame('StatusBar', nil, self.Health)
		ohpb:SetPoint('TOPLEFT', mhpb:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
		ohpb:SetPoint('BOTTOMLEFT', mhpb:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
		ohpb:SetWidth(250)
		ohpb:SetStatusBarTexture(normTex)
		ohpb:SetStatusBarColor(0, 1, 0, 0.25)

		self.HealPrediction = {
			myBar = mhpb,
			otherBar = ohpb,
			maxOverflow = 1,
		}
	end
	return self
end


oUF:RegisterStyle('TukuiDpsP05', Shared)
oUF:Factory(function(self)
	oUF:SetActiveStyle("TukuiDpsP05")

	local raid = self:SpawnHeader("oUF_TukuiDpsP05", nil, "party", 
		'oUF-initialConfigFunction', ([[
				local header = self:GetParent()
				local ptarget = header:GetChildren():GetName()
				self:SetWidth(%d)
				self:SetHeight(%d)
				for i = 1, 5 do
					if ptarget == "oUF_TukuiDpsP05UnitButton"..i.."Target" then
						header:GetChildren():SetWidth(%d)
						header:GetChildren():SetHeight(%d)		
					end
				end
			]]):format(T.Scale(240), T.Scale(40), T.Scale(100), T.Scale(25)),	
		"showParty", true, 
		"showPlayer", true, --C["unitframes"].showplayerinparty
		"showRaid", false, 
		"point", "BOTTOM",
		"yOffset", T.Scale(38),
		'template', 'DPSPartyTarget'
	)
	raid:SetPoint('BOTTOMLEFT', UIParent, 8, 320)
	
	local pets = {} 
		pets[1] = oUF:Spawn('partypet1', 'oUF_TukuiPartyPet1') 
		pets[1]:SetPoint('BOTTOMLEFT', raid, 'TOPLEFT', 0, 40)
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