CCTween = CCTween or {}

function CCTween.FormOutToIn(node,time,delay)
	if not time then time = 0.2 end
	if not delay then delay = 0.2 end
	node:setOpacity(0)
	
	local fadeInAction = cc.FadeIn:create(time)
	local delayAction = cc.DelayTime:create(delay)
	local arr = {delayAction,fadeInAction}
	local action = cc.Sequence:create(arr)
	node:runAction(action)
end

function CCTween.FaceIn(node,duration)
	node:runAction(
		cc.Sequence:create(
			cc.Show:create(),
			cc.FadeIn:create(duration)
		))
end
function CCTween.FaceOut(node,duration)
	local fadeIn = 
	node:runAction(
		cc.Sequence:create(
			cc.FadeOut:create(duration),
			cc.Hide:create()
		))
end
function CCTween.RandomBlink(node,remove,pts,startTime,endTime)
	if node then
		if remove then
			node:stopAllActions()
			return 
		end
		if not startTime then startTime = 3 end
		if not endTime then endTime = 5 end

		local onFrame = function ()
			if node then
				if math.random() < 0.5 then
					if type(pts) == "table" then
						for k,v in pairs(pts) do
							v:resetSystem()
						end
					else
						pts:resetSystem()
					end
				end
			end
		end
		node:runAction(
				cc.RepeatForever:create( 
				cc.Sequence:create(
					cc.DelayTime:create(math.random(startTime,endTime)),
					cc.CallFunc:create(onFrame)
		)))
	end
end
--渐变闪烁
function CCTween.CCShadeBlink(node,remove,duration,times)
	if remove then
		node:stopAllActions()
		return
	end

	if not duration then duration = 0.4 end

	local fadeIn = cc.FadeIn:create(duration)
	local fadeOut = cc.FadeOut:create(duration)
	local arr = {fadeIn,fadeOut}
	local action = cc.Sequence:create(arr)
	local item = nil
	if times then
		item = cc.Repeat:create(action,times)
	else
		item = cc.RepeatForever:create(action)
	end
	node:runAction(item)
end
--渐变缩放times次数
function CCTween.CCScaleTo(node,remove,scaleX,sclaeY,time,times)
	if remove then
		node:setScale(1)
		node:stopAllActions()
		return
	end

	if not scaleX then scaleX = 0.8 end
	if not sclaeY then sclaeY = 0.8 end
	if not time then time = 0.6 end

	local scaleMin = cc.ScaleTo:create(time,scaleX,sclaeY)
	local scaleMax = cc.ScaleTo:create(time,1,1)
	local arr = {scaleMin,scaleMax}
	local action = cc.Sequence:create(arr)
	local item = nil
	if times then
		item = cc.Repeat:create(action,times)
	else
		item = cc.RepeatForever:create(action)
	end
	node:runAction(item)
end

function CCTween.RandomMove( node, remove, t)
	if not t then t = 1 end
	if remove then
		node:stopAllActions()
		return
	end
	local x,y = node:getPosition()
	local random = math.random(1,4)
	if random == 1 then
		y = y + 15
		x = x + 15
	elseif random == 2 then
		y = y - 15
		x = x - 15
	elseif random == 3 then
		x = x + 15
		y = y - 15
	else
		x = x - 15
		y = y + 15
	end
	node:runAction(
		cc.Repeat:create(
			cc.Sequence:create(
				cc.MoveTo:create(t,cc.p(x, y))
		),1))
end

function CCTween.setNodeColor( node, remove, color, t )
	if not t then t = 1 end
	if remove then
		node:stopAllActions()
		return
	end
	local function cb1( )
		node:setColor(color)
	end
	node:runAction(
		cc.Repeat:create(
			cc.Sequence:create(
				cc.DelayTime:create(t),
				cc.CallFunc:create(cb1)
		),1))
end

--小幅上下循环移动
function CCTween.SlowMove(node, remove,t)
	if not t then t = 1 end
	if remove then
		node:stopAllActions()
		return
	end

	node:runAction(
		cc.RepeatForever:create(
			cc.Sequence:create(
				cc.MoveBy:create(t,cc.p(0, 10)),
				cc.MoveBy:create(t,cc.p(0, -10))
		)))
end
--横向左右移动 duration
function CCTween.SlowMoveX(node, remove,t,duration)
	if not t then t = 1 end
	if not duration then duration = 10 end
	if remove then
		node:stopAllActions()
		return
	end

	node:runAction(
		cc.RepeatForever:create(
			cc.Sequence:create(
				cc.MoveBy:create(t,cc.p(duration,0)),
				cc.MoveBy:create(t,cc.p(-duration,0))
		)))
end
--循环淡入淡出
function CCTween.fadeLoop(node, remove,t)
	if not t then t = 0.6 end
	if remove then
		node:stopAllActions()
		return
	end

	node:runAction(
		cc.RepeatForever:create(
			cc.Sequence:create(
				cc.FadeIn:create(t),
				cc.FadeOut:create(t)
		)))
end
--dir 0 X轴 1Y轴
function CCTween.MoveBy(node,remove,t,dir,float)
	if not t then t = 1 end
	if remove then
		node:stopAllActions()
		return
	end
	local x = 0
	local y = 0
	if dir == 0 then
		x = float
	elseif dir == 1 then
		y = float
	end
	node:runAction(
		cc.RepeatForever:create(
			cc.Sequence:create(
				cc.MoveBy:create(t,cc.p(-x,-y)),
				cc.MoveBy:create(t,cc.p(math.abs(x),math.abs(y)))
		)))
end

-- tank disabled
function CCTween.TintDisabled(node, remove,time,notColor,repOnce)
	if not node then
		logWarnning("[CCTween.TintSelected] node is NULL")
		return
	end

	if remove then
		node:stopAllActions()
		if notColor == nil then
			node:setColor(cc.c3b(255,255,255))
		end
		return
	end

	if time == nil then time = 0.6 end
	local action = cc.Sequence:create(
						-- cc.TintTo:create(time, 128,128,128),
						-- cc.TintTo:create(time, 255,255,255)
						cc.TintTo:create(time,     	90,90,90),
						cc.DelayTime:create(time*0.2),
						cc.TintTo:create(time, 		200,200,200)
					)
	local item = repOnce and cc.Repeat:create(action,1) or cc.RepeatForever:create(action)

	node:stopAllActions()
	node:runAction(item)
end

-- rage disabled
function CCTween.rageDisabled(node, remove,time,notColor,repOnce)
	if not node then
		logWarnning("[CCTween.TintSelected] node is NULL")
		return
	end

	if remove then
		node:stopAllActions()
		if notColor == nil then
			node:setColor(cc.c3b(255,255,255))
		end
		return
	end

	if time == nil then time = 0.4 end
	local action = cc.Sequence:create(
						cc.TintTo:create(time, 18+90,6+90,40+90),
						cc.DelayTime:create(time*0.2),
						cc.TintTo:create(time, 200,200,200)
					)
	local item = repOnce and cc.Repeat:create(action,1) or cc.RepeatForever:create(action)

	node:stopAllActions()
	node:runAction(item)
end

-- alpha循环变化
function CCTween.opacityLoop(node, remove,f, vMax,vMin)
	if remove then
		node:stopAllActions()
		return
	end

	vMin = vMin or 0.3
	vMax = vMax or 1
	local a = node:getOpacity()
	local f = f or 0.02
	local cb1 = function ()
		a = a + f
		if a < vMin	then a=vMin;  f=math.abs(f)  end
		if a > vMax then a=vMax; f=-math.abs(f) end
		node:setOpacity(a*255)
	end
	node:runAction(
		cc.RepeatForever:create(
			cc.Sequence:create(
				cc.DelayTime:create(0.016),
				cc.CallFunc:create(cb1)
		)))
end
function CCTween.opacityLoopEx(node, remove,f, vMax, pendingMax, vMin)
	if remove then
		node:stopAllActions()
		return
	end

	vMin = vMin or 0 -- 0.3
	vMax = vMax or 1
	local pMax = pendingMax or 0
	local a = node:getOpacity()
	local f = f or 0.02
	local p = 0
	local cb1 = function ()
		a = a + f
		if a < vMin then
			-- a = vMin;
			f = math.abs(f)
			if p > 0 then
				p = p - 1
				if p <= 0 then
					a = vMin;
				end
			else
				a = vMin;
			end
		elseif a > vMax then 
			p = math.floor(pMax * math.random())
			a = vMax; 
			f = -math.abs(f) 
		end
		if a < 0 then a = 0 end
		node:setOpacity(a*255)
	end
	node:runAction(
		cc.RepeatForever:create(
			cc.Sequence:create(
				cc.DelayTime:create(0.016),
				cc.CallFunc:create(cb1)
		)))
end

-- 循环旋转
function CCTween.rotationLoop(node, remove,angle,t)
	if not t then t = 1 end
	if not angle then angle = 720 end
	if remove then
		node:stopAllActions()
		return
	end

	node:runAction(
		cc.RepeatForever:create(
			cc.Sequence:create(
				cc.RotateTo:create(t, angle)
		)))
end

-- 透明度渐变循环
function CCTween.fadeToLoop(node, remove,startOpacity, endOpacity, t)
	if remove then
		node:stopAllActions()
		return
	end
	
	node:setOpacity(startOpacity)
	local fade1 = cc.FadeTo:create(t, endOpacity)
	local fade2 = cc.FadeTo:create(t, startOpacity)

	node:runAction(
		cc.RepeatForever:create(
			cc.Sequence:create(
				{fade1, fade2}
		)))
end

function CCTween.ScaleMinOrMax(node,time,delay)
	if not time then time = 0.2 end
	if not delay then delay = 0.2 end
	node:setOpacity(0)

	local nodeScaleX = node:getScaleX()
	local nodeScaleY = node:getScaleY()
	
	local fadeInAction = cc.FadeIn:create(time)
	local delayAction = cc.DelayTime:create(delay)
	local scaleMin = cc.ScaleTo:create(time,0.5*nodeScaleX,0.5*nodeScaleY)
	local scaleMax = cc.ScaleTo:create(time,2*nodeScaleX,2*nodeScaleY)
	local scaleNormal = cc.ScaleTo:create(time,1*nodeScaleX,1*nodeScaleY)
	local arr = {delayAction,fadeInAction,scaleMin,scaleMax,scaleNormal}
	local action = cc.Sequence:create(arr)
	node:runAction(action)
end
