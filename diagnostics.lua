local database = require("database")
local config = require("config")
local posUtil = require("posUtil")
local term = require("term")

local function printFarm(workingCrop)
    local farm = database.getFarm()
	local outstr = ""

	for y=config.farmSize - 1, 0, -1 do
		for x=1, config.farmSize + 0, 1 do
			local slot = posUtil.globalToFarm({x, y})
			local crop = farm[slot]
			--outstr = outstr .. string.format("%4d", slot)
			if slot % 2 == 0 then
				outstr = outstr .. " ---"
			elseif crop == nil then
				outstr = outstr .. " nil"
			elseif crop.name == "weed" then
				outstr = outstr .. " wed"
			elseif crop.name == "crop" then
				outstr = outstr .. " crp"
			else
                local stat = crop.gr+crop.ga-crop.re
				if crop.name == workingCrop then
					outstr = outstr .. string.format(" Y%2d", stat)
				else
					outstr = outstr .. string.format(" N%2d", stat)
				end
			end
		end
		print(outstr)
		outstr = ""
	end
end

local function diagnoseAutoStat(workingCrop, lowestStat, lowestStatSlot)
	local coord = posUtil.farmToGlobal(lowestStatSlot)
	
	term.clear()
	if coord ~= nil then
		print(workingCrop .. ": " .. lowestStat.." @ " .. string.format("%2d,%2d", coord[1], coord[2]))
	else
		print(workingCrop .. ":  BAD COORD? SLOT = "..tostring(lowestStatSlot))
	end

	printFarm(workingCrop)
end

return {
	diagnoseAutoStat = diagnoseAutoStat,
	printFarm = printFarm
}