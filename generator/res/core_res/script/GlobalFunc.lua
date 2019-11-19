-- 获取当前地块是否可以行走（为空地）全局函数，C++直接调用，勿改
function isBlockEmpty( x, y )
	if y < 0 then
		return false
	end
	
	local typeValue = MineData.BlockInfoForC[x .. ":" .. y]
	if typeValue == MineData.BLOCK_TYPE["empty"] then
		return true
	end

	return false
end