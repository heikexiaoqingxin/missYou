local RoomView = class("RoomView")
function RoomView:ctor(ctrl , data)
	self.data = data
	self.ctrl = ctrl
end

function RoomView:Open( pSocket )
	local id = self.data:CreateRoom(pSocket)
	local player_list = PlayList
	local room_list = player_list:GetRoomList()
	local protocol = {}
	protocol.num = 1
	protocol.id = id
	protocol.room_list = room_list[#player_list:GetRoomList()]
	self.ctrl:SendRoomProtocol(protocol)
	--广播创建房间信息
	local room_info = {room_list = room_list}
	self.ctrl:SendRoomListInfo(room_info)
end


return RoomView