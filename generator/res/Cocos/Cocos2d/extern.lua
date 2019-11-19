
function clone(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs(object) do
            new_table[_copy(key)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

--Create an class.
function class(classname, super)
    if super and type(super) == "table" and super._realrequire_ then
        super = super._realrequire_()
    end

    local superType = type(super)
    local cls

    if superType ~= "function" and superType ~= "table" then
        superType = nil
        super = nil
    end

    if superType == "function" or (super and super.__ctype == 1) then
        -- inherited from native C++ Object
        cls = {}

        if superType == "table" then
            -- copy fields from super
            for k, v in pairs(super) do cls[k] = v end
            cls.__create = super.__create
            cls.super    = super
        else
            cls.__create = super
        end

        cls.ctor = function() end
        cls.autoInit = function() end
        cls.__cname = classname
        cls.__ctype = 1

        cls._isSingleton = false
        cls._instance = nil

        function cls.new(...)
        	if cls._isSingleton then
				error("\n####### [" .. cls.__cname .. "] is a SingleTon. please use 'getInstance' #######\n")
        	end
        	
            local instance = cls.__create(...)
            -- copy fields from class to native object
            for k,v in pairs(cls) do instance[k] = v end
            instance.class = cls
            instance:ctor(...)
            instance:autoInit(  )
            return instance
        end

        function cls.getInstance(...)
            cls._isSingleton = true

            if cls._instance == nil then
                
                local instance = cls.__create(...)
                -- copy fields from class to native object
                for k,v in pairs(cls) do instance[k] = v end

                cls._instance = instance

                cls._instance.class = cls
                cls._instance:ctor(...)
                cls._instance:autoInit(  )
            end
            return cls._instance
        end

        function cls.createIns(...)
            if cls._createIns_ == nil then
                
                local instance = cls.__create(...)
                -- copy fields from class to native object
                for k,v in pairs(cls) do instance[k] = v end

                cls._createIns_ = instance

                cls._createIns_.class = cls
                cls._createIns_:ctor(...)
                cls._createIns_:autoInit(  )
            end

            return cls._createIns_
        end
    else
        -- inherited from Lua Object
        if super then
            cls = clone(super)
            cls.super = super
        else
            cls = {ctor = function() end, autoInit = function() end}
        end

        cls.__cname = classname
        cls.__ctype = 2 -- lua
        cls.__index = cls

        cls._isSingleton = false
        cls._instance = nil

        function cls.new(...)
        	if cls._isSingleton then
				error("\n####### [" .. cls.__cname .. "] is a SingleTon. please use 'getInstance' #######\n")
        	end

            local instance = setmetatable({}, cls)
            instance.class = cls
            instance:ctor(...)
            instance:autoInit(  )
            return instance
        end


        function cls.getInstance(...)
            cls._isSingleton = true

            if cls._instance == nil then
                cls._instance = setmetatable({}, cls)
                cls._instance.class = cls
                cls._instance:ctor(...)
                cls._instance:autoInit(  )
            end
            return cls._instance
        end


        -- 某些界面可能同时只存在一个，又不需要用单例（单例会常驻内存，在关闭界面的时候不会释放），调用此方法吧
        function cls.createIns(...)
            if cls._createIns_ == nil then
                cls._createIns_ = setmetatable({}, cls)
                cls._createIns_.class = cls
                cls._createIns_:ctor(...)
                cls._createIns_:autoInit(  )
            end

            return cls._createIns_
        end
    end

    return cls
end

function schedule(node, callback, delay)
    local delay = cc.DelayTime:create(delay)
    local sequence = cc.Sequence:create(delay, cc.CallFunc:create(callback))
    local action = cc.RepeatForever:create(sequence)
    node:runAction(action)
    return action
end

function performWithDelay(node, callback, delay)
    local delay = cc.DelayTime:create(delay)
    local sequence = cc.Sequence:create(delay, cc.CallFunc:create(callback))
    node:runAction(sequence)
    return sequence
end
