local T, C, L = unpack(Tukui) -- Import: T - functions, constants, variables; C - config; L - locales
if C["breakdown"].enable == false then return end

-- widgetItem
-------------------------------------
-- 	title = Name of the item
--	frame = WoWFrame
--	[expand] = Expand on login
--	[resize] = function after position change and width changed
--

-- Sample
---------
-- AddBreakdownWidget({title = "Recount", frame = Recount.MainWindow, expand = true, resize = function() Recount:ResizeMainWindow() end})



-- Add widget to breakdown collection
function AddBreakdownWidget(widgetItem)
	breakdown:add(widgetItem)
end

-- Set widget to given status and save it so you can reset the autostatus only if automdus enabled
function AutoSetWidget(title, expand)
	if not breakdown:isauto() then return end
	local widgetItem = breakdown:get(title)
	
	
	if widgetItem == nil then
		print("Couldn't not found WidgetItem " .. title .. " but you try to AutoSet it")
		return
	end
	
	if expand and not  breakdown:isexpand(title) then
		widgetItem.autoCollapse = nil
		widgetItem.autoExpand = true
		breakdown:expand(title)
	elseif not expand and widgetItem.expand then
		widgetItem.autoExpand = nil
		widgetItem.autoCollapse = true
		breakdown:collapse(title)
	end
end

-- Reset widget if in automodus and widget is change by automodus
function AutoResetWidget(title)
	if not breakdown:isauto() then return end
	local widgetItem = breakdown:get(title)
	
	if widgetItem == nil then
		print("Couldn't not found WidgetItem " .. title .. " but you try to AutoReset it")
		return
	end
	if widgetItem.autoExpand then
		breakdown:collapse(title)
	end
	
	if widgetItem.autoCollapse then
		breakdown:expand(title)
	end
	
	widgetItem.autoExpand = nil
	widgetItem.autoCollapse = nil
end

