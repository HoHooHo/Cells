module("MessageCache", package.seeall)

local _handler = nil

-- [Dse] = msg
local _msgCache = {}

-- [Dce] = Dse
local _filterOnce = nil
local _filterNewDay =  nil

-- [dse] = true
local _needCache = {}
local _onlyListenDic = {}

local _ready = false

local _pkgMap = nil

local _dseTypes = {}


local function onNewDay()
	for k,v in pairs(_filterNewDay) do
		_msgCache[v] = nil
	end
	EventSystem.dispatchEvent(EventType.NEW_DAY)
end

local function init()
	if _ready then return end
	_ready = true


	-- 需要缓存的消息 永久性的
	_filterOnce = 
	{
		-- [ID_DceHeartbeat] = ID_DseHeartbeat,
	}


	-- 需要缓存的消息，跨天需要重新处理的
	_filterNewDay = 
	{
		-- [ID_DceStageList] = ID_DseStageList,
		-- [ID_DceCampaignRequireData] = ID_DseCampaignRequireData,		--空岛之战	-- 多处刷新没法改缓存
	}




	for k,v in pairs(_filterOnce) do
		_needCache[v] = true
	end

	for k,v in pairs(_filterNewDay) do
		_needCache[v] = true
	end

	NetMessageSystem.registerMessageListener(ID_DseSetNewDay, onNewDay, NetMessageSystem.PRIORITY_LEVEL.HIGH)
end


local function checkMSG( dceType )
	local dseType = _filterOnce[dceType]

	if not dseType then
		dseType = _filterNewDay[dceType]
	end

	if dseType then
		return _msgCache[dseType], dseType
	else
		return nil, nil
	end

end

local function dispatchMsg( data )
	if _handler then
		_handler(data.type, data.msg)
	end
end

-- 某条消息请求，没有名字对应的DSE时，设置一个对应的DSE
local SPECIAL_DCE_DSE = nil
local function getSpecialDceToDse( dceType )
	if SPECIAL_DCE_DSE == nil then

		SPECIAL_DCE_DSE = {
			[ID_DceMining_DetailData] = ID_DseMining_ChestData,
			[ID_DceSendAllFriendPoint] = ID_DseSendFriendPoint,
		}

	end

	return SPECIAL_DCE_DSE[dceType]
end

function sendRequest( dceType, data, onlySend, force, delayShow )
	local msg, dseType = checkMSG( dceType )
	if msg and (not force) then
		-- logF("FROM CACHE:   " .. dceType , "MSG_CACHE", "a")
		Scheduler.scheduleOnce( dispatchMsg, 0.01, {type = dseType, msg = msg})
	else
		-- logF("FROM REQUEST: " .. dceType , "MSG_CACHE", "a")
		if not onlySend then
			local dseType = _pkgMap:GetDesTypeByDceType(dceType) or getSpecialDceToDse( dceType )
			if dseType then
				_dseTypes[dseType] = 1 + (_dseTypes[dseType] or 0)
			else
		        error("\n\n***ERROR*** " .. _pkgMap:GetDescriptorName( dceType ) .. " dosen't mapped ID_Dse ***ERROR***")
			end
			-- Global.showTips("dceType is " .. dceType)
	        NetLoadingViewLogic.show( delayShow )
        	-- Global.showTips("sendRequest: dceType")
		end
		HeartBeatManager.tryHeartBeat()
		NetMessageSystem._sendRequest( dceType, data, onlySend )
	end
end

local function cacheMsg( dseType, msg )
	if _needCache[dseType] then
		_msgCache[dseType] = msg
	end
end

local function onSocketMsg( pkgType, msg )
	cacheMsg(pkgType, msg)

	if pkgType == ID_DseAuthState or _dseTypes[pkgType] then
		if pkgType ~= ID_DseAuthState then
			_dseTypes[pkgType] = _dseTypes[pkgType] - 1
			if _dseTypes[pkgType] == 0 then
				_dseTypes[pkgType] = nil
			end
		end
		-- Global.showTips("receive type is " .. pkgType)
    	NetLoadingViewLogic.hide()
    end
    
    dispatchMsg{type = pkgType, msg = msg}
end

function deleteMsgCache(dse)
	_msgCache[dse] = nil
end

function setNetHandler( handler, netProxy )
	init()
	_handler = handler
	_pkgMap = ProtocolMgr:GetPkgMap()

	netProxy.setNetHandler( onSocketMsg )
end

-- 关闭socket连接时，清除_dseTypes
function clearDseTypes()
	_dseTypes = {}
end

function onReconnectNet()
	local text = ""
	for k,v in pairs(_dseTypes) do
		text = text .. tostring(_pkgMap:GetDescriptorName( k )) .. "_" .. tostring(v) .. "##"
	end

	local data = {
				uid = ServerConfig.UID,
				text = text
            }

    WebMessageSystem.sendRequest(WebMessageType.CUSTOM_EVENT, data, true)
end