local ProtocolProcess = {}
local ProtocolManager  = require("Protocol.ProtocolManager")


function ProtocolProcess:DelarProtocol(msg_id , buf , server)
	for key , protocol_file in ipairs(ProtocolManager:GetProtocolObj()) do 
		if protocol_file.msg_id == msg_id and protocol_file.ctor then 
			protocol_file:RecvProtocolData(buf)
			BaseControl:FireFunc(msg_id , protocol_file , server)
			break
		end
	end	
end

return ProtocolProcess

