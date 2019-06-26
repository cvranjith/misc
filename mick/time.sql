undef date
set pages 100
SELECT
RPAD(function_id,12,' ')|| 
LPAD(to_char(floor((system_end_time - system_start_time)*24*60)),3,' ')||' min  '||
LPAD(to_char(floor(((system_end_time - system_start_time)*24*60*60 - 60*(floor((SYSTEM_END_TIME - system_start_time)*24*60))))),3,' ')||' sec' TIME
FROM SMTB_SMS_LOG
WHERE function_id in( select function_id from aetm_process_defn)-- 'ICEOD'
AND TO_CHAR(SYSTEM_START_TIME,'DD-MM-YYYY') = TO_CHAR(nvl(TO_DATE('&&date'),sysdate),'DD-MM-YYYY')
AND SYSTEM_START_TIME >=
(SELECT SYSTEM_START_TIME FROM SMTB_SMS_LOG
WHERE FUNCTION_ID = 'BACKUP' AND TO_CHAR(SYSTEM_START_TIME,'DD-MM-YYYY') = TO_CHAR(nvl(TO_DATE('&&date'),sysdate),'DD-MM-YYYY')
AND ROWNUM = 1)
order by system_start_time
/
undef date