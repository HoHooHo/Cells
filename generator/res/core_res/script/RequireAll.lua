-- require "ServerConfig"


-- require "Lang/Lang"
-- require "Lang/CSBLang"


-- require "Template/TemplateLang"
-- require "Template/TemplateManager"

-- require "RequireCore"


-- require "SDKHelper/SDKManager"

-- require "TimelineHelper"

-- require "GlobalConsts"

-- -- 为了提前load url  放在此处require
-- require "ViewLogic/Login/NoticeViewLogic"

-- require "protocol/ProtocolMgr"

-- require "RequireModule"

-- require "RequireView"




local LUA_FILES =  {}

local function init()
	table.insert(LUA_FILES, "ServerConfig")


	table.insert(LUA_FILES, "Lang/Lang")
	table.insert(LUA_FILES, "Lang/CSBLang")


	table.insert(LUA_FILES, "Template/TemplateLang")
	table.insert(LUA_FILES, "Template/TemplateManager")


	table.insert(LUA_FILES, "MusicHelper")

	local allCore = require("RequireCore")

	for i,v in ipairs(allCore) do
		table.insert(LUA_FILES, v)
	end

	table.insert(LUA_FILES, "SDKHelper/SDKManager")

	table.insert(LUA_FILES, "TimelineHelper")

	table.insert(LUA_FILES, "GlobalConsts")
	table.insert(LUA_FILES, "GlobalFunc")
	table.insert(LUA_FILES, "ViewLogic/Login/NoticeViewLogic")

	table.insert(LUA_FILES, "protocol/ProtocolMgr")



	local allModule = require("RequireModule")

	for i,v in ipairs(allModule) do
		table.insert(LUA_FILES, v)
	end


	local allViewLogic = require("RequireView")

	for i,v in ipairs(allViewLogic) do
		table.insert(LUA_FILES, v)
	end
end


local REQUIRE_UNIT = 50
local INIT_UNIT = 5

function requireAll( cb, initFunc )
	local requireAllStart = socket.gettime()
	LUA_FILES = {}
	init()

	local luaCount = #LUA_FILES
	local totalCount = luaCount + #initFunc


	local nowCount = 0

    --借用下载面板的进度的条
    DownloadViewLogic.updateProgress( nowCount, totalCount, true )

	local entryId = nil

    local callback = function (  )
	    if nowCount >= totalCount then
	    	if Config.Debug then
		    	local requireAllEnd = socket.gettime()
	    		Global.showTips(requireAllEnd - requireAllStart)
	    	end

	        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(entryId)
	        cb()
	        return

        elseif nowCount >= luaCount then
        	for i=1, INIT_UNIT do
		    	nowCount = nowCount + 1
		    	if nowCount > totalCount then
		    		nowCount = totalCount
		    		break
		    	end

		        local func = initFunc[nowCount - luaCount]

		        logW(func[1] .. "." .. func[2])

		        _G[func[1]][func[2]]()
        	end
	    else
		    for i=1, REQUIRE_UNIT do
		    	nowCount = nowCount + 1
		    	if nowCount > luaCount then
		    		nowCount = luaCount
		    		break
		    	end

		    	-- logW(LUA_FILES[nowCount])

		    	require(LUA_FILES[nowCount])
		    end
	    end

	    DownloadViewLogic.updateProgress( nowCount, totalCount, true )
    end

    entryId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(callback, 0.01, false)
end

