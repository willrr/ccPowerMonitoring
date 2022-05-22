local detector = peripheral.find("energyDetector") or error("No detector attached", 0)
local modem = peripheral.find("modem") or error("No Modem Attached", 0)

while true do
    modem.transmit(2, 43, "Total,".. detector.getTransferRate()) 
    sleep(1)
end
