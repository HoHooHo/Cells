
require "res/Cocos/Cocos2d/Cocos2d"
require "res/Cocos/Cocos2d/Cocos2dConstants"
require "res/Cocos/Cocos2d/extern"
require "res/Cocos/Cocos2d/bitExtend"
require "res/Cocos/Cocos2d/DrawPrimitives"

-- Opengl
require "res/Cocos/Cocos2d/Opengl"
require "res/Cocos/Cocos2d/OpenglConstants"

-- CocosDenshion
require "res/Cocos/CocosDenshion/AudioEngine"

-- Cocosstudio
require "res/Cocos/CocoStudio/CocoStudio"

-- ui
require "res/Cocos/UI/GuiConstants"
require "res/Cocos/UI/ExperimentalUIConstants"

-- Extensions
require "res/Cocos/Extension/ExtensionConstants"

-- network
require "res/Cocos/NetWork/NetworkConstants"


--LuaBridge
local targetPlatform = cc.Application:getInstance():getTargetPlatform()
if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) then
     LuaBridge = require "res/Cocos.Cocos2d.luaoc"
elseif (cc.PLATFORM_OS_ANDROID == targetPlatform) then
    LuaBridge = require "res/Cocos.Cocos2d.luaj"
end