local T, C, L = unpack(Tukui) -- Import: T - functions, constants, variables; C - config; L - locales
if C["breakdown"].enable == false then return end


--Minimap
if TukuiMinimap then
	breakdown:add({["title"] = "Map", frame = TukuiMinimap, expand = true})
end

--Recount
if IsAddOnLoaded("Recount") then
	AddBreakdownWidget({title = "Recount", frame = Recount.MainWindow, resize = function() Recount:ResizeMainWindow() end})
end

--Omen
if IsAddOnLoaded("Omen") then
	AddBreakdownWidget({title = "Omen", frame = Omen.Anchor, resize = function() end})
end