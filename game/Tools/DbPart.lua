local CDbPart = {}
local mysql = require "resty.mysql"

function CDbPart:Init()
	return self
end

function CDbPart:InitConnect()
	self.config = {}
	local config = self:ParaseConfig()
	local json_data = json.decode(config)
	for k , v in pairs(json_data) do 
		if "DataBase" == k then 
			for key , value in pairs(v) do 
				self.config[key] = value
			end
		end
	end
	self.config.charset = "utf8"
	self.config.max_packet_size = 1024 * 1024	


	local conn, err = mysql.new()
	self.m_pMysqlConn = conn
	Print("get mysql connect!!")
	local ok, err, errcode, sqlstate = self.m_pMysqlConn:connect(self.config)
	self.m_pMysqlConn:set_timeout(1000)  
	self.m_pMysqlConn:set_keepalive(60)
	if not ok then
		Print("mysql connect fail!!")
		return false
	end

	Print("mysql connect success!!")
	return true
end

function CDbPart:ParaseConfig()
	local file = io.open("config.json" , "r")
	local json = file:read("*a")
	file:close()
	return json
end

local ParseSql = function(column_param , table_name , param)
	local sql_word = "select"
	local column_word = ""
	for i = 1 , #column_param do 	
		if i == #column_param then 
			column_word = column_word .. column_param[i]
			break
		end
		column_word = column_word .. column_param[i] .. " , "
	end
	sql_word = sql_word .. " " .. column_word .. " from " .. table_name
	if not param then return sql_word end
	sql_word = sql_word .. " " .. "where" .. " "
	local param_word = ""
	for k , v in ipairs(param) do 
		for key , value in pairs(v) do
			if k == #param then 
				param_word = param_word .. key .. "=" .. "'" .. value .. "'"
 				break
			end
			param_word = param_word .. key .. "=" .. "'" .. value .. "'" .. "  and  "
		end
	end
	sql_word = sql_word .. param_word
	return sql_word
end

local UpdateSql = function(column_param , table_name , param)
	local sql_word = "update " .. table_name .. " set "
	local column_word = ""
	local num = 1
	for key , value in pairs(column_param) do
		if num == table.nums(column_param) then 
			column_word = column_word .. key .. "=" .. "'" .. value .. "'"
			break
		end
		column_word = column_word .. " " .. key .. "=" .. "'" .. value .. "'" .. " , "
		num = num + 1
	end

	sql_word = sql_word .. column_word .. " where "
	local param_word = ""
	local param_num = 1
	for key , value in pairs(param) do 
		if param_num == table.nums(param) then 
			param_word = param_word .. key .. "=" .. "'" .. value .. "'"
			break
		end
		param_word = param_word .. key .. "=" .. "'" .. value .. "'" .. " and "
		param_num = param_num + 1
	end
	sql_word = sql_word .. param_word
	return sql_word
end

function CDbPart:GetAccount(column_param , table_name , param)
	self.m_pMysqlConn = mysql.new()
	local sql = ParseSql(column_param , table_name , param)
	local ok, err, errcode, sqlstate = self.m_pMysqlConn:connect(self.config)
	local res, ok = self.m_pMysqlConn:query(sql)
	return res
end

function CDbPart:InsertData(column_param , table_name , param)
	self.m_pMysqlConn = mysql.new()
	local sql = UpdateSql(column_param , table_name , param)
	local ok, err, errcode, sqlstate = self.m_pMysqlConn:connect(self.config)
	local res, ok = self.m_pMysqlConn:query(sql)
	return res
end

function CDbPart:InsertToData( table_name, key1, key2, value1, value2 )
	-- body
	self.m_pMysqlConn = mysql.new()
	local ok, err, errcode, sqlstate = self.m_pMysqlConn:connect(self.config)
	local sql = "insert into " .. table_name .. "(" .. key1 .. " , " .. key2 .. ")" .. "values" .. "(" .. value1 .. " , " .. value2 .. ")"  
	local res, ok = self.m_pMysqlConn:query(sql)
	return res
end

return CDbPart