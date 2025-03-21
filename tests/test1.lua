-- Unit testing starts - for Lu5.2
--[[
library required 
    lua-bitop - for bitwise operations
        apt install lua-bitop, or from lua-jit on Nginx

    luaunit - for unit testing
        apt install lua-unit

--]]


package.path = "/usr/share/lua/5.1/?.lua;"..package.path


local lu = require('luaunit')

--define ngx.say
ngx = {}
function ngx.say(msg1, msg2)
    local msg=""
    if msg2 then
        msg = msg1..msg2
    else
        msg = msg1
    end
    print(msg)
end

--import the module
function getIPInSubnet()
    -- os.execute("sleep 0.2")

    package.path = "../lib/?.lua;"..package.path
    IPInSubnet = require("IPInSubnet")
    mIPInSubnet = IPInSubnet:new()
    return mIPInSubnet
end

--test cases
function testSubnetFormat()
    mIPInSubnet = getIPInSubnet()
    lu.assertEquals( mIPInSubnet:addSubnet("127.0.0.0/8"), true)
    lu.assertEquals( mIPInSubnet:addSubnet("127.0.0.0/64"), false)
    lu.assertEquals( mIPInSubnet:addSubnet("127.0.0.0/a"), false)
    lu.assertEquals( mIPInSubnet:addSubnet("300.330.0.0/8"), false)
    lu.assertEquals( mIPInSubnet:addSubnet("192.168.0.0"), false)
    lu.assertEquals( mIPInSubnet:addSubnet("127.0.0/8"), false)

    lu.assertEquals( mIPInSubnet:addSubnet("3001:0db2::/24"), true)
    lu.assertEquals( mIPInSubnet:addSubnet("3001:0db2::"), false)
    lu.assertEquals( mIPInSubnet:addSubnet("gggg:0db2::/24"), false)

    lu.assertEquals( mIPInSubnet:addSubnet("ip"), false)
end


function testIsInSubnet()
    mIPInSubnet = getIPInSubnet()
    
    lu.assertEquals( mIPInSubnet:isInSubnets("192.168.2.0"), false)
    lu.assertEquals( mIPInSubnet:isInSubnets("2001:0db8::1"), false)

    lu.assertEquals( mIPInSubnet:addSubnet("192.168.1.0/24"), true)
    lu.assertEquals( mIPInSubnet:addSubnet("2001:0db3::/64"), true)

    lu.assertEquals( mIPInSubnet:isInSubnets("192.168.2.0"), false)
    lu.assertEquals( mIPInSubnet:isInSubnets("2001:0db8::1"), false)

    lu.assertEquals( mIPInSubnet:addSubnet("192.168.2.0/24"), true)
    lu.assertEquals( mIPInSubnet:isInSubnets("192.168.2.0"), true)
    lu.assertEquals( mIPInSubnet:isInSubnets("192.168.2.2"), true)

    lu.assertEquals( mIPInSubnet:addSubnet("192.150.2.0/23"), true)
    lu.assertEquals( mIPInSubnet:isInSubnets("192.150.3.254"), true)
    lu.assertEquals( mIPInSubnet:isInSubnets("192.150.2.0"), true)
    lu.assertEquals( mIPInSubnet:isInSubnets("192.150.1.0"), false)

    lu.assertEquals( mIPInSubnet:addSubnet("2001:0db8::/64"), true)
    lu.assertEquals( mIPInSubnet:isInSubnets("2001:0db8::1"), true)
    lu.assertEquals( mIPInSubnet:isInSubnets("2001:0db9::1"), false)
    lu.assertEquals( mIPInSubnet:isInSubnets("2001:0db7::1"), false)
 
    lu.assertEquals( mIPInSubnet:addSubnet("3001:0db2::/31"), true)
    lu.assertEquals( mIPInSubnet:isInSubnets("3001:0db1::"), false)

    lu.assertEquals( mIPInSubnet:isInSubnets("3001:0db2::"), true)
    lu.assertEquals( mIPInSubnet:isInSubnets("3001:0db3::"), true)
    lu.assertEquals( mIPInSubnet:isInSubnets("3001:0db5::"), false)
    lu.assertEquals( mIPInSubnet:isInSubnets("4001:0db5::"), false)
    lu.assertEquals( mIPInSubnet:isInSubnets("4001:b5::"), false)
    
end


function testIPv4()
    mIPInSubnet = getIPInSubnet()
    mIPInSubnet.treeIPv4.insertIPv4("192.168.1.0", mIPInSubnet.treeIPv4.root, 24)
    lu.assertEquals( mIPInSubnet.treeIPv4.searchIPv4("192.168.2.0", mIPInSubnet.treeIPv4.root), false)
    mIPInSubnet.treeIPv4.insertIPv4("192.168.2.0", mIPInSubnet.treeIPv4.root, 24)
    lu.assertEquals( mIPInSubnet.treeIPv4.searchIPv4("192.168.2.0", mIPInSubnet.treeIPv4.root), true)
    mIPInSubnet.treeIPv4.insertIPv4("192.150.2.0", mIPInSubnet.treeIPv4.root, 23)
    lu.assertEquals( mIPInSubnet.treeIPv4.searchIPv4("192.150.3.254", mIPInSubnet.treeIPv4.root), true)
    lu.assertEquals( mIPInSubnet.treeIPv4.searchIPv4("192.150.2.0", mIPInSubnet.treeIPv4.root), true)
    lu.assertEquals( mIPInSubnet.treeIPv4.searchIPv4("192.150.1.0", mIPInSubnet.treeIPv4.root), false)
    
   
end

function testIPv6()
    
    mIPInSubnet = getIPInSubnet()
    mIPInSubnet.treeIPv6.insertIPv6("2001:0db8::", mIPInSubnet.treeIPv6.root, 64)
    lu.assertEquals( mIPInSubnet.treeIPv6.searchIPv6("2001:0db8::1", mIPInSubnet.treeIPv6.root), true)
    lu.assertEquals( mIPInSubnet.treeIPv6.searchIPv6("2001:0db9::1", mIPInSubnet.treeIPv6.root), false)
    lu.assertEquals( mIPInSubnet.treeIPv6.searchIPv6("2001:0db7::1", mIPInSubnet.treeIPv6.root), false)

    -- .0010:
    mIPInSubnet.treeIPv6.insertIPv6("3001:0db2::", mIPInSubnet.treeIPv6.root, 31)
    -- .0001: -false
    lu.assertEquals( mIPInSubnet.treeIPv6.searchIPv6("3001:0db1::", mIPInSubnet.treeIPv6.root), false)
    -- .0010: -true
    lu.assertEquals( mIPInSubnet.treeIPv6.searchIPv6("3001:0db2::", mIPInSubnet.treeIPv6.root), true)
    -- .0011: -true
    lu.assertEquals( mIPInSubnet.treeIPv6.searchIPv6("3001:0db3::", mIPInSubnet.treeIPv6.root), true)

    lu.assertEquals( mIPInSubnet.treeIPv6.searchIPv6("3001:0db5::", mIPInSubnet.treeIPv6.root), false)

    lu.assertEquals( mIPInSubnet.treeIPv6.searchIPv6("4001:0db5::", mIPInSubnet.treeIPv6.root), false)
end



function testDecompressedIPv6()
    mIPInSubnet = getIPInSubnet()
    lu.assertEquals(
        mIPInSubnet.treeIPv6.decompressedIPv6("21:db8::1"), 
        "0021:0db8:0000:0000:0000:0000:0000:0001"
    )
    lu.assertEquals(
        mIPInSubnet.treeIPv6.decompressedIPv6("21:db8::800:0:0:12"), 
        "0021:0db8:0000:0000:0800:0000:0000:0012"
    )
    lu.assertEquals(
        mIPInSubnet.treeIPv6.decompressedIPv6("21:0db8::0000:0800:0000:0000:0001"), 
        "0021:0db8:0000:0000:0800:0000:0000:0001"
    )

    lu.assertEquals(
        mIPInSubnet.treeIPv6.decompressedIPv6("1234:5678:9abc:def0:1234:5678:9abc:def0"),
        "1234:5678:9abc:def0:1234:5678:9abc:def0"
    )

    lu.assertEquals(
        mIPInSubnet.treeIPv6.decompressedIPv6("::1"),
        "0000:0000:0000:0000:0000:0000:0000:0001"
    )

    lu.assertEquals(
        mIPInSubnet.treeIPv6.decompressedIPv6("::"),
        "0000:0000:0000:0000:0000:0000:0000:0000"
    )

    lu.assertEquals(
        mIPInSubnet.treeIPv6.decompressedIPv6("0:0:0:0:0:0:0:1"),
        "0000:0000:0000:0000:0000:0000:0000:0001"
    )

    lu.assertEquals(
        mIPInSubnet.treeIPv6.decompressedIPv6("1::"),
        "0001:0000:0000:0000:0000:0000:0000:0000"
    )

    lu.assertEquals(
        mIPInSubnet.treeIPv6.decompressedIPv6("0:2:1::"),
        "0000:0002:0001:0000:0000:0000:0000:0000"
    )

    lu.assertEquals(
        mIPInSubnet.treeIPv6.decompressedIPv6("0:2:1::23"),
        "0000:0002:0001:0000:0000:0000:0000:0023"
    )

    lu.assertEquals(
        mIPInSubnet.treeIPv6.decompressedIPv6("2001:db8::ff00:42:8329"),
        "2001:0db8:0000:0000:0000:ff00:0042:8329"
    )

    lu.assertEquals(
        mIPInSubnet.treeIPv6.decompressedIPv6("fe80::1"),
        "fe80:0000:0000:0000:0000:0000:0000:0001"
    )

    lu.assertEquals(
        mIPInSubnet.treeIPv6.decompressedIPv6("fe80::"),
        "fe80:0000:0000:0000:0000:0000:0000:0000"
    )

    lu.assertEquals(
        mIPInSubnet.treeIPv6.decompressedIPv6("0000:0002:0001:0000:0000:0000:0000:0023"),
        "0000:0002:0001:0000:0000:0000:0000:0023"
    )

    lu.assertEquals(
        mIPInSubnet.treeIPv6.decompressedIPv6("1:2::3:4:5:6"),
        "0001:0002:0000:0000:0003:0004:0005:0006"
    )

    lu.assertEquals(
        mIPInSubnet.treeIPv6.decompressedIPv6("1:2:3:4:5:6::"),
        "0001:0002:0003:0004:0005:0006:0000:0000"
    )

    lu.assertEquals(
        mIPInSubnet.treeIPv6.decompressedIPv6("ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff"),
        "ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff"
    )

end



os.exit(lu.LuaUnit.run())


