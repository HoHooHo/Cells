PkgMap = class("PkgMap")

function PkgMap:ctor()
    -- 记录 PackageType --> Message 如 _arrIndex[67] = BseLogin
    self._arrIndex = {}
    -- 记录Messsage --> PackageType的对应, 如_arrIndex[BseLogin] = 67
    self._arrTypes = {}
end


function PkgMap:AddPkg(msgType, cls)
    if (self._arrIndex[msgType] ~= nil) then
        -- log("Already register Pakcage Type for "..msgType)
        return false
    end

    if cls == nil then
        -- log("cls is nil for msgType: "..msgType)
        return false
    end

    self._arrIndex[msgType] = cls
    self._arrTypes[cls] = msgType
end

function PkgMap:GetPkg(msgType)
    if self._arrIndex[msgType] == nil then
        ProtocolMgr:InitByID( msgType )
    end

    return self._arrIndex[msgType]
end

function PkgMap:GetPkgType(pkg)
    return self._arrTypes[pkg]
end

function PkgMap:GetDescriptorName( msgType )
    local pkg = self:GetPkg(msgType)

    return tostring(getmetatable(pkg)._descriptor.name)
end

function PkgMap:GetDesTypeByDceType( dceType )
    local dceName = self:GetDescriptorName( dceType )
    local dceKeyName = "ID_" .. dceName
    local dseKeyName = string.gsub(dceKeyName, "ID_Dce", "ID_Dse")

    return _G[dseKeyName]
end
