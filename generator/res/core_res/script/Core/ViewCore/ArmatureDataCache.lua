module("ArmatureDataCache", package.seeall)

local ARMATURE_FILE_NAME_PREFIX = "armature/"

local _armatureData = {}

local function needCacheData( key )
	if _armatureData[key] then
		_armatureData[key] = _armatureData[key] + 1
		log("ArmatureData is exist:  "..key)
		return false
	end

	_armatureData[key] = 1
	log("ArmatureData addArmatureData:  "..key)
	return true
end


function addDBArmatureFileInfo( xml, plist, image )
	if needCacheData( xml ) then
		ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(ARMATURE_FILE_NAME_PREFIX..image, ARMATURE_FILE_NAME_PREFIX..plist, ARMATURE_FILE_NAME_PREFIX..xml)
	end
end

function addCSBArmatureFileInfo( csb )
	if needCacheData( csb ) then
		ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(ARMATURE_FILE_NAME_PREFIX..csb)
	end
end

function addDBArmatureFileInfoAsync( xml, plist, image, callback )
	if needCacheData( xml ) then
		local closure_callback = function ( percent )
			if callback then
				callback(  )
			end
		end
		ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync(ARMATURE_FILE_NAME_PREFIX..image, ARMATURE_FILE_NAME_PREFIX..plist, ARMATURE_FILE_NAME_PREFIX..xml, closure_callback)
	else
		if callback then
			callback(  )
		end
	end
end

function addCSBArmatureFileInfoAsync( csb, callback )
	if needCacheData( csb ) then

		local closure_callback = function ( percent )
			if callback then
				callback(  )
			end
		end
		ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync(ARMATURE_FILE_NAME_PREFIX..csb, closure_callback)
	else
		if callback then
			callback(  )
		end
	end
end

function removeArmatureFileInfo( file, instant )
	if file ~= nil and _armatureData[file] ~= nil then
		_armatureData[file] = _armatureData[file] - 1

		if _armatureData[file] < 0 then
			_armatureData[file] = 0
		end

		if _armatureData[file] == 0 and instant then
			_armatureData[file] = nil
		    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(ARMATURE_FILE_NAME_PREFIX..file)
		end
	end
end

function removeUnusedArmatureInfo(  )
	for k,v in pairs(_armatureData) do
		if v == 0 then
			_armatureData[k] = nil
		    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(ARMATURE_FILE_NAME_PREFIX..k)
		end
	end
end

function clear(  )
	for k,v in pairs(_armatureData) do
		ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(ARMATURE_FILE_NAME_PREFIX..k)
	end
	-- _armatureData = {}
end