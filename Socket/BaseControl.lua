BaseControl = {}
local ProtocolManager  = require("Protocol.ProtocolManager")

function BaseControl:__init()
	self.protocol_func = {}
end

function BaseControl:SetServer(sever)
	self.server = sever
end

function BaseControl:ProtoclParse(msg_id , event_func)
	self.protocol_func[msg_id] = Bind2(event_func , self)
end

function BaseControl:FireFunc(msg_id , buf , server)
	if self.protocol_func[msg_id] then 
		self.protocol_func[msg_id](buf , server)
	end
end

function BaseControl:Send(msg_id , protocol, is_broad)
	for key , protocol_file in ipairs(ProtocolManager:GetProtocolObj()) do 
		if protocol_file.msg_id == msg_id and protocol_file.ctor then 
			local buf = ByteArray.new()
			buf:writeShort(msg_id)
			protocol_file:SendProtocolData(protocol , buf , self.server)
			buf:End()
			if is_broad then 
				local player_list = PlayList
				for k , player in pairs(player_list:GetPlayList()) do 
					player.server:Send(buf)
				end
				break
			else
				self.server:Send(buf)
				break
			end
		end
	end 
end

BaseControl:__init()
return BaseControl