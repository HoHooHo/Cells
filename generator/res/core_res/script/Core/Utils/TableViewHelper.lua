module("TableViewHelper", package.seeall)

TABLEVIEW_FILL_TOPDOWN = 0
TABLEVIEW_FILL_BOTTOMUP = 1

SCROLLVIEW_SCRIPT_SCROLL = 0
SCROLLVIEW_SCRIPT_ZOOM   = 1
SCROLLVIEW_SCRIPT_ENDED  = 2
TABLECELL_TOUCHED        = 3
TABLECELL_HIGH_LIGHT     = 4
TABLECELL_UNHIGH_LIGHT   = 5
TABLECELL_WILL_RECYCLE   = 6
TABLECELL_SIZE_FOR_INDEX = 7
TABLECELL_SIZE_AT_INDEX  = 8
NUMBER_OF_CELLS_IN_TABLEVIEW = 9

SCROLLVIEW_DIRECTION_NONE = -1
SCROLLVIEW_DIRECTION_HORIZONTAL = 0
SCROLLVIEW_DIRECTION_VERTICAL = 1
SCROLLVIEW_DIRECTION_BOTH  = 2

--[[
rect [x,y,w,h] tableview的坐标 和 宽高
cbs 
 {
	cellsCount  = numberOfCellsInTableView (table)
	cellSize    = cellSizeForTable (table, idx)
	tableCell   = tableCellAtIndex (table, idx)  --idx : 0 ~ (numberOfCellsInTableView()-1)
	cellTouched = tableCellTouched (table, cell) --cell:getIdx()
	didScroll   = scrollViewDidScroll (view)
	didZoom     = scrollViewDidZoom (view)
 }
direction tableView的滚动方向
fillOrder tableView中cell的顺序，只对纵向有作用
--]]
function createTableView(rect, cbs, parent, direction, fillOrder, gap, notRelaodData)
	if direction == nil then direction = SCROLLVIEW_DIRECTION_HORIZONTAL end

	local tableView = ETableView:create(cc.size(rect[3], rect[4]))
    tableView:setDirection(direction)
	tableView:setPosition(cc.p(rect[1], rect[2]))

	if gap then
		tableView:setGap(gap.max or cc.p(0, 0), gap.min or cc.p(0, 0))
	end

	if parent then
		parent:addChild(tableView)
	end
		
	if fillOrder then
		tableView:setVerticalFillOrder(fillOrder)
	end
	
	tableView:setDelegate()

	tableView:registerScriptHandler(cbs.cellsCount, NUMBER_OF_CELLS_IN_TABLEVIEW)  
	tableView:registerScriptHandler(cbs.cellSize, TABLECELL_SIZE_FOR_INDEX)
	tableView:registerScriptHandler(cbs.tableCell, TABLECELL_SIZE_AT_INDEX)
	if cbs.cellTouched then tableView:registerScriptHandler(cbs.cellTouched, TABLECELL_TOUCHED) end
	if cbs.didScroll then tableView:registerScriptHandler(cbs.didScroll, SCROLLVIEW_SCRIPT_SCROLL) end
	if cbs.didZoom then tableView:registerScriptHandler(cbs.didZoom, SCROLLVIEW_SCRIPT_ZOOM) end

	if not notRelaodData then
		tableView:reloadData()
	end

	return tableView
end

function replaceTableView( logic, rect, name, cbs, direction, fillOrder, gap, notRelaodData)
	local tempWidget = name
	if type(name) == "string" then
		tempWidget = logic:getChildByName(name)
	end
	
	local x, y = tempWidget:getPosition()
	local size = tempWidget:getContentSize()

	local tableView = createTableView(
		{rect[1] or x, rect[2] or y, rect[3] or size.width, rect[4] or size.height}, 
		cbs,
		nil, 
		direction,
		fillOrder,
		gap,
		notRelaodData
	)

	tempWidget:setPosition(rect[1] or x, rect[2] or y)

	logic:replaceWithNodeByNode( tempWidget, tableView )

	return tableView, size.width, size.height
end

-- return [有效x,有效y,有效w,有效h],
function getTagRectByNode( logic, pannel, top, buttom, direction, gap )
	local panelNode = logic:getChildByName(pannel)
	if direction == 0 then
		local x, y = panelNode:getPosition()
		local size = panelNode:getContentSize()
		size.width = WIN_SIZE.width
		return {x, cy, size.width, size.height}, 
				0,
				0, 0
	end

	if type(top) == "number" or type(buttom) == "number" then
		top = top or 0
		buttom = buttom or 0
		local x, y = panelNode:getPosition()
		local anchor = panelNode:getAnchorPoint()
		local size = panelNode:getContentSize()
		local h = top+buttom
		local hNew = WIN_SIZE.height-h-(gap or 0)
		local yNew = buttom + hNew * anchor.y
		local dis = WIN_SIZE.height-Config.ResolutionSize.height
		return {x, yNew, size.width, hNew}, 
				0,
				h, dis
	end

	local voT,voB = nil, nil
	if type(top)=="string" then 
		voT = logic:getChildByName(top)
	elseif top and top.getBoundingBox then
		voT = top
	end
	if type(buttom)=="string" then
		voB = logic:getChildByName(buttom)
	elseif buttom and buttom.getBoundingBox then
		voB = buttom 
	end
	local topSize   = {width=0,height=0}
	local buttomSize= {width=0,height=0}

	local ty = 0
	local by = 0
	if voT then
		topSize   = voT:getBoundingBox() 
		ty = voT:getPositionY() or 0
		ty = ty - topSize.height * voT:getAnchorPoint().y
	end
	if voB then
		buttomSize = voB:getBoundingBox()
		by = voB:getPositionY() or 0
		by = by + buttomSize.height * (1-voB:getAnchorPoint().y)
	end
	local cy = by + (ty-by) *0.5

	local x, y = panelNode:getPosition()
	local size = panelNode:getContentSize()

	local h = buttomSize.height + topSize.height
	local dis = WIN_SIZE.height - Config.ResolutionSize.height

	return {x, cy, size.width, WIN_SIZE.height - h - (gap or 0)}, 
			0,
			h, dis
end

function startAnimEffect(tableView, mode)
end
-- function startAnimEffect_ORG(tableView, mode)
-- 	local p = tableView:getContentOffset()
-- 	if tableView:getDirection() == SCROLLVIEW_DIRECTION_HORIZONTAL then
-- 		-- tableView:getInnerContainer():setOpacity(0)
-- 		if mode and mode == 1 then
-- 			tableView:getInnerContainer():runAction(
-- 					cc.Sequence:create(
-- 						cc.MoveBy:create(0.2, cc.p(-30, 0)),
-- 						cc.MoveBy:create(0.15, cc.p(30, 0))
-- 					))
-- 		else
-- 			tableView:getInnerContainer():runAction(
-- 					cc.Sequence:create(
-- 						-- cc.DelayTime:create(0.01),
-- 						-- cc.Place:create(cc.p(p.x+70, p.y)),
-- 						cc.MoveBy:create(0, cc.p(80, 0)),
-- 						-- cc.Spawn:create(cc.FadeIn:create(0.2), cc.MoveBy:create(0.2, cc.p(0, 90))),
-- 						cc.MoveBy:create(0.2, cc.p(-120, 0)),
-- 						cc.MoveBy:create(0.15, cc.p(40, 0))
-- 					))
-- 		end
-- 	elseif tableView:getDirection() == SCROLLVIEW_DIRECTION_VERTICAL then
-- 		-- tableView:getInnerContainer():setOpacity(0)
-- 		tableView:getInnerContainer():runAction(
-- 				cc.Sequence:create(
-- 					cc.Place:create(cc.p(p.x, p.y-90)),
-- 					-- cc.Spawn:create(cc.FadeIn:create(0.2), cc.MoveBy:create(0.2, cc.p(0, 90))),
-- 					cc.MoveBy:create(0.2, cc.p(0, 130)),
-- 					cc.MoveBy:create(0.3, cc.p(0, -40))
-- 				))
-- 	end
-- end

function updateAndLockPosition(tbView, fun)
	local tbPos = nil
	if tbView then tbPos = tbView:getContentOffset() end
	fun()
	if tbPos then tbView:setContentOffset(tbPos) end
end

function setContentOffset( tbView, offset, animated )
	tbView:setContentOffset(offset, animated)
end

-- 设置tableview拖动处理函数，实现近大远小的滚动效果
-- Input: 
--		tabView 	-- 操作对象tableview
--		tabParams = 
--		{
--			cnt,				-- 获取tableView元素的数量的函数
--			width,				-- cellWidth
--			height,				-- cellHeight
--			direction,			-- direction
--		}
--		params = 
-- 		{
--			posPerc,			-- cell最大位置的百分比
--			maxScale,			-- 最大縮放比值
--			xMin,				-- 进行缩放和显示的x轴最小坐标（横向滚动时使用）
--			xMax,				-- 进行缩放和显示的x轴最大坐标（横向滚动时使用）
--			yMin,				-- 进行缩放和显示的y轴最小坐标（纵向滚动时使用）
--			yMax,				-- 进行缩放和显示的y轴最大坐标（纵向滚动时使用）
--			alphaPerc,			-- cell最大位置以上区域，alpha开始变化的位置的百分比
--			invisiblePerc,		-- cell最大位置以上区域，开始完全透明的位置的百分比
-- 		}
--		func        -- 针对tableview的offset，对界面中的其它图形元素进行操作
function registerScrollHandler( tabView, tabParams, params, func )
	-- check tabView
	if tabView == nil then
		Global.showDebugTips("registerScrollHandler: tableView is nil.")
		return
	end

	-- check tabParams
	if tabParams == nil 
	 or tabParams.cnt == nil 
	 or tabParams.width == nil 
	 or tabParams.height == nil 
	 or tabParams.direction == nil then
		Global.showDebugTips("registerScrollHandler: tabParams noVilid.")
		return
	end

	-- chack params
	if params == nil then
		params = {}
	end

	-- params prepare
	local posPercent = params.posPerc or 0.214
	local maxScale = params.maxScale or 2
	local cntFunc = tabParams.cnt
	local cellWidth = tabParams.width
	local cellHeight = tabParams.height
	local direction = tabParams.direction

	local alphaPoint = params.alphaPerc or 0.25
	local invisiblePoint = params.invisiblePerc or 0.2

	-- scroll callback
	local function scrollFunc(  )
		-- params prepare
		local cnt = cntFunc()
		local height = tabView:getContentSize().height
		local width = tabView:getContentSize().width
		local xMin = params.xMin or 0
		local xMax = params.xMax or width
		local yMin = params.yMin or - height * 0.5
		local yMax = params.yMax or height * 0.9

		local posY = tabView:getContentOffset().y
		local posX = tabView:getContentOffset().x

		-- process scale and opacity  
		if direction == SCROLLVIEW_DIRECTION_VERTICAL then 	-- vertical
			for i = 0, cnt - 1 do
				local cell = tabView:cellAtIndex(i)
				if cell ~= nil then
					local cellY = cell:getPositionY()
					local y = cellY + posY
					if y >= yMax then
						cell:setScale(0)
						cell:setOpacity(0)
					elseif y > yMax * posPercent then
						local scale = maxScale * (1 - y / yMax) / (1 - posPercent)
						if scale < invisiblePoint then
							cell:setOpacity(0)
						elseif scale < alphaPoint then
							cell:setOpacity(255 * (scale - invisiblePoint) / (alphaPoint - invisiblePoint))
						else
							cell:setOpacity(255)
						end
						cell:setScale(scale)
					elseif y > yMin then
						cell:setScale(maxScale * (y - yMin) / (yMax * posPercent - yMin))
					else
						cell:setScale(0)
					end
				end
			end

			if func then
				func(tabView:getInnerContainer():getPositionY())
			end
		else 												-- horizonal
			for i = 0, cnt - 1 do
				local cell = tabView:cellAtIndex(i)
				if cell ~= nil then
					local cellX = cell:getPositionX()
					local x = cellX + posX
					if x > xMax then
						cell:setScale(0)
					elseif x > xMax * posPercent then
						cell:setScale(2 - x / (xMax * posPercent))
					elseif x > 0 then
						cell:setScale(x / (xMax * posPercent))
					else
						cell:setScale(0)
					end
				end
			end

			if func then
				func(tabView:getInnerContainer():getPositionX())
			end
		end
	end

	tabView:registerScriptHandler(scrollFunc, cc.SCROLLVIEW_SCRIPT_SCROLL)
end

-- tableview停止后的处理函数
function registerStopHandler( tabView, func )
	local function scrollFunc(  )
		local posY = tabView:getContentOffset().y
		local posX = tabView:getContentOffset().x

		func({x = posX, y = posY})
	end
	tabView:registerScriptHandler(scrollFunc, cc.SCROLLVIEW_SCRIPT_ENDED)
end