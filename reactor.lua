local reactor = peripheral.find("BigReactors-Reactor") or error("No reactor attached", 0)
local modem = peripheral.find("modem") or error("No Modem Attached", 0)
local lastFE = 0
rs.setAnalogOutput("right", 0)
rs.setAnalogOutput("left", 0)

while true do
    local left = rs.getAnalogInput("left")
    --print(left)
    if left > 13 and reactor.getActive() == true
    then
        print("Reactor Off")
        rs.setAnalogOutput("right", 0)
    elseif (left < 5) and reactor.getActive() == false
    then
        print("Reactor On")
        rs.setAnalogOutput("right", 15)
    end
    if reactor.getActive() == true 
    then
        lastFE = math.floor(reactor.getEnergyProducedLastTick())
        modem.transmit(1, 43, "Total Production,".. lastFE)
    else
        modem.transmit(1, 43, "Total Production,".. lastFE)
    end
    sleep(1)
    --os.pullEvent("redstone")
end
