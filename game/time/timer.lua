local Timer = class("Timer")
function Timer:getInstance( ... )
	-- body
	if not self.instance then 
		self.instance = self.new()
	end
	return self.instance
end

function Timer:ctor( ... )
	self.m_Timers = {}
end

function Timer:InitTimer()
	local timeCircle 
	timeCircle = function(premature, self)
		if premature then 
			return
		end	
		ngx.thread.spawn(handler(self , self.run))
		if self then
			ngx.timer.at(1, timeCircle, self)
		end
	end
	ngx.timer.at(1, timeCircle, self)
end

function Timer:BindTimer( event_name, func )
	-- body
	self.m_Timers[event_name] = func
end

function Timer:run( ... )
	-- body
	local now = ngx.time()
	for k , func in pairs(self.m_Timers) do 
		func(now)
	end
end

return Timer