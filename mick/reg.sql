SELECT	USER_ID,
	PARAM_NAME,
	PARAM_VALUE
FROM	SMTB_USER_REG
WHERE	USER_ID LIKE REPLACE(upper('&US%'),' ','%')
AND	PARAM_NAME LIKE REPLACE(upper('&PAR%'),' ','%')
/