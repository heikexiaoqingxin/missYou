Protocol = {

	RECV_SERVER_HEART = 0x1001 , --服务器心跳
	RECV_SERVER_LOGIN = 0x1002 , --账号密码登录
	RECV_SERVER_ACCOUNT = 0x1003 , --创建昵称
	RECV_SERVER_INFO = 0x1004,	 --请求玩家所有信息
	RECV_SERVER_CHAT = 0x1005,	 --聊天
	RECV_SERVER_CREATE = 0x1006, --注册账号
	RECV_SERVER_ROOM = 0x1007,	 --创建房间
	RECV_SERVER_ROOMLIST = 0x1008,--房间列表信息

	-- RECV_SERVER_SEATID = 0x1002 , --服务器座位ID
	-- RECV_SERVER_STOPCARD = 0x1010,--停止出牌
	-- RECV_SERVER_SENDCARD = 0x1003,--收到用户手牌
	-- RECV_SERVER_LOADCARD = 0x1004,--收到地主手牌
	-- RECV_SERVER_PLAYCARD = 0x1005,--开始打牌
	-- RECV_SERVER_SHOWCARD = 0x1006,--显示玩家打出去的牌
	-- RECV_SERVER_STOPTIME = 0x1007,--打牌停止时间
	-- RECV_SERVER_STOPSTATUS = 0x1009 , --收到停止状态

	SEND_CLIENT_HEART = 0x1001 , --用户心跳 
	SEND_CLIENT_LOGIN = 0x1002 , --账号密码登录
	SEND_CLIENT_ACCOUNT = 0x1003 ,--创建昵称
	SEND_CLIENT_INFO = 0x1004,   --请求玩家所有信息
	-- SEND_CLIENT_SENDCARD = 0x1003, --发送玩家手牌
	-- SEND_CLIENT_SENDSTOP = 0x1004, --玩家此局结束的时间
	-- SEND_CLIENT_PASS = 0x1005 , --玩家不出牌
	
}


return Protocol