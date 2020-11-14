local CProcessPacket = class("BaseCProcessPacket")
local Protocol = require("Protocol.Protocol")
local ProtocolProcess = require("Socket.ProtocolProcess")
local player = require "game.player.player"
local player_list = PlayList

function CProcessPacket:ProcessPacket(pPackage, pSocket)
	local msg_id = pPackage:readShort()

	Print (string.format("0x%04x .game_cmd" , msg_id))
	if not player_list:GetPlayer(pSocket.m_Id) then 
		Print ("pSocket.m_Id" , pSocket.m_Id)
		player_list:AddPlayer(pSocket.m_Id , player.new(pSocket))

	end
	BaseControl:SetServer(pSocket)
	ProtocolProcess:DelarProtocol(msg_id , pPackage , pSocket)

end

function CProcessPacket:ClientHeartBeat(pPackage , pSocket)
	self.heart_beat = self.heart_beat or HeartBeat.new(pPackage , pSocket , Protocol)
	self.heart_beat:SendHeartBeat()
end

function CProcessPacket:ClientAccountLogin(pPackage , pSocket)
	return GameServer:Login(pPackage , pSocket , "login")
end

function CProcessPacket:ClientCreateName(pPackage , pSocket)
	return GameServer:Login(pPackage , pSocket , "create_name")
end

function CProcessPacket:OnUserStartGame(pPackage, pSocket, dwSessionID)
    local pUser = pSocket:GetUser()
    local pTable = pUser:GetTable()
    pTable:StartGame()
end

function CProcessPacket:OnUserLogin(pPackage, pSocket, dwSessionID)

    local tid=pPackage:readInt() -- 18 , 21
    local uid=pPackage:readInt() --21 , 24
    local seatId=pPackage:readInt() -- 24 , 27
	local sex = pPackage:readByte()
    local nickname=pPackage:readStringUInt()
	local portrait=pPackage:readStringUInt()
	local latitude = pPackage:readStringUInt()
	local longitude = pPackage:readStringUInt()
	local otherInfo = pPackage:readStringUInt()
	local activityId = pPackage:readInt()
	local ip = pPackage:readStringUInt()

	Print (seatId , "----OnUserLogin----")

	local userInfo = {uid = uid, seatId = seatId, sex = sex, nickname = nickname, portrait = portrait, 
		latitude = latitude, longitude = longitude, otherInfo = otherInfo, ip = ip}

	Print("tid = ", tid)
	Print("userInfo = ", inspect(userInfo))
	Print("activityId = ", activityId)

    return CGameServer:ProcUserLogin(tid, userInfo, activityId, pSocket)
end

function CProcessPacket:OnUserLogout(pPackage, pSocket, dwSessionID)

    local pUser = pSocket:GetUser()
    if pUser == nil then
        return 0
    end

    local pTable = pUser:GetTable()
    if pTable and pUser.m_IsPlay and pTable:GetTableStatus() ~= CONST.GAME_STATUS_STOP then
        CGameServer:GetSendHandle():SendLogoutErrResponse(pSocket, LOGOUT_ERR_STATUS)
        return 0
    end
	-- VLogMsg(LM_DEBUG,"CProcessPacket:OnUserLogout:%d\n",pUser:m_nUserID)

	return CGameServer:ProcUserLogout(pUser)
end

function CProcessPacket:OnUserHeartBeat(pPackage, pSocket, dwSessionID)

	local pUser = pSocket:GetUser()
    if pUser == nil then
        return 0
    end
	pUser.m_heartBeatCount = pUser.m_heartBeatCount + 1
	-- Print ("pUser.Userid" , pUser:GetUserId())
	-- Print ("pUser.m_heartBeatCount" , pUser.m_heartBeatCount)
	return 0
end

function CProcessPacket:OnUserreadyOrCancel(pPackage, pSocket, dwSessionID)

	-- local typ = pPackage:readByte()
	local typ = 1
	Print("OnUserreadyOrCancel !! ", typ)

	CGameServer:ProcUserReadyOrCancel(typ, pSocket)

	return 0
end

function CProcessPacket:OnUserSit(pPackage, pSocket, dwSessionID)

	local pUser = pSocket:GetUser()
	local pTable = pUser:GetTable()

	local seatId = -1 --pPackage:readInt()

	seatId = pTable:getAvailableSeat(seatId)

	local ret = pTable:UserSit(seatId, pUser)
	if ret then
		CGameServer:GetSendHandle():SendUserOperationCode(pUser, ret)
	end
	Print("OnUserSit", ret, " ", pPackage:toString())

	return 0
end


--暂时处理桌子换座位逻辑
function CProcessPacket:OnUserReplaceSeat(pPackage, pSocket, dwSessionID)
	local pUser = pSocket:GetUser()
	local pTable = pUser:GetTable()
	local seat_id = pPackage:readInt()
	Print("OnUserReplaceSeat", " ", pPackage:toString())
	
	local ret = pTable:ReplaceSeat(pUser , seat_id)
	if ret then
		CGameServer:GetSendHandle():SendUserOperationCode(pUser, ret)
	end
	return 0
end


function CProcessPacket:OnUserStand(pPackage, pSocket, dwSessionID)

	local pUser = pSocket:GetUser()
    if pUser == nil then return 0 end
	local pTable = pUser:GetTable()
	if pTable == nil then return 0 end

	local ret = pTable:UserStand(pUser)

	if ret then
		CGameServer:GetSendHandle():SendUserOperationCode(pUser, ret)
	end

	return 0
end

function CProcessPacket:OnUserQuit(pPackage, pSocket, dwSessionID)

	local pUser = pSocket:GetUser()
    if pUser == nil then return 0 end

	local ret = CGameServer:UserQuit(pUser)

	if ret then
		CGameServer:GetSendHandle():SendUserOperationCode(pUser, ret)
	end
end

function CProcessPacket:OnUserMsg(pPackage, pSocket, dwSessionID)

	local pUser = pSocket:GetUser()
    if pUser == nil then return 0 end
	local pTable = pUser:GetTable()
	if pTable == nil then return 0 end

	local level = pPackage:readShort()

	if level ~= CGameServer.m_nLevel then
		return 0
	end

	local message = pPackage:readStringUInt()

	CGameServer:GetSendHandle():BroadcastMsg(pTable, message)

	return 0
end

function CProcessPacket:OnUserGiveCoins(pPackage, pSocket, dwSessionID)

	local pUser = pSocket:GetUser()
    if pUser == nil then return 0 end
	local pTable = pUser:GetTable()
	if pTable == nil then return 0 end

	local desUid = pPackage:readInt()
	local coins = pPackage:readInt()

	local ret = pTable:ProcUserGiveCoins(pUser, desUid, coins)

	if ret then
		CGameServer:GetSendHandle():SendUserOperationCode(pUser, ret)
	end

	return 0
end

function CProcessPacket:OnUserSendFace(pPackage, pSocket)

	local nType = pPackage:readInt()
	local pUser = pSocket:GetUser()
	if not pUser then
		return -1
	end
	local pTable = pUser:GetTable()
	if not pTable then 
		return -1
	end

	CGameServer:GetSendHandle():BroadcastClientSendFace(pUser:GetUserId() , nType , pTable)
end

return CProcessPacket

