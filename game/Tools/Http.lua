local http = require "resty.http"
local Http = class("Http")

function Http:getInstance( ...)
	if not self.instance then 
		self.instance = self.new()
	end
	return self.instance
end

function Http:QueryIp()
	local http_result = http.new()
	local resp, err = http_result:request_uri("http://ip.taobao.com", {  
		method = "GET",  
		path = "/service/getIpInfo.php?ip=" .. ngx.var.remote_addr,  
		headers = {  
		["User-Agent"] = "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.111 Safari/537.36"  
		}  
	})  
	local body = json.decode(resp.body)
	return body.data.region .. "省" .. body.data.city .. "市"
end

return Http