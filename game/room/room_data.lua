local RoomData = class("RoomData")
function RoomData:CreateRoom( pSocket )
	-- body
	local player_list = PlayList
	return player_list:CreateRoom(pSocket.m_Id , player)
end


return RoomData