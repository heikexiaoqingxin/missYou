local ChatCtrl = class("ChatCtrl" , BaseControl)
local ChatData = require("game.chat.chat_data")
local ChatView = require("game.chat.chat_view")

function ChatCtrl:ctor()
	self.data = ChatData.new()
	self.view = ChatView.new(self , self.data)
	self:ProtoclParse(Protocol.RECV_SERVER_CHAT , ChatCtrl.SCCHATDATA)
end

function ChatCtrl:SCCHATDATA(protocol, pSocket)
	self.data:SetProtocolData(protocol)
	self.view:Open(pSocket)
end

function ChatCtrl:SendProtocol( addr, my_name, message )
	local protocol = { address = addr , name = my_name , msg = message}
	self:Send(Protocol.RECV_SERVER_CHAT , protocol , "broadcast")
end

return ChatCtrl