SPOOL TMP.TMP
PROMPT CL SCR
SELECT 'SPOOL C:\TMP'||TO_CHAR(SYSDATE,'DD-MM-RRRR-HH24MISS')||'.LOG' FROM DUAL;
PROMPT PROMPT
PROMPT PROMPT
PROMPT PROMPT Enter branch code                                                                           ==> &&BRANCH_CODE
SELECT 'PROMPT Enter conversion date in "DD/MM/RRRR" format. [You may hit enter if the date is '||TO_CHAR(today,'DD/MM/RRRR')||'] ==> &&CONV_DATE'
FROM	STTM_DATES
WHERE	branch_code = '&&BRANCH_CODE';

SPOOL OFF

cl scr
cl scr

@TMP.TMP
