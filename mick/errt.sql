UNDEF STR
UNDEF TYP
UNDEF ERRC

SET HEAD OFF VERIFY OFF

ACCEPT STR CHAR PROMPT 'Enter Search String for err code / errm  ==> '

SELECT TYPE ||' '||ERR_CODE||' - '||MESSAGE FROM ERTB_MSGS
WHERE 
(
UPPER(ERR_CODE) LIKE UPPER(REPLACE('%&&STR%',' ','%'))
OR 
UPPER(MESSAGE) LIKE REPLACE(upper('%&&STR%'),' ','%')
)
/

UNDEF STR

ACCEPT ERRC CHAR PROMPT 'Enter ERROR CODE ==> '

SET FEED OFF

SELECT 'TYPE FOR '||ERR_CODE||' IS '||TYPE
FROM ERTBS_MSGS
WHERE ERR_CODE = '&ERRC'
/


ACCEPT TYP CHAR PROMPT  'Enter TYPE [I/E/O] ==> '

SET FEED ON

UPDATE 	ERTBS_MSGS
SET	TYPE = '&&TYP'
WHERE	ERR_CODE = '&ERRC'
/

SET FEED OFF

SELECT TYPE ||' '||ERR_CODE||' - '||MESSAGE FROM ERTB_MSGS
WHERE ERR_CODE = '&ERRC'
/

SET HEAD ON VERIFY ON FEED ON
UNDEF STR
UNDEF TYP
UNDEF ERRC
