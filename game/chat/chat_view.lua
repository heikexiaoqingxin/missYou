local ChatView = class("ChatView")
function ChatView:ctor(ctrl , data)
	self.data = data
	self.ctrl = ctrl
end

function ChatView:Open( pSocket )
	local chat_data = self.data:GetMsgData()
	local player_list = PlayList
	local player = player_list:GetPlayer(pSocket.m_Id)
	self.ctrl:SendProtocol(player:GetAddress(), player:GetName(), chat_data)
end

return ChatView