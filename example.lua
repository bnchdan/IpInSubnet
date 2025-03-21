--add the patk to the package.path
package.path = "../lib/?.lua;"..package.path
-- or append the full path to the package.path where the lib is saved
-- package.path = package.path .. ";/usr/local/share/lua/IPInSubnet/lib/?.lua"

IPInSubnet = require("IPInSubnet")
mIPInSubnet = IPInSubnet:new()


mIPInSubnet:addSubnet("192.168.1.0/24")

print("192.168.1.1 : ",mIPInSubnet:isInSubnets("192.168.1.1"))