# IPInSubnet - Fast Binary Tree-Based IP Subnet Matching

## Overview
**IPInSubnet** is a Lua library for efficient IPv4 and IPv6 subnet searches using a binary tree. It is designed for scenarios involving a large number of subnets, enabling quick lookups to determine whether an IP address belongs to a specific subnet.

### Features
- Supports both **IPv4** and **IPv6** addresses.
- Efficient binary tree implementation for quick lookups.
- Handles **CIDR notation** for subnet masks.
- Ideal for **firewalls, access control, and Nginx/OpenResty** use cases.


---
## Usage Example
Below is a complete example in Nginx 

### nginx.conf
```nginx
init_by_lua_file "/{YOUR_PATH}/init.lua";
server {
    ...
    access_by_lua_file "/{YOUR_PATH}/access.lua";
}
```

### init.lua
```lua
-- Load module dynamically
local info = debug.getinfo(1, "S")  
local path = info.source:sub(2):match("(.*/)")  
package.path = path.."../lib/?.lua;" .. package.path

-- Require the module
IPInSubnet = require("IPInSubnet")

-- Create subnet lists
blockedIPs = IPInSubnet:new()
allowedIPs = IPInSubnet:new()

-- Define allowed and blocked subnets
allowedIPs:addSubnet("192.168.1.0/24")
blockedIPs:addSubnet("192.168.2.0/24")
blockedIPs:addSubnet("11:0db8::/32")
```

### access.lua
```lua
ngx.header.content_type = "text/plain"

ngx.say("IP: ", ngx.var.remote_addr)
ngx.say("Is allowed: ", allowedIPs:isInSubnets(ngx.var.remote_addr))
ngx.say("Is blocked: ", blockedIPs:isInSubnets(ngx.var.remote_addr))
```

### response
```ip 192.168.3.1
is allowed : false
is blocked : false
```

---

- Fast and scalable – Optimized for handling large subnet lists.
- Easy integration – Works with **Nginx, OpenResty, and pure Lua applications**.



