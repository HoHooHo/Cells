module("NetMessageSystem", package.seeall)

-- 消息的优先级 分三级
PRIORITY_LEVEL = {
	HIGH   = 1,
	NORMAL = 2,
	LOW    = 3,
}

ERROR_CODE =
{
    TIMEOUT = -1  ,
    FAILED  = 404 ,
    SOCKET_CLOSED = "closed",
    CANNOT_CONNECT = "cannot_connect"
}

local _netProxy = nil
local _messageListenerCache = {}

local KEY_MESSAGE_TYPE = 1
local KEY_MESSAGE_LISTENER = 2


local descriptor = require "descriptor"
local FieldDescriptor = descriptor.FieldDescriptor

local _dialogLogic = nil

local _reconnectCount = 0
local RECONNECT_MAX_COUNT = 3

local _notParseDic = {}

function addNotParseMessge(msgType)
	_notParseDic[msgType] = true
end

local function alert( errorCode )
	local title = getLang("温馨提示")
	local content = getLang("发生未知错误")
	-- local cancel = getLang("取消")
	local reconnect = getLang("重新连接")

	local cb = function()
		_dialogLogic = nil
		_netProxy.restartNet()
	end

	log(" *** NetMessageSystem: errorCode  "  .. tostring(errorCode))
	
	if errorCode == ERROR_CODE.TIMEOUT then
		log(" *** NetMessageSystem: errorHandler  TIMEOUT *** ")
	elseif errorCode == ERROR_CODE.FAILED then
		log(" *** NetMessageSystem: errorHandler  FAILED *** ")
	elseif errorCode == ERROR_CODE.SOCKET_CLOSED then
		log(" *** NetMessageSystem: errorHandler  SOCKET CLOSED *** ")
		content = getLang("服务器断开连接")
	elseif errorCode == ERROR_CODE.CANNOT_CONNECT then
		log(" *** NetMessageSystem: errorHandler  SOCKET CANNOT CONNECT *** ")
		_reconnectCount = _reconnectCount + 1
		content = getLang("无法连接服务器，请重试")
		if _reconnectCount >= RECONNECT_MAX_COUNT then
			content = getLang("无法连接服务器，请重启游戏")
			reconnect = getLang("重新启动")
			cb = restartGame
		end
	else
		log(" *** NetMessageSystem: errorHandler  UNKNOWN ERROR *** "  .. tostring(errorCode))

		content = content .. "( " .. tostring(errorCode) .. " )"
	end

	if _dialogLogic == nil then
		_dialogLogic = CommonDialogViewLogic.new(title, content, cb, cb, nil, reconnect, true)
		_dialogLogic.viewLevel = SceneHelper.LAYER_TYPE.EXIT_LAYER
		_dialogLogic:openView()
	end
end

function pkg_table( msg )
	local ret = {}
    for field, value in msg:ListFields() do

        local put_field = function(field_value, repeated)
	        local name = field.name
            -- write(string.rep(" ", indent))
            if field.type == FieldDescriptor.TYPE_MESSAGE then
                local extensions = getmetatable(msg)._extensions_by_name
                if extensions[field.full_name] then
                    -- write("[" .. name .. "] {\n")
                else
                    -- write(name .. " {\n")
                end
                if repeated then
                	if ret[name] == nil then
                		ret[name] = {}
                	end
                	table.insert(ret[name], pkg_table(field_value))
                else
	                ret[name] = pkg_table(field_value)
                end
                -- write(string.rep(" ", indent))
                -- write("}\n")
            else
                -- write(string._format("%s: %s\n", name, tostring(field_value)))
                if repeated then
                	if ret[name] == nil then
                		ret[name] = {}
                	end
                	table.insert(ret[name], field_value)
                else
	                ret[name] = field_value
                end

            end
        end

        if field.label == FieldDescriptor.LABEL_REPEATED then
            for _, k in ipairs(value) do
                put_field(k, true)
            end
        else
            put_field(value)
        end
    end

    return ret
end

local function dispatchMessage( msgType, msg )
	_reconnectCount = 0

	if Config.Debug and cc.PLATFORM_OS_WINDOWS == cc.Application:getInstance():getTargetPlatform() then 
		local str = "### msgName = " .. getmetatable(msg)._descriptor.name .."  msgType = " .. msgType .. "  byteSize= " .. msg:ByteSize() .." ###"
		logC( logbit(F_R, F_B), str )
		XDebug.xMsg(0, str)
	end

	local caches = _messageListenerCache[msgType]

	if caches == nil or (#caches[PRIORITY_LEVEL.HIGH] == 0 and #caches[PRIORITY_LEVEL.NORMAL] == 0 and #caches[PRIORITY_LEVEL.LOW] == 0) then
		log("NetMessageSystem: nothing has registered with "..msgType)
		return
	end
	
	local msgTable
	if _notParseDic[msgType] then
		msgTable = msg
	else
		msgTable = pkg_table(msg)
	end

	for i,v in ipairs(caches) do
		for i,cacheObj in ipairs(v) do
			if cacheObj and cacheObj[KEY_MESSAGE_LISTENER] then
				cacheObj[KEY_MESSAGE_LISTENER]( msgTable )
			end
		end
	end
end

function simulateDispatchMessage( msgType, msgTable )
	local caches = _messageListenerCache[msgType]

	if caches == nil or (#caches[PRIORITY_LEVEL.HIGH] == 0 and #caches[PRIORITY_LEVEL.NORMAL] == 0 and #caches[PRIORITY_LEVEL.LOW] == 0) then
		log("NetMessageSystem[simulate]: nothing has registered with "..msgType)
		return
	end

	for i,v in ipairs(caches) do
		for i,cacheObj in ipairs(v) do
			if cacheObj and cacheObj[KEY_MESSAGE_LISTENER] then
				cacheObj[KEY_MESSAGE_LISTENER]( msgTable )
			end
		end
	end
end

local function errorHandler( errorCode )
	alert( errorCode )
end

local function cacheListener( messageType, listener, priority )
	if _messageListenerCache[messageType] == nil then
		_messageListenerCache[messageType] = {}

		for k,v in pairs(PRIORITY_LEVEL) do
			_messageListenerCache[messageType][v] = {}
		end
	end

	local cacheObj = {
						[KEY_MESSAGE_TYPE] = messageType,
						[KEY_MESSAGE_LISTENER] = listener
					}

	local caches = _messageListenerCache[messageType]

	for i,v in ipairs(caches[priority or PRIORITY_LEVEL.NORMAL]) do
		if v[KEY_MESSAGE_LISTENER] == listener then
			return false
		end
	end

	table.insert(caches[priority or PRIORITY_LEVEL.NORMAL], cacheObj)

	return true
end

function registerMessageListener( messageType, listener, priority )
	if listener == nil then
		error("\n\n####### listener is nil #######\n")
	end

	if messageType == nil then
		error("\n\n####### MESSAGE_TYPE is nil #######\n")
	end

	ProtocolMgr:InitByID( messageType )

	if cacheListener(messageType, listener, priority) then
		log("NetMessageSystem: registered message "..messageType.." success")
	else
		log("NetMessageSystem: cannot repeat registered message")
	end
end

function unregisterMessageListener( messageType, listener, priority )
	if listener == nil then
		error("\n\n####### listener is nil #######\n")
	end

	if messageType == nil then
		error("\n\n####### MESSAGE_TYPE is nil #######\n")
	end

	local caches = _messageListenerCache[messageType]

	if caches == nil then
		log("NetMessageSystem: nothing has registered with "..messageType)
		return
	end

	local unregister = false

	for i,v in ipairs(caches[priority or PRIORITY_LEVEL.NORMAL]) do
		if v[KEY_MESSAGE_LISTENER] == listener then
			table.remove(caches[priority or PRIORITY_LEVEL.NORMAL], i)
			log("NetMessageSystem: unregisterMessage "..messageType.." success")
			unregister = true
			break
		end
	end

	if not unregister then
		log("NetMessageSystem: has not registered with "..messageType)
	end
end

function init(  )
	_netProxy = SocketProxy
	-- _netProxy = HttpProxy

	MessageCache.setNetHandler( dispatchMessage, _netProxy )

	_netProxy.startNet(ServerConfig.SERVER_IP, ServerConfig.SERVER_PORT, ProtocolMgr:GetPkgMap())
	-- _netProxy.setNetHandler( dispatchMessage )
	_netProxy.setErrorHandler( errorHandler )
	_pkgMap = _netProxy.getPkgMap()
	-- sendRequest(nil)
end

function getPkg( type )
	return _netProxy.getClearPkg(type)
end

local generatePB = nil

generatePB = function ( pkg, fields, data )
	pkg:Clear()
	if fields then
		for k,v in pairs(fields) do
			if data[v.name] then
				if v.message_type then
					local pbDataFn = protobuf.Message(v.message_type)

					if v.label == descriptor.FieldDescriptor.LABEL_REPEATED then
						for rk,rv in pairs(data[v.name]) do
							local pbData = pbDataFn()
							generatePB(pbData, v.message_type.fields, rv)
							table.insert(pkg[v.name], pbData)
						end
					else
						generatePB(pkg[v.name], v.message_type.fields, data[v.name])
					end

				else
					if v.label == descriptor.FieldDescriptor.LABEL_REPEATED then
						for rk,rv in pairs(data[v.name]) do
							table.insert(pkg[v.name], rv)
						end
					else
						pkg[v.name] = data[v.name]
					end
				end
			end
		end
	end
end

function _sendRequest( msgType, data, onlySend )
	ProtocolMgr:InitByID( msgType )

	local pkg = getPkg(msgType)

	if Config.Debug then 
		local str = "@@@ msgName = " .. tostring(getmetatable(pkg)._descriptor.name) .. " msgType = " .. msgType .." @@@"
		logC( logbit(F_G), str)
		XDebug.xMsg(0, str)
	end

	if data then
		generatePB(pkg, getmetatable(pkg)._descriptor.fields, data)
	end
	
	_netProxy.send( pkg )
end

-- msgType 	协议ID
-- data 	数据
-- onlySend 	是否不显示屏蔽层  true为不显示
-- force 	对于有缓存的消息，是否忽略缓存，强制请求服务器 true为强制请求服务器
-- delayShow 	是否延时显示屏蔽层 delayShow的值为延时时间（为数值）
function sendRequest( msgType, data, onlySend, force, delayShow )
	if _dialogLogic then
		return
	end

	if msgType == nil then
		error("\n\n####### MESSAGE_TYPE is nil #######\n")
	end

	MessageCache.sendRequest( msgType, data, onlySend, force, delayShow )
end

function reconnectNet(  )
	if _netProxy then
		_netProxy.reconnectNet()
	end
end

function onRestart()
	if _netProxy then
		_netProxy.clear()
	end
end

setRestartListener(onRestart)

