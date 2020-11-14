local CliSocketHandle = class("CliSocketHandle")
local ByteArray = require("lib.ByteArray")
local semaphore = require "ngx.semaphore"

--返回递增的一个ID
local function getIdAllocator(from)
	local id = from or 0;
	return function()
		id = id + 1;
		return id;
	end
end

local func = getIdAllocator(0)


local function readLen(buf)
    buf:setPos(1)
    local len = buf:readShort()
    buf:setPos(1)
    return len
end

function CliSocketHandle:ctor(receiveHandler, name)

	self.pUser = nil
	self.m_pLogicServer = nil
	self.m_bConntected = false
	self.m_Addr = ""
	self.m_nPort = 0
	self.m_Id = func()

	self._tcp_to_send_data = {}
	Print("self.m_Id:", self.m_Id)
	
	local sock, err = ngx.req.socket()
	sock:settimeout(2000)  --单位是毫秒ms

	if err then 
		Print("fail to catch req , reason is:" , err)
		return
	else
		self.m_bConntected = true
	end

	local partial, data, lenmsg, cmd, len, buf, buf_str, msg_len, _

	self._sema = semaphore.new(0)

    local sendMsg = function()
	    while self do
	    	self._sema:wait(0.01)
		    if self and self._tcp_to_send_data[1] then
				Print("send data to client :%2X")
				_, err = sock:send(self._tcp_to_send_data[1])
				if err == "closed" then
					Print("sock closed while send")
					goto sendThreadclosed
				end
				table.remove(self._tcp_to_send_data, 1)
			end
		end
		::sendThreadclosed::
	end
	ngx.thread.spawn(sendMsg)

	while true do
        lenmsg, err = sock:receive(2)
        if lenmsg then

        	--获取协议数据长度
            buf = ByteArray.new()
            buf:writeBuf(lenmsg)
            len = readLen(buf)
            ----------------------
            --根据数据长度获取协议数据主体
            data, err = sock:receive(len)
			buf:writeBuf(data)
			buf:setPos(1)
			ngx.thread.spawn(function()
				receiveHandler:ProcessPacket(buf, self)
			end)
			
		elseif err == "closed" then
			Print("socket close while reading!!!")
			self:OnClose()
			goto sockclosed
        end
	end

	::sockclosed::
	self = nil
end

function CliSocketHandle:SetUser(user)
	self.pUser = user
end

function CliSocketHandle:GetUser()
	return self.pUser
end

function CliSocketHandle:GetAddr()
	return self.m_Addr
end

function CliSocketHandle:GetPort()
	return self.m_nPort
end

function CliSocketHandle:Send(packet)
	table.insert(self._tcp_to_send_data, packet:getPack())
	self._sema:post(1)
end

function CliSocketHandle:Receive()
end

function CliSocketHandle:OnConnected()
    self.m_bConntected = true
end

function CliSocketHandle:OnClose()
	Print(self.m_Name, "   socket has been closed!!!")
	self.m_bConntected = false
end

function CliSocketHandle:IsConnected()
	return self.m_bConntected
end

return CliSocketHandle