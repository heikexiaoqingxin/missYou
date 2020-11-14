local LoginCtrl = class("LoginCtrl" , BaseControl)
local LoginData = require("game.Login.login_data")
local LoginView = require("game.Login.login_view")
function LoginCtrl:ctor()
	self.data = LoginData.new()
	self.view = LoginView.new(self , self.data)
	self:ProtoclParse(Protocol.RECV_SERVER_LOGIN , LoginCtrl.SCLOGIDATA)
	self:ProtoclParse(Protocol.RECV_SERVER_ACCOUNT , LoginCtrl.SCACCOUNTDATA)
	self:ProtoclParse(Protocol.RECV_SERVER_INFO , LoginCtrl.SCINFODATA)
	self:ProtoclParse(Protocol.RECV_SERVER_CREATE , LoginCtrl.SCCREATEDATA)
end

function LoginCtrl:SCLOGIDATA(protocol, pSocket)
	self.data:SetProtocolData(protocol)
	self.view:Open(pSocket)
end

function LoginCtrl:SCACCOUNTDATA(protocol)
	self.data:SetAccountData(protocol)
	self.view:CreateAccount()
end

function LoginCtrl:SCINFODATA(protocol , pSocket)
	-- body
	self.data:SetInfoData(protocol)
	self.view:CreateLoginInfo(pSocket)
end

function LoginCtrl:SCCREATEDATA(protocol)
	-- body
	self.data:SetCreateData(protocol)
	self.view:CreateNumber()
end


function LoginCtrl:SendProtocol(protocol)
	self:Send(Protocol.RECV_SERVER_LOGIN , protocol)
end

function LoginCtrl:SendNameProtocol(protocol)
	self:Send(Protocol.RECV_SERVER_ACCOUNT , protocol)
end

function LoginCtrl:SendInfoProtocol(protocol)
	self:Send(Protocol.RECV_SERVER_INFO , protocol)
end

function LoginCtrl:SendCreateProtocol(protocol)
	self:Send(Protocol.RECV_SERVER_CREATE , protocol)
end

return LoginCtrl