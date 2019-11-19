module("Global", package.seeall)

local function realCleanCache(  )
	cc.AnimationCache:destroyInstance()
	cc.Director:getInstance():purgeCachedData()
	
    collectgarbage("collect")
end

-- 由于ViewStack中 有通过计数进行清理资源的规则，所以不要直接使用此函数了，请调用ViewStack.checkClean
function cleanCache( immediate )
	if immediate then
		realCleanCache()
	else
		Scheduler.scheduleOnce( realCleanCache, 0.01 )
	end
end

function uidToDisplay( uid )
	return math:_10_36(uid)
end

function displayToUID( display )
	return math:_36_10(display)
end

-- 获得具体折扣数值  9折
-- 日文版没有折扣概念，所以是 10%off
-- 传入数值是百分制
-- 如：9折的话  传入 90  返回 10% 或者 9
-- 注意：日文版的描述中含有 % 所以 使用string.format的时候要转义
function getDiscountValue( value )
	value = tonumber(value)
	if BundleID.CHANNEL_TYPE.CN == BundleID.getChannelType() or BundleID.CHANNEL_TYPE.TW == BundleID.getChannelType() or BundleID.CHANNEL_TYPE.EN == BundleID.getChannelType() then
		return value/10
	else
		return (100 - value) .. "%%"
	end
end

function getTimeDesc( time )
	local t = TimeHelper.getZeroTime(HeartBeatManager.getServerZoneTime(nil, time))
	local ct = TimeHelper.getZeroTime(HeartBeatManager.getServerZoneTime())

	if ct - t > 0 then
		local day = (ct - t)/(24*60*60)
		if day == 1 then
			return getLang("昨天")
		elseif day == 2 then
			return getLang("前天")
		else
			return getLang("#1天前", "3")
		end
	else
		local sec, min, hour = HeartBeatManager.getFormatTime(false, time)

		return string._format("%d:%.2d", hour, min)
	end
end

function getTimeDescII( time )
	local t = HeartBeatManager.getGlobalTime() - time

	local minute = 60
	local hour = 60 * minute
	local day = 24 * hour
	local month = 30 * day

	if t < hour then
		return getLang("#1分钟前", math.ceil(t / minute))
	elseif t < day then
		return getLang("#1小时前", math.floor(t / hour))
	elseif t < month then
		return getLang("#1天前", math.floor(t / day))
	else
		return getLang("超过1个月")
	end
end

local UNIT = {
	{unit = "B", value = 1000 * 1000 * 1000},
	{unit = "M", value = 1000 * 1000},
	{unit = "K", value = 1000},
}

-- int 表示是否取整（不带小数部分，某些消耗肯定是整数，可能有这需求）
-- ceil 表示是否向上取整（true：向上取整；false：向下取整）
function unitConversion( num, int, ceil )
	if type(num) ~= "number" then
		num = tonumber(num)
	end
	
	local res = string._format("%d", num)
	for i,v in ipairs(UNIT) do
		if math.abs(num) >= v.value then
			if ceil then
				num = math.ceil(num / (v.value / 100)) / 100	--将两位小数以后的去掉，向上取整，否则会四舍五入
			else 
				num = math.floor(num / (v.value / 100)) / 100	--将两位小数以后的去掉，否则会四舍五入
			end 
			if int then
				res = string._format("%d%s", num, v.unit)
			else
				res = string._format("%.2f%s", num, v.unit)
			end
			break
		end
	end

	return res
end

function isAncestorsVisible( node )
	if node == nil then
		return true
	elseif not node:isVisible() then
		return false
	else
		return isAncestorsVisible( node:getParent() )
	end
end

-- 震屏效果 intensity:振幅 times:震动次数
function shakeScreen(node, intensity, duration, decay, callBack, orgPos)
	-- 振幅
	local amplitude = intensity
	-- 每一步震荡时间
	local timeT = 0.02
	local times = duration/(4*timeT)
	-- 震动位移系数
	--		 1
	--	   / | \		  
	--	  4  +  2
	--	   \ | /
	--		 3
	local shakeRange = {[1] = {x = -1, y = -1} ,
						[2] = {x = -1, y =  1} ,
						[3] = {x =  1, y =  1} ,
						[4] = {x =  1, y = -1} 
						}
	-- local curX, curY = 0,0
	-- local curX, curY = self:getPosition()
	local curPosX, curPosY = node:getPosition()
	if orgPos then
		curPosX, curPosY = orgPos.x, orgPos.y
	end
	local actionArray = {}
	local point = cc.p(0,0)

	local ratio = 1
	for i=1,times do
		if decay then
			ratio = (times + 1 - i) / times
		end

		for j=1,#shakeRange do
			point.x = curPosX + shakeRange[j].x*amplitude * ratio
			point.y = curPosY + shakeRange[j].y*amplitude * ratio
			actionArray[#actionArray + 1] = cc.MoveTo:create(timeT, point)
		end
	end

	point.x = curPosX
	point.y = curPosY

	actionArray[#actionArray + 1] = cc.MoveTo:create(timeT, point)
	if callBack then
		actionArray[#actionArray + 1] = cc.CallFunc:create(callBack)
	end

	local actionSequence = cc.Sequence:create(actionArray)
	node:runAction(actionSequence)
end

--添加序列帧动画
--@param plist   plist资源路径
--@param liteName   每张图片名字前缀（例如：“battle_map_base_001.png”, 前缀为“battle_map_base_”）
--@param startIndex 起始图片编号（例如：第一张图片为“battle_map_base_001.jpg”，起始编号为 1 ）
--@param endIndex  结束图片编号
--@param totalTime  总播放时间
--@return           返回动画Sprite
--@format 数字格式化
function addAnimationByPlist(plist, liteName, startIndex, endIndex, totalTime, repeate, onlyAction, format, callBack)
	if format == nil then
		format = "%d"
	end

    cc.SpriteFrameCache:getInstance():addSpriteFrames(plist)

    local animation = cc.Animation:create()
	local number, name
	local step = endIndex>startIndex and 1 or -1
    for i = startIndex, endIndex, step do
    	local number = string._format(format, i)   --string._format("%03d", i)
        name = liteName .. number .. ".png"
        animation:addSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(name))
    end
    -- should last 2.8 seconds. And there are 14 frames.
    animation:setDelayPerUnit(totalTime / endIndex)
    animation:setRestoreOriginalFrame(true)

    local action = cc.Animate:create(animation)
    if repeate then
    	action = cc.RepeatForever:create(action)
    end
    if callBack then
	    local sprite = cc.Sprite:createWithSpriteFrameName( liteName .. startIndex .. ".png" )
	    sprite:runAction(
		    	cc.Sequence:create(
		    		action,
					cc.CallFunc:create(callBack)
		    		)
		    	)
	    return sprite
    end
    if not onlyAction then
	    local sprite = cc.Sprite:createWithSpriteFrameName( liteName .. startIndex .. ".png" )
	    sprite:runAction(action)

	    return sprite, action
    end

    return action
end

function showTips( str, color, delay )
	if str and str ~= "" then
		if Config.Debug then
			logW(str)
		end
		TipsManager.show( str, color, delay )
	end
end

function showDebugTips( str, color, delay )
	if Config.Debug and str and str ~= "" then
		logW(str)
		TipsManager.show( str, color, delay )
	end
end

function showRichTips(data)
	TipsManager.showRich(data)
end

function showErrTips(tips, tab, errID)
	if tab and tab[errID] then
		if Config and Config.LAN then
			showTips( tab[errID] .." code:".. errID  )
		else
			showTips( tab[errID] )
		end
	elseif Config and Config.LAN then
		showTips( tips .." code:".. errID )
	end
end

function showGoldDlg(msg)
	showNotenoughDlg(DROPDATA_TYPE.GOLD, 0, msg)
end

function showPayDlg(msg)
	local onConfirm = function()
		--点击确定跳转到充值
		PaymentData.openPaymentView()
	end

	local title = getLang("钻石不足")
	local content = msg or getLang("钻石不足，是否前往充值？")
	local dialog = CommonDialogViewLogic.new(title, content, function()end, onConfirm, getLang("取消"), getLang("确定"))
	dialog:openView()
end

--根据资源类型弹不同的提示
--type为空默认为道具
function showNotenoughDlg(type, id, msg)
	type = type or DROPDATA_TYPE.ITEM
	if type == DROPDATA_TYPE.CASH then
		showPayDlg(msg)
		return
	elseif type == DROPDATA_TYPE.ITEM then
		if MineManager.tryBuyMineItem(id) then
			return
		end
	end

	local info = BagData.getDropDataConfig( id, type )
	--配置了引导跳转，则弹出引导跳转框
	if (info.get and #info.get > 0) or (info.recommend and #info.recommend > 0) then
		ResourceSeekViewLogic.new({id=id, type=type}):openView()
		return
	end

	--没配置引导跳转，直接提示xx不足
	if not msg then
		if type == DROPDATA_TYPE.MERCENARY then
			msg = getLang("英雄数量不足")
		elseif type == DROPDATA_TYPE.TREASURESOUL then
			msg = getLang("宝具数量不足")
		else
			msg = getLang("#1不足", info.name)
		end
	end
	showTips(msg)
end

--弹出增加资源面板
function showAddResourceDlg(type, id)
	type = type or DROPDATA_TYPE.ITEM
	if type == DROPDATA_TYPE.CASH then
		PaymentData.openPaymentView()
		return
	elseif type == DROPDATA_TYPE.ITEM then
		if id == PropertyKey.BOMB_ID then
			local shopInfo = ShopData.getTemplateByResourceId(PropertyKey.BOMB_ID)
		BuyMoreViewLogic.new({shopid = shopInfo.id}):openView()
			return
		end
	end

	local info = BagData.getDropDataConfig( id, type )
	--配置了引导跳转，则弹出引导跳转框
	if (info.get and #info.get > 0) or (info.recommend and #info.recommend > 0) then
		ResourceSeekViewLogic.new({id=id, type=type, hideNotEnough=true}):openView()
	end
end

--是否配置了增加资源
function hasAddResource(type, id, info)
	if not info then
		 info = BagData.getDropDataConfig( id, type )
	end
	if type == DROPDATA_TYPE.CASH then
		return true
	end
	if type == DROPDATA_TYPE.ITEM and id == PropertyKey.BOMB_ID then
		return true
	end
	return (info.get and #info.get > 0) or (info.recommend and #info.recommend > 0)
end

-- function testShowTips(  )
-- 	Global.showRichTips( { {str = "Test"}, {str = "DDD", color = cc.c3b(255, 0, 0)}, {str = "TTT", color = cc.c3b(0, 255, 0)} }, true )
-- end

function formatTemplateContent( content )
	local contents = {}
	local str = content
	while true do
		local pos = string.find(str, "|")
		if not pos then
			if str ~= "" then
				contents[#contents + 1] = str
			end
			break
		end

		local subStr = string.sub(str, 1, pos - 1)
		if subStr ~= "" then
			contents[#contents + 1] = subStr
		end
		str = string.sub(str, pos + 1, #str)
	end
	return contents
end

function createCountDownNode(time, format, fontName, fontSize, convertDay)
	local uiText = ccui.Text:create(format, fontName,fontSize)

	local countDownNodeLua = CountDownNodeLua:createWithLabel(time, format, uiText, convertDay)
	return countDownNodeLua, uiText
end

function replaceTimeNode( logic, name, time, convertDay, format)
	local uiText = name
	if type(name) == "string" then
		uiText = logic:getChildByName(name)
	end
	if format == nil then
		format = uiText:getString()
	end

	local countDownNode = CountDownNodeLua:createWithLabel(time, format, uiText, convertDay)

	return countDownNode
end

function replaceClippingNode( maskNode, alphaThreshold, inverted )
	local clippingNode = cc.ClippingNode:create()
	clippingNode:setCascadeOpacityEnabled(true)
	clippingNode:setCascadeColorEnabled(true)
	maskNode:getParent():addChild(clippingNode)

	local maskSize = maskNode:getContentSize()
	local anchor = maskNode:getAnchorPoint()

	clippingNode:setContentSize(maskSize)
	clippingNode:setAnchorPoint(anchor)
	clippingNode:setPosition(maskNode:getPosition())

	clippingNode:setAlphaThreshold( alphaThreshold or 0 )
	clippingNode:setInverted( inverted or false )

	maskNode:retain()
	maskNode:removeFromParent()

	clippingNode:setStencil( maskNode )
	maskNode:release()
	maskNode:setPosition(cc.p(maskSize.width * anchor.x, maskSize.height * anchor.x))

	for k,v in pairs(maskNode:getChildren()) do
		v:retain()
		v:removeFromParent()
		clippingNode:addChild(v)
		v:release()
	end

	return clippingNode
end

-- startId
--	1 ------------- 2
--	  |				|
--	  |				|
--	0 ------------- 3
function getAroundAction( startId, time, minX, minY, maxX, maxY )

	local leftBottom = cc.p(minX, minY)
	local leftTop = cc.p(minX, maxY)
	local rightTop = cc.p(maxX, maxY)
	local rightBottom = cc.p(maxX, minY)

	local distance = (maxX - minX + maxY - minY) * 2
	local averageTime = time/distance

	local leftAction = cc.MoveTo:create(averageTime * (maxY - minY), leftTop)
	local topAction = cc.MoveTo:create(averageTime * (maxX - minX), rightTop)
	local rightAction = cc.MoveTo:create(averageTime * (maxY - minY), rightBottom)
	local bottomAction = cc.MoveTo:create(averageTime * (maxX - minX), leftBottom)

	local cornor = {
		leftBottom,
		leftTop,
		rightTop,
		rightBottom,
	}

	local actions = 
	{
		leftAction,
		topAction,
		rightAction,
		bottomAction,
	}

    local actionArray = {}

    local idx = startId%4 + 1
    local startPos = cornor[idx]
    actionArray[#actionArray + 1] = actions[idx]
    idx = (startId + 1)%4 + 1
    actionArray[#actionArray + 1] = actions[idx]
    idx = (startId + 2)%4 + 1
    actionArray[#actionArray + 1] = actions[idx]
    idx = (startId + 3)%4 + 1
    actionArray[#actionArray + 1] = actions[idx]

	local actionSequence = cc.Sequence:create(actionArray)
	local actionRepeat = cc.RepeatForever:create(actionSequence)

	return actionRepeat, startPos
end

local SPECIAL_EFFECT_PARTICLE = {
	{name = "particle/dakuanglizi.plist", maxX = 49, maxY = 49, minX = -49, minY = -49, time = 3},
	{name = "particle/xiaokuanglizi.plist", maxX = 31, maxY = 31, minX = -31, minY = -31, time = 3}
}

function stopAroundParticle( node )
	if node == nil then
		error("\n\n####### node is nil #######\n")
	end

	if node._roundParticle1_ then
		node._roundParticle1_:removeFromParent( true )
		node._roundParticle1_ = nil
	end
	if node._roundParticle2_ then
		node._roundParticle2_:removeFromParent( true )
		node._roundParticle2_ = nil
	end
end

-- type: 1 BigItemNode  2 ItemNode  BagItemNode
function playAroundParticle( node, type )
	stopAroundParticle( node )

	type = type or 1

	local info = SPECIAL_EFFECT_PARTICLE[type]

	node._roundParticle1_ = cc.ParticleSystemQuad:create(info.name)
	node._roundParticle1_:setPositionType(cc.POSITION_TYPE_RELATIVE)
	local action1, pos1 = getAroundAction( 0, info.time, info.minX, info.minY, info.maxX, info.maxY )
	node._roundParticle1_:setPosition(pos1)
	node._roundParticle1_:runAction(action1)
	node:addChild(node._roundParticle1_)


	node._roundParticle2_ = cc.ParticleSystemQuad:create(info.name)
	node._roundParticle2_:setPositionType(cc.POSITION_TYPE_RELATIVE)
	local action2, pos2 = getAroundAction( 2, info.time, info.minX, info.minY, info.maxX, info.maxY )
	node._roundParticle2_:setPosition(pos2)
	node._roundParticle2_:runAction(action2)
	node:addChild(node._roundParticle2_)
end

function playMoveParticle( node, positionList, time, callback )
	if node == nil then
		error("\n\n####### node is nil #######\n")
	elseif positionList == nil or #positionList < 2 then
		error("\n\n####### positionList is error #######\n")
	end

	if time == nil then
		time = 2
	end

	node._moveParticle_ = cc.ParticleSystemQuad:create("particle/dakuanglizi.plist")
	node._moveParticle_:setPositionType(cc.POSITION_TYPE_RELATIVE)
	node._moveParticle_:setPosition(positionList[1])

	node:addChild(node._moveParticle_)


	local info = {}
	local totalDis = 0
	for i,v in ipairs(positionList) do
		local from = v
		local to = positionList[i + 1]

		if to then
			local distance = math.pow(from.x - to.x, 2) + math.pow(from.y - to.y, 2)

			totalDis = totalDis + distance
			info[i] = {from = v, to = to, dis = distance}
		end
	end

	local actionArray = {cc.Show:create()}
	for i,v in ipairs(info) do
		table.insert(actionArray, cc.MoveTo:create(v.dis/totalDis * time, v.to))
	end

	local function onEnd()
		node._moveParticle_:removeFromParent(true)
		node._moveParticle_ = nil

		if type(callback) == "function" then
			callback()
		end
	end

	table.insert(actionArray, cc.CallFunc:create(onEnd))
	node._moveParticle_:runAction(cc.Sequence:create(actionArray))
end

--获取时区偏移量
function getTimeZone()
	local now = os.time()
	local utcDate = os.date("!*t", now)

    local zoneDate = os.date("*t", now)
    zoneDate.isdst = false

  	return os.difftime( os.time(zoneDate), os.time(utcDate) )
end


-- 如果富文本中某个位置是图片，则对应的color设置为true，对应的value设置为图片路径或者图片的FrameName既可
-- Global.generateRichText("测 #3试 #1 测试 #2 测试", {" 1是绿色 ", " 2是蓝色 ", " 3是红色 "}, {"00FF00", "0000FF", "FF0000"}, cc.size(560,80), ResConfig.FONT_NAME,18)
-- 当richSize的height为0时 会自动适配宽高
function generateRichText( content, values, colors, richSize, fontName, fontSize, normalColor, emojiScale, outline, richFontSize, shadow)
	return RichTextHelper.generateRichText( content, values, colors, richSize, fontName, fontSize, normalColor, emojiScale, outline, richFontSize, shadow )
end

-- 为了适配多语言版本，csb中的“富文本”通过代码转换
-- contentNode （UItext） 富文本的内容来源于contentNode的文本内容
-- valueNodes 是一个（UItext）table 富文本的变量的值来源于valueNodes中所有的UItext的文本内容
-- richSize 自定义的富文本的size，（可以不传）
-- richFontSize 富文本的变量的值的字号是否由valueNodes的字号决定 true or false （可以不传）
function generateRichTextByNodes( contentNode, valueNodes, richSize, richFontSize, outline, shadow )
	local size = nil

	if not richSize and not contentNode:isIgnoreContentAdaptWithSize() then
		size = contentNode:getContentSize()
	end
	return RichTextHelper.generateRichTextByNodes( contentNode, valueNodes, richSize or size, richFontSize, outline, shadow )
end

function isNpc(uid)
	if not uid then
		return true
	end
	return tonumber(uid) < 2100000000
end

function showPowerChangedTips(params)
	-- logW(ToString({Global.showPowerChangedTips = params}))
    if params.toNum ~= params.fromNum then
        local countUpNode = CountUpNode.getInstance()
        countUpNode:initData(params)
        countUpNode:openView()
        countUpNode:playAction()
    end
end


function blink( node, time )
	local fadeOut = cc.FadeOut:create(time or 0.6)
	local fadeIn = cc.FadeIn:create(time or 0.6)
	local sequene = cc.Sequence:create({fadeOut,fadeIn})
	local repeatForever = cc.RepeatForever:create(sequene)
	
	node:runAction(repeatForever)
end

-- UIText控件的宽度适配貌似有问题，来回切换的时候 好像会把字挤窄，转换宽度适配方式
function adaptUITextWidth( uiText, withoutSpace )
	if withoutSpace == nil then
		withoutSpace = true
	end
	
	uiText:getVirtualRenderer():setLineBreakWithoutSpace(withoutSpace)
	uiText:getVirtualRenderer():setMaxLineWidth(uiText:getContentSize().width)
	uiText:ignoreContentAdaptWithSize(true)
end

-- 动态创建 消耗的Item
-- 自动调整数量和坐标
function createCostItems( viewLogic, container, itemList, costList, maxWidth, space, show_type)
    local len = #costList

    local space = space or 20
    local cellWidth = 74

    local panelCotainerWidth = space * (len -1) + cellWidth * len
    if maxWidth and panelCotainerWidth > maxWidth then
    	panelCotainerWidth = maxWidth
    	space = (panelCotainerWidth - cellWidth * len)/(len -1)
    end

    local panelCotainerHeight = container:getContentSize().height
    container:setContentSize({width = panelCotainerWidth,height = panelCotainerHeight})
    for i,v in ipairs(costList) do
        local item = itemList[i]
        if item == nil then
            item = ItemNode.new()
            item:setShowType(show_type or ITEMNODE_SHOWTYPE.COST)
            item:setSpecialValid(false)
            item:openView(container, viewLogic)
            table.insert(itemList,item)
        end

        item:setVisible(true)
        item:setPosition(cc.p(cellWidth * (i) + space *(i-1) - cellWidth/2 ,panelCotainerHeight/2))
        item:UpdateInfo(v,i)
    end

    for i=#costList + 1,#itemList do
        itemList[i]:setVisible(false)
    end
end


-- 在node左右切换时，有可能快速连续点击切换按钮，导致___onMoveActionEnd___没有被回调，所以需要判定并且尝试回调
function nodeSwitchAction(node, dir, onEnd, pos, offset)
	offset = offset or 30

    if node.___onMoveActionEnd___ then
        node.___onMoveActionEnd___()
    end

	node:stopAllActions()
	node:setPosition(pos)

	if not dir then dir = 1 end
    
    node.___onMoveActionEnd___ = onEnd
	local cb = function ()
		if node.___onMoveActionEnd___ then
	        node.___onMoveActionEnd___()
			node.___onMoveActionEnd___  = nil
	    end
	end

	node:runAction(
		cc.Sequence:create(
			cc.Spawn:create(cc.FadeOut:create(0.05), cc.MoveBy:create(0.10, cc.p(-offset*dir,0))),
			cc.Place:create(cc.p(pos.x + offset*dir, pos.y)),
			cc.CallFunc:create(cb),
			cc.Spawn:create(cc.FadeIn:create(0.05), cc.MoveBy:create(0.10, cc.p(-offset*dir,0)))
		))
end



-- 金币等收集粒子移动特效
-- srcPos、destPos为worldPos
function playCollectParticle( srcPos, destPos, imgName, particleName )
    local layer = SceneHelper.getLayer(SceneHelper.LAYER_TYPE.TIPS_LAYER)
    srcPos = layer:convertToNodeSpace(srcPos)
    destPos = layer:convertToNodeSpace(destPos)

	local function generate( data, count )
	    local tempDurantion = 0.1 * math.random(5,8)
	    
	    local node = cc.Node:create()
	    local sprite = cc.Sprite:create()
	    CCX.setNodeImg(sprite, imgName)
	    node:setScale(0.1 * math.random(5,9))
	    node:addChild(sprite)

	    node:setPosition(cc.p(srcPos.x + math.random(0, 60), srcPos.y + math.random(0, 60)))
	    layer:addChild(node)

	    if count == 1 or count == 3 or count == 5 then
	        local particle = cc.ParticleSystemQuad:create(particleName)
	    	particle:setBlendFunc(gl.ONE, gl.ONE)
	    	node:addChild(particle)
	    end

	    local motion1 = cc.Spawn:create(cc.ScaleTo:create(0.125,1,0.7,1),cc.SkewTo:create(0.125,45,45))
	    local motion2 = cc.Spawn:create(cc.ScaleTo:create(0.125,1,0.3,1),cc.SkewTo:create(0.125,0,0))
	    local motion3 = cc.Spawn:create(cc.ScaleTo:create(0.125,1,0.7,1),cc.SkewTo:create(0.125,-45,-45))
	    local motion4 = cc.Spawn:create(cc.ScaleTo:create(0.125,1,1,1),cc.SkewTo:create(0.125,0,0))
	    local actionArray1 = {motion1,motion2,motion3,motion4}

	    local moveTo =  cc.MoveTo:create(tempDurantion, cc.p(destPos.x + 20, destPos.y + 20))
	    local removeTemp = function (  )
		    node:removeFromParent()
	    end

	    local callFuc = cc.CallFunc:create(removeTemp)
	    local actionArray = {moveTo, callFuc}

        node:runAction(cc.Sequence:create(actionArray))
        sprite:runAction(cc.RepeatForever:create(cc.Sequence:create(actionArray1)))
	end

	Scheduler.scheduleForRepeat( generate, 0.125, nil, 8 )
end