-- DANGEROUS!!
-- THIS SCRIPT WILL DROP ALL THE OBJECTS.
-- PUT THE FILE IN DROP_IAMSURE.SQL

SET SERVEROUT ON SIZE 10000
SET PAGES 0 LINE 9999 TRIMSPOOL ON FEED OFF VERIFY OFF
SPOOL TMP.TMP
DECLARE
	N NUMBER := 0;
BEGIN
	SELECT	COUNT(1)
	INTO	N
	FROM	USER_OBJECTS;
	
	IF N = 0 
	THEN
		DBMS_OUTPUT.PUT_LINE('REM');
	ELSE
		DBMS_OUTPUT.PUT_LINE('SPOOL TMP.TMP1');
		DBMS_OUTPUT.PUT_LINE('PROMPT SET FEED ON');
		DBMS_OUTPUT.PUT_LINE('PROMPT SPOOL DROPOBJ_'||USER||'_'||TO_CHAR(SYSDATE,'YYYYDDMMHH24MISS')||'.LOG');
		DBMS_OUTPUT.PUT_LINE('SELECT ''PROMPT ''||OBJECT_TYPE||'' ''||OBJECT_NAME||''
DROP ''||OBJECT_TYPE||'' ''||OBJECT_NAME||'';'' FROM USER_OBJECTS WHERE OBJECT_TYPE NOT IN (''PACKAGE BODY'',''TRIGGER'',''INDEX'');');
		DBMS_OUTPUT.PUT_LINE('PROMPT SPOOL OFF');
		DBMS_OUTPUT.PUT_LINE('SPOOL OFF');
		DBMS_OUTPUT.PUT_LINE('@TMP.TMP1');
		DBMS_OUTPUT.PUT_LINE('@DROP_IAMSURE.SQL');
	END IF;
END;
/
SPOOL OFF
@TMP.TMP
SET FEED ON
