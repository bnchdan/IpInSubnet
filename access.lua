
ngx.header.content_type = "text/plain"

ngx.say("ip : ", ngx.var.remote_addr)
ngx.say("is allowed : ",allowedIPs:isInSubnets(ngx.var.remote_addr))
ngx.say("is blocked : ",blockedIPs:isInSubnets(ngx.var.remote_addr))

ngx.say("Allowed IPs Tree IPv4")
allowedIPs.treeIPv4.printTree(allowedIPs.treeIPv4.root)


