package.path = "../lib/?.lua;"..package.path
IPInSubnet = require("IPInSubnet")
mIPInSubnet = IPInSubnet:new()


mIPInSubnet:addSubnet("192.168.1.0/24")

print("192.168.1.1 : ",mIPInSubnet:isInSubnets("192.168.1.1"))