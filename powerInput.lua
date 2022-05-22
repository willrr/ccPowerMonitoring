local detector = peripheral.find("energyDetector") or error("No detector attached", 0)
local modem = peripheral.find("modem") or error("No Modem Attached", 0)
local highestFE = 0
rs.setAnalogOutput("right", 0)
rs.setAnalogOutput("left", 0)

while true do
    if detector.getTransferRate() > highestFE 
    then
        highestFE = detector.getTransferRate()
        modem.transmit(2, 43, "Total,".. detector.getTransferRate()) 
    end
    sleep(1)
    --os.pullEvent("redstone")
end
