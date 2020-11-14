local RoomCtrl = class("RoomCtrl" , BaseControl)
local RoomData = require("game.room.room_data")
local RoomView = require("game.room.room_view")

function RoomCtrl:ctor( ... )
	self.data = RoomData.new()
	self.view = RoomView.new(self , self.data)
	self:ProtoclParse(Protocol.RECV_SERVER_ROOM , RoomCtrl.SCROOMDATA)
end

function RoomCtrl:SCROOMDATA( Protocol , pSocket )
	-- body
	self.view:Open(pSocket)
end

function RoomCtrl:SendRoomProtocol(protocol)
	self:Send(Protocol.RECV_SERVER_ROOM , protocol)
end

function RoomCtrl:SendRoomListInfo( protocol )
	-- body
	self:Send(Protocol.RECV_SERVER_ROOMLIST , protocol, "broad")
end

return RoomCtrl