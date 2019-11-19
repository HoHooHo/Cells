-- spine动画构造接口，主要调用C++接口实现，实现缓存数据的引用计数
-- noted by baofeng 20180116
module("SpineDataCache", package.seeall)

local JSON_FILE_NAME_SUFFIX = ".json"
local BINARY_FILE_NAME_SUFFIX = ".skel"
local ATLAS_FILE_NAME_SUFFIX = ".atlas"
local PATH = "spine/"

local _cacheData = {}

-- 获取缓存数据的索引key
-- 该key是一个spine数据在缓存中的唯一标识
local function getKey( jsonFileName, atlasFileName )
	return jsonFileName .. "_" .. atlasFileName
end

-- 从文件构造spine动画对象
function _createSpine(jsonFileName, atlasFileName, isBinary, customPath)
	if isBinary then
		return sp.SkeletonAnimation:createWithBinaryFile((customPath or PATH) .. jsonFileName .. BINARY_FILE_NAME_SUFFIX, (customPath or PATH) .. atlasFileName .. ATLAS_FILE_NAME_SUFFIX )
	else
		return sp.SkeletonAnimation:create( (customPath or PATH) .. jsonFileName .. JSON_FILE_NAME_SUFFIX, (customPath or PATH) .. atlasFileName .. ATLAS_FILE_NAME_SUFFIX )
	end
end

-- 获取对应的spine动画对象
function createSpine(jsonFileName, atlasFileName, isBinary, customPath)
	if not _cacheData[getKey(jsonFileName, atlasFileName)] then
		-- 缓存中没有
		local spine = _createSpine(jsonFileName, atlasFileName, isBinary, customPath)
		spine:retain()
		local info = {spine = spine, count = 1}
		_cacheData[getKey(jsonFileName, atlasFileName)] = info
		return spine
	else
		-- 缓存中有
		local info = _cacheData[getKey(jsonFileName, atlasFileName)]
		local spine = info.spine
		info.count = info.count + 1
		return spine:clone()
	end
end

-- 释放对应的缓存数据
function disposeSpine(jsonFileName, atlasFileName)
	if not _cacheData[getKey( jsonFileName, atlasFileName )] then
		return
	end
	local info = _cacheData[getKey( jsonFileName, atlasFileName )]
	info.count = info.count - 1
	if info.count == 0 then
		local spine = info.spine
		spine:release()
		_cacheData[getKey( jsonFileName, atlasFileName )] = nil
	end
end

-- 清除所有缓存数据
function clear(  )
	for k,info in pairs(_cacheData) do
		local spine = info.spine
		spine:release()
	end
	_cacheData = {}
end
