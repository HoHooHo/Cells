module("RichTextHelper", package.seeall)

local SPLIT_STR = "#|#|#"
local SPLIT_STR_LEN = #SPLIT_STR


local function getRichElementText( tag, color, str, font, fontSize, outline, shadow )
    local richElement = ccui.RichElementText:create(tag, color, 255, str, font, fontSize)
    if type(outline) == "boolean" and outline then
        richElement:enableOutline(GLB_OUTLINE_DATA.color, GLB_OUTLINE_DATA.size)
    elseif type(outline) == "table" and outline.color and outline.size then
        richElement:enableOutline(outline.color, outline.size)
    end

    if type(shadow) == "boolean" and shadow then
        richElement:enableShadow(GLB_SHADOW_DATA.color, GLB_SHADOW_DATA.size)
    elseif type(shadow) == "table" and shadow.color and shadow.size then
        richElement:enableShadow(shadow.color, shadow.size)
    end

	return richElement
end

--[[
RichText
    RichElement-Text
    RichElement-Image
]]  

local function getRichElementImage( tag, fileName, emojiScale )
	return ccui.RichElementImage:create(tag, cc.c3b(255, 255, 255), 255, fileName, emojiScale or 1, emojiScale or 1)
end

function getRichElement( tag, value, color, font, fontSize, emojiScale, outline, shadow )
	if color == nil then
		return nil
	elseif type(color) == "string" then
		local r, g, b = string.hexToRGB(color)
		return getRichElementText(tag, cc.c3b(r, g, b), value, font, fontSize, outline, shadow)
	elseif type(color) == "number" then
		return getRichElementText(tag, Utils.getColor3B(color), value, font, fontSize, outline, shadow)
	elseif type(color) == 'boolean' then
		return getRichElementImage( tag, value, emojiScale )
	else
		return getRichElementText(tag, color, value, font, fontSize, outline, shadow)
	end
end

local function splitContent( content )
	local contents = {}
	local str = content
	while true do
		local pos = string.find(str, SPLIT_STR)
		if not pos then
			contents[#contents + 1] = str
			break
		end

		local subStr = string.sub(str, 1, pos - 1)
		contents[#contents + 1] = subStr
		str = string.sub(str, pos + SPLIT_STR_LEN, #str)
	end

	return contents
end

-- 根据占位符顺序 对 values 和 colors 进行重新排序，分割content
function serialize( content, values, colors )
    local str = content
    local newValues = {}
    local newColors = {}
    local temp = {}

    local gsub = {}

    local tempStr = str .. "-"
    -- 处理占位符
    for i in ipairs(values) do
        local idx = string.find(tempStr, "#" .. i .. "%D")
        if idx and idx > 0 then
        	table.insert(temp, {idx = idx, value = values[i], color = colors[i]})
        	-- 由于占位符 与 分隔符SPLIT_STR的长度不一致 在此替换的话 有可能会发生 顺序错乱的情况，所以 最后统一替换
        	table.insert(gsub, "#" .. i)
	        -- str = string.gsub(str, "#" .. i, SPLIT_STR, 1)
        end
    end

    -- 处理AAM_EMOJI
    EmojiManager.checkAAMEmoj( str, temp, gsub )

   	-- 对富文本内容进行排序
    table.sort(temp, function ( a, b )
        return a.idx < b.idx
    end)

    -- 生成正确顺序的富文本内容和颜色
    for i, v in ipairs(temp) do
        newValues[i] = v.value
        newColors[i] = v.color
    end

    -- 统一替换占位符
    str = str .. "-"
    for i, v in ipairs(gsub) do
        str = string.gsub(str, v .. "(%D)", SPLIT_STR .. "%1", 1)
    end

    return splitContent(string.sub(str, 1, -2)), newValues, newColors
end

-- 如果富文本中某个位置是图片，则对应的color设置为true，对应的value设置为图片路径或者图片的FrameName既可
-- Global.generateRichText("测 #3试 #1 测试 #2 测试", {" 1是绿色 ", " 2是蓝色 ", " 3是红色 "}, {"00FF00", "0000FF", "FF0000"}, cc.size(560,80), ResConfig.FONT_NAME,18)
function generateRichText( content, value, color, richSize, fontName, fontSize, normalColor, emojiScale, outline, fontSizes, shadow )
	local contents, values, colors = serialize(content, value, color)

	-- logW(contents)
	-- logW(values)
	-- logW(colors)
    local valueNum = #values
    local contentNum = #contents

    local richText = ccui.RichText:create()
    if richSize then
	    richText:setContentSize(richSize)
    end
    richText:ignoreContentAdaptWithSize( richSize == nil )

    local tag = 1
    local normalColor = normalColor or cc.c3b(255, 255, 255)

    local contentOutline = outline
    local valueOutline = outline
    if type(outline) == "table" and #outline > 0 then
        contentOutline = outline[1]
        valueOutline = outline[2]
    end

    local contentShadow = shadow
    local valueShadow = shadow
    if type(shadow) == "table" and #shadow > 0 then
        contentShadow = shadow[1]
        valueShadow = shadow[2]
    end

    local len = contentNum >= valueNum and contentNum or valueNum

	for i = 1, len do
		local str = contents[i]
		if str and str ~= "" then
			local richElement = getRichElement( tag, str, normalColor, fontName or ResConfig.FONT_NAME, fontSize or 16, nil, contentOutline, contentShadow )
			if richElement then
			    richText:pushBackElement(richElement)
			    tag = tag + 1
			end
		end

		if values[i] and colors[i] then
			local richElement = getRichElement( tag, values[i], colors[i], fontName or ResConfig.FONT_NAME, fontSizes and fontSizes[i] or fontSize or 16, emojiScale, valueOutline, valueShadow )
			if richElement then
			    richText:pushBackElement(richElement)
			    tag = tag + 1
			end
		end
	end

	richText:setAnchorPoint(cc.p(0.5, 0.5))
	richText:formatText()

	return richText
end

-- 为了适配多语言版本，csb中的“富文本”通过代码转换
function generateRichTextByNodes( contentNode, valueNodes, size, richFontSize, outline, shadow )
	local content = contentNode:getString()
	local values = {}
	local colors = {}
    local fontSizes = {}
	for i,v in ipairs(valueNodes) do
		table.insert(values, v:getString())
		table.insert(colors, v:getColor())
        if richFontSize then
            table.insert(fontSizes, v:getFontSize())
        end
	end

    return generateRichText( content, values, colors, size, contentNode:getFontName(), contentNode:getFontSize(), contentNode:getColor(), nil, outline, richFontSize and fontSizes or nil, shadow)
end

function addElementClickEventListener( logic, element, callback )
	if element == nil then
        error("\n\n***ERROR*** element is nil  ***ERROR***")
    elseif callback == nil then
        error("\n\n***ERROR*** callback is nil  ***ERROR***")
	end

    local function onTouchBegan( touch, event )
        local target = event:getCurrentTarget()

        if not Global.isAncestorsVisible(target) then
        	return false
        end
        
        local locationInNode = target:convertToNodeSpace(touch:getLocation())
        local size = target:getContentSize()
        local rect = cc.rect(0, 0, size.width, size.height)

	    if cc.rectContainsPoint(rect, locationInNode) then
	        return true
	    end

    	return false
    end

    local function onTouchEnded(touch, event)
        local target = event:getCurrentTarget()
        
        local locationInNode = target:convertToNodeSpace(touch:getLocation())
        local size = target:getContentSize()
        local rect = cc.rect(0, 0, size.width, size.height)

	    if cc.rectContainsPoint(rect, locationInNode) then
			callback(logic, target)
	    end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)

    element:addTouchEventListener(listener)
end

function addElementTouchEventListener( logic, element, callback )
	if element == nil then
        error("\n\n***ERROR*** element is nil  ***ERROR***")
    elseif callback == nil then
        error("\n\n***ERROR*** callback is nil  ***ERROR***")
	end

    local function onTouchBegan(touch, event)
        local target = event:getCurrentTarget()

        if not Global.isAncestorsVisible(target) then
        	return false
        end
        
        local locationInNode = target:convertToNodeSpace(touch:getLocation())
        local size = target:getContentSize()
        local rect = cc.rect(0, 0, size.width, size.height)

	    if cc.rectContainsPoint(rect, locationInNode) then
	    	-- log(event:getEventCode())
	    	callback( logic, target, event:getEventCode(), touch )
	        return true
	    end

    	return false
    end

    local function onTouchMoved(touch, event)
    	-- log(event:getEventCode())
        local target = event:getCurrentTarget()
    	callback( logic, target, event:getEventCode(), touch )
    end

    local function onTouchEnded(touch, event)
        local target = event:getCurrentTarget()
        
        local locationInNode = target:convertToNodeSpace(touch:getLocation())
        local size = target:getContentSize()
        local rect = cc.rect(0, 0, size.width, size.height)

	    if cc.rectContainsPoint(rect, locationInNode) then
	    	-- log(event:getEventCode())
			callback( logic, target, event:getEventCode(), touch )
		else
	    	-- log(event:getEventCode() + 1)
			callback( logic, target, event:getEventCode() + 1, touch )
	    end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )

    element:addTouchEventListener(listener)
end

function test(  )
	cc.SpriteFrameCache:getInstance():addSpriteFrames("img/carnival.plist")

	return Global.generateRichText("测 #3试 #1 测 #4 [01tp] 试 #2 测试", {" 1是绿色 ", " 2是蓝色 ", " 3是红色 ", "carnival/2015062001.png"}, {"00FF00", "0000FF", "FF0000", true, true}, cc.size(560,80), ResConfig.FONT_NAME,18)
	-- return Global.generateRichText("#3试#1测#4[wx]试#2", {" 1是绿色 ", " 2是蓝色 ", " 3是红色 ", "carnival/2015062001.png"}, {"00FF00", "0000FF", "FF0000", true}, cc.size(560,80), ResConfig.FONT_NAME,18)
end