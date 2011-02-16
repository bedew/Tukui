-- Breakdown class
-- Author: bedew
-- Description: Class to provide "expand/collapse" feeling to WoW
----------------------------------------------------------------------------------------------------
local T, C, L = unpack(Tukui) -- Import: T - functions, constants, variables; C - config; L - locales

local lastitems = {}
local function InitWidget(widgetItem, anchorPoint, anchorFrame, anchorFramePoint, offsetX, offsetY)
	local lastitem = lastitems[widgetItem.breakdown.title]
	
	
	--Format and size hideframe
	widgetItem.hideframe:ClearAllPoints()
	widgetItem.hideframe:SetWidth(widgetItem.breakdown.widgetSize)
	widgetItem.hideframe:SetHeight(widgetItem.frame:GetHeight())	
	if lastitem then
		if widgetItem.breakdown.widgetDirection == "TOP" then
			widgetItem.hideframe:SetPoint("BOTTOM", lastitem.hideframe, widgetItem.breakdown.widgetDirection, 0, widgetItem.breakdown.widgetSpace)
			--widgetItem.frame:SetWidth(widgetItem.breakdown.widgetSize)
		elseif widgetItem.breakdown.widgetDirection == "BOTTOM" then
			widgetItem.hideframe:SetPoint("TOP", lastitem.hideframe, widgetItem.breakdown.widgetDirection, 0, -widgetItem.breakdown.widgetSpace)
			--widgetItem.frame:SetWidth(widgetItem.breakdown.widgetSize)
		elseif widgetItem.breakdown.widgetDirection == "RIGHT" then
			widgetItem.hideframe:SetPoint("LEFT", lastitem.hideframe, widgetItem.breakdown.widgetDirection, widgetItem.breakdown.widgetSpace, 0)
			--widgetItem.frame:SetHeight(widgetItem.breakdown.widgetSize)
		elseif widgetItem.breakdown.widgetDirection == "LEFT" then
			widgetItem.hideframe:SetPoint("RIGHT", lastitem.hideframe, widgetItem.breakdown.widgetDirection, -widgetItem.breakdown.widgetSpace, 0)
			--widgetItem.frame:SetHeight(widgetItem.breakdown.widgetSize)
		else
			print("Direction for breakdown " .. widgetItem.breakdown.title .. " not know")
		end
		widgetItem.hideframe:SetParent(lastitem.hideframe)
	else
		--First widget dock to maindock
		widgetItem.hideframe:SetPoint(anchorPoint, anchorFrame, anchorFramePoint, offsetX, offsetY)
		widgetItem.hideframe:SetParent(anchorFrame)
	end
	
	
	
		
	-- Expand or Collapse on INIT
	if widgetItem.expand then
		widgetItem.breakdown:expand(widgetItem.title)
	else
		widgetItem.breakdown:collapse(widgetItem.title)
	end
	lastitems[widgetItem.breakdown.title] = widgetItem
end

-- CORE   	BREAKDOWN
---------------------------------------
breakdown = {}
breakdown.__index = breakdown




function breakdown.create(name, widgetDirection, widgetSize, widgetSpace, automodusEnable)
	local acnt = CreateFrame("Frame", name .. "Frame", UIParent)        
	setmetatable(acnt,breakdown)
	acnt.title = name
	acnt.automodus = automodusEnable
	acnt.widgetSize = widgetSize
	acnt.widgetSpace = widgetSpace
	acnt.widgetDirection = widgetDirection
	acnt.isinit = false
	acnt.formatButton = false
	acnt.widgets = {}
	return acnt
end

function breakdown:init(AnchorPoint, AnchorFrame, AnchorFramePoint, offsetX, offsetY)
	if not self.isinit then
		local count = 0
		for _, widgetItem in pairs(self.widgets) do
			InitWidget(widgetItem, AnchorPoint, AnchorFrame, AnchorFramePoint, offsetX, offsetY)
			count = count +1
		end
		self.isinit = true
	else
		print("Breakdown " .. self.title .. " already init")
	end
end

function breakdown:initButton(buttonFrame, formatButton)
	self.formatButton = formatButton
	self.buttonFrame = buttonFrame
	buttonFrame:EnableMouse(true)
	buttonFrame:SetScript("OnMouseUp", function(selfButtonFrame, btn)
		if btn == "RightButton" then
			local menuList = {}
			for title, widgetItem in pairs(self.widgets) do
				table.insert(menuList, {text = title, func = function(selfButton) self:toggle(selfButton:GetText()) end, checked = function(selfButton) return self:isexpand(selfButton:GetText()) end})
			end
			 
			table.insert(menuList,{text = "Alle anzeigen",func = function() self:expandall() end, notCheckable = true})
			table.insert(menuList,{text = "Alle verstecken",func = function() self:collapesall() end, notCheckable = true})
			
			local AutohideText = nil		
			if self:isauto() then 
				AutohideText = "Automdodus (abschalten)"
			else
				AutohideText = "Automdodus (einschalten)"
			end
			table.insert(menuList,{text = AutohideText,func = function() self:toggleauto() end, checked = self:isauto()})
			local menuFrame = CreateFrame("Frame", "DropdownWidgetMenuFrame", UIParent, "UIDropDownMenuTemplate")
			EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 2)
		
		else
		
			self:toggleauto()
		end
	end)
	
	self:UpdateButtonText()

end

function breakdown:initAutofunction(autoUpdateFunction, events)
	self.autoUpdateFunction = autoUpdateFunction
	self.autoUpdateFrame = CreateFrame("Frame", self.title .. "AutoFrame", UIParent) 
	for _, event in pairs(events) do
		self.autoUpdateFrame:RegisterEvent(event)
	end
	self.autoUpdateFrame:SetScript("OnEvent", function(selfUpdateFrame, event, ...) self:autoUpdate() end)
end

function breakdown:autoUpdate()
	self:autoUpdateFunction(self)
	self:UpdateButtonText()	
end

function breakdown:add(widgetItem)
	widgetItem.hideframe = CreateFrame("Frame", self.title .. widgetItem.title .. "Hideframe", widgetItem.frame)
	widgetItem.breakdown = self
	-- widgetItem.hideframe:SetTemplate("Default")
	self.widgets[widgetItem.title] = widgetItem
end

function breakdown:get(title)
	if not self.widgets[title] then
		if not title then title = "NIL" end
		print("Failed, could not found widget for title: " .. title .. " in breakdown " .. self.title)
		return
	end
	return self.widgets[title]
end

function breakdown:collapse(title)
	-- print("Collapse " .. title)
	local widgetItem = self:get(title)
	widgetItem.hideframe:SetHeight(1)
	widgetItem.frame:Hide()
	widgetItem.expand = false
end

function breakdown:expand(title)
	-- print("Expand " .. title)
	local widgetItem = self:get(title)
	widgetItem.hideframe:Show()
	widgetItem.hideframe:SetHeight(widgetItem.frame:GetHeight())
	widgetItem.frame:Show()
	widgetItem.expand = true
	
	widgetItem.frame:ClearAllPoints()
	widgetItem.frame:SetPoint("TOPLEFT",widgetItem.hideframe,"TOPLEFT")
	
	if widgetItem.resize then
		widgetItem:resize()
	end
	
end

function breakdown:isexpand(title)
	local widgetItem = self:get(title)
	return widgetItem.expand
end

function breakdown:toggle(title)
	if self:isexpand(title) then
		self:collapse(title)
	else
		self:expand(title)
	end
end

function breakdown:collapesall()
	for title, widgetItem in pairs(self.widgets) do
		self:collapse(title)
	end
end

function breakdown:expandall()
	for title, widgetItem in pairs(self.widgets) do
		self:expand(title)
	end
end

function breakdown:toggleauto()
	if self.automodus then 
		self.automodus = false
	else
		self.automodus = true
	end
	self:autoUpdate()
end

function breakdown:isauto()
	return self.automodus
end


-- Set widget to given status and save it so you can reset the autostatus only if automdus enabled
function breakdown:AutoSetWidget(title, expand)
	if not self:isauto() then return end
	local widgetItem = self:get(title)
	
	
	if widgetItem == nil then
		print("Couldn't not found WidgetItem " .. title .. " but you try to AutoSet it")
		return
	end
	
	if expand and not  self:isexpand(title) then
		widgetItem.autoCollapse = nil
		widgetItem.autoExpand = true
		self:expand(title)
	elseif not expand and widgetItem.expand then
		widgetItem.autoExpand = nil
		widgetItem.autoCollapse = true
		self:collapse(title)
	end
end

-- Reset widget if in automodus and widget is change by automodus
function breakdown:AutoResetWidget(title)
	if not self:isauto() then return end
	local widgetItem = self:get(title)
	
	if widgetItem == nil then
		print("Couldn't not found WidgetItem " .. title .. " but you try to AutoReset it")
		return
	end
	if widgetItem.autoExpand then
		self:collapse(title)
	end
	
	if widgetItem.autoCollapse then
		self:expand(title)
	end
	
	widgetItem.autoExpand = nil
	widgetItem.autoCollapse = nil
end

function breakdown:UpdateButtonText()
	if self.formatButton and self.buttonFrame then
		if not self.buttonFrame.text then
			buttonFrame:FontString("text", C.media.font, 12)
			buttonFrame.text:Point("CENTER", 1, -1)
			buttonFrame.text:SetParent(widgetbutton)
			buttonFrame:StyleButton()
		end
		if self:isauto() then
			self.buttonFrame.text:SetText("!")
		else
			self.buttonFrame.text:SetText("-")
		end
	end
end