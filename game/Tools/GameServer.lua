local GameServer = class("GameServer")

function GameServer:ctor(db_obj , redis_obj , http , timer)
	self.db_obj = db_obj
	self.redis_obj = redis_obj
	self.login = nil
	self.http = http
	self.timer = timer
end

function GameServer:InitConnect()
	self.db_obj:InitConnect()
	self.timer:InitTimer()
end



return GameServer