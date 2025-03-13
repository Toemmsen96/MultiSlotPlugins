local M = {}
M.type = "auxiliary"
M.relevantDevice = nil

local function inflateEnergyStorage(storage)
	storage.capacity = storage.capacity * 100
	storage.startingCapacity = storage.capacity
	
	storage.jbeamData.capacity = storage.capacity
	storage.jbeamData.startingCapacity = storage.startingCapacity
	
	storage.setRemainingRatio(1)
	
	dump(storage)
end

local function init(jbeamData)
	local enableFire = (jbeamData.enableFire or 1) > 0.5
	local enableEngineFlood = (jbeamData.enableEngineFlood or 1) > 0.5
	local enableEngineBreak = (jbeamData.enableEngineBreak or 1) > 0.5
	local enableBrakeThermals = (jbeamData.enableBrakeThermals or 1) > 0.5
	
	--disable fire
	--fire.init happens after controller.init
	--so simply ste flashPoint to nil
	if not enableFire then
		for _,node in pairs(v.data.nodes) do
			node.flashPoint = nil 
		end
	end
	
	--disable flooding
	--controller.init happens after powertrain init
	--so simply set the canFlood values
	if not enableEngineFlood then
		local powertrainDevices = powertrain.getDevices()
		for _, device in pairs(powertrainDevices) do
			device.canFlood = nil
		end
	end
	
	--disable engine breaking
	if not enableEngineBreak then
		local powertrainDevices = powertrain.getDevices()
		for _, device in pairs(powertrainDevices) do
			if device.type == "combustionEngine" then
				device.maxPhysicalAV = math.huge
				device.maxTorqueRating = math.huge
				--device.breakTriggerBeam = {}
				
				-- replace thermals with our dummy ones
				if device.thermals ~= nil then
					local oldThermals = device.thermals
					device.thermals = require("powertrain/dm_dummyEngineThermals")
					device.thermals.stealRequiredData(oldThermals)
				end
			end
		end
	end
	
	--disable manual transmission  breaking
	if not enableGearDamage then
		local powertrainDevices = powertrain.getDevices()
		for _, device in pairs(powertrainDevices) do
			if device.type == "manualGearbox" then
				device.gearDamageThreshold = math.huge
			end
		end
	end
	
	--disable brake thermals 
	--wheels.init was called before us
	if not enableBrakeThermals then
		for _,wheel in pairs(wheels.wheels) do
			wheel.enableBrakeThermals = false
		end
	end
end

M.init = init

return M
