--队列
local Quene = {}

--创建
function Quene.new()
    local list = {first = 0,last = -1}
    return list
end

--队列头插入
function Quene.pushFront(list, value)
    local firstindex = list["first"] - 1
    list["first"] = firstindex
    list[firstindex] = value
end

--队列尾插入
function Quene.pushBack(list, value)
    local lastindex = list["first"] + 1
    list["last"] = lastindex
    list[lastindex] = value
end

function Quene.popFront(list)
    local firstindex = list["first"]
    if firstindex > list["last"] then
        Print("Quene is empty")
        return nil
    end

    local value = list[firstindex]
    list[firstindex] = nil
    list["first"] = firstindex + 1
    return value
end

function Quene.popBack(list)
    local lastindex = list["last"]
    if list["first"] > lastindex then
        error("Quene is empty")
    end
    local value = list[lastindex]
    list[lastindex] = nil
    list["last"] = lastindex - 1 
    return value
end

--测试代码
local function testQuene()
    local testquene = Quene.new()
    Quene.pushFront(testquene,12)
    Print( testquene:popFront())
end

return {["Quene"] = Quene}


