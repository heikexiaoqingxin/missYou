local CRedisManagerClient = {}
local redis = require("resty.redis")

function CRedisManagerClient:Init()

	self.m_RedisConfMap = {
		[0] = {m_redisId = 0, m_strip="127.0.0.1", m_port = 4501},
		[1] = {m_redisId = 1, m_strip="127.0.0.1", m_port = 4502},
		[2] = {m_redisId = 2, m_strip="127.0.0.1", m_port = 4503},
	}

	return self
end

function CRedisManagerClient:InitConnect()
	for redisId, redisConfig in pairs(self.m_RedisConfMap) do
		local m_RedisClient = redis.new()
		local ok, err = m_RedisClient:connect(redisConfig.m_strip, redisConfig.m_port)
		if ok then
			m_RedisClient:set_timeout(1000)
			if redisId == 0 then
				local ret = m_RedisClient:del("USER_GAME_STATUS")
				Print("remove USER_GAME_STATUS ret = ", ret)
			end
			Print("redis:" .. redisId .. " connect success!!")
			m_RedisClient:setkeepalive(0)
		end	
	end 
	return 0
end

function CRedisManagerClient:writeGameResult(resultStr)	
	local redisConfig = self.m_RedisConfMap[2] --4503
	local m_RedisClient = redis.new()
	local ok, err = m_RedisClient:connect(redisConfig.m_strip, redisConfig.m_port)
	if ok then
		m_RedisClient:connect(redisConfig.m_strip, redisConfig.m_port)
		return m_RedisClient:lpush("GAME_RESULT_QUEUE", resultStr)
	else
		Print("writeGameResult: ", err)
		return -1
	end
end 

function CRedisManagerClient:writeGameDrawWater(resultStr)	
	local redisConfig = self.m_RedisConfMap[2] --4503
	local m_RedisClient = redis.new()
	local ok, err = m_RedisClient:connect(redisConfig.m_strip, redisConfig.m_port)
	if ok then
		m_RedisClient:connect(redisConfig.m_strip, redisConfig.m_port)
		return m_RedisClient:rpush("JIFEN_PROFIT", resultStr)
	else
		Print("writeGameResult: ", err)
		return -1
	end
end 



function CRedisManagerClient:writeGameAA(uid, activity)	
	local redisConfig = self.m_RedisConfMap[2] --4503
	local m_RedisClient = redis.new()
	local ok, err = m_RedisClient:connect(redisConfig.m_strip, redisConfig.m_port)
	if ok then
		m_RedisClient:connect(redisConfig.m_strip, redisConfig.m_port)
		return m_RedisClient:hset("USER_GAME_AA_" .. activity, tostring(uid), tostring(uid))
	else
		Print("writeGameResult: ", err)
		return -1
	end
end 

function CRedisManagerClient:writeGameVerification(resultStr)	
	local redisConfig = self.m_RedisConfMap[2] --4503
	local m_RedisClient = redis.new()
	local ok, err = m_RedisClient:connect(redisConfig.m_strip, redisConfig.m_port)
	if ok then
		m_RedisClient:connect(redisConfig.m_strip, redisConfig.m_port)
		Print("writeGameVerification success !!")
		return m_RedisClient:hset("GAME_SERVER_VERIFICATION", tostring(level), tostring(level))
	else
		Print("writeGameResult: ", err)
		return -1
	end
end 

return CRedisManagerClient