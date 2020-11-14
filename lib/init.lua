--捕获脚本错误
__G__TRACKBACK__ = function(msg)
    local msg = debug.traceback(msg, 3)
    Print(msg)
    --这里可以做一些如发邮件通知之类的操作
    return msg
end

local prefix = "lib."
require(prefix .. "functions")
inspect = require(prefix .. "inspect")
json = require("cjson.safe")
local dataStructure = require(prefix .. "dataStructure")
Timer = require ("game.time.timer"):getInstance()
require (prefix .. "Overall")
_G.Quene = dataStructure["Quene"]
ByteArray = require("lib.ByteArray")

function string.split(str, reps)
    local resultStrList = {}
    string.gsub(str, '[^'..reps..']+', function(w)
        table.insert(resultStrList, w)
    end)
    return resultStrList
end
