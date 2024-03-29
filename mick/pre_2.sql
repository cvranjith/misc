SPOOL TMP.TMP
SELECT 'ACCEPT CONV_DATE CHAR PROMPT '||CHR(39)||'Enter conversion date in "DD/MM/RRRR" format. [You may hit enter if the date is '||TO_CHAR(today,'DD/MM/RRRR')||'] ==> '||CHR(39)
FROM	STTM_DATES
WHERE	branch_code = '&&BRANCH_CODE';
SPOOL OFF
CL SCR

PROMPT
PROMPT
PROMPT Enter branch code                                                                           ==> &&BRANCH_CODE
@TMP.TMP



SPOOL TMP.TMP
DECLARE
D VARCHAR2(100) := '&&CONV_DATE';
B DATE;
F BOOLEAN := TRUE;
BEGIN
	IF D IS NOT NULL
	THEN
	BEGIN
		SELECT TO_DATE(D,'DD/MM/RRRR')	INTO B	FROM	DUAL;
	EXCEPTION
		WHEN OTHERS
		THEN
			F := FALSE;
	END;
	END IF;
	IF NOT F
	THEN
		DBMS_OUTPUT.PUT_LINE('PROMPT INVALID FORMAT');
	ELSE
		DBMS_OUTPUT.PUT_LINE('@PRE_3');
	END IF;
END;
/
SPOOL OFF
CL SCR
@TMP.TMP

--CL SCR
