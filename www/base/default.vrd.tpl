<?xml version="1.0" encoding="UTF-8"?>
<point xmlns="http://v8.1c.ru/8.2/virtual-resource-system"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                base="/base"
                ib="Srvr=&quot;${IB_SERVER}&quot;;Ref=&quot;${IB_NAME}&quot;;">
        <standardOdata enable="true"
                        reuseSessions="autouse"
                        sessionMaxAge="20"
                        poolSize="10"
                        poolTimeout="5"/>
        <analytics enable="true"/>
</point>


