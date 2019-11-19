module("EmojiManager", package.seeall)

local EMOJI_PLIST = "img/icon/expression.plist"

AAM_EMOJI_PATTERN = "%[[^%[]-%]"

local CHANNEL_DISPLAY = {
	-- [BundleID.CHANNEL_TYPE.CN] = "zh_cn",
}

local displayKey = CHANNEL_DISPLAY[BundleID.getChannelType()] or "display"

local REAL_TEMPLATE = {}
local REVERSE_TEMPLATE = {}
local IMG_LIST = {}	--	判断图片是否是EMOJI使用


function isEmojiImg( imgName )
	return IMG_LIST[imgName]
end

function isEmojiCode( str )
	return REAL_TEMPLATE[str]
end

function isEmojiStr( str )
	return REVERSE_TEMPLATE[str]
end

-- 根据字符串得到转义后的字符串
-- 如[微笑]  ==>> %[微笑%]
local function getESCStr( str )
	return "%" .. string.sub(str, 1, -2) .. "%]"
end

local function check( str, idx )
    local startIdx, endIdx = string.find(str, AAM_EMOJI_PATTERN, idx)
    local aam_emoji = nil

    if startIdx then
    	aam_emoji = string.sub(str, startIdx, endIdx)
    end

    return startIdx, endIdx, aam_emoji
end

function checkAAMEmoj( str, value, gsub )
	-- 查找Emoji字符的开始位置 结束位置 emoji字符
	local sid = nil
	local eid = 1
	local emoji = nil
    repeat
    	sid, eid, emoji = check(str, eid)
    	if sid and REAL_TEMPLATE[emoji] then
        	table.insert(value, {idx = sid, value = REAL_TEMPLATE[emoji].img, color = true})
        	table.insert(gsub, getESCStr( emoji ))
    	end
    until sid == nil


	CCX.cachePlist(EMOJI_PLIST)
end


-- 传入表情码 返回表情符号
-- 如 [01tp]  ==>> [调皮]
function getDisplay( id )
	local data = REAL_TEMPLATE[id]
	if data then
		return data.display
	else
		return id
	end
end

-- 传入表情符号 返回表情码
-- 如 [调皮]  ==>> [01tp]
local function getCode( str )
	local data = reverseTemplate[str]
	if data then
		return data.id
	else
		return str
	end
end

-- 把字符串中的表情显示 替换成 表情存储
function getCodeStr( str )
	return string.gsub(str, AAM_EMOJI_PATTERN, REVERSE_TEMPLATE)
end


function init()
	for k,v in pairs(TemplateManager.getLookContentTemplate("ChatExpressionTemplate")) do
		REAL_TEMPLATE[k] = {id = v.id, img = v.img, display = v[displayKey]}
		REVERSE_TEMPLATE[v[displayKey]] = v.id
		IMG_LIST[v.img] = true
	end
end