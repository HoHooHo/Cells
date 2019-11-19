-- cocos2dx的一些方法的快捷调用
CCX = CCX or {}

math.randomseed(os.time())

local _PlatformType = nil
function CCX.getDeviceType()
	if not _PlatformType then
		_PlatformType = 0
		local targetPlatform = cc.Application:getInstance():getTargetPlatform()
		if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) then
			_PlatformType = 1
		elseif (cc.PLATFORM_OS_ANDROID == targetPlatform) then
			_PlatformType = 2
		end
	end
	return _PlatformType
end

function CCX.createLayerTo(parent, size)
	local ly = ccui.Layer:create()
	return ly
end

function CCX.createSpriteTo(parent, framename, pos, anchor)
	local sp = cc.Sprite:create(framename)
	if anchor then sp:setAnchorPoint(anchor[1],anchor[2]) end
	if pos then sp:setPosition(cc.p(pos[1],pos[2])) end
	if parent then
		parent:addChild(sp)
	end
end

function CCX.destroyWidget(container)
	if not container then
		logW("[destroyWidget] :: container is nil")
		return
	end
	container:removeFromParentAndCleanup(true)
end

function CCX.setNodeBlendAsBG(node)
	node:setBlendFunc(gl.ONE, gl.ZERO)
end
function CCX.setNodeBlendAsADD(node)
	node:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
end

------------------------------------------------------------------------

function CCX.setContentSizeByScale(node, size)
	local sz = node:getContentSize()
	node:setScale(size[1] / sz.width, size[2] / sz.height)
end

-- 对图片做等比缩放，
-- 取长宽缩放值中较小的，以保证在比例不失真的情况下，图片被包含在目标容器内
function CCX.setScaleByContentSize( node, size )
	local sz = node:getContentSize()
	local scaleX = size.width / sz.width
	local scaleY = size.height / sz.height 
	local scaleValue = scaleX > scaleY and scaleY or scaleX
	if scaleValue < 1 then 
		node:setScale(scaleValue)
	end 
end

function CCX.getNodeSize( node )
	local sz = node:getBoundingBox()
	return sz
end

function CCX.getNodeRect( node )
	local sz = node:getBoundingBox()
	return {0, 0, sz.width, sz.height}
end

-- with Touch
-- 如果node中有子对象有Click/Touch事件,并且要该对象的事件保持有效，
-- 则要设置subnode:setSwallowTouches(false)
-- hitObj 可以是CCNode(要在同级) or Rect[x,y,w,h]; 这个参数可为空
function CCX.addDrag( node, endCB, hitObj, hitCB )
	local touchPos = nil --touchBeginPoint
	local drag     = false
	local nodeRect = CCX.getNodeRect(node)
	local hitFlag  = (hitObj and hitCB) and 0 or -1
	local hitRect  = (hitObj and hitObj.getBoundingBox) and CCX.getNodeRect(hitObj) or hitObj

	local function onTouchBegan(touch, event)
		local loc = touch:getLocation()
		local np = node:convertToNodeSpace(touch:getLocation()) --locInNode
		-- log("onTouchBegan: %0.2f, %0.2f", loc.x, loc.y)
		touchPos = {x = loc.x, y = loc.y}
		return math.rectContainsPoint(nodeRect, np.x,np.y)
	end

	local function onTouchMoved(touch, event)
		local loc = touch:getLocation()
		-- log("onTouchMoved: %0.2f, %0.2f, %d", loc.x, loc.y, hitFlag)
		if touchPos then
			local cx, cy = node:getPosition()
			local dx, dy = loc.x - touchPos.x, loc.y - touchPos.y
			if not drag and math.abs(dx) + math.abs(dy) > 8 then
				drag = true
			end
			if drag then
				node:setPosition(cx + dx, cy + dy)
				touchPos = {x = loc.x, y = loc.y}

				if hitFlag > -1 then
					local hit = math.rectContainsPoint(hitRect, loc.x,loc.y)
					if hitFlag == 0 and hit then
						hitFlag = 1
						hitCB(loc.x, loc.y, hit)
					else
						hitFlag = 0
					end
				end
			end
		end
	end

	local function onTouchEnded(touch, event)
		local loc = touch:getLocation()
		-- log("onTouchEnded: %0.2f, %0.2f", loc.x, loc.y)
		drag = false
		if endCB then
			local hit = hitRect and math.rectContainsPoint(hitRect, loc.x,loc.y) or false
			endCB(loc.x, loc.y, hit)
		end
		-- if removeOnUp then
		-- 	touchPos = nil
		-- 	endCB = nil
		-- end
	end

	local evtDer   = node:getEventDispatcher()
	local listener = cc.EventListenerTouchOneByOne:create()
	listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
	listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
	listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
	evtDer:addEventListenerWithSceneGraphPriority(listener, node)

	-- evtDer:removeEventListenersForTarget(node)
	-- evtDer:removeEventListener(listener)

	return evtDer, listener
end

-- for Sprite
function CCX.addTapEvent(node, callback, param, getC4B)
	if node.addClickEventListener then 	--uiWidget
		local cb = function ( sender )
			callback(param or node, sender, 0)
		end
		node:addClickEventListener(cb)
	else --
		local function onTouchBegan(touch, event)
			local target = event:getCurrentTarget()
			if not target:isVisible() or not CCX.isAncestorsVisible(target) then
				return false
			end
			local locInNode = target:convertToNodeSpace(touch:getLocation())
			local rect = target:getContentSize() --!!
			rect.x = 0; rect.y = 0
			if cc.rectContainsPoint(rect, locInNode) then
				local c = getC4B and target:getColorAtPoint(locInNode) or nil
				callback(param or node, target, 0, touch, c)
				return true
			end
			return false
		end

		local function onTouchMoved(touch, event)
			callback(param or node, event:getCurrentTarget(), 1, touch, nil)
		end

		local function onTouchEnded(touch, event)
			local target = event:getCurrentTarget()
			local locInNode = target:convertToNodeSpace(touch:getLocation())
			local rect = target:getContentSize()
			rect.x = 0
			rect.y = 0
			local c = getC4B and target:getColorAtPoint(locInNode) or nil
			callback(param or node, target, cc.rectContainsPoint(rect, locInNode) and 2 or 3, touch, c)
		end

		local listener = cc.EventListenerTouchOneByOne:create()
		listener:setSwallowTouches(true)
		listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
		listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
		listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)

		local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
		eventDispatcher:addEventListenerWithSceneGraphPriority(listener, node)
	end
end

-- 父级不可见，则无效
function CCX.isAncestorsVisible( node )
	if node == nil then
		return true
	end
	local parent = node:getParent()
	if parent and not parent:isVisible() then
		return false
	end
	return CCX.isAncestorsVisible( parent )
end

-- "img/...
local _SFC = cc.SpriteFrameCache:getInstance()
function CCX.cachePlist(url)
	-- if CCX.hasFile(url) then
	_SFC:addSpriteFrames(url)
	-- end
end

function CCX.removePlist(url)
	-- if CCX.hasFile(url) then
	_SFC:removeSpriteFramesFromFile(url)
	-- end
end

-- cb(tex2d)
function CCX.cacheTextureAsync(url, cb)
	-- if CCX.hasFile(url) then
	if string.sub(url, -5,-1) == "plist" then
		logW("CCX.cacheTextureAsync 只能加载贴图")
		return
	end
	local texCache = cc.Director:getInstance():getTextureCache()
	texCache:addImageAsync(url, cb)
	-- end
end

function CCX.getSpriteFrame(fn)
	return _SFC:getSpriteFrame(fn)
end

-- holdScale 1取大 -1取小
function CCX.setNodeImg(node, u, fixSize, holdScale)
	if type(holdScale)~="number" then holdScale = 1 end
	local o = fixSize and node:getBoundingBox() or nil
	if not u then
		logE("CCX.setNodeImg not u")
		return
	end

	local isUIImage = node.loadTexture ~= nil
	local capInsets = nil
	local isScale9Enabled = false

	if isUIImage then
		isScale9Enabled = node:isScale9Enabled()
		capInsets = node:getCapInsets()
	end

	if string.find(u, "img/") ~= 1 then
	-- local sf = CCX.getSpriteFrame(u)
	-- if sf then
		-- node:setSpriteFrame(sf)
		IconInfo.loadImage(u)
		if node.loadTexture then
			node:loadTexture(u, 1) 	--ImageView
		elseif node.setSpriteFrame then
			node:setSpriteFrame(u)	--Sprite
		end
	else
		if node.loadTexture then
			node:loadTexture(u, 0)  --ImageView
		elseif node.setTexture then
			node:setTexture(u) 		--Sprite
		end
	end

	if isUIImage and isScale9Enabled then
	    node:setCapInsets(capInsets)
	end

	if fixSize then
		local n = node:getContentSize()
		if type(fixSize) == "boolean" then
			if holdScale == 1 then
				node:setScale( math.max(o.width/n.width, o.height/n.height) )
			elseif holdScale == -1 then
				node:setScale( math.min(o.width/n.width, o.height/n.height) )
			else
				node:setScaleX( o.width/n.width )
				node:setScaleY( o.height/n.height )
			end
		elseif type(fixSize) == "table" then
			if holdScale == 1 then
				node:setScale( math.max(fixSize[1]/n.width, fixSize[2]/n.height) )
			elseif holdScale == -1 then
				node:setScale( math.min(fixSize[1]/n.width, fixSize[2]/n.height) )
			else
				node:setScaleX( fixSize[1]/n.width )
				node:setScaleY( fixSize[2]/n.height )
			end
		end
	end
end

------------------------------------------------------------------------
-- 描边+阴影
function CCX.setTextFx(tt)
	tt:enableShadow(cc.c4b(0,0,0,150), cc.size(2,-2))
	-- tt:enableOutline(cc.c4b(50,50,50,255))
end

------------------------------------------------------------------------
function CCX.getRichTextSet(tag, color, opacity, txt, fontName, fontSize)
	if type(color)=="string" then color = cc.c3b(string.hexToRGB(color)) end
	return 
	{
		tag 	= tag or 1,
		color 	= color or cc.c3b(255,255,255),
		opacity	= opacity or 255,
		txt		= txt or "-",
		fontName= fontName or ResConfig.FONT_NAME,
		fontSize= fontSize or 20
	}
end

--rect [x,y,w,h, ax,ay]
function CCX.createRichTextTo(parent, sets, rect, fmt)
	local rt = ccui.RichText:create() --UIRichText
	if fmt then
		if fmt[1] ~= nil then rt:ignoreContentAdaptWithSize(fmt[1]) end
	else
		rt:ignoreContentAdaptWithSize(true)
	end
	if rect then
		if rect[1] then rt:setPosition(cc.p(rect[1], rect[2])) end
		if rect[3] then rt:setContentSize(cc.size(rect[3], rect[4])) end
		if rect[5] then rt:setAnchorPoint(cc.p(rect[5], rect[6])) end
	end

	if sets and #sets > 0 then
		for i,v in ipairs(sets) do
			local rtEle = ccui.RichElementText:create(
								v.tag,
								v.color,
								v.opacity,
								v.txt,
								v.fontName,
								v.fontSize)
			rt:pushBackElement(rtEle)
		end
	end

	if parent then
		parent:addChild(rt)
	end
	return rt
end

function CCX.setRichTextEffect( richText, shadowC4b, shadowOffset, outlineC4b, outlineSize )
	if richText and richText.getElementRenderer then
		shadowC4b = shadowC4b or cc.c4b(0,0,0,150)
		shadowOffset = shadowOffset or cc.size(1,-1)
		local node = richText:getElementRenderer()
		local list = node:getChildren()
		for i,v in ipairs(list) do
			v:disableEffect()
			v:enableShadow( shadowC4b, shadowOffset )
			if outlineC4b then -- cc.c4b(50,50,50,128), 1
				v:enableOutline( outlineC4b, outlineSize or -1 )
			end
		end
	end
end

-----------------------------------------
function CCX.transformText(node, sets, tag, fixSub)
	local p = node:getParent()

	local x,y = node:getPosition()
	local s = node:getContentSize()
	local a = node:getAnchorPoint()
	local r = {
				x, y, s.width, s.height,
				a.x, a.y
				-- (a.x<=0 and a.x+0.25) or (a.x>=1 and a.x-0.25) or a.x,
				-- (a.y<=0 and a.y+0.25) or (a.y>=1 and a.y-0.25) or a.y,
			}
	local ig = nil
	if node.isIgnoreContentAdaptWithSize then ig = node:isIgnoreContentAdaptWithSize() end

	if tag and p then
		-- logHR("tag", tag, tostring(p:getChildByTag(tag)))
		if p:getChildByTag(tag) then
			p:removeChildByTag(tag)
		end
	end
	node:setVisible(false)

	-- logWarnning( ToString(r) )
	local rt = CCX.createRichTextTo(p, sets, r, {ig})
	if tag then
		rt:setTag(tag)
	end

	return rt
end

--t1 黄
--t2 白
--t3 绿
function CCX.transformAsPropText(node, t1,t2,t3, tag)
	local fontSize = node:getFontSize()
	local kvs = {
					CCX.getRichTextSet(1, cc.c3b(255,255,0), nil, t1, nil, fontSize),
					CCX.getRichTextSet(2, cc.c3b(255,255,255), nil, t2, nil, fontSize),
				}
	if t3 then kvs[3] = CCX.getRichTextSet(3, cc.c3b(0,187,83), nil, t3, nil, fontSize) end
	return CCX.transformText(node, kvs, tag and tag+1000000000 or nil)
end
-- 名称 +改造等级
function CCX.transformAsNameText(node, name, quality, rlv, tag, strformat ,specialColor, showRedLevel)
	-- node:setString(  name) )
	-- node:setColor( PropertyKey.getColor(quality) )
	local fontSize = node:getFontSize()
	local kvs = {}
	if strformat then
		table.insert( kvs, CCX.getRichTextSet(1, node:getColor(), nil,  string._format(strformat, ""), nil, fontSize) )
	end
	table.insert( kvs, CCX.getRichTextSet(1, specialColor or PropertyKey.getColor(quality), nil, name, nil, fontSize) )
	if rlv > 0 and (quality <= 5 or showRedLevel) then 
		table.insert( kvs, CCX.getRichTextSet(2,  cc.c3b(0,187,83), nil, " +".. rlv, nil, fontSize) )
	end
	return CCX.transformText(node, kvs, tag and tag+1000000000 or nil)
end

-- 名称 +改造等级 横扫千军需要置灰
function CCX.transformAsNameTextEx(node, name, quality, rlv, tag, strformat, needGray, specialColor, showRedLevel)

	local grayColor = cc.c3b(213, 213, 213)
	local nameColor = specialColor or PropertyKey.getColor(quality)
	local qualityColor = cc.c3b(0,187,83)

	if needGray then
		nameColor = grayColor
		qualityColor = grayColor
	end

	local fontSize = node:getFontSize()
	local kvs = {}

	if strformat then
		table.insert( kvs, CCX.getRichTextSet(1, node:getColor(), nil,  string._format(strformat, ""), nil, fontSize) )
	end

	table.insert( kvs, CCX.getRichTextSet(1, nameColor, nil, name, nil, fontSize) )
	
	if rlv > 0 and (quality <= 5 or showRedLevel) then 
		table.insert( kvs, CCX.getRichTextSet(2,  qualityColor, nil, " +".. rlv, nil, fontSize) )
	end

	return CCX.transformText(node, kvs, tag and tag+1000000000 or nil)
end

-- kvs [ [txt,c3b] ... ]
function CCX.transformTextWithKVs(node, kvs, tag)
	if not kvs or #kvs == 0 then
		return
	end
	-- logHR("kvs", ToString(kvs))

	local sets = {}
	local fontSize = node:getFontSize()
	for i,v in ipairs(kvs) do
		if v then
			table.insert(sets, CCX.getRichTextSet(i, v[2], nil, v[1], nil, v[3] or fontSize) )
		end
	end
	return CCX.transformText(node, sets, tag and tag+1000000000 or nil)
end

-- str : 带占位符的字串
-- params: [ [value/字符, cc.c3b(string.hexToRGB("FFF100")), fontSize] ]
function CCX.transformTextWithParams(node, str, params, tag,richSize)
	local ndSize = node:getContentSize()
	-- node:ignoreContentAdaptWithSize(false)
	local kvs = CCX.getRichKVs(str, params, node:getColor())
	local rt = CCX.transformTextWithKVs(node, kvs, tag)
    if richSize then
	    rt:setContentSize(richSize)
	    rt:ignoreContentAdaptWithSize( richSize == nil )
    end
    
	rt:formatText()
	local rtSize = rt:getVirtualRendererSize()
	rt:setPositionY(rt:getPositionY() - rtSize.height + ndSize.height)
	return rt
end

----------------------------------
-- rects [x,y,w,h, ax,ay]
function CCX.createRichTextWithKVs(p, kvs, tag, rects)
	if tag and p then
		if p:getChildByTag(tag) then
			p:removeChildByTag(tag)
		end
	end

	local sets = {}
	for i,v in ipairs(kvs) do
		table.insert(sets, CCX.getRichTextSet(i, v[2], nil, v[1], nil, v[3]) )
	end
	local rt = CCX.createRichTextTo(p, sets, rects)
	if tag then
		rt:setTag(tag)
	end

	return rt
end

-- params: [ [text1:string, color1:c3b, fontSize1:int(@=20)], [text2, color2, fontSize2], ... ]
function CCX.getRichKVs(str, params, defaultColor)
	local kvs = {}
	local s = str
	if type(defaultColor) == "string" then defaultColor = cc.c3b( string.hexToRGB(defaultColor) ) end
	local refC = defaultColor or cc.c3b(255,255,255)
	local n1 = 0
	local nL = 0
	for i=1,20 do
		n1 = string.find(s, "%%s"); nL=2
		if not n1 then n1 = string.find(s, "%%d"); nL=2 end
		if not n1 then
			table.insert( kvs, { s, refC } )
			break
		end
		local s1 = string.sub(s, 1, n1-1)
		s = string.sub( s, n1+nL, #s )
		-- logHR(i, tostring(n1), s)
		
		table.insert( kvs, { s1, refC } )

		if not params[i] then
			params[i] = {"nil"}
		end

		local tmpC = params[i][2]
		if type(tmpC) == "string" then tmpC = cc.c3b( string.hexToRGB(tmpC) ) end
		table.insert( kvs, { params[i][1], tmpC or cc.c3b(255,145,0), params[i][3] } )
	end
	return kvs
end
------------------------------------------------------------------------

-- 会倒计时文本框
-- function CCX.transformAsCountdownText(node, sec, mask, cb)
-- 	local ct = CountDownNode:createWithTTF(sec, 
-- 			mask or "dd HH:mm:ss",
-- 			node:getFontName() or ResConfig.FONT_NAME, 
-- 			node:getFontSize() )

-- 	if cb then ct:registerHandler(cb) end
-- 	ct:setMode(4)
-- 	ct:startCountDown()

-- 	ct:setPosition(node:getPosition())
-- 	ct:getLabel():setColor(node:getColor())
-- 	ct:getLabel():setAnchorPoint(node:getAnchorPoint())
-- 	-- ct:getLabel():setTextAlignment(node:getTextAlignment())
-- 	-- ct:getLabel():setTextHorizontalAlignment(node:getTextHorizontalAlignment())
-- 	-- ct:getLabel():setTextVerticalAlignment(node:getTextVerticalAlignment()) 

-- 	node:getParent():addChild(ct)
-- 	return ct
-- end
-- function CCX.removeAsCountdownText(node)
-- 	if node then
-- 		node:stopCountDown()
-- 		node:removeFromParent()
-- 		node = nil
-- 	end
-- end

function CCX.transformAsCountdownText(node, sec, mask, cb)
	local ct = Global.createCountDownNode(sec, 
		mask or "dd HH:mm:ss", 
		node:getFontName() or ResConfig.FONT_NAME, 
		node:getFontSize() )
	if cb then ct:registerHandler(cb) end
	ct:setMode(4)
	ct:startCountDown()

	ct:setPosition(node:getPosition())
	local color = node:getColor()
	ct:getLabel():setColor(color)
	ct:getLabel():setTextColor(cc.c4b(color.r,color.g,color.b, 255))
	ct:getLabel():setAnchorPoint(node:getAnchorPoint())

	node:getParent():addChild(ct:getLabel())
	return ct
end

function CCX.transformAsCountdownTextB(node, sec, mask, cb ,convertDay)
	local ct = Global.createCountDownNode(sec, 
		mask or "dd HH:mm:ss", 
		node:getFontName() or ResConfig.FONT_NAME, 
		node:getFontSize() ,
		convertDay)
	if cb then ct:registerHandler(cb) end
	ct:setMode(4)
	ct:startCountDown()

	ct:setPosition(node:getPosition())
	local color = node:getColor()
	ct:getLabel():setColor(color)
	ct:getLabel():setTextColor(cc.c4b(color.r,color.g,color.b, 255))
	ct:getLabel():setAnchorPoint(node:getAnchorPoint())

	node:getParent():addChild(ct:getLabel())
	return ct
end
function CCX.removeAsCountdownText(node)
	if node then
		node:stopCountDown()
		node:getLabel():removeFromParent()
		node = nil
	end
end
------------------------------------------------------------------------

function CCX.transformAsEditBox(node, placehold, cb)
	local sz = node:getContentSize()
	local eb = ccui.EditBox:create(
					sz, 
					ccui.Scale9Sprite:create(
						
						))--cc.rect(1,1,8,8), "Default/null.png"
	eb:setAnchorPoint(node:getAnchorPoint())
	eb:setPosition(node:getPosition())
	eb:setFontName(node:getFontName())
	eb:setFontSize(node:getFontSize())
	eb:setFontColor(node:getColor())
	eb:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE) 
	eb:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE) 
	
	-- eb:ignoreContentAdaptWithSize(node:isIgnoreContentAdaptWithSize())
	-- eb:ignoreContentAdaptWithSize(false)
	-- eb:setInputMode(2) -- 1EMAIL_ADDRESS 2NUMERIC 3PHONE_NUMBER 4URL 5DECIMAL 6SINGLE_LINE
	-- eb:setMaxLength(20)
	-- eb:getText()
	-- eb:setText(node:getString())
	if node.getPlaceHolder then
		eb:setPlaceHolder(placehold or node:getPlaceHolder())
	else
		eb:setPlaceHolder(placehold or node:getString())
	end
	eb:setPlaceholderFont(node:getFontName(), node:getFontSize())  --在iOS中字号不一至
	eb:setPlaceholderFontColor(cc.c3b(143, 115, 93))

	if cb then
		-- cb(evt, w) --evt: began changed ended return
		eb:registerScriptEditBoxHandler(cb)
	end
	node:getParent():addChild(eb)
	node:setVisible(false)
	return eb
end

function CCX.transformAsTextField( node, placehold, cb)
	local sz = node:getContentSize()
	local tf = ccui.TextField:create("", node:getFontName(), node:getFontSize())

	-- tf:setFontColor(node:getColor())
	tf:setAnchorPoint(node:getAnchorPoint())
	tf:setPosition(node:getPosition())
	tf:setContentSize(node:getContentSize())
	tf:ignoreContentAdaptWithSize(false)

	-- tf:setPlaceholderFont(node:getFontName(), node:getFontSize())
	if node.getPlaceHolder then
		tf:setPlaceHolder(placehold or node:getPlaceHolder())
	else
		tf:setPlaceHolder(node:getString())
	end
	
	tf:setPlaceholderFontColor(cc.c3b(143, 115, 93))
	if cb then
	end

	node:getParent():addChild(tf)
	node:setVisible(false)
	return tf
end
------------------------------------------------------------------------

-- function CCX.fixTableViewPosition(tv)
-- 	local n = 0
-- 	for i=1,20 do
-- 		n = tv:cellAtIndex(i) and n+1 or n
-- 	end
-- 	if n == 0 then tv:reloadData() end
-- end

-- reloadData后，保持原有位置
-- fixCntChg 适应数量变化
function CCX.fixTableViewReloadData(tv, fixCntChg)
	local p = tv:getContentOffset()
	local h1 = tv:getInnerContainer():getContentSize().height
	tv:reloadData()

	local h2 = tv:getInnerContainer():getContentSize().height
	local gapBottom, gapTop = tv:getGap()
	local contentHeight = tv:getContentSize().height
	local min = gapBottom.y
	local max = h2 - contentHeight + gapTop.y
	if h1 < contentHeight or h2 < contentHeight then
		return
	end
	if fixCntChg and h1 ~= h2 then
		local flag = 0
		if type(fixCntChg) == "boolean" then flag = -1
		elseif type(fixCntChg) == "number" then flag = fixCntChg
		end
		if flag == -1 then    -- 数据前加，最新在顶
			p.y = h1 - (max + min)
		elseif flag == 1 then -- 数据后加，最新在底
			p.y = p.y + (h1 - h2)
		end
	end

	--现在tableview加上了gapmin和gapmax，这个判断会导致位置错误
	if p.y > min then p.y = min end
	if p.y < -max then p.y = -max end
	tv:setContentOffset(p)
end

function CCX.setTableViewOffset(tv, pos)
	local si = tv:getInnerContainerSize()
	local sv = tv:getContentSize()
	pos.x = - math.min(pos.x, si.width-sv.width)
	pos.x = math.min(pos.x, 0)
	-- pos.y = - math.min(pos.y, si.height-sv.height)
	tv:setContentOffset(p)
end

function CCX.isTableViewAtTop(tv)
	local p = tv:getContentOffset()
	local h1 = tv:getInnerContainer():getContentSize().height
	local min = tv:getContentSize().height
	local max = h1 - min
	return math.abs(p.y) == math.abs(max)
end

function CCX.isTableViewAtButtom(tv)
	local p = tv:getContentOffset()
	return math.floor(math.abs(p.y)) == 0
end

function CCX.fixTableViewReloadDataEx(tv, fixCntChg, holdAtTop, holdAtButtom, holdSec, forceToTop, forceToButtom)
	-- logWarnning("fixTV_A", tostring(holdAtTop), tostring(holdAtButtom), tostring(forceToTop), tostring(forceToButtom))
	local hold = false
	if holdAtTop then
		local atTop = CCX.isTableViewAtTop(tv)
		if atTop then
			hold = true
		end
	end
	if holdAtButtom then
		local atButtom = CCX.isTableViewAtButtom(tv)
		if atButtom then
			forceToButtom = true
		else
			hold = true
		end
	end
	-- if holdSec then
	-- 	local t = Time.getTime()
	-- 	if t - tv._oprateTime > 5 then
	-- 		tv._oprateTime = t
	-- 		hold = true
	-- 	end
	-- end

	-- logWarnning("fixTV_B", tostring(forceToButtom), tostring(hold), tostring(forceToTop))
	if forceToButtom then
		local p = tv:getContentOffset()
		tv:reloadData()
		local h2 = tv:getInnerContainer():getContentSize().height
		local min = tv:getContentSize().height
		if h2 > min then
			p.y = 0
			tv:setContentOffset(p)
		end
	elseif hold and not forceToTop then
		CCX.fixTableViewReloadData(tv, fixCntChg)
	else
		tv:reloadData()
	end
end
------------------------------------------------------------------------

function CCX.hasFile(u)
	-- if string.sub(u, -3,-1) == "png" then
	-- 	if getDeviceType() == 1 then u = string.sub(u, 0,-4) .. "pvr.ccz" end
	-- 	elseif getDeviceType() == 2 then u = string.sub(u, 0,-4) .. "pkm" end
	-- end
	return cc.FileUtils:getInstance():isFileExist(u) --这个方法没有区分平台
end

function CCX.saveString(str, fn, mode)
	if type(str) ~= "string" then logW("saveString str参数非法"); return end
	if type(fn) ~= "string" then logW("saveString fn参数非法"); return end

	local fn = cc.FileUtils:getInstance():getWritablePath() .. fn
	local file = io.open(fn, mode or "a")
	file:write(str)
	file:close()
end

------------------------------------------------------------------------
function CCX.setNodeVisAndEnabled(widget,state)
	if widget then
		widget:setVisible(state)
		widget:setTouchEnabled(state)
	end
end
------------------------------------------------------------------------

function CCX.createAroundParticle(node, n, style, size,time)
	if not n then n = 1 end

	local pp = nil
	local time = time or 2
	if style then
		if style == 1 then -- 适合大的图
			time = 3
			-- pp = cc.ParticleSystemQuad:create("particle/duobaoqibing/dakalizi.plist")
			pp = cc.ParticleSystemQuad:create("particle/other/renwukuangtuowei.plist")
			pp:setStartSize(pp:getStartSize()*0.5)
			pp:setEndSize(pp:getEndSize()*0.5)
			pp:setBlendFunc(gl.ONE, gl.ONE)
		elseif style == 11 then -- 
			time = 4
			pp = cc.ParticleSystemQuad:create("particle/head_choose/xuanzelan.plist")
		elseif style == 12 then -- 
			time = 4
			pp = cc.ParticleSystemQuad:create("particle/head_choose/xuanzelv.plist")
		elseif style == 13 then -- 
			time = 4
			pp = cc.ParticleSystemQuad:create("particle/head_choose/xuanzehong.plist")
		elseif style == 14 then
			pp = cc.ParticleSystemQuad:create("particle/other/xinashizi.plist")
		elseif style == 15 then
			pp = cc.ParticleSystemQuad:create("particle/other/xianshichen.plist")
		end
	end
	if not pp then
		pp = cc.ParticleSystemQuad:create("particle/duobaoqibing/xiaokalizi.plist")
	end
	pp:setPositionType(cc.POSITION_TYPE_RELATIVE)
	-- pp:setTotalParticles(40)  --@53
	node:addChild(pp)
	local size = size or node:getBoundingBox()
	if size.width > (WIN_SIZE.width/2) then time = 4 end--矩形太大 时间减慢
	if style and (style == 14 or style == 15) then time = 7 end
	if n == 1 then pp:setPosition(cc.p(0, size.height)) end
	if n == 3 then pp:setPosition(cc.p(size.width, 0)) end
	local action0 = Global.getAroundAction(n, size.width, size.height, time)
	pp:runAction(action0)
	return pp
end
function CCX.createAroundParticleTo(node, bindToNode, style, size,time)
	local p1 = CCX.createAroundParticle(node, 1, style, size)
	local p2 = CCX.createAroundParticle(node, 3, style, size)
	if bindToNode then
		node._particle1 = p1
		node._particle2 = p2
	end
	return p1,p2
end

function CCX.CreateGuideParticle(node,bindToNode,style,num)
	local p1 = nil
	local p2 = nil
	if not num then num = 1 end
	if num == 1 then
		p1 = CCX.createAroundParticle(node, 1, style)
	elseif num == 2 then
		p1 = CCX.createAroundParticle(node, 1, style)
		p2 = CCX.createAroundParticle(node, 3, style)
	end
	if bindToNode then
		if p1 then
			node._particle1 = p1
		end
		if p2 then
			node._particle2 = p2
		end
	end
	return p1,p2
end

function CCX.removeAroundParticleFrom(node)
	if node._particle1 then
		node._particle1:stopAllActions()
		node._particle1:removeFromParent()
		node._particle1 = nil
	end
	if node._particle2 then
		node._particle2:stopAllActions()
		node._particle2:removeFromParent()
		node._particle2 = nil
	end
end
-- 在viewlogic(tableNode)上加转动效果
function CCX.createAroundParticleWith(logic, bindToNode, style, addDropStar)
	local layout = ccui.Layout:create()
	local s = cc.size(100,100)
	-- if logic.Panel then 
	-- 	s = logic.Panel:getBoundingBox()
	-- else
		local list = logic:getView():getChildren()
		for i,v in ipairs(list) do
			local t = v:getContentSize()
			if t.width > s.width then s.width = t.width end
			if t.height > s.height then s.height = t.height end
		end
	-- end
	local x,y = logic:getView():getPosition()
	layout:setContentSize(s)
	layout:setPosition(x-s.width*0.5, y-s.height*0.5)
	layout:setTouchEnabled(false)
	logic:getView():getParent():addChild(layout)
	local p1 = CCX.createAroundParticle(layout, 1, style)
	local p2 = CCX.createAroundParticle(layout, 3, style)
	if bindToNode then
		logic._particlePanel = layout
		logic._particle1 = p1
		logic._particle2 = p2
	end

	-- addDropStar = false
	if addDropStar then
		local l2 = ccui.Layout:create()
		l2:setTouchEnabled(false)
		l2:setContentSize(s)
		l2:setClippingEnabled(true)
		local pp = nil
		if     style == 11 then pp = cc.ParticleSystemQuad:create("particle/head_choose/juesebeijinlan.plist")
		elseif style == 12 then pp = cc.ParticleSystemQuad:create("particle/head_choose/juesebeijinlv.plist")
		elseif style == 13 then pp = cc.ParticleSystemQuad:create("particle/head_choose/juesebeijinhong.plist")
		end
		if not pp then
			pp = cc.ParticleSystemQuad:create("particle/other/juese.plist")
			pp:setBlendFunc(gl.ONE, gl.ONE)
		end
		pp:setPosition(s.width*0.5, y+s.height*0.5-0)
		l2:addChild(pp)
		layout:addChild(l2)
	end
	return layout, p1,p2
end
function CCX.removeAroundParticleWith(logic)
	if logic._particle1 then
		logic._particlePanel:removeFromParent()
		logic._particlePanel = nil
		logic._particle1 = nil
		logic._particle2 = nil
	end
end

-- alpha
function CCX.transfromClipping(mask, node)
	node:removeFromParent()
	local x,y = mask:getPosition()
	local size = mask:getContentSize()
	local clippingNode = cc.ClippingNode:create()
	clippingNode:setStencil(mask)
	clippingNode:setAlphaThreshold(0)
	clippingNode:addChild(node)
	clippingNode:setAnchorPoint(mask:getAnchorPoint())
	clippingNode:setPosition(x-size.width*0.5, y-size.height*0.5)
	mask:getParent():addChild(clippingNode, mask:getLocalZOrder())
end
function CCX.transfromClippingEx(mask, node)
	local cn = cc.ClippingNode:create()
	cn:setAnchorPoint(mask:getAnchorPoint())
	mask:getParent():addChild(cn)
	mask:retain()
	mask:removeFromParent()
	node:retain()
	node:removeFromParent()
	cn:setStencil(mask)
	cn:setAlphaThreshold(0)
	cn:addChild(node)
	mask:release()
	node:release()
end

--textureType = 0 --全路径
--textureType = 1 --Plist
function CCX.SetButtonTexture(node,normal,selected,disabled,textureType)
	local isScale9Enabled = node:isScale9Enabled()
	local capInsets = node:getCapInsetsNormalRenderer()
	
	local normal = normal
	local selected = selected
	local disabled = disabled
	node:loadTextures(normal,selected,disabled,textureType)
	if isScale9Enabled then
	    node:setCapInsets(capInsets)
	end
end

-- fromNode映射到to中的位置
function CCX.getPointWithNodeToNode( fromNode, toNode )
	local pos = cc.p(fromNode:getPosition())
	pos = fromNode:getParent():convertToWorldSpace( pos )
	pos = toNode:convertToNodeSpace( pos )
	return pos
end

function CCX.setButtonSpriteFrameLoop(btn, plist,pFmt,ps,pe)
	CCX.cachePlist(plist)
	local iMin = ps
	local iMax = pe
	local i = iMin

	local s0 = btn:getVirtualRenderer():getSprite()
	btn:setBrightStyle(ccui.BrightStyle.highlight)
	local s1 = btn:getVirtualRenderer():getSprite()
	s1:setScale(0.95)
	btn:setBrightStyle(ccui.BrightStyle.normal)

	local cb1 = function ()
		s0:setSpriteFrame(string._format(pFmt,i))
		s1:setSpriteFrame(string._format(pFmt,i))
		i=i+1
		if i > iMax then i = iMin end
	end
	btn:runAction(
		cc.RepeatForever:create(
			cc.Sequence:create(
				cc.CallFunc:create(cb1),
				cc.DelayTime:create(0.016*3)
		)))
end

function CCX.setButtonGray(btn, gray)
	btn:getVirtualRenderer():getSprite():setGray( gray )
	btn:setBrightStyle(ccui.BrightStyle.highlight)
	btn:getVirtualRenderer():getSprite():setGray( gray )
	btn:setBrightStyle(ccui.BrightStyle.normal)
end
function CCX.setButtonSpriteFrame(btn, fnNor, fnClk)
	btn:getVirtualRenderer():getSprite():setSpriteFrame(fnNor)
	btn:setBrightStyle(ccui.BrightStyle.highlight)
	btn:getVirtualRenderer():getSprite():setSpriteFrame(fnClk or fnNor)
	btn:setBrightStyle(ccui.BrightStyle.normal)
end

function CCX.isMainViewLogic()
	local top = ViewStack._viewStackCache[#ViewStack._viewStackCache]
	local logic = type(top)=="table" and top[#top] or nil
	if logic and logic.getCSBName then 
		return logic:getCSBName() == "MainView"
	end
	return false
end
function CCX.isTopLogic(self)
	local top = ViewStack._viewStackCache[#ViewStack._viewStackCache]
	local logic = type(top)=="table" and top[#top] or nil
	if logic and logic.getLogicId then 
		return logic:getLogicId() == self:getLogicId()
	end
	return false
end

function CCX.getTopLogic()
	local top = ViewStack._viewStackCache[#ViewStack._viewStackCache]
	local logic = type(top)=="table" and top[#top] or nil
	if logic and logic.getLogicId then 
		return logic
	end
	return nil
end

-- 0top 大于0非top
function CCX.getLogicLv(self)
	local L = #ViewStack._viewStackCache
	if L > 5 then L = 5 end
	for i=L,1,-1 do
		local cur = ViewStack._viewStackCache[i]
		local logic = type(cur)=="table" and cur[#cur] or nil 
		if logic and logic.getLogicId then 
			if logic:getLogicId() == self:getLogicId() then
				return L - i
			end
		end
	end
	return 5
end
function CCX.getLogicLvByName(cname)
	local L = #ViewStack._viewStackCache
	if L > 5 then L = 5 end
	for i=L,1,-1 do
		local ls = ViewStack._viewStackCache[i]
		if not ls then return 5 end
		for j,vl in ipairs(ls) do
			if vl.__cname == cname then
				return L - i, vl
			elseif vl.subViewLogic and vl.subViewLogic.__cname == cname then
				return L - i, vl.subViewLogic
			elseif vl.childLogics then
				for i,v in ipairs(vl.childLogics) do
					if v.__cname == cname then
						return L - i, v
					end
				end
			end
		end
	end
	return 5, nil
end

function CCX.fxBreatheWithBtn( btn )
	local f = btn:getVirtualRenderer():getSprite()
	f = f:getSpriteFrame()
	local light = cc.Sprite:createWithSpriteFrame( f )
	light:setAnchorPoint(0, 0)
	light:setBlendFunc(gl.ONE, gl.ONE)
	CCTween.opacityLoop(light, nil, 0.04)
	return light
end
function CCX.fxStarGlow()
	local sp = Global.addAnimationByPlist("img/ui_main_new.plist", "huodonglizi_frame_", 0,11, 0.6, true, false)
	sp:setAnchorPoint(0, -0.5)
	sp:setBlendFunc(gl.ONE, gl.ONE)
	return sp
end

---------------------------------------
--设置滚动文本 需要3个参数 滚动容器 文本 字符
function CCX.autoSetScrollText(scroll,text,string)
	local width = scroll:getContentSize().width
	local content = text
	content:getVirtualRenderer():setLineHeight(content:getVirtualRenderer():getLineHeight())
	content:setString(string)
	content:getVirtualRenderer():setMaxLineWidth(width)
	local height = content:getVirtualRenderer():getContentSize().height
	scroll:setInnerContainerSize(cc.size(width, height))
	local scrollSize = scroll:getContentSize()
	local posY = height
	if posY < scrollSize.height then
		posY = scrollSize.height
	end

	content:setPosition(cc.p(0, posY))
end

--创建下划线文字按钮，目前只应用于将领详情界面跳转推荐将领和将领详情界面跳转推荐坦克
--parent -> 父节点
--nodes -> 要创建为按钮的节点
--callbacks -> 对应节点的回调函数
--qualities ->获取线的颜色
--fontsize ->字体大小
function CCX.createLineLabelButton(parent, nodes, callbacks, qualities, fontsize)
	parent:removeAllChildren()
	local positionx = 0
	for i = 1, #nodes do
		local node = nodes[i]
		local callback = callbacks[i]
		local quality = qualities[i]

		local color = node:getColor()
		local size = node:getContentSize()
		
		if callback and quality then
			CCX.cachePlist("img/ui_captain.plist")
			local _colorLine = { 
			[0] = "line03.png", 
			[4] = "line02.png",
			[5] = "line01.png" }

			local line = cc.Sprite:createWithSpriteFrameName(_colorLine[quality])
			line:setAnchorPoint(cc.p(0, 1))
			line:setScaleX(size.width/23)
			node:setTextColor(cc.c4b(color.r,color.g,color.b, 255))
			node:addChild(line)
			CCX.addTapEvent(node, callback)
		end

		parent:addChild(node)
		node:setPositionX(positionx)
		positionx = positionx + size.width

		if i ~= #nodes then
			local point = ccui.Text:create()
		    point:setString("、")
		    point:setFontSize(fontsize)
		    point:setAnchorPoint(cc.p(0, 0))
		    point:setFontName("font/msyhbd.ttf")
		    parent:addChild(point)
		    point:setPositionX(positionx)
		    positionx = positionx + point:getContentSize().width
		end
	end
end

-- 通用方法，给label增加下划线，下划线颜色和字体颜色相同
function CCX.createSingleLineLabelButton(node)
	local tag = 10386

	local line = node:getChildByTag(tag)
	if not line then
		line = ccui.Layout:create()
		line:setBackGroundColorType(1)
		line:setBackGroundColor(PropertyKey.getDefColor("white"))
		node:addChild(line)
		line:setAnchorPoint(cc.p(0, 1))
		line:setTag(tag)
	end
	
	local size = node:getContentSize()	
	line:setContentSize(cc.size(size.width, node:getFontSize()/10))
end

--将node绘制到rendertexture，提升渲染效率
--hasStencil, node内部有遮罩时，须将这个参数传为true
--tag 用于标记rendertexture，重复调用时保证只会有一个rendertexture
--remove true表示移除缓存
function CCX.cacheAsRenderTexture(view, zorder, hasStencil, remove, tag)
	zorder = zorder or 0
	tag = tag or 10234
	view:getParent():removeChildByTag(tag, true)
	view:setVisible(true)
	if remove then
		return
	end
	
--	local scale = WIN_SIZE.height / 640
	
--	view:setScale(scale)
	local box = view:getBoundingBox()
	local x,y = view:getPosition()
	local tempPosition = cc.p(x - box.x, y - box.y)
	view:setPosition(tempPosition)

	
	local renderTexture 
	if hasStencil then
		renderTexture = cc.RenderTexture:create(box.width, box.height, 2, gl.DEPTH24_STENCIL8_OES)
	else
		renderTexture = cc.RenderTexture:create(box.width, box.height)
	end
	renderTexture:setTag(tag)
	renderTexture:beginWithClear(0, 0, 0, 0, 0, 0)
	view:visit()
	renderTexture:endToLua()
	
	
	
	view:setPosition(cc.p(x,y))
--	view:setScale(1)
	
	local sprite = renderTexture:getSprite()
	sprite:setAnchorPoint(0, 0)
	sprite:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA)
--	sprite:setScale(1 / scale)
	sprite:setPosition(cc.p(box.x, box.y))
	sprite:getTexture():setAntiAliasTexParameters()
	
	view:getParent():addChild(renderTexture, zorder)
	view:setVisible(false)
	
	return renderTexture
end

--截全屏的时候，上面的函数有点bug，暂时用这个函数
function CCX.cacheScreenRenderTexture(view, zorder, hasStencil, remove, tag)
	zorder = zorder or 0
	tag = tag or 10234
	view:getParent():removeChildByTag(tag, true)
	view:setVisible(true)
	if remove then
		return
	end
	
	local renderTexture 
	if hasStencil then
		renderTexture = cc.RenderTexture:create(WIN_SIZE.width, WIN_SIZE.height, 2, gl.DEPTH24_STENCIL8_OES)
	else
		renderTexture = cc.RenderTexture:create(WIN_SIZE.width, WIN_SIZE.height)
	end
	renderTexture:setTag(tag)
	renderTexture:beginWithClear(0, 0, 0, 0, 0, 0)
	view:visit()
	renderTexture:endToLua()
	
	local sprite = renderTexture:getSprite()
	sprite:setAnchorPoint(0, 0)
	sprite:setPosition(cc.p(0, 0))
	sprite:getTexture():setAntiAliasTexParameters()
	view:getParent():addChild(renderTexture, zorder)
	view:setVisible(false)
	
	return renderTexture
end

function CCX.createTestLabel(parent)
	local label = cc.LabelTTF:create()
    label:setFontSize(24)
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:setFontName("font/msyhbd.ttf")
    label:setPosition(cc.p(0,0))
    return label
end
-- 以锚点计算位置
function CCX.setPosYInScreen(node,anchor)
	if not node then return end
	if not anchor then anchor = {0.5,0.5} end
	local x = anchor[1]
	local y = anchor[2]
	local posX = 0
	local posY = 0
	if x == 0 then
		posX = 0
	elseif x == 0.5 then
		posX = WIN_SIZE.width/2
	elseif x == 1 then
		posX = WIN_SIZE.width
	end

	if y == 0 then
		posY = 0
	elseif y == 0.5 then
		posY = WIN_SIZE.height/2
	elseif y == 1 then
		posY = WIN_SIZE.height
	end
	node:setAnchorPoint(cc.p(x,y))
	node:setPosition(cc.p(posX,posY))
end

--多属性排序，默认为normal从大到小，在special列表中的属性按从小到大排序
--normal: 属性列表，如:{"isEquip", "quality", "level", "id"}
--special: 特殊属性列表，如：{"id"}
function CCX.sortTable(tab, normalList, specialList)
	
	if type(normalList) ~= "table" then
		normalList = {}
	end

	if type(specialList) ~= "table" then
		specialList = {}
	end

	local function sortCondition(a,b)
		for i, v in ipairs(normalList) do

            local isSpecial =  false
			for j, w in ipairs(specialList) do
				if w == v then
					isSpecial = true
					break
				end
			end

			if a[v] ~= b[v] then
				if not isSpecial then
					return a[v] > b[v]
				else
					return a[v] < b[v]
				end
			end
		end
		
	end
	table.sort( tab, sortCondition )
end

function CCX.SetTextOutline(widget, color, outline_width)
	GLB_setTextOutline( widget, color, outline_width )
end

function CCX.SetGenreTextOutline(widget, color)
	GLB_setTextOutline( widget, color, 3 )
end

function CCX.clearTextOutLine(widget)
	widget:disableEffect()
end

function CCX.setBtnEnabled(btn, enabled)
	if enabled then
		btn:setEnabled(true)
		btn:setTouchEnabled(true)
		btn:setColor(PropertyKey.getDefColor("white"))
	else
		btn:setEnabled(false)
		btn:setTouchEnabled(false)
		btn:setColor(PropertyKey.getDefColor("btn_gray"))
	end
end

function CCX.setBtnEnabledWithOldColor(btn, enabled, oldColor, OldgrayColor)  --oldColor 为置灰前  
	if enabled then
		btn:setEnabled(true)
		btn:setTouchEnabled(true)
		btn:setColor(cc.c3b(string.hexToRGB(oldColor)))
	else
		btn:setEnabled(false)
		btn:setTouchEnabled(false)
		btn:setColor(cc.c3b(string.hexToRGB(OldgrayColor)))
	end
end

function CCX.setBtnPositive(btn, positive)
	btn._positive_ = positive

	if btn["setColor"] then
		if positive then
			btn:setColor(PropertyKey.getDefColor("white"))
			if btn._positiveLocalzorder_ then
				btn:setLocalZOrder(btn._positiveLocalzorder_)
			end
		else
			btn:setColor(PropertyKey.getDefColor("btn_gray"))
			if btn._localzorder_ then
				btn:setLocalZOrder(btn._localzorder_)
			end
		end
	end
end

function CCX.resumeCoroutine(corou)
	if corou and coroutine.status (corou) == "suspended" then
		local ok, res = coroutine.resume(corou, true)
		if not ok then
	        __G__TRACKBACK__( "[CUSTOM CORNUTINE] " .. res)
		end
	end
end

function CCX.stopCoroutine(corou)
	if corou and coroutine.status (corou) == "suspended" then
		local ok, res = coroutine.resume(corou, false)
		if not ok then
	        __G__TRACKBACK__( "[CUSTOM CORNUTINE] " .. res)
		end
	end
end

--根据界面上拼好的节点创建viewlogic
function CCX.initViewlogicWithNode(cls, node, parentLogic, ...)
    local logic = cls.new( ... )
    logic.csbRootNode = node
    logic.csbRootNode.logic = logic
    local x,y = node:getPosition()
    logic.pos = cc.p(x, y)
    logic:openView(nil, parentLogic)
    return logic
end

local RADIO_IMG = {
	[1] = {positive = "ui/button/top_tab_1_on.png", negative = "ui/button/top_tab_1.png"},
	[2] = {positive = "ui/button/top_tab_2_on.png", negative = "ui/button/top_tab_2.png"},
}

function CCX.setRadioPositive(btn, positive)
	btn._positive_ = positive

	btn:setHighlighted(positive)

	CCX.setBtnPositive(btn, positive)

	-- if btn["loadTextures"] then
	-- 	if positive then
	-- 		btn:loadTextures(RADIO_IMG[btn.tab_type or 1].positive, RADIO_IMG[btn.tab_type or 1].positive, RADIO_IMG[btn.tab_type or 1].positive, ccui.TextureResType.plistType)
	-- 		if btn._positiveLocalzorder_ then
	-- 			btn:setLocalZOrder(btn._positiveLocalzorder_)
	-- 		end
	-- 	else
	-- 		btn:loadTextures(RADIO_IMG[btn.tab_type or 1].negative, RADIO_IMG[btn.tab_type or 1].negative, RADIO_IMG[btn.tab_type or 1].negative, ccui.TextureResType.plistType)
	-- 		if btn._localzorder_ then
	-- 			btn:setLocalZOrder(btn._localzorder_)
	-- 		end
	-- 	end

	-- 	if btn.capInsets then
	-- 		btn:setCapInsets(btn.capInsets)
	-- 	end
	-- end
end

-- 单选按钮 永远是 左边的按钮压右边的按钮（激活的按钮在最上方）
-- 为了不影响按钮和其他控件的层级关系  最好是将同组的单选按钮 单独放着一个node节点下
-- edit by zhangjun 回调函数如果返回"cancel", 切换就不执行了
-- force 强制执行，忽略__focuse_的状态
function CCX.radioButton( logic, buttons, callbacks, positiveIdx, force )
	local cbTb = {}
	local len = #buttons
	for i,v in ipairs(callbacks) do
		buttons[i]:setPressedActionEnabled(false)
		-- buttons[i]._localzorder_ = buttons[i]:getLocalZOrder() + len - i
		-- buttons[i]._positiveLocalzorder_ = buttons[i]:getLocalZOrder() + len
		-- if buttons[i]["getCapInsetsNormalRenderer"] then
		-- 	buttons[i].capInsets = buttons[i]:getCapInsetsNormalRenderer()
		-- end

		if i == (positiveIdx or 1) then
			CCX.setRadioPositive(buttons[i], true)
		else
			CCX.setRadioPositive(buttons[i], false)
		end

		local cb = function ( sender )
			sender = sender or buttons[i]
			if not force and sender.__focuse_ then
				CCX.setRadioPositive(sender, true)
				return false
			end

			if v(logic, sender) == "cancel" then
				CCX.setRadioPositive(sender, false)
				return false
			end

			for j,btn in ipairs(buttons) do
				buttons[j].__focuse_ = i == j
				CCX.setRadioPositive(buttons[j], buttons[j].__focuse_)
			end
			
			return true
		end

		if buttons[i].setRadioCallback then
			buttons[i]:setRadioCallback(cb)
		else
			buttons[i]:addClickEventListener(cb)
		end
		table.insert(cbTb, cb)
	end
	return cbTb
end


function addQuickClicked( node, cb, tapCount , parent )
	local time = 0
	local count = 0
	local maxTapCount = tapCount or 10

	local function listener()
	    local now = socket.gettime()

	    if now - time < 0.5 then
	        count = count + 1
	    else
	        count = 0
	    end

	    -- logW("count = " .. count)

	    time = now

	    if count == maxTapCount then
	        cb(parent)
	    end
	end


    node:setTouchEnabled(true)
    node:addClickEventListener( listener )
end

function nodelongPress( node )
	local longPressSchedule = nil


	local function unSchedule()
		if longPressSchedule then				
			Scheduler.unschedule(longPressSchedule)
			longPressSchedule = nil
		end
	end

	local onTouch = function (target, event, touch)
	    if event == 0 then
			local count = 0
			if longPressSchedule == nil then
				local function tap()
					count = count + 1

					if count == 15 then
						unSchedule()
						MessageBoxHelper:show(ZZBase64.decodeURL( "5Y2O5riF6aOe5omsKHNpbmNldGltZXMp" ), ZZBase64.decodeURL( "5Y2O5riF6aOe5omsKGh0dHA6Ly93d3cuc2luY2V0aW1lcy5jb20p5Ye65ZOB" ), "ok", function () end)
					end
				end
				longPressSchedule = Scheduler.schedule(tap, 1)
			end
		elseif event == 2 or event == 3 then
			unSchedule()
		end
	end

	
	if node.addClickEventListener then 	--uiWidget
		node:setTouchEnabled(true)
		node:addTouchEventListener(onTouch)
	else 	--a node, but not uiWidget
	    local function onTouchBegan(touch, event)
	        local target = event:getCurrentTarget()

	        if not Global.isAncestorsVisible(target) then
	        	return false
	        end
	        
	        local locationInNode = target:convertToNodeSpace(touch:getLocation())
	        local s = target:getContentSize()
	        local rect = cc.rect(0, 0, s.width, s.height)

		    if cc.rectContainsPoint(rect, locationInNode) then
		    	onTouch(target, event:getEventCode(), touch)
		        return true
		    end

	    	return false
	    end

	    local function onTouchEnded(touch, event)
		    onTouch(target, event:getEventCode(), touch)
	    end

	    local listener = cc.EventListenerTouchOneByOne:create()
	    listener:setSwallowTouches(true)
	    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
	    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )

	    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
	    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, node)
	end
end

--添加长按
function CCX.addLongPress(viewLogic, uiwidget, callback, touchCallback)
	local onTouch = function (viewLogic, target, event, touch)
		if touchCallback then
			touchCallback(viewLogic, target, event, touch)
		end
	    if event == 0 then
			if viewLogic._longPressSchedule == nil then
				local function tap()		
					if not uiwidget:isHighlighted() then
						return
					end
					uiwidget:setHighlighted(false)		
					callback(viewLogic, uiwidget)
				end
				viewLogic._longPressSchedule = viewLogic:scheduleOnce(tap, 0.3)
			end
		elseif event == 2 or event == 3 then
			if viewLogic._longPressSchedule then				
				viewLogic:unschedule(viewLogic._longPressSchedule)
				viewLogic._longPressSchedule = nil
			end
		end
	end
	viewLogic:addTouchEventListener(uiwidget, onTouch)
end

--添加长按后快速增长
function CCX.addLongPressTick(viewLogic, uiwidget, callback)
	local onTouch = function (viewLogic, target, event, touch)
	    if event == 0 then
			if viewLogic._longPressSchedule == nil then
				viewLogic.tapDelay = 0
				target:setBrightStyle(ccui.BrightStyle.highlight)
				local function tapNum()				
					if viewLogic.tapDelay == 0 or viewLogic.tapDelay >= 3 then
						AudioManager.play(ResConfig.AUDIO_NORMAL_CLICK)
						callback(viewLogic, uiwidget)
					end
					viewLogic.tapDelay = viewLogic.tapDelay + 1
				end
				tapNum()
				viewLogic._longPressSchedule = viewLogic:schedule(tapNum, 0.1)
			end
		elseif event == 2 or event == 3 then
			target:setBrightStyle(ccui.BrightStyle.normal)
			if viewLogic._longPressSchedule then
				viewLogic:unschedule(viewLogic._longPressSchedule)
				viewLogic._longPressSchedule = nil
			end
		end
	end
	viewLogic:addTouchEventListener(uiwidget, onTouch)
end


--添加长按后快速增长 区别滑动操作，即滑动时取消快速增长
function CCX.addLongPressTickEX(viewLogic, uiwidget, callback)
	local touchBeganPos = cc.p(0, 0)

	local longPressSchedule = nil

	local tapDelay = 0

	local function unSchedule()
    	tapDelay = 0
	    	
		if longPressSchedule then
			Scheduler.unschedule(longPressSchedule)
			longPressSchedule = nil
		end
	end

	local function tapNum( touchEnd )
		if 	viewLogic == nil or uiwidget == nil or uiwidget:isVisible() == false then
			unSchedule()
			return
		end
		if touchEnd or tapDelay >= 3 then
			AudioManager.play(ResConfig.AUDIO_NORMAL_CLICK)
			callback(viewLogic, uiwidget)
		end

		tapDelay = tapDelay + 1
	end

	

	local onTouch = function (viewLogic, target, event)
	    if event == 0 then
	    	touchBeganPos = target:getTouchBeganPosition()
			if longPressSchedule == nil then
				target:setBrightStyle(ccui.BrightStyle.highlight)
				longPressSchedule = Scheduler.schedule(tapNum, 0.1)
			end
		elseif event == 1 then
			local movePos = target:getTouchMovePosition()
			-- 安卓手机 对触摸好像过于敏感，当x或y移动大于5像素时 认为是move操作
			if math.abs(movePos.x - touchBeganPos.x) > 5 or math.abs(movePos.y - touchBeganPos.y) > 5 then
				target:setBrightStyle(ccui.BrightStyle.normal)
				unSchedule()
			end
		elseif event == 2 then
			tapNum( true )
			target:setBrightStyle(ccui.BrightStyle.normal)
			unSchedule()
		else
			target:setBrightStyle(ccui.BrightStyle.normal)
			unSchedule()
		end
	end
	viewLogic:addTouchEventListener(uiwidget, onTouch)
end

function CCX.removeLongPressSchedule(viewLogic)
	if viewLogic._longPressSchedule then
		viewLogic:unschedule(viewLogic._longPressSchedule)
		viewLogic._longPressSchedule = nil
	end
end

--根据排名修改排行标志和颜色
-- 前三名用图片 之后的用程序字

-- rank 排行名次
-- rankBGImg 排名的背景图片
-- rankText 排名的文本控件
-- rankImg 排名的图片控件
-- nameBG 左下角的小背景图
-- cellBG 整个cell的背景图
-- isSelf 自己需要特殊变色
function CCX.updateRankLogo(rank, rankBGImg, rankText, rankImg, nameBG, cellBG, isSelf)
	if rank < 4 then
		if rankImg then
			rankImg:setVisible(true)
			rankText:setVisible(false)
			CCX.setNodeImg(rankImg, "ui/bg/ladder_head_num_" .. rank .. ".png")
		else
			rankText:setVisible(true)
			rankText:setString(rank)
		end

		CCX.setNodeImg(rankBGImg, "ui/bg/ladder_head_bg_" .. rank .. ".png")
		if nameBG then
			CCX.setNodeImg(nameBG, "ui/bg/ladder_head_no_" .. rank .. ".png")
		end

		if cellBG then
			CCX.setNodeImg(cellBG, "ui/bg_big_8/ladder_bg_no_" .. rank .. ".png")
		end
	else
		if rankImg then
			rankImg:setVisible(false)
		end
		rankText:setVisible(true)
		rankText:setString(rank)

		CCX.setNodeImg(rankBGImg, "ui/bg/ladder_head_bg_other.png")
		if nameBG then
			if isSelf then
				CCX.setNodeImg(nameBG, "ui/bg/ladder_head_no_4.png")
			else
				CCX.setNodeImg(nameBG, "ui/bg/ladder_head_other.png")
			end
		end

		if cellBG then
			if isSelf then
				CCX.setNodeImg(cellBG, "ui/bg_big_8/bar_4.png")
			else
				CCX.setNodeImg(cellBG, "ui/bg_big_8/bar_3.png")
			end
		end
	end
end

function CCX.addToGroupNode(view)
	view:retain()
	local parent = view:getParent() 
	local nodecls = EGroupNode or cc.Node 
	local groupNode = nodecls:create()
	parent:addChild(groupNode)
	view:removeFromParent()
	groupNode:addChild(view)
	view:release()
	return groupNode
end

function CCX.bringToAboveText(view)
	view:setGlobalZOrder(3000)
end

-- nodes显隐 zhaolu
function CCX.setNodesVisible( tb )
	for k,v in pairs(tb) do
		if k then
			k:setVisible(v)
		else
			logW("CCX.setNodesVisible don't have "..tostring(k).." node")
		end
	end
end
-- nodes显隐 zhaolu
function CCX.setNodesVisibleByName(node,tb)
	for name,visble in pairs(tb) do
		local _node = node:getChildByName(tostring(name))
		if _node then
			_node:setVisible(v)
		else
			logW("CCX.setNodesVisible don't have "..tostring(_node).." node")
		end
	end
end
-- text 设置文字 zhaolu
function CCX.setStringForLabel( tb )
	for k,v in pairs(tb) do
		if k and v then
			k:setString(tostring(v))
		else
			logW("CCX.setStringForLabel k or v has error")
		end
	end
end
-- 根据btn名批量注册btn方法
function CCX.addBtnEvent( node, tb )
	for name,callBack in pairs(tb) do
		local btn = node:getChildByName(tostring(name))
		if btn ~= nil then
			node:addClickEventListener(btn, callBack)
		else
			logE("CCX.setBtnEnableWithColor "..tostring(btn).." btn not exist")
		end
	end
end
-- 在场景最上层增加遮罩panel，防止动画过程点击按钮动画.param:delayTime：延迟多久后untouch层消失
function CCX.addUntouchLayer(delayTime)
	local maskPanel = cc.Layer:create()
	maskPanel:setContentSize(cc.size(_WIN_SIZE.width, _WIN_SIZE.height))
	local currentScene = cc.Director:getInstance():getRunningScene()
	currentScene:addChild(maskPanel)
 	maskPanel:setOpacity(0)
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    local function onTouchBegan(data)
 		print("UntouchLayer touch begin")
		return true
    end
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    maskPanel:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, maskPanel)

 	Scheduler.scheduleOnce(function()
 		maskPanel:removeFromParent()
 		maskPanel = nil
 	end, delayTime)
end
-- 修改当前btn的样子
function CCX.refreshBtnView(btn,normalPic,selectedPic,disablePic)
	if normalPic then
		btn:loadTextureNormal(normalPic, 1) --替换正常显示的效果
	end
	if selectedPic then
		btn:loadTexturePressed(selectedPic, 1) --替换按下显示的效果
	end
	if disablePic then
		btn:loadTextureDisabled(disablePic, 1) --替换禁用的效果
	end
end
-- 筛选统一处理
function CCX.refreshFilterBtn( logic,helper,btnTb,imgTb,txtTb,callBack,curTabName )
	local normalImg = IconInfo.getBtnImgByName("formation_button2")
	local selectImg = IconInfo.getBtnImgByName("formation_button3")
	for i,v in ipairs(btnTb) do
		if v then
			-- local pos = txtTb[i]:getPositionX()
			local function btnClickCallBack()
				imgTb[helper[curTabName]]:setVisible(false)
				callBack(i)
				imgTb[i]:setVisible(true)

				for j=1,#btnTb do
					if i==j then
						CCX.refreshBtnView(btnTb[j],selectImg,selectImg)
						-- txtTb[j]:setPositionX(pos-20)
					else
						CCX.refreshBtnView(btnTb[j],normalImg,normalImg)
						-- txtTb[j]:setPositionX(pos)
					end
				end
			end
			logic:addClickEventListener(v,btnClickCallBack)
		end
	end
end
-- btn 设置是否可用，先给vip重构界面用
-- param:tb(k=btn,v={enable,color})
function CCX.setBtnEnableWithColor( tb )
	for btn, info in pairs(tb) do
		if btn~=nil then
			if type(info) == "table" then
                local enable = info[1]
                local enableColor = info[2]
                local unableColor = info[3]

				if enable then
					btn:setEnabled(true)
					btn:setTouchEnabled(true)
					btn:setColor(cc.c3b(string.hexToRGB(enableColor)))
				else
					btn:setEnabled(false)
					btn:setTouchEnabled(false)
					btn:setColor(cc.c3b(string.hexToRGB(unableColor)))
				end
			else
				logE("CCX.setBtnEnableWithColor " .. tostring(btn) .. " btn not exist")
			end
		else
			logE("CCX.setBtnEnableWithColor " .. tostring(btn) .. " btn not exist")
		end
	end
end

function CCX.setBtnTitleText( btn, string )
	btn:setTitleText(string)
end

-- 替换字符串中"#1"为实际参数
function CCX.setStringByFormat(node, format, ...)
	node:setString(string.format(format, ...))
end