undef spid
SELECT 	distinct c.username, c.osuser, c.terminal,c.status,d.sql_text,c.sid
FROM 	v$session c,
	v$sql d,
	v$process a
WHERE	c.sql_address = d.address
and	a.addr= c.paddr
and	a.spid = '&&SPID'
/
