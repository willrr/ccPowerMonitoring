local modem = peripheral.find("modem") or error("No modem attached", 0)
local monitor = peripheral.find("monitor") or error("No monitor attached", 0)
local event, side, channel, replyChannel, message, distance, prodFEnum, usedFEnum
local tableList = {}
--local channelsArray = {}

for x=1,20 do
    modem.open(x)
end

local width, height = monitor.getSize()

monitor.clear()
monitor.setCursorBlink(false)
monitor.setTextScale(1)
monitor.setCursorPos(1, 1)
monitor.setTextColour(1)

function updateScreen()
    local totalFE = 0
    for i,line in ipairs(tableList) do
        local name = string.sub(line, 0, string.find(line, ",")-1)
        local rf = tonumber(string.sub(line, string.find(line, ",")+1, string.len(line)))
        if i > 2 then
            totalFE = totalFE + rf
        end
        monitor.setCursorPos(1, i)
        monitor.clearLine()
        if prodFEnum ~= nil and prodFEnum ~=0 and i ~= 1 
        then
            local percentageUsed = math.floor(rf / prodFEnum * 100)
            monitor.write(name .. " Usage: " .. rf .. "FE/t = " .. percentageUsed .. "%")
        elseif i == 1
        then
            monitor.write(name .. ": " .. rf .. "FE/t")
        else
            --print(prodFEnum)
            monitor.write(name .. " Usage: " .. rf .. "FE/t")
        end
    end
    if prodFEnum ~= nil and usedFEnum ~= nil and prodFEnum ~= 0 
    then
        monitor.setCursorPos(1, height)
        monitor.clearLine()
        percentageUsed = math.floor((usedFEnum - totalFE) / prodFEnum * 100)
        monitor.write("Unaccounted Usage: ".. math.floor(usedFEnum - totalFE).. "FE/t = " .. percentageUsed.. "%"  )
    end
end

function updatePercentage()
    if prodFEnum ~= nil and usedFEnum ~= nil and prodFEnum ~= 0
    then
        local calcMessage = "Percentage usage: ".. math.floor(usedFEnum / prodFEnum * 100).. "%"
        monitor.setCursorPos(1, height)
        monitor.clearLine()
        monitor.write(calcMessage)
    end
end

function updateTable(channel, message)
    tableList[channel] = tostring(message)
    --for x=0,table.getn(channelsArray) do
    --    if channelsArray[x] ~= channel and x == table.getn(channelsArray)
    --    then
    --        channelsArray[x+1] = channel
    --    end
    --end
    updateScreen()
end

while true do
    event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    if channel < 11
    then
        updateTable(channel, message)
    end
    if channel == 1 
    then
        prodFEnum = tonumber(string.sub(tostring(message), string.find(tostring(message), ",")+1, string.len(tostring(message))))
        updateTable(channel, message)
    elseif channel == 2
    then
        usedFEnum = tonumber(string.sub(tostring(message), string.find(tostring(message), ",")+1, string.len(tostring(message))))
        updateTable(channel, message)
    end

end

