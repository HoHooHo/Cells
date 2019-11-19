module("NetProxy", package.seeall)

_ip = nil
_port = nil

_pkgMap = nil

_pdString = nil
_pbFinalString = nil

_netHandler = nil
_errorHandler = nil

_uid = nil
_secret = nil

function initProxy( ip, port, pkgMap )
    _ip = ip
    _port = port
    _pkgMap = pkgMap

    _pdString = pb.new_iostring()
    _pbFinalString = pb.new_iostring()
end

function getPkg( type )
    local pkg = _pkgMap:GetPkg(type)
    if (pkg == nil) then
        log("Can not get package for " .. type)
    end 
    return pkg
end

function getClearPkg( type )
    local pkg = _pkgMap:GetPkg(type)
    if (pkg == nil) then
        log("Can not get package for " .. type)
    end 
    -- pkg:Clear()
    
    return pkg
end

function getPkgMap(  )
    return _pkgMap
end

function setIP( ip )
    _ip = ip
end

function setPort( port )
    _port = port
end

function setNetHandler( handler )
    _netHandler = handler
end

function setErrorHandler( handler )
    _errorHandler = handler
end

function setUID( uid )
    _uid = uid
end

function setSecret( secret )
    _secret = secret
end

function getUID(  )
    return ServerConfig.UID
end

function getSecret(  )
    return ServerConfig.SECRET
end

function startNet( ip, port, pkgMap )
    error("\n***ERROR*** NetProxy.startNet() should be override ***ERROR***")
end

function send( pkg )
    error("\n***ERROR*** NetProxy.send() should be override ***ERROR***")
end


function clear( pkg )
    log("==== ****    CLEAR   **** ====")
end