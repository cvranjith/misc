UNDEFINE SESSIONID
SELECT 	c.username, c.osuser, c.terminal,c.status,d.sql_text,c.sid
FROM 	v$session c,
	v$sql d
WHERE	c.sql_address = d.address
AND	upper(c.osuser) = 'KUMARS'
AND	TO_CHAR(C.SID) LIKE NVL('&&SESSIONID','%')
/
UNDEFINE SESSIONID
