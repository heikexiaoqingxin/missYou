local ChatData = class("ChatData")
function ChatData:SetProtocolData(protocol)
	self.msg = protocol.msg
end

function ChatData:GetMsgData( ... )
	-- body
	return self.msg
end

return ChatData