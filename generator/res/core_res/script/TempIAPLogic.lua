module("TempIAPLogic", package.seeall)

local _time = 0
local _cash = {}

local DETAL = 8

local function onIAP( id )
    local now = socket.gettime()
    local temp = math.ceil(now - _time)
    if temp >= DETAL then
        if _cash[id] then
            Global.showTips("这个你点过了已经，别再点了！")
        else
            _time = now
            Global.showTips(tostring(id))
            NetMessageSystem.sendRequest( ID_DceRechargeBroadcast, {cashid = id}, true )
            _cash[id] = true
        end
    else
        Global.showTips("那么着急干嘛，休息" .. (DETAL - temp) .. "秒钟！")
    end

end

function tempIAP(  )
	local layer = cc.Layer:create()
    SceneHelper.addChild(layer, SceneHelper.LAYER_TYPE.TIPS_LAYER)


    local scroll = ccui.ScrollView:create()

    scroll:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
    scroll:setBackGroundColor(cc.c3b(0, 255, 0))
    scroll:setBackGroundColorOpacity(100)

    scroll:setContentSize(WIN_SIZE)
    scroll:setTouchEnabled(true)
    scroll:setBounceEnabled(true)
    scroll:setAnchorPoint(0.5, 0.5)
    scroll:setPosition(WIN_CENTER)


    local inner = scroll:getInnerContainer()
    inner:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
    inner:setBackGroundColor(cc.c3b(0, 0, 255))
    inner:setBackGroundColorOpacity(100)

    local cashLen = TemplateManager.getLen("CashDataTemplate")

    for i,v in ipairs(TemplateManager.getLookContentTemplate("CashDataTemplate")) do
        local text = ccui.Text:create()
        text:setString(v.name)
        text:setFontSize(30)
        text:setColor(cc.c3b(255, 0, 0))
        text:setTouchEnabled(true)
        text:setTouchScaleChangeEnabled(true)

        text:setPosition(cc.p(WIN_SIZE.width/2, (cashLen + 1 - i)*45))

        text:addClickEventListener(function (  )
            onIAP( v.id )
        end)

        scroll:addChild(text)
    end

    scroll:setInnerContainerSize(cc.size(WIN_SIZE.width, cashLen*45 + 100))

    layer:addChild(scroll)



    local _close_ = ccui.Text:create()
    _close_:setAnchorPoint(cc.p(0.5, 0.5))
    _close_:setString("close")
    _close_:setFontSize(40)
    _close_:setColor(cc.c3b(255, 255, 255))
    _close_:setPosition(cc.p(WIN_SIZE.width - 100, WIN_SIZE.height - 100))
    _close_:setTouchEnabled(true)
    _close_:setTouchScaleChangeEnabled(true)
    layer:addChild(_close_)


    local function closeView(  )
        layer:removeFromParent()
    end

    _close_:addClickEventListener(closeView)
end