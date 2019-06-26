set head off
set pause off
set feedback off
set pages 30000
spool D:\xx.sql
SELECT 
	'ALTER '|| decode (object_type, 'PACKAGE BODY', 'PACKAGE',object_type)
		|| ' ' || object_name|| ' ' ||
		decode (object_type, 'PACKAGE BODY', 'COMPILE BODY;','COMPILE;')
FROM
	user_objects
WHERE
	STATUS	=	'INVALID'
AND	object_type	=	'PACKAGE'
ORDER BY
	object_name
/
spool off
set feedback on
@d:\xx.sql
set feedback off
set pages 30000
spool d:\xx1.sql
SELECT 
	'ALTER '|| decode (object_type, 'PACKAGE BODY', 'PACKAGE',object_type)
		|| ' ' || object_name|| ' ' ||
		decode (object_type, 'PACKAGE BODY', 'COMPILE BODY;','COMPILE;')
FROM
	user_objects
WHERE
	STATUS	=	'INVALID'
ORDER BY
	object_type,
	object_name
/
spool off
set feedback on
@xx1.sql
set pause off 
set head on