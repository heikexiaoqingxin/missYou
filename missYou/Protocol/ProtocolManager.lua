local ProtocolManager = {}
local protocol_cls = {}
local protocol_file = {}

function ProtocolManager:LoadProtocolObj( obj )
	return table.insert(protocol_cls , obj)
end

function ProtocolManager:InitProtocol( ... )
	for _, protocol in ipairs(protocol_cls) do
		table.insert(protocol_file, protocol.new())
	end
end

function ProtocolManager:GetProtocolObj( ... )
	return protocol_file
end

return ProtocolManager

