module("CountDownNodeLua", package.seeall)

local DELTA = 0.05
local _restarting = false

COUNTDOWN_SHOW_MODE = 
{
    SHOW_ONE_SINGLE = -1,   -- 只显示秒，宽度自适应
    SHOW_ONE = 0,
    SHOW_TWO = 1,
    SHOW_THREE = 2,
    SHOW_ALL = 3,
    SHOW_AUTO = 4,
    SHOW_DAY_AUTO = 5  -- 天自动，如果有大于1天，则显示全部，如果小于1天，则不显示天
}

COUNTDOWN_STATE = 
{
    READY = 0,
    RUNNING = 1,
    PAUSE = 2,
    END = 3
}


local function updateDisplayAll(self, day, hour, minute, second)
    local display = ""
    
    if self._pre then
        display = self._preStr
    end

    if self._day then
        display = display .. day .. self._dayStr
    end

    if self._hour then
        display = string._format(display .. "%02d" .. self._hourStr, hour)
    end

    if self._minute then
        display = string._format(display .. "%02d" .. self._minuteStr, minute)
    end

    if self._second then
        display = string._format(display .. "%02d" .. self._secondStr, second)
    end

    self._label:setString(display)

    return display
end

local function updateDisplayAuto(self, day, hour, minute, second)
    local display = ""
    local displayCount = 0
    
    if self._pre then
        display = self._preStr
    end

    if self._day and day > 0 then
        displayCount = displayCount + 1
        display = display .. day .. self._dayStr
    end

    if self._hour and (hour > 0 or displayCount > 0) then
        displayCount = displayCount + 1
        display = string._format(display .. "%02d" .. self._hourStr, hour)
    end

    if self._minute and (minute > 0 or displayCount > 0) then
        displayCount = displayCount + 1
        display = string._format(display .. "%02d" .. self._minuteStr, minute)
    end

    if self._second then
        display = string._format(display .. "%02d" .. self._secondStr, second)
    end

    self._label:setString(display)

    return display
end

local function updateDisplayDayAuto(self, day, hour, minute, second)
    local display = ""

    if self._pre then
        display = self._preStr
    end


    if self._day and day > 0 then
        display = display .. day .. self._dayStr
    end

    if self._hour then
        display = string._format(display .. "%02d" .. self._hourStr, hour)
    end

    if self._minute then
        display = string._format(display .. "%02d" .. self._minuteStr, minute)
    end

    if self._second then
        display = string._format(display .. "%02d" .. self._secondStr, second)
    end

    self._label:setString(display)

    return display
end

local function updateDisplayCustom(self, day, hour, minute, second)
    local display = ""
    local displayCount = 0

    if self._pre then
        display = self._preStr
    end

    repeat
        if self._day and day > 0 then
            displayCount = displayCount + 1
            display = display .. day .. self._dayStr
        end

       
        if displayCount > self._mode then break end

        if self._hour and (hour > 0 or displayCount > 0 or self._mode > COUNTDOWN_SHOW_MODE.SHOW_TWO) then
            displayCount = displayCount + 1
            display = string._format(display .. "%02d" .. self._hourStr, hour)
        end

        if displayCount > self._mode then break end

        if self._minute and (minute > 0 or displayCount > 0 or self._mode > COUNTDOWN_SHOW_MODE.SHOW_ONE) then
            display = string._format(display .. "%02d" .. self._minuteStr, minute)
        end

        if displayCount > self._mode then break end

        if self._second then
            display = string._format(display .. "%02d" .. self._secondStr, second)
        end
    until true 


    self._label:setString(display)

    return display
end

local function updateDisplayOneSingle( self, day, hour, minute, second )
    local display = ""

    if self._pre then
        display = self._preStr
    end

    if self._second then
        display = string._format(display .. "%d" .. self._secondStr, second)
    end

    self._label:setString(display)

    return display
end


local function updateDisplay( self )
    local countDown = self._currentCountDown > 0 and math.ceil(self._currentCountDown) or 0
    local day = math.floor(countDown / (24 * 3600))
    local hour = math.floor((countDown % (24*3600)) / 3600)
    
    if not self._convertDay then
        hour = math.floor(countDown / 3600)
    end
    
    local minute = math.floor(((countDown % (24*3600)) % 3600) / 60)
    local second = ((countDown % (24*3600)) % 3600) % 60

    if COUNTDOWN_SHOW_MODE.SHOW_ALL == self._mode then
        return updateDisplayAll(self, day, hour, minute, second)
    elseif COUNTDOWN_SHOW_MODE.SHOW_AUTO == self._mode then
        return updateDisplayAuto(self, day, hour, minute, second)
    elseif COUNTDOWN_SHOW_MODE.SHOW_DAY_AUTO == self._mode then
        return updateDisplayDayAuto(self, day, hour, minute, second)
    elseif COUNTDOWN_SHOW_MODE.SHOW_ONE_SINGLE == self._mode then
        return updateDisplayOneSingle(self, day, hour, minute, second)
    else
        return updateDisplayCustom(self, day, hour, minute, second)
    end
end

local function formatNode( self, format )
    self._format = format

    local tag = nil
    tag = string.find(format, "dd")
    if tag then
        self._pre = true
        self._day = true
        self._preStr = string.sub(format, 1, tag - 1)
        format = string.sub(format, tag + 2)
    end

    tag = string.find(format, "HH")
    if tag then
        self._hour = true
        if self._pre then
            self._dayStr = string.sub(format, 1, tag - 1)
        else
            self._pre = true
            self._preStr = string.sub(format, 1, tag - 1)
        end
        
        format = string.sub(format, tag + 2)
    end

    tag = string.find(format, "mm")
    if tag then
        self._minute = true
        if self._pre then
            self._hourStr = string.sub(format, 1, tag - 1)
        else
            self._pre = true
            self._preStr = string.sub(format, 1, tag - 1)
        end
        format = string.sub(format, tag + 2)
    end

    tag = string.find(format, "ss")
    if tag then
        self._second = true ;
        if self._pre then
            self._minuteStr = string.sub(format, 1, tag - 1)
        else
            self._pre = true ;
            self._preStr = string.sub(format, 1, tag - 1)
        end
        self._secondStr = string.sub(format, tag + 2)
    else
        self._minuteStr = format
    end
end

local function init(self, time, format, label, convertDay)
    self._startCountDown = time
    self._currentCountDown = time
    self._convertDay = convertDay


    formatNode(self, format)

    self._label = label
    updateDisplay(self)
end

local function hide( self, time )
    if self._actionTime > 0 then
        local now = socket.gettime()

        if time > 1 and self._actionTime + 1 >= time and now - self._actionTimeval >= 0.5 then
            self._label:setVisible(false)
        end
    end
end

local function show( self )
    if self._actionTime > 0 then
        self._actionTimeval = socket.gettime()
        self._label:setVisible(true)
    end
end

local function run(self, delta)

    if _restarting then
        return
    end

    self._currentTimeval = socket.gettime()

    local subTime = self._currentTimeval - self._startTimeval
    local currentCountDown = self._startCountDown - subTime - self._pausePeriod

    hide( self, currentCountDown )

    if self._currentCountDown - currentCountDown >= 1 or currentCountDown < 1 then
        self._currentCountDown = math.ceil(currentCountDown)

        show(self)

        local l = updateDisplay( self )

        if self._extCallbackTime > 0 and self._extCallbackTime >= self._currentCountDown then
            if self._handler then
                self._handler( self._extCallbackTime )
            end
            
            self._extCallbackTime = 0
        end

        if currentCountDown <= 0 then
            self:stopCountDown()
            if self._handler then
                self._handler( currentCountDown )
            end
        end
    end
end

-- convertDay 如果为false的话，只计算到小时，如 120个小时
function CountDownNodeLua:createWithLabel(time, format, label, convertDay)
    if convertDay == nil then
        convertDay = true
    end

    local temp = {}
    setmetatable(temp, {__index = CountDownNodeLua})

    local curTime = socket.gettime()

    temp._label = nil
    temp._startTimeval = curTime
    temp._currentTimeval = curTime
    temp._pauseTimeval = curTime
    temp._startCountDown = 0
    temp._currentCountDown = 0
    temp._pausePeriod = 0
    temp._autoHide = false
    temp._handler = nil
    temp._start = false
    temp._pause = false
    temp._stop = false
    temp._mode = COUNTDOWN_SHOW_MODE.SHOW_ALL
    temp._format = "HH:mm:ss"
    temp._preStr = ""
    temp._dayStr = ""
    temp._hourStr = ""
    temp._minuteStr = ""
    temp._secondStr = ""
    temp._pre = false
    temp._day = false
    temp._hour = false
    temp._minute = false
    temp._second = false
    temp._convertDay = true
    temp._entryId = nil
    temp._state = COUNTDOWN_STATE.READY
    temp._actionTime = 0
    temp._actionTimeval = 0
    temp._extCallbackTime = 0

    init(temp, time, format, label, convertDay)

    return temp
end

function CountDownNodeLua:startCountDown(  )
    if COUNTDOWN_STATE.RUNNING == self._state or self._startCountDown <= 0 then
        return
    end

    self._state = COUNTDOWN_STATE.RUNNING
    self._start = true
    self._label:setVisible(true)
    self._startTimeval = socket.gettime()
    self._actionTimeval = self._startTimeval
    if self._entryId == nil then
        self._entryId = Scheduler.schedule( run, DELTA, self )
    end
end

function CountDownNodeLua:restartCountDown(  )   
    if self._startCountDown <= 0 then
        return
    end

    self._state = COUNTDOWN_STATE.RUNNING
    self._start = true
    self._label:setVisible(true)

    self._currentCountDown = self._startCountDown
    self._startTimeval = socket.gettime()
    self._actionTimeval = self._startTimeval
    if self._entryId == nil then
        self._entryId = Scheduler.schedule( run, DELTA, self )
    end
end

function CountDownNodeLua:pauseCountDown(  )
    if COUNTDOWN_STATE.PAUSE == self._state then
        return
    end
    
    self._state = COUNTDOWN_STATE.PAUSE
    self._pause = true
    self._pauseTimeval = socket.gettime()
    if self._entryId then
        Scheduler.unschedule( self._entryId )
        self._entryId = nil
    end
end

function CountDownNodeLua:resumeCountDown(  )
    if COUNTDOWN_STATE.RUNNING == self._state then
        return
    end
    
    self._state = COUNTDOWN_STATE.RUNNING
    self._pause = false
    self._pausePeriod = socket.gettime() - self._pauseTimeval

    if self._entryId == nil then
        self._entryId = Scheduler.schedule( run, DELTA, self )
    end
end

function CountDownNodeLua:stopCountDown(  )
    if COUNTDOWN_STATE.END == self._state then
        return
    end
    
    self._state = COUNTDOWN_STATE.END
    self._stop = true

    if self._entryId then
        Scheduler.unschedule( self._entryId )
        self._entryId = nil
    end

    if self._autoHide then
        self._label:setVisible(false)
    end

end

function CountDownNodeLua:resetTime( time )
    if COUNTDOWN_STATE.RUNNING == self._state and math.abs(self._currentCountDown - time) <= 1 then
        return false
    end

    self._startCountDown = time
    self._currentCountDown = time
    self._startTimeval = socket.gettime()

    updateDisplay( self )

    return true
end

function CountDownNodeLua:registerExtCallbackTime( time )
    self._extCallbackTime = time
end

function CountDownNodeLua:setAutoHide( auto )
    self._autoHide = auto
end

function CountDownNodeLua:registerHandler( handler )
    self._handler = handler
end

function CountDownNodeLua:isStart(  )
    return self._start
end

function CountDownNodeLua:isPause(  )
    return self._pause
end

function CountDownNodeLua:isStop(  )
    return self._stop
end

function CountDownNodeLua:getLabel(  )
    return self._label
end

function CountDownNodeLua:setMode( mode )
    self._mode = mode
    updateDisplay( self )
end

function CountDownNodeLua:setVisible( visible )
    self._label:setVisible(visible)
end

function CountDownNodeLua:setPosition( pos1, pos2 )
    if pos2 then
        self._label:setPosition(pos1, pos2)
    else
        self._label:setPosition(pos1)
    end
end

function CountDownNodeLua:setActionTime( time )
    self._actionTime = time
end

function CountDownNodeLua:getState(  )
    return self._state
end

function CountDownNodeLua:getTime(  )
    return self._currentCountDown
end

function onRestart(  )
    _restarting = true
end

setRestartListener(onRestart)