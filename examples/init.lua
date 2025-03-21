--load module
info = debug.getinfo(1, "S")  
path = info.source:sub(2):match("(.*/)")  
package.path = path.."../lib/?.lua;" ..package.path
-- or append to package.path where the lib is saved
-- package.path = package.path .. ";/usr/local/share/lua/IPInSubnet/lib/?.lua"



IPInSubnet = require("IPInSubnet")
blockedIPs = IPInSubnet:new()
allowedIPs = IPInSubnet:new()


allowedIPs:addSubnet("192.168.1.0/24")


blockedIPs:addSubnet("192.168.2.0/24")
blockedIPs:addSubnet("11:0db8::/32")


