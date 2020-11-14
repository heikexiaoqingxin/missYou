local LoginView = class("LoginView")
function LoginView:ctor(ctrl , data)
	-- body
	self.data = data
	self.ctrl = ctrl
end

function LoginView:Open(pSocket)
	local login_data = self.data:GetDbLoginData()
	if not login_data then 
		self:LoginSucess(1)
	end
	local suceess = self.data:GetLoginState(login_data)
	if 3 == suceess then 
		self:LoginSucess(3)
		self.data:SetIpData(pSocket)
		return 
	elseif 2 == suceess then 
		self:LoginSucess(2)
		return 
	end
	self:LoginSucess(1)
end

function LoginView:LoginSucess(status)
	local name , word = "" , ""
	if 2 == status or 3 == status then 
		name , word = self.data:GetUserData()
	end
	local data = {username = name , password = word , errcode = status}
	self.ctrl:SendProtocol(data)
end

function LoginView:CreateAccount()
	local tip_code = type(self.data:CreateName()) == "table" and 1 or 2
	local account_name , register_name , register_word = self.data:GetAccountData()
	self.ctrl:SendNameProtocol({errcode = tip_code, user_name = register_name, pass_word = register_word})
end

function LoginView:CreateLoginInfo( pSocket )
	local info_data = type(self.data:GetInfoData()) == "table" and self.data:GetInfoData() or {}
	local protocol = {}
	for player , info in pairs(info_data) do 
		protocol.Name = info.Name
	end
	local player_list = PlayList
	local player = player_list:GetPlayer(pSocket.m_Id)
	player:SetName(protocol.Name)
	protocol.city = player:GetAddress()
	local room_list = player_list:GetRoomList()
	protocol.num = #room_list
	protocol.room_list = room_list
	self.ctrl:SendInfoProtocol(protocol)
end

function LoginView:CreateNumber(  )
	local name_number, pass_number = self.data:GetCreateData()
	GameServer.db_obj:InsertToData("User", "Account", "PassWord", name_number, pass_number)
	local protocol = {errcode = 1}
	self.ctrl:SendCreateProtocol(protocol)
end



return LoginView