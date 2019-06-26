UNDEFINE SESSIONID
SELECT 	c.username, c.module,c.osuser, c.terminal,c.status,d.sql_text,c.sid
FROM 	v$session c,
	v$sql d
WHERE	c.sql_address = d.address
AND	C.SID = &&SESSIONID
UNION
SELECT 	c.username, c.module, c.osuser, c.terminal,c.status,d.sql_text,c.sid
FROM 	v$session c,
	v$sql d
WHERE	c.PREV_SQL_ADDR = d.address
AND	C.SID = &&SESSIONID
/
UNDEFINE SESSIONID
