SET HEAD OFF
SET TRIMSPOOL ON
SPO COMPILE.SQL
SELECT 
'PROMPT Altering ' || object_type || ' ' || object_name || chr(10) ||
'ALTER '|| DECODE(OBJECT_TYPE,'PACKAGE BODY','PACKAGE','TYPE BODY','TYPE',OBJECT_TYPE)
||' '||OBJECT_NAME||' COMPILE ' || DECODE(OBJECT_TYPE,'PACKAGE BODY','BODY','TYPE BODY','BODY') || ';'
FROM USER_OBJECTS
WHERE STATUS='INVALID' 
AND OBJECT_NAME LIKE 'PC%' ORDER BY CREATED;

SPO OFF

SET HEAD ON

PROMPT *****************************************************
PROMPT INVALID COUNT
PROMPT *****************************************************

SELECT COUNT(1), OBJECT_TYPE
FROM USER_OBJECTS
WHERE STATUS = 'INVALID'
GROUP BY OBJECT_TYPE
/

PROMPT *****************************************************
PROMPT Run @COMPILE.SQL to compile invalid objects
PROMPT *****************************************************
