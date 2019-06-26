SELECT
lpad((select COUNT(1)
FROM FTTB_UPLOAD_MASTER
where source_ref in (select
external_ref_no from cstb_ext_contract_stat
where to_char(external_init_date,'DDMMYY') = to_char(sysdate,'DDMMYY'))
),6,' ')||' FTs
'||
lpad((select COUNT(1)
FROM FTTB_UPLOAD_MASTER
where source_ref in (select
external_ref_no from cstb_ext_contract_stat
where to_char(external_init_date,'DDMMYY') = to_char(sysdate,'DDMMYY'))
and upload_status = 'A'),6,' ')
||' Processed
'||
lpad((select COUNT(1)
FROM FTTB_UPLOAD_MASTER
where source_ref in (select
external_ref_no from cstb_ext_contract_stat
where to_char(external_init_date,'DDMMYY') = to_char(sysdate,'DDMMYY'))
and upload_status <> 'A'),6,' ')
||' Remaining
'|| lpad((select count(1) from fttb_upload_exception),6,' ')|| ' Exceptions '
||'
Aprox Speed '||
FLOOR(((select ((
(decode((select run_stat from eitb_pending_programs where function_id = 'FTBFNUPD'),'T',sysdate,SYSTEM_END_TIME))
-system_start_time)*24*60*60/
(select COUNT(1)
FROM FTTB_UPLOAD_MASTER
where source_ref in (select
external_ref_no from cstb_ext_contract_stat
where to_char(external_init_date,'DDMMYY') = to_char(sysdate,'DDMMYY'))
and upload_status = 'A'))
from smtb_sms_log
where FUNCTION_ID = 'FTBFNUPD' AND TO_CHAR(SYSTEM_START_TIME,'DD-MON-YYYY')=TO_CHAR(SYSDATE,'DD-MON-YYYY')
)*100))
||' sec Per 100 FT'
FT_Upload from dual
/
