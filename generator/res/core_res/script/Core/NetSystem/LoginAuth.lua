module("LoginAuth", package.seeall)

-- 登陆，a消息
function sendAuth( ip, port, socket, uid, secret, errorHandler )
    --TGW改造
    -- local finalbuffertgw = pb.new_iostring()
    local authStringtgw =  "tgw_17_forward\r\nHost: " .. ip .. ":" .. port .. "\r\n\r\n"
    local res = socket:send(authStringtgw)
    -- finalbuffertgw:write(authStringtgw)

    if res == nil or res <= 0 then
        NetLoadingViewLogic.clear()
        errorHandler()
    end

    local finalbuffer = pb.new_iostring()
    local authString = "a," .. uid .. "," .. secret
    finalbuffer:writeShort(#authString)
    finalbuffer:write(authString)

    local res = socket:send(finalbuffer:__tostring())

    if res == nil or res <= 0 then
        NetLoadingViewLogic.clear()
        errorHandler()
    end

    log("#####  SendAuth: " .. authString .. "  #####")
end

local _dialogLogic = nil

local function onAuth( pkg )
    if pkg.pass == true then 
        RecordLogic.record(RecordLogic.ID.LOGIN_SUCC)
        --登陆成功
        log("####  Login Success !  ####")
        ServerConfig.GAME_LOGINED = true

        HeartBeatManager.heartBeat()

        --登录成功统计事件
        EventSystem.dispatchEvent(EventType.TUNE_STATISTICS_LOGIN_SUCCESS)
    else
        RecordLogic.record(RecordLogic.ID.LOGIN_FAILED)
        logW("####  Login Error ! code : " .. pkg.type .. "  ####")
        if pkg.type == 1 then--登陆验证失败，禁止重新连接
            if _dialogLogic == nil then
                _dialogLogic = CommonDialogViewLogic.new(getLang("温馨提示"), getLang("无法连接服务器，请重启游戏"), nil, restartGame, nil, getLang("重新启动"), true)
                _dialogLogic.viewLevel = SceneHelper.LAYER_TYPE.EXIT_LAYER
                _dialogLogic:openView()
            end
        elseif pkg.type == 2 then--封停
            Global.showTips( string._format(getLang("账号已封停，预计%.2f小时后解封！"), pkg.leftMin / 60)  )
        end
    end
end

function init()
    NetMessageSystem.registerMessageListener(ID_DseAuthState, onAuth)
end