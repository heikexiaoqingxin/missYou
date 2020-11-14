local HeartCtrl = class("HearCtrl" , BaseControl)
function HeartCtrl:ctor()
	self:ProtoclParse(Protocol.RECV_SERVER_HEART , HeartCtrl.SCLOGIDATA)
end

function HeartCtrl:SCLOGIDATA(protocol)
	-- self:SendProtocol()
end

function HeartCtrl:SendProtocol()
	-- local protocol = {time = tostring(ngx.time())}
	-- self:Send(Protocol.RECV_SERVER_HEART)
end

return HeartCtrl