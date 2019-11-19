TableViewLogic = class("TableViewLogic")

-- sets = 
-- {
-- 	logic     = viewLogic,	--
-- 	container = "",  		--装cell的容器
-- 	cellclass = class,		--cell类名
-- 	cellCheck = ",			--cellsize

-- 	list 	  = {},  		--数据列表
--  dir  	  = 1,  		--滑动方向
--  fill      = 			-- 填充方向
--  rect  	  = {x,y,w,h}	--

--  offset	  = {top, buttom, gap}	--
-- }
function TableViewLogic:ctor(sets)
	if not sets.dir then sets.dir = 1 end
	self._sets = sets

	self:init()
end

function TableViewLogic:init()
	local _vFrom = self._sets.logic

	local _cellWidth, _cellHeight = 0, 0
	local _topGap = 0
	local _bottomGap = 0
	local _dir = 1
	local function cellSizeForTable(table,idx) 
		if self._cellSize then
			local sz = self._cellSize[idx + 1]
			return sz[1] or _cellWidth, sz[2] or _cellHeight
		end
		return _cellWidth, _cellHeight
	end
	local function numberOfCellsInTableView(table)
	   return #self._sets.list
	end
	local function tableCellAtIndex(table, idx)
		local cell = table:dequeueCell()
		if nil == cell then
			cell = ETableViewCell:new()

			local cls = _G[self._sets.cellclass].new( self._sets.paramCtor )
			cls:openView(cell, _vFrom)
			cls:setPosition(cc.p(_cellWidth/2, _cellHeight/2))
			cls:getView():setTag(100)
			cls:UpdateInfo( self._sets.list[idx+1], idx+1, self._sets.param )
		else
			local vo = cell:getChildByTag(100)
			local cls = vo and vo.logic or nil
			cls:setPosition(cc.p(_cellWidth/2, _cellHeight/2))
			cls:UpdateInfo( self._sets.list[idx+1], idx+1, self._sets.param )
		end

		if self._sets.cbOnIdx then
			self._sets.cbOnIdx(idx)
		end
		return cell
	end

	local tmp = _G[self._sets.cellclass].new()
	tmp:initCSBNode()
	local cellvx = tmp:getChildByName(self._sets.cellCheck)
	local size = cellvx:getContentSize()
	_cellWidth, _cellHeight = self._sets.cellWidth or size.width, self._sets.cellHeight or size.height
	_dir = self._sets.dir or 1
	self._sets.cellWidth = _cellWidth
	self._sets.cellHeight = _cellHeight

	_topGap = self._sets.topGap or 0
	_bottomGap = self._sets.bottomGap or 0
	local maxGap = (_dir == 1) and cc.p(0,_bottomGap) or cc.p(_topGap, 0)
	local minGap = (_dir == 1) and cc.p(0,_topGap) or cc.p(_bottomGap, 0)

	local rect, gap = self._sets.rect or {}, 0
	if self._sets.fixScreenSize then
		rect, gap = TableViewHelper.getTagRectByNode( 
									_vFrom, self._sets.container, 
									self._sets.offset[1], self._sets.offset[2], 
									self._sets.dir, self._sets.offset[3])
	end

	self._tbView = TableViewHelper.replaceTableView( 
							_vFrom, 
							rect,
							self._sets.container,
							{
								cellsCount=numberOfCellsInTableView,
								cellSize=cellSizeForTable,
								tableCell=tableCellAtIndex,
							},
							self._sets.dir , self._sets.fill, 
							{max=maxGap, min=minGap})

	if self._sets.fixScreenSize and (not self._sets.notOffsetY) then
		if self._sets.dir == 0 then

		else -- 1
			self._tbView:setPositionY(rect[2]+gap) -- 0.5,1
		end
	end
end

function TableViewLogic:reloadData(list, holdpos, param, cellSize)
	if not self._tbView then return end
	self._sets.list = list or self._sets.list
	self._sets.param = param or self._sets.param
	self._cellSize = cellSize

	if holdpos then
		CCX.fixTableViewReloadData(self._tbView, self._sets.fixCntChg)
	else
		self._tbView:reloadData()
	end
end

-- ToTop/ToLeft
function TableViewLogic:offsetToIndex(idx , time, notfixPos)
	if not self._tbView then return end
	local tv = self._tbView
	local scrollSize = tv:getContentSize()
	local totalSize = tv:getInnerContainerSize()
	local p = tv:getContentOffset()
	local gapBottom, gapTop = tv:getGap()
	if self._sets.dir == 0 then
		if totalSize.width <= scrollSize.width then
			return
		end
		p.x = -((idx - 1) * self._sets.cellWidth) + gapBottom.x
		p.x = math.max(p.x, scrollSize.width - totalSize.width - gapTop.x)
		p.x = math.min(p.x, gapBottom.x)
	else -- 1
		if totalSize.height <= scrollSize.height then
			return
		end
		p.y = scrollSize.height - ((#self._sets.list - idx + 1) * self._sets.cellHeight) - gapTop.y
		p.y = math.max(p.y, scrollSize.height - totalSize.height - gapTop.y)

		if not notfixPos then
			p.y = math.min(p.y, gapBottom.y)
		end
	end
	if time then
		tv:setContentOffsetInDuration(p, time)
	else
		tv:setContentOffset(p)
	end
end

function TableViewLogic:offsetToCenter(idx)
	if not self._tbView then return end
	local tv = self._tbView
	local scrollSize = tv:getContentSize()
	local totalSize = tv:getInnerContainerSize()
	local p = tv:getContentOffset()
	local gapBottom, gapTop = tv:getGap()
	if self._sets.dir == 0 then
		if totalSize.width <= scrollSize.width then
			return
		end
		p.x = -((idx - 0.5) *self._sets.cellWidth) + scrollSize.width / 2
		p.x = math.max(p.x, scrollSize.width - totalSize.width - gapTop.x)
		p.x = math.min(p.x, gapBottom.x)
	else -- 1
		if totalSize.height <= scrollSize.height then
			return
		end
		p.y = scrollSize.height / 2 - ((#self._sets.list - idx + 0.5) * self._sets.cellHeight) 
		p.y = math.max(p.y, scrollSize.height - totalSize.height - gapTop.y)
		p.y = math.min(p.y, gapBottom.y)
	end
	tv:setContentOffset(p)
end

function TableViewLogic:startAnimEffect(mode)
	TableViewHelper.startAnimEffect(self._tbView, mode)
end

function TableViewLogic:close()
	if self._tbView then
		self._tbView:removeFromParent()
		self._tbView = nil
	end
	self._sets = nil
end

function TableViewLogic:getTableView()
	return self._tbView
end

function TableViewLogic:getSets( )
	return self._sets
end

function TableViewLogic:setVisible(value)
	self._tbView:setVisible(value)
end

-- 不可点击cell中的按钮，不能拖动
function TableViewLogic:setTouchEvent( v )
	self._tbView:setEnabled(v)
end

-- 可点击cell中的按钮，不能拖动
function TableViewLogic:setTouchEnabled( v )
	self._tbView:setTouchEnabled(v)
end

-- 设置tableview拖动处理函数
function TableViewLogic:registerScrollHandler( params, func )
	local function numberOfCellsInTableView()
	   return #self._sets.list
	end
	TableViewHelper.registerScrollHandler(self._tbView,
	 {
	 	cnt = numberOfCellsInTableView,
	 	width = self._sets.cellWidth,
	 	height = self._sets.cellHeight,
	 	direction = self._sets.dir,
	 },
	 params,
	 func)
end

-- 设置tableview停止处理函数
function TableViewLogic:registerStopHandler( func )
	TableViewHelper.registerStopHandler(self._tbView, func)
end

function TableViewLogic:setContentOffset( offset, animated )
	TableViewHelper.setContentOffset(self._tbView, offset, animated)
end

function TableViewLogic:setDeaccelRate( value )
	self._tbView:setDeaccelRate(value)
end