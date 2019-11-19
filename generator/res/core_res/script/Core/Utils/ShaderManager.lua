module("ShaderManager", package.seeall)


local TARGET_PLATFORM = cc.Application:getInstance():getTargetPlatform()

local SHADERS = {
    SEA        = {fileName = "shader/sea", moduleName = "sea", vertName = "vert", fragName = "frag"},
}

local _programs = {}

local function getGLProgramKey( shaderKey, value )
    return QuickMD5:getInstance():MD5String( shaderKey .. "_" .. value.fileName .. "_" .. value.moduleName .. "_" .. value.vertName .. "_" .. value.fragName )
end

function init()
    for k,v in pairs(SHADERS) do
        local key = getGLProgramKey(k, v)
        local program = cc.GLProgramCache:getInstance():getGLProgram(key)

        if program == nil then
            require(v.fileName)
            
            local moduleName = _G[v.moduleName]

            program = cc.GLProgram:createWithByteArrays(moduleName[v.vertName], moduleName[v.fragName])
            cc.GLProgramCache:getInstance():addGLProgram(program, key)

            -- logD(type(program))
        end

        _programs[k] = program
    end
end

function getProgram( key )
    return _programs[key]
end


function testSea(  )
    local sea = cc.Sprite:create("img/sea/water.png")
    sea:setPosition(cc.p(320, 568))
    sea:setScale(2)


    local normalMapTextrue = cc.Director:getInstance():getTextureCache():addImage( "img/sea/water_normal.png" )
    normalMapTextrue:setTexParameters(gl.LINEAR, gl.LINEAR, gl.REPEAT, gl.REPEAT)


    sea:setGLProgram(ShaderManager.getProgram("SEA"))
    sea:getGLProgramState():setUniformTexture("u_normalMap", normalMapTextrue:getName())

    return sea
end