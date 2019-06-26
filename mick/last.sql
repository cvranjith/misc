set numformat 9999.99
SELECT
'"'||FUNCTION_ID ||'" Started by '||'"'||USER_ID||'"'||' on '||
TO_CHAR(SYSTEM_START_TIME,'DD-MON-YYYY')||' at '||TO_CHAR(SYSTEM_START_TIME,'HH24:MI:SS')  ||' has been running for '||
--TO_CHAR(SYSdate,'HH:MI:SS') systime,
to_char(floor((SYSDATE - system_start_time)*24*60))||' min '||
to_char(floor(((SYSDATE - system_start_time)*24*60*60 - 60*(floor((SYSDATE - system_start_time)*24*60)))))||' sec' last_activity
FROM SMTB_SMS_LOG
WHERE SEQUENCE_NO
= (SELECT MAX(SEQUENCE_NO) FROM SMTB_SMS_LOG)
/

