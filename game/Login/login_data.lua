local LoginData = class("LoginData")
function LoginData:SetProtocolData(protocol)
	self.username = protocol.username
	self.password = protocol.password
end

function LoginData:SetInfoData( protocol )
	-- body
	self.user_name = protocol.user_name
	self.pass_word = protocol.pass_word
end

function LoginData:GetInfoData()
	local login_tab = {"Name"}
	local param = {{Account = self.user_name} , {PassWord = self.pass_word}}
	return  GameServer.db_obj:GetAccount(login_tab , "User" , param)
end

function LoginData:GetDbLoginData()
	local login_tab = {"Account" , "PassWord" , "Name"}
	return  GameServer.db_obj:GetAccount(login_tab , "User")
end

function LoginData:GetLoginState(login_data)
	for key , login_value in pairs(login_data) do 
		if login_value["Account"] == self.username and login_value["PassWord"] == self.password and ngx.null == login_value["Name"] then 
			return 2
		elseif login_value["Account"] == self.username and login_value["PassWord"] == self.password then 
			return 3
		end
	end
end

function LoginData:SetAccountData( protocol )
	self.account_name = protocol.account_name
	self.register_name = protocol.register_name
	self.register_word = protocol.register_word
end

function LoginData:GetAccountData( ... )
	return self.account_name , self.register_name , self.register_word
end

function LoginData:CreateName()
	local account_name , register_name , register_word = self:GetAccountData()
	local name_tab = {Name = account_name}
	local limit_tab = {Account = register_name , PassWord = register_word}
	return GameServer.db_obj:InsertData(name_tab , "User" , limit_tab)
end


function LoginData:SetIpData(pSocket)
	local player_list = PlayList
	local player = player_list:GetPlayer(pSocket.m_Id)
	local ip_tab = {ip =  ngx.var.remote_addr , address = player:GetAddress()}
	local limit_tab = {Account = self.username , PassWord = self.password}
	return GameServer.db_obj:InsertData(ip_tab , "User" , limit_tab)
end

function LoginData:SetCreateData(protocol)
	self.name_number = protocol.username
	self.pass_number = protocol.password
end

function LoginData:GetCreateData( ... )
	return self.name_number, self.pass_number
end

function LoginData:GetUserData()
	return self.username , self.password
end

return LoginData