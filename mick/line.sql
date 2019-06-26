@storeset
ACCEPT package PROMPT "Enter package name : "
ACCEPT line PROMPT "Enter line number : "

COLUMN line FORMAT 9999
COLUMN text FORMAT A74
SET feedback OFF
SET pagesize 20
SET verify OFF
SET timing OFF
SET heading ON

SELECT line,text
FROM   user_source
WHERE  line BETWEEN (&line - 5) AND (&line - 1)
AND    type = 'PACKAGE BODY'
AND    name = UPPER('&package')
/
SET pagesize 0

SELECT RPAD ('=',80,'=')
FROM   dual
/
SELECT line,text
FROM   user_source
WHERE  line = &line
AND    type = 'PACKAGE BODY'
AND    name = UPPER('&package')
/
SELECT RPAD ('=',80,'=')
FROM   dual
/
SELECT line,text
FROM   user_source
WHERE  line BETWEEN (&line + 1) AND (&line + 5)
AND    type = 'PACKAGE BODY'
AND    name = UPPER('&package')
/

@restoreset
