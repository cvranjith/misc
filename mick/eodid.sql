SELECT 	C.SID,c.username, c.osuser, c.terminal,c.status,d.sql_text
FROM 	v$session c,
	v$sql d
WHERE	c.sql_address = d.address
AND	upper(c.osuser) = 'EODID'
/
