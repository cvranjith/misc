SET HEAD OFF
SET TRIMSPOOL ON
SPO COMPILE.SQL
SELECT 'ALTER '|| DECODE(TYPE,'PACKAGE BODY','PACKAGE','TYPE BODY','TYPE',TYPE)
||' '||NAME||' COMPILE ' || DECODE(TYPE,'PACKAGE BODY','BODY','TYPE BODY','BODY') || ';'
FROM USER_DEPENDENCIES
WHERE REFERENCED_NAME = UPPER('&OBJ_NAME')
/

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
