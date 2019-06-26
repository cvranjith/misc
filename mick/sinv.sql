set head off
SELECT 
	'ALTER '|| decode (object_type, 'PACKAGE BODY', 'PACKAGE',object_type)
		|| ' ' || object_name|| ' ' ||
		decode (object_type, 'PACKAGE BODY', 'COMPILE BODY;','COMPILE;')
FROM
	user_objects
WHERE
	STATUS	=	'INVALID'
--	AND object_type ='PACKAGE BODY'

ORDER BY
OBJECT_TYPE
/
