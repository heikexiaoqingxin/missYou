local ServerHearBeat = class("ServerHearBeat", "protocol")
function ServerHearBeat:ctor()
	self.msg_id = Protocol.RECV_SERVER_HEART
end

function ServerHearBeat:SendProtocolData(protocol , buff , server)
	-- buff:writeStringUInt(protocol.time)
end	

function ServerHearBeat:RecvProtocolData(protocol)
end

local ServerLoginAccount = class("ServerLoginAccount", "protocol")
function ServerLoginAccount:ctor()
	self.msg_id = Protocol.RECV_SERVER_LOGIN
end

function ServerLoginAccount:SendProtocolData(protocol , buff , server)
	buff:writeByte(protocol.errcode)
	buff:writeStringUInt(protocol.username)
	buff:writeStringUInt(protocol.password)
end

function ServerLoginAccount:RecvProtocolData(protocol)
	self.username = protocol:readStringUInt()
	self.password = protocol:readStringUInt()
end

local ServerCreateName = class("ServerCreateName", "protocol")
function ServerCreateName:ctor()
	self.msg_id = Protocol.RECV_SERVER_ACCOUNT
end

function ServerCreateName:SendProtocolData(protocol , buff , server)
	buff:writeByte(protocol.errcode)
	buff:writeStringUInt(protocol.user_name)
	buff:writeStringUInt(protocol.pass_word)
end

function ServerCreateName:RecvProtocolData(protocol)
	self.account_name = protocol:readStringUInt()
	self.register_name = protocol:readStringUInt()
	self.register_word = protocol:readStringUInt()
end

local ServerRoleInfo = class("ServerRoleInfo", "protocol")
function ServerRoleInfo:ctor()
	self.msg_id = Protocol.RECV_SERVER_INFO
end

function ServerRoleInfo:SendProtocolData(protocol , buff , server)
	buff:writeStringUInt(protocol.Name)
	buff:writeStringUInt(protocol.city)
	buff:writeByte(protocol.num)
	for i = 1 , protocol.num do
		buff:writeStringUInt(protocol.room_list[i]:GetName())
		buff:writeStringUInt(protocol.room_list[i]:GetAddr())
		buff:writeByte(protocol.room_list[i]:GetId())
	end
end

function ServerRoleInfo:RecvProtocolData(protocol)
	self.user_name = protocol:readStringUInt()
	self.pass_word = protocol:readStringUInt()
end

local ServerChatInfo = class("ServerChatInfo", "protocol")
function ServerChatInfo:ctor()
	self.msg_id = Protocol.RECV_SERVER_CHAT
end

function ServerChatInfo:SendProtocolData(protocol , buff , server)
	buff:writeStringUInt(protocol.address)
	buff:writeStringUInt(protocol.name)
	buff:writeStringUInt(protocol.msg)
end

function ServerChatInfo:RecvProtocolData(protocol)
	self.msg = protocol:readStringUInt()	
end

local ServerCreateNumber = class("ServerCreateNumber", "protocol")
function ServerCreateNumber:ctor()
	self.msg_id = Protocol.RECV_SERVER_CREATE
end

function ServerCreateNumber:SendProtocolData(protocol , buff , server)
	buff:writeByte(protocol.errcode)
end

function ServerCreateNumber:RecvProtocolData(protocol)
	self.username = protocol:readStringUInt()
	self.password = protocol:readStringUInt()
end

--创建房间
local ServerCreateRoom = class("ServerCreateRoom", "protocol")
function ServerCreateRoom:ctor()
	self.msg_id = Protocol.RECV_SERVER_ROOM
end

function ServerCreateRoom:SendProtocolData(protocol , buff , server)
	buff:writeByte(protocol.num)
	buff:writeByte(protocol.id)
	for i = 1 , protocol.num do
		buff:writeStringUInt(protocol.room_list:GetName())
		buff:writeStringUInt(protocol.room_list:GetAddr())
	end
end

function ServerCreateRoom:RecvProtocolData(protocol)
end

--房间列表信息
local ServerRoomList = class("ServerRoomList", "protocol")
function ServerRoomList:ctor()
	self.msg_id = Protocol.RECV_SERVER_ROOMLIST
end

function ServerRoomList:SendProtocolData(protocol , buff , server)
	buff:writeByte(#protocol.room_list)
	for i = 1 , #protocol.room_list do
		buff:writeStringUInt(protocol.room_list[i]:GetName())
		buff:writeStringUInt(protocol.room_list[i]:GetAddr())
		buff:writeByte(protocol.room_list[i]:GetId())
	end
end

function ServerRoomList:RecvProtocolData(protocol)
end


