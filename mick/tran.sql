select b.sid,b.status,USED_UBLK,USED_UREC,LOG_IO,PHY_IO,CR_GET
from v$transaction a, v$session b
where a.ses_addr = b.saddr
/
