local T, C, L = unpack(Tukui) -- Import: T - functions, constants, variables; C - config; L - locales
if C["breakdown"].enable == false then return end

-- Locals
---------------------------------------------

local breakdownHead = TukuiWidgetHead
local breakdownButton = TukuiWidgetButton

local function setButtonText()
	if breakdown:isauto() then
		breakdownButton.text:SetText("!")
	else
		breakdownButton.text:SetText("-")
	end
end

-- CORE   				BREAKDOWN
---------------------------------------

breakdown = {}
breakdown.items = {}
breakdown.update = function() end

breakdown.add = function(self, widgetItem)
	widgetItem.hideframe = CreateFrame("Frame", widgetItem.title .. "Hideframe", widgetItem.frame)
	-- widgetItem.hideframe:SetTemplate("Default")
	self.items[widgetItem.title] = widgetItem
end

breakdown.get = function(self, title)
	if not breakdown.items[title] then
		print("Failed, could not found widget for title: " .. title)
		return
	end
	return self.items[title]
end

breakdown.collapse = function(self, title)
	-- print("Collapse " .. title)
	local widgetItem = breakdown:get(title)
	widgetItem.hideframe:SetHeight(1)
	widgetItem.frame:Hide()
	widgetItem.expand = false
end

breakdown.expand = function(self, title)
	-- print("Expand " .. title)
	local widgetItem = breakdown:get(title)
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

breakdown.isexpand = function(self, title)
	local widgetItem = breakdown:get(title)
	return widgetItem.expand
end

breakdown.toggle = function(self, title)
	if self:isexpand(title) then
		self:collapse(title)
	else
		self:expand(title)
	end
end

breakdown.collapesall = function()
	for title, widgetItem in pairs(breakdown.items) do
		breakdown:collapse(title)
	end
end

breakdown.expandall = function()
	for title, widgetItem in pairs(breakdown.items) do
		breakdown:expand(title)
	end
end

breakdown.toggleauto = function()
	if C["breakdown"].automodus then 
		C["breakdown"].automodus = false
	else
		C["breakdown"].automodus = true
	end
	setButtonText()
	breakdown:update()
end

breakdown.isauto = function()
	return C["breakdown"].automodus
end



---------Dropdown
setButtonText()
breakdownButton:EnableMouse(true)
breakdownButton:SetScript("OnMouseUp", function(self, btn)
	if btn == "LeftButton" then
		local menuList = {}
		for title, widgetItem in pairs(breakdown.items) do
			table.insert(menuList, {text = title, func = function(selfButton) breakdown:toggle(selfButton:GetText()) end, checked = function(selfButton) return breakdown:isexpand(selfButton:GetText()) end})
		end
		 
		table.insert(menuList,{text = "Alle anzeigen",func = breakdown.expandall, notCheckable = true})
		table.insert(menuList,{text = "Alle verstecken",func = breakdown.collapesall, notCheckable = true})
		
		local AutohideText = nil		
		if breakdown:isauto() then 
			AutohideText = "Automdodus (abschalten)"
		else
			AutohideText = "Automdodus (einschalten)"
		end
		table.insert(menuList,{text = AutohideText,func = breakdown.toggleauto, checked = breakdown:isauto()})
		local menuFrame = CreateFrame("Frame", "DropdownWidgetMenuFrame", UIParent, "UIDropDownMenuTemplate")
		EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 2)
	
	else
	
		breakdown:toggleauto()
	end
end)






