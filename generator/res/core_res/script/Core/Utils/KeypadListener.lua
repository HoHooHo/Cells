module("KeypadListener", package.seeall)

local hideChat = false

local function onKeyReleased( keyCode, event )
	-- Global.showTips( keyCode .. "  " .. cc.KeyCodeKey[keyCode + 1], cc.c3b(255, 0, 0), true )
	if keyCode == cc.KeyCode.KEY_BACK then
		-- android物理返回键 处理
		---用于公告等返回
		if not ServerConfig.GAME_LOGINED then
			EventSystem.dispatchEvent(EventType.BACK_VIEW_BEFORAE_LOGIN)
			return
		end
		
		if NetLoadingViewLogic.isShow() or BattleManager.inBattle() or NoviceGuideManager.isGuide() or ActivityData._isMarchAnim then
			return
		end
		--TL adbrix startSession
		if SDKManager and SDKManager.adbrixStartSession then
			SDKManager.adbrixStartSession()
		end
		if hideChat then
			EventSystem.dispatchEvent(EventType.CHAT_LAYER_VISIBLE, { visible = false })
		else
			EventSystem.dispatchEvent(EventType.BACK_VIEW)
		end
	end
end



local function onChatVisible( data )
	hideChat = data.visible and ChatData.CHAT_LAYER_MODE.ONLY_CHAT == data.showType
end

function init(  )
	local layer = cc.Layer:create()

	local listener = cc.EventListenerKeyboard:create()
	listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED)

	layer:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, layer)

	SceneHelper.getRunningScene():addChild(layer, 0)


	EventSystem.registerEventListener(EventType.ON_CHAT_LAYER_VISIBLE_EVENT, onChatVisible)
end