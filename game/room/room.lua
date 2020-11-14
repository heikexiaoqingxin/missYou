local room = class("room")
function room:ctor( id , player )
	-- body
	self.id = id --房间Id
	self.name = player:GetName() --创建人名字
	self.addr = player:GetAddress() --创建人地址
	
end

function room:GetName( ... )
	-- body
	return self.name
end

function room:GetAddr( ... )
	-- body
	return self.addr
end

function room:GetId( ... )
	-- body
	return self.id
end

return room