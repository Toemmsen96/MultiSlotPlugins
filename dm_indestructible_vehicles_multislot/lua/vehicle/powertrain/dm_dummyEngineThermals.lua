local M = {}

-- steal the state of the previous device
local function stealRequiredData(from)
	M.debugData = from.debugData
	M.exhaustTemperature = from.exhaustTemperature
	M.oilTemperature = from.oilTemperature
	M.engineBlockTemperature = from.engineBlockTemperature
	M.exhaustTemperature = from.exhaustTemperature
	M.cylinderWallTemperature = from.cylinderWallTemperature
	M.coolantTemperature = from.coolantTemperature
end

local function nop()
end

M.init = nop
M.initSounds = nop
M.resetSounds = nop
M.reset = nop
M.updateGFX = nop
M.beamBroke = nop

M.stealRequiredData = stealRequiredData

M.applyDeformGroupDamage = nop
M.setPartConditionRadiator = nop
M.setPartConditionExhaust = nop
M.getPartConditionRadiator = nop
M.getPartConditionExhaust = nop

return M
