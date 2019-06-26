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
FT_Upload from dual
/
