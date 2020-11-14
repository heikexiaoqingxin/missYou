local player = class("player")
function player:ctor(pSocket)
	self.server = pSocket
	self.m_Id = pSocket.m_Id
	self.Send = pSocket.Send
	self:SetAddress(GameServer.http:QueryIp())
end

function player:SetAccount(account , pass_word)
	self.account = account 
	self.pass_word = pass_word
end

function player:SetName(name)
	self.name = name 
end

function player:SetAddress( addr )
	self.addr = addr
end

function player:GetAddress( ... )
	return self.addr
end

function player:GetName()
	return self.name
end

return player
