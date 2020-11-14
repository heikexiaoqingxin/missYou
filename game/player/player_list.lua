PlayList = {}
local room = require("game.room.room")
function PlayList:__init( ... )
	self.player_list = {}
	self.room_list = {}
end

function PlayList:AddPlayer(m_Id, player)
	self.player_list[m_Id] = player
end

function PlayList:GetPlayer(m_Id)
	return self.player_list[m_Id]
end

function PlayList:GetPlayList( ... )
	-- body
	return self.player_list
end

function PlayList:CreateRoom( m_Id , player )
	-- body
	local player = self:GetPlayer(m_Id)
	self.room_list[#self.room_list + 1] = room.new(#self.room_list + 1 , player)
	return #self.room_list
end

function PlayList:GetRoomList( ... )
	-- body
	return self.room_list
end

PlayList:__init()

return PlayList
