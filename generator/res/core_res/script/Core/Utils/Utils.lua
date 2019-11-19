Utils = {}

funcFree = function (...) end

-- function argsToString(...)
-- 	local str = ""
-- 	for i,v in ipairs({...}) do
-- 		str = str .. tostring(v) .. " "
-- 	end
-- 	return str
-- end

---------------------------------------------------
-- mode nil/log  1/log 2/json-lua 3/json-nor
function ToString(obj, mode, split, depth)
	if (not obj) then return "nil" end
	if (type(obj) ~= "table") then return ToStringC(obj) end

	if not mode then mode = 0 end
	if not split then split = "\n" end
	local showIdx=false
	local sj=nil  --split-j
	local sn=nil  --split-end
	local sl=nil
	local sr=nil
	local sv=nil
	local sc=nil
	local sp=nil
	local bLv0=nil
	if     mode == 0  then showIdx=false; sj=split; sn=split; bLv0=nil;	 sl="\'";  sv="\'";  sc=" = ";  sp="  "  --@
	elseif mode == 1  then showIdx=true;  sj=split; sn=split; bLv0=true; sl="\'";  sv="\'";  sc=" = ";  sp="  "
	elseif mode == 2  then showIdx=false; sj=split; sn=","..split;		 sl="";    sv="\'";  sc=" = ";  sp="\t"
	elseif mode == 3  then showIdx=false; sj=split; sn=","..split;		 sl="\"";  sv="\"";  sc=" : ";  sp="\t"
	end

	if (depth == nil) then depth=0; end

	local m0="" --move space
	for n=0,depth-1,1 do m0=m0 .. sp; end
	local isArr = mode>2 and obj[1] and true or false
	local str = (isArr and "[" or "{") .. sj
	
	local mov=""
	for n=0,depth-0,1 do mov=mov .. sp; end
	local s = ""
	local t = ""  --vtype

	for i,f in pairs(obj) do
		if type(i) == "number" then s = mode>1 and "" or string._format("%s%s", i, sc)
		else  						s = string._format("%s%s%s%s", sl,i,sl, sc)  end
		t = type(f) --field
		if (t == "table" and (not bLv0)) then
			if showIdx then
				str = string._format("%s%s%s = {%s}%s", str,mov,i,type(obj), sn)
			end
			str = string._format("%s%s%s%s", str, mov, s, ToString(f, mode, split, depth+1))

		elseif (t == "number") then
			str = string._format("%s%s%s%s%s", str,mov,s,f, sn)
		elseif (t == "string") then
			str = string._format("%s%s%s%s%s%s%s",  str,mov,s, sv,f,sv, sn)
		elseif (t == "boolean") then
			str = string._format("%s%s%s%s%s", str,mov,s,tostring(f), sn)

		elseif (t == "function") then
			str = string._format("%s%s%s()%s", str,mov,i, sn)
		else
			str = string._format("%s%s%s<userdata=[%s]>%s", str,mov,i,t, sn)
		end
	end
	if mode and mode>1 then str = string.sub(str, 1, #str-2) ..sj end
	str = str..m0.. (isArr and "]" or "}") .. (depth==0 and sj or sn)
	return str
end
function ToStringB(obj)
	return ToString(obj, 1)
end

function ToStringC(obj)
	if (not obj) then 
		return "nil"
	end
	local s = ""
	local t = type(obj)
	if t == "table" then
		s = "{table}"
	elseif t == "number" then
		s = tostring(obj)
	elseif t == "string" then
		s = string._format("\"%s\"", obj)
	elseif t == "boolean" then
		s = tostring(obj)
	elseif t == "function" then
		s = string._format("%s()", tostring(obj))
	else
		s = string._format("<userdata=[%s]>", tostring(obj))
	end
	return s
end

-----------------------------------------------
--多属性排序
--ps : 属性列表  如:{"type","lvl"}
--ASC: 排序方式： -1(<从小到大)  1(>从大到小)
function table.sortOn(tab, ps, ASC)
	if type(tab)~="table" then
		logE("table.sortOn: tab abnormity")
		return
	end
	if type(ps)=="string" then ps={ps} end
	if not ASC then ASC = -1 end

	local L = #ps
	local k = nil
	local function sortCondition(a,b)
		for i=1,L do
			k=ps[i]
			if a[k] == b[k] then
			else
				if nil == a[k] or nil == b[k] then
					logW("table.sortOn:: value is nil. ", tostring(k))
				elseif ASC==-1 then
					return a[k] < b[k]
				else
					return a[k] > b[k]
				end
			end
		end
		if ASC==-1 then
			return a[k] > b[k]
		else
			return a[k] < b[k]
		end
	end
	table.sort( tab, sortCondition )
end

function table.sortNum(tab, ASC)
	if not ASC then ASC = -1 end

	if ASC == -1 then
		table.sort( tab, function(a,b) return a<b end )
	else
		table.sort( tab, function(a,b) return a>b end )
	end
	return tab
end

function table.clone(tab, full)
	if type(full)~="boolean" then full = false end
	local ret = {}
	for i,v in ipairs(tab) do
		if full and "table" == type(v) then
			ret[i] = table.clone(v, full)
		else
			ret[i] = v
		end
	end
	return ret
end

function table.cloneByPairs(tab, full)
	if type(full)~="boolean" then full = false end
	local ret = {}
	for i,v in pairs(tab) do
		if full and "table" == type(v) then
			ret[i] = table.cloneByPairs(v, full)
		else
			ret[i] = v
		end
	end
	return ret
end

function table.indexOf(tab, ele)
	for i,v in ipairs(tab) do
		if v == ele then
			return i
		end
	end
	return -1
end

function table.reverse(tab)
	local ret = {}
	local L = #tab
	for i,v in ipairs(tab) do
		ret[L-i+1] = v
	end
	return ret
end

function table.tabToString(tab, key, split)
	if not split then split = "," end
	local s = ""
	for k,v in pairs(tab) do
		s = string._format("%s,%s", s, k .."=".. key and v[key] or v)
	end
	return s
end
function table.arrayToString(arr, key, split)
	if not split then split = "," end
	local s = ""
	for i,v in ipairs(arr) do
		s = string._format("%s,%s", s, key and v[key] or v)
	end
	return s
end

function table.arrayToMap(arr, defValue)
	local useIdx = false
	if type(defValue)=="nil" then 
		defValue = true
	elseif type(defValue)=="string" and defValue=="INDEX" then
		useIdx = true
	end
	
	local ret = {}
	for i,v in ipairs(arr) do
		ret[v] = useIdx and i or defValue
	end
	return ret
end

function table.pairsLength(tab)
	local count = 0
	for k,v in pairs(tab) do
		count = count + 1
	end
	return count
end

-- idx/value最接近tab元素项
function Utils.arrayNear(tab, ri, rv)
	if (not ri) and (not rv) then return nil, nil end

	local ti = 0
	local td = 100000000000
	local d = 0
	for i,v in pairs(tab) do
		if     ri then d = math.abs(i-ri)
		elseif rv then d = math.abs(v-rv) end
		if d < td then td=d; ti=i end
	end
	return ti, tab[ti]
end
-----------------------------------------------

-- for ProjTank
-- function Utils.getSplitTab(str)
-- 	local list = string.split(string.sub(str, 2,#str), "|", nil, "number")
-- 	return list
-- end
-- function Utils.getSplitEle(str, i)
-- 	local list = string.split(string.sub(str, 2,#str), "|")
-- 	local n = list[i]
-- 	return n and tonumber(n) or nil
-- end

--几个数据放1组里
--例如num=2
--tab = {{1,2},{3,4}}
function string.spliteDataByNum(data,num)
	if not data then logWarnning("spliteDataByNum data is Null") end
	if not num then num = 1 end
	local tab = {}
	local i = 1
	for k,v in pairs(data) do
		if not tab[i] then tab[i] = {} end
		table.insert(tab[i],v)
		if k % num == 0 then
			i = i + 1
		end
	end
	return tab
end

function Utils.getTabEleChg(tab)
	for i,v in ipairs(tab) do
		tab[i] = tonumber(v)
	end
	return tab
end
function Utils.getTabChgEle(tab, i)
	return tonumber(tab[i])
end

-- 在str中以d的方向 按r的步长加sep
function string.join(str, sep, r, d)
	if not sep then sep = "" end
	if not r then r = 1 end
	if not d then d = 0 end --dir

	local ret = ""
	local l = #str
	local i = 1
	local n = 0
	for t=1,l do
		if i+r > l then sep = "" end
		if d < 0 then
			n = l-i-r+2
			ret = string._format("%s%s%s", sep, string.sub(str, n<1 and 1 or n, l-i+1), ret)
		else
			ret = string._format("%s%s%s", ret, string.sub(str, i, i+r-1), sep)
		end
		i = i+r
		if i > l then break end
	end
	return ret
end

function string.hexToRGB(hexstr)
	if (not hexstr) or type(hexstr)~="string" or #hexstr<6 then
		-- logE("ERROR [string.hexToRGB] not param")
		return 255,255,255
	end
	if string.find(hexstr,"#") == 1 then
		hexstr = string.sub(hexstr,2)
	end
	if string.find(hexstr,"0x") == 1 then
		hexstr = string.sub(hexstr,3)
	end

	if (#hexstr < 6) then
		-- for i=#hexstr , 6-1 do hexstr = '0' .. hexstr end
		for i=#hexstr , 6-1 do hexstr = hexstr .. '0' end
	end
	return  tonumber(string.sub(hexstr, 1, 2),16),
			tonumber(string.sub(hexstr, 3, 4),16),
			tonumber(string.sub(hexstr, 5, 6),16)
end
function string.hexToRGBA(hexstr)
	if string.find(hexstr,"#") == 1 then
		hexstr = string.sub(hexstr,2)
	end
	if string.find(hexstr,"0x") == 1 then
		hexstr = string.sub(hexstr,3)
	end

	if (#hexstr < 8) then
		for i=#hexstr , 8-1 do hexstr = hexstr .. '0' end
	end
	return  tonumber(string.sub(hexstr, 1, 2),16),
			tonumber(string.sub(hexstr, 3, 4),16),
			tonumber(string.sub(hexstr, 5, 6),16),
			tonumber(string.sub(hexstr, 7, 8),16)
end

function string.hexToRGB_F(hexstr)
	local r,g,b = string.hexToRGB(hexstr)
	return r/255,g/255,b/255
end
function string.hexToRGBA_F(hexstr)
	local r,g,b,a = string.hexToRGBA(hexstr)
	return r/255,g/255,b/255,a/255
end

function string.hexToC3B(hexstr)
	local r,g,b = string.hexToRGB(hexstr)
	return cc.c3b(r,g,b)
end
function string.hexToC4F(hexstr)
	local r,g,b,a = string.hexToRGBA_F(hexstr)
	return cc.c4f(r,g,b,a)
end


local _fmtNum = 
{
	[3]="K",
	[6]="M",
	[9]="G",
	-- [12]="T",
	-- [15]="P",
}
-- s _fmtNum
-- sep 分段符
-- width 返回的最大字符长度
function string.formatNum(n, sep, width)
	if not sep then sep = "," end
	if not width then width = 8 end

	local s = tostring(n)
	if #s > width then
		local l = Utils.arrayNear(_fmtNum, #s-width)
		if l and _fmtNum[l] then
			s = string.sub(s, 1,#s-l)
			-- logWarnning("formatNum", s)
			if sep and #sep>0 then s = string.join(s, sep, 3, -1) end
			return s .. _fmtNum[l]
		end
	end
	if sep and #sep>0 then s = string.join(s, sep, 3, -1) end
	return s
end
-----------------------------------------------

-- 检查字是不是汉字
-- 一个汉字符len为3, 
-- 一个英文字符len为1
function string.checkWord(s)
	local ret = {};
	local f = '[%z\1-\127\194-\244][\128-\191]*';
	local line, lastLine, isBreak = '', false, false;
	local nCN, nEN = 0,0
	for v in s:gfind(f) do
		if #v~=1 then nCN=nCN+1
		else nEN=nEN+1 end
		table.insert(ret, {c=v, isChinese=(#v~=1)});
	end
	return ret, nCN, nEN, nCN+nEN
end
function string.checkWordAlignment(s, max)
	local ret, nCN, nEN, nA = string.checkWord(s)
	if nCN*2 + nEN > max then
		return 0
	end
	return 1
end


--获取路径
function string.getPath(u)  
	return string.match(u, "(.+)/[^/]*%.%w+$") or u --*nix system  
	--return string.match(u, “(.+)\\[^\\]*%.%w+$”) — windows  
end  
--获取文件名
function string.getFilename(u)  
	return string.match(u, ".+/([^/]*%.%w+)$") or u -- *nix system  
	--return string.match(u, “.+\\([^\\]*%.%w+)$”) — *nix system  
end  
--去除扩展名  
function string.stripExtensionName(u)  
	local idx = u:match(".+()%.%w+$")  
	return idx and u:sub(1, idx-1) or u
end 
--获取扩展名
function string.getExtensionName(u)  
	return u:match(".+%.(%w+)$")  
end  
-----------------------------------------------

-- 截取小数部分长度。四舍五入
function math.round(v, l)
	if l then
		local d = math.pow(10,l)
		return math.floor(v*d+0.5) / d
	end
	return math.floor(v+0.5)
end

-- 限制取值范围
function math.clamp(v, min,max)
	if not min then min = 0 end
	if not max then max = 1 end
	if min > max then
		local tmp = min
		min = max
		max = tmp
	end
	v = math.max(v, min)
	v = math.min(v, max)
	return v
end

-- 另 cc.rectContainsPoint( rect, point )
-- rect : [x,y, width,height]
function math.rectContainsPoint(r, x,y)
	return x > r[1] and y > r[2] and x < r[1]+r[3] and y < r[2]+r[4]
end
-- rect : [x0,y0, x1,y1]
function math.pointInnerDots(r, x,y)
	return x > r[1] and y > r[2] and x < r[3] and y < r[4]
end


function math.distance(x1,y1,x2,y2)
	local dx = x2-x1
	local dy = y2-y1
	return math.sqrt(dx*dx+dy*dy)
end
function math.distanceByPoint(p1, p2)
	return math.distance(p1.x,p1.y, p2.x,p2.y)
end

function math.xrad(x1,y1,x2,y2)
	local dx = x2-x1
	local dy = y2-y1
	return math.atan2(dy,dx)
end
function math.xradByPoint(p1, p2)
	return math.xrad(p1.x,p1.y, p2.x,p2.y)
end

-----------------------------------------------

-- fix (n^2)
local _eqs=nil
function Utils.getNumMask(N)
	if not _eqs then
		_eqs = {}
		local n=1
		for i=1,16 do table.insert(_eqs,n); n=2*n; end
	end
	local ret = {}
	local M=N
	local v=0
	while (M>0) do
		for i=#_eqs,1,-1 do
			v=_eqs[i]
			if v <= M then
				table.insert( ret, v)
				M=M-v
				break
			end
		end
	end
	return ret
end

-----------------------------------------------

Time = {}

local _hbReady = false
local _timeSYNC = 0
function Time.SYNC(t)
	_timeSYNC = t-os.time()
end
-- 本地时间相对服务器时间偏移量
function Time.getTimeOffset()
	local z = PlayerData.getZone() or 8
	return z * 60 * 60 - Global.getTimeZone()
end
--return 服务器时间的秒数 （已经进行了时区转换）
--如果时区不同，则此值不能再与服务器时间值进行直接比较
function Time.getTime()
	if _hbReady then
		return HeartBeatManager.getServerZoneTime()
	end
	_hbReady = HeartBeatManager and HeartBeatManager.isReady()
	return os.time()+_timeSYNC
end
function Time.getLogTime()
	if _hbReady then
		local t = HeartBeatManager.GetSystemDate()
		local m = math.round(os.clock(),3)
		return string._format( "%s:%s:%s %s", t.hour, t.min, t.sec, math.floor((m-math.floor(m))*1000))
	end
	_hbReady = HeartBeatManager and HeartBeatManager.isReady()
	return os.date("%X")
	-- return math.round(os.clock(),3)
end
-- return {year, month, day, hour, min, sec, wday(7六 1日), yday, isdst}
function Time.getDate()
	return os.date("*t", Time.getTime())
end
function Time.getWeekday()
	return tonumber(os.date("%w", Time.getTime())) --0~6 周日~周六
end

-- 没有对传过来的t做时间偏移处理
-- return hh:mm:ss
function Time.toString(t)
	if not t then t = Time.getTime() end
	return os.date("%X", t)
end
function Time.toFullString()
	local t = Time.getTime()
	local z = PlayerData.getZone() or 8
	local s = string._format(" (UTC+%s:00)", z<10 and "0"..z or z)
	return os.date("%Y-%m-%d %H:%M:%S"..s, t)
end

--绝对时间转秒 date(string): "2014-08-07 19:45:33"
--别超过2038年
function Time.dateToTime(date)
	if not string.find(date, "-") then
		date = string._format("%s %s", os.date("%Y-%m-%d", Time.getTime()), date)
	end
	local y, m, d, hh, mm, ss = date:match("(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)")
	if not y then
		y, m, d, hh, mm, ss = date:match("(%d+)-(%d+)-(%d+)-(%d+):(%d+):(%d+)")
	end
	if not y then 
		logWarnning("WARNNING DateToTime 参数非法")
		return 0 
	end
	local t = os.time({year=y, month=m, day=d, hour=hh, min=mm, sec=ss})
	-- logWarnning("convertedTimestamp", tostring(t), os.time())
	return t
end

function Time.getCDNewDay()
	return Time.dateToTime("24:0:0")-Time.getTime()
end

-- 取得新一天的分界秒(临界值)
function Time.getNewDayCriticalSec()
	return Time.dateToTime("24:0:0")
end
-- return true 新一天，可刷新一次
function Time.isNewDayFirst( criticalSec )
	if Time.getTime() > criticalSec+1 then
		criticalSec = Time.getNewDayCriticalSec()
		return true, criticalSec
	end
	return false, criticalSec
end


local _strD = nil
local _strH = nil
local _strM = nil
local _strS = nil
local function chkTimeStr()
	if not _strD then
		_strD = getLang("天")
		_strH = getLang("时")
		_strM = getLang("分")
		_strS = getLang("秒")
	end
end
local function doubleDigi(sec)
	if sec < 10 then
		return string._format("0%s", sec)
	end
	return sec
end
Time.doubleDigi = doubleDigi
local function getSecGap(s,g)
	local v = 0
	if (s >= g) then
		v = math.floor(s / g)
		s = s - (v * g)
	end
	return s,v
end
--格式化时间显示
-- @formatMode 
--      0 简略时间(最多两位)
--      1 完整时间(最多天时分秒)
-- @unitMode
--      0 无单位 仅“天” 其它使用冒号“:”
---     1 完整单位 完全都有  “天时分秒”
-- @maxIsHour
---     1 “时分秒”
function Time.gapValue(sec)
	local nD=0
	local hh=0
	local mm=0
	local ss=math.floor(sec)
	if (ss < 0) then ss = 0 end
	ss,nD = getSecGap(ss, 86400)
	ss,hh = getSecGap(ss, 3600)
	ss,mm = getSecGap(ss, 60)
	return nD, hh, mm, ss
end
function Time.gap(sec, formatMode, unitMode, maxIsHour)
	if type(formatMode) ~= "number" then formatMode = 0 end
	if type(unitMode) ~= "number" then unitMode = 0 end
	chkTimeStr()

	local nD, hh, mm, ss = Time.gapValue(sec)

	if maxIsHour then
		hh = hh+nD*24
		nD = 0
	end

	if formatMode == 1 then --完整时间
		if unitMode == 0 then --无单位
			if nD > 0 then return string._format("%d%s %d:%s:%s", nD,_strD, hh,doubleDigi(mm),doubleDigi(ss)) end
			if hh > 0 then return string._format("%d:%s:%s", hh,doubleDigi(mm),doubleDigi(ss)) end
			if mm > 0 then return string._format("%s:%s", doubleDigi(mm),doubleDigi(ss)) end
			return string._format("%s", ss)
		else --完整单位
			if nD > 0 then return string._format("%d%s %d%s%s%s%s%s", nD,_strD, hh,_strH, doubleDigi(mm),_strM, doubleDigi(ss),_strS) end
			if hh > 0 then return string._format("%d%s%s%s%s%s", hh,_strH, doubleDigi(mm),_strM, doubleDigi(ss),_strS) end
			if mm > 0 then return string._format("%s%s%s%s", doubleDigi(mm),_strM, doubleDigi(ss),_strS) end
			return string._format("%s%s", ss,_strS)
		end
	else --简略时间
		if unitMode == 0 then --无单位
			if nD > 0 then return string._format("%d%s", nD,_strD) end
			if hh > 0 then return string._format("%d:%s", hh,doubleDigi(mm)) end
			if mm > 0 then return string._format("%s:%s", doubleDigi(mm),doubleDigi(ss)) end
			return string._format("%d", ss)
		elseif unitMode == 1 then --完整单位
			if nD > 0 then return string._format("%d%s", nD,_strD) end
			if hh > 0 then return string._format("%d%s%d%s", hh,_strH, mm,_strM) end
			if mm > 0 then return string._format("%d%s%s%s", mm,_strM, doubleDigi(ss),_strS) end
			return string._format("%d%s", ss, _strS)
		elseif unitMode == 2 then--显示 天时分
			if nD > 0 then return string._format("%d%s%d%s%d%s", nD,_strD,hh,_strH,mm,_strM) end
			if hh > 0 then return string._format("%d%s%d%s", hh,_strH, mm,_strM) end
			if mm > 0 then return string._format("%d%s%s%s", mm,_strM, doubleDigi(ss),_strS) end
			return string._format("%d%s", ss, _strS)
		end
	end
	return ""
end
--00:00:00 时分秒格式
--isSymbol 以冒号还是中文间隔
--dayInHour 是否把天数累积到小时数
function Time.getFormatTime(sec,isSymbol,dayInHour)
	chkTimeStr()
	local nD, hh, mm, ss = Time.gapValue(sec)
	if dayInHour then
		hh = hh + nD *24
	end
	if isSymbol then
		return string._format("%s%s%s",doubleDigi(hh)..":",doubleDigi(mm)..":",doubleDigi(ss))
	end
	return string._format("%s%s%s",doubleDigi(hh).._strH,doubleDigi(mm).._strM,doubleDigi(ss).._strS)
end
--转换限时活动时间 当时间大于24小时时 限时X天X时
--否则
function Time.FormatLATime(sec)
	chkTimeStr()
	local nD, hh, mm, ss = Time.gapValue(sec)
	if nD > 0 then
		return string._format("%d%s%d%s", nD,_strD,hh,_strH)
	else
		return Time.FormatTimeAsHMax(sec)
	end
	return ""
end
-- 剩余时间格式化为简略时间(只有一个单位：或天或时或分或秒)
function Time.FormatTime(sec)
	return Time.gap(sec, 0, 1)
end
-- 剩余时间格式化为完整时间（最大只为时, “时分秒”）
function Time.FormatTimeAsHMax(sec)
	return Time.gap(sec, 1, 0, 1)
end
-- 剩余时间格式化为完整时间（最大只为天, "天时分" "时分秒" "分秒"）
function Time.FormatTimeAsDayMax(sec, unitMode)
	chkTimeStr()
	-- return Time.gap(sec, 1, 0, false)
	local nD, hh, mm, ss = Time.gapValue(sec)

	if unitMode == 0 then --无单位
		if nD > 0 then return string._format("%d%s %d:%s", nD,_strD, hh,doubleDigi(mm)) end
		if hh > 0 then return string._format("%d:%s:%s", hh,doubleDigi(mm),doubleDigi(ss)) end
		if mm > 0 then return string._format("%s:%s", doubleDigi(mm),doubleDigi(ss)) end
		return string._format("00:%s%s", doubleDigi(ss))
	else --完整单位
		if nD > 0 then return string._format("%d%s %d%s%s%s", nD,_strD, hh,_strH, doubleDigi(mm),_strM) end
		if hh > 0 then return string._format("%d%s%s%s%s%s", hh,_strH, doubleDigi(mm),_strM, doubleDigi(ss),_strS) end
		if mm > 0 then return string._format("%s%s%s%s", doubleDigi(mm),_strM, doubleDigi(ss),_strS) end
		return string._format("00%s%s%s", _strM,doubleDigi(ss),_strS)
	end
end
-- 剩余时间格式化为两位的时间（最大只为天, "天时" "时分" "分秒"）
function Time.FormatTimeAsDayMax2(sec, unitMode)
	chkTimeStr()
	-- return Time.gap(sec, 1, 0, false)
	local nD, hh, mm, ss = Time.gapValue(sec)

	if unitMode == 0 then --无单位
		if nD > 0 then return string._format("%d%s %d:%s", nD,_strD, hh,doubleDigi(mm)) end
		if hh > 0 then return string._format("%d:%s:%s", hh,doubleDigi(mm),doubleDigi(ss)) end
		if mm > 0 then return string._format("%s:%s", doubleDigi(mm),doubleDigi(ss)) end
		return string._format("00:%s%s", doubleDigi(ss))
	else --完整单位
		if nD > 0 then return string._format("%d%s %d%s", nD,_strD, hh,_strH) end
		if hh > 0 then return string._format("%d%s%s%s", hh,_strH, doubleDigi(mm),_strM) end
		if mm > 0 then return string._format("%s%s%s%s", doubleDigi(mm),_strM, doubleDigi(ss),_strS) end
		return string._format("00%s%s%s", _strM,doubleDigi(ss),_strS)
	end
end
-- 剩余时间格式化为强制完整时间（任何时候都显示“时分秒”）
function Time.FormatTimeAsForce(sec)
	chkTimeStr()
	local nD, hh, mm, ss = Time.gapValue(sec)
	hh = hh+nD*24
	nD = 0
	return string._format("%s:%s:%s", doubleDigi(hh),doubleDigi(mm),doubleDigi(ss))
end

-- 剩余时间格式化为“天时分”
function Time.FormatTimeAsDMax(sec)
	chkTimeStr()
	local nD, hh, mm, ss = Time.gapValue(sec)
	return string._format("%s%s%s%s%s%s", nD,_strD, doubleDigi(hh),_strH,doubleDigi(mm),_strM)
end
-- 剩余时间格式化为强制完整时间（任何时候都显示“分秒”）
function Time.FormatTimeAsMAndS(sec)
	chkTimeStr()
	local nD, hh, mm, ss = Time.gapValue(sec)
	hh = hh+nD*24
	nD = 0
	return string._format("%s:%s",doubleDigi(mm),doubleDigi(ss))
end
-- 剩余时间格式化为“分秒”
function Time.FormatTimeAsMS(sec)
	chkTimeStr()
	local nD, hh, mm, ss = Time.gapValue(sec)
	mm = nD*24*60*60 + hh*60*60 + mm
	hh = hh+nD*24
	nD = 0
	return string._format("%s:%s",doubleDigi(mm),doubleDigi(ss))
end

function Time.ToDay(sec)
	local date = os.date("*t", sec)
	return date.day
end
--根据秒转下来年月日
--time 服务器下发的绝对时间
--返回为服务器的date(已进行时区处理)
function Time.GetDateFormat(time)
	return os.date("*t", time - Global.getTimeZone() + PlayerData.getZone() * 60 * 60)
end
function Time.formatMinutes(m)
	local hour = string._format("%0d", m/60)
	local minutes = string._format("%.2d", m%60)
	return hour..":"..minutes
end
--mode 0 年月日时分秒
--mode 1 年月
--mode 2 年月日
--mode 3 年月日时
--mode 4 年月日时分
--mode 5 月日时分
--mode 6 月日时
--mode 7 月日
--mode 8 时分
--mode 9 月日时分秒
--默认带时区转换
function Time.formatSec(times,mode,notZone, sperator)
	sperator = sperator or "."
	if not mode then mode = 0 end
	local showYears = true
	local showMonth = true
	local showDay = true
	local showHour = true
	local showMin = true
	local showSec = true
	if mode == 1 then
		showDay = false
		showHour = false
		showMin = false
		showSec = false
	elseif mode == 2 then
		showHour = false
		showMin = false
		showSec = false
	elseif mode == 3 then
		showMin = false
		showSec = false
	elseif mode == 4 then
		showSec = false
	elseif mode == 5 then
		showYears = false
		showSec = false
	elseif mode == 6 then
		showYears = false
		showMin = false
		showSec = false
	elseif mode == 7 then
		showYears = false
		showMin = false
		showSec = false
		showHour = false
	elseif mode == 8 then
		showYears = false
		showMonth = false
		showSec = false
		showDay = false
	elseif mode == 9 then
		showYears = false
	end
	local date = nil
	if notZone then
		date = os.date("*t", times)
	else
		date = os.date("*t", times - Global.getTimeZone() + PlayerData.getZone() * 60 * 60)
	end
	local completeTimes = ""
	if showYears then completeTimes = string.sub(date.year,3,4)..sperator end
	if showMonth then completeTimes = completeTimes .. date.month..sperator end
	if showDay then completeTimes = completeTimes .."".. date.day end
	if showHour then completeTimes = completeTimes .." ".. date.hour end
	if showMin then completeTimes = completeTimes ..":"..tostring(string._format("%.2d",date.min)) end
	if showSec then completeTimes = completeTimes ..":".. tostring(string._format("%.2d",date.sec)) end
	return completeTimes
end

function Time.timestampToUTC(sec)
	local date = os.date("*t", sec)
	return string._format("%s-%s-%s %s:%s:%s", date.year,date.month,date.day, date.hour,date.min,date.sec )
end

-- 今日与timeStr相距的时间(秒)。 
-- sec<0过期 sec==0在同一秒 sec>0时间未到
-- date为当前时间
function Time.getTodayTime( timeStr )
	local hh, mm, ss = timeStr:match("(%d+):(%d+):(%d+)")
	local date = os.date("*t", HeartBeatManager.getServerZoneTime())
	hh = tonumber(hh)
	mm = tonumber(mm)
	ss = tonumber(ss)
	if not hh then
		return -1, date 
	end
	local sec = (hh - date.hour)*3600 + (mm - date.min)*60 + (ss - date.sec)
	return sec, date
end

function Time.getSingleUnitTime(sec)
	chkTimeStr()
	local nD, hh, mm, ss = Time.gapValue(sec)

	local str = ""
	if nD ~= 0 then
		str = str .. string._format("%d%s", nD,  _strD)
	end
	if hh ~= 0 then
		str = str .. string._format("%d%s", hh,  getLang("小时"))
	end
	if mm ~= 0 then
		str = str .. string._format("%d%s", mm,  getLang("分钟"))
	end
	if ss ~= 0 then
		str = str .. string._format("%d%s", ss,  _strS)
	end
	return str
end

local bit_rshift = bit.rshift
local bit_band = bit.band

--将color_string(如：0xffff00 类型为number), 解析为color4b 
function Utils.getColor4B(color, alpha_value)
	local color_4b = {}
    color_4b.r = bit_band(bit_rshift(color, 16), 0xff)
    color_4b.g = bit_band(bit_rshift(color, 8), 0xff)
    color_4b.b = bit_band(color, 0xff)
    color_4b.a = alpha_value or 255

    return color_4b
end

--将color_string(如：0xffff00 类型为number), 解析为color3b
function Utils.getColor3B(color)
	local color_3b = {}
    color_3b.r = bit_band(bit_rshift(color, 16), 0xff)
    color_3b.g = bit_band(bit_rshift(color, 8), 0xff)
    color_3b.b = bit_band(color, 0xff)

    return color_3b
end

-- 获取数字的第几位数
function Utils.getNumberByDigit(oriNumber,digit)
	local strNumber = tostring(oriNumber)
	if string.len(strNumber)<digit then
		logE("Utils.getNumberByDigit digit too lang")
	else
		return tonumber(string.sub(strNumber,digit,digit))
	end
end
