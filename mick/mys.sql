SELECT 	c.sid, c.username, c.osuser, c.terminal,c.status, c.serial#,C.MODULE
FROM 	v$session c
WHERE	c.status = 'ACTIVE'
AND     C.AUDSID != USERENV('SESSIONID')
AND	C.MACHINE IN
	(
	SELECT D.MACHINE
	FROM   V$SESSION D
	WHERE  D.AUDSID = USERENV('SESSIONID')
	)
and username is not null
/
