
set feed off verify off pages 0 line 999 trimspo on long 2000000000
exec dbms_metadata.set_transform_param(dbms_metadata.session_transform,'SQLTERMINATOR',true);
exec dbms_metadata.set_transform_param(dbms_metadata.session_transform,'STORAGE',false);
exec dbms_metadata.set_transform_param(dbms_metadata.session_transform,'PRETTY',false);
exec dbms_metadata.set_transform_param(dbms_metadata.session_transform,'TABLESPACE',false);
exec dbms_metadata.set_transform_param(dbms_metadata.session_transform,'SEGMENT_ATTRIBUTES',false)

spo srcvw.spl

select  '@srcspoolvw '||
        object_name  ||' '||
        replace(object_type,' ')||' '||
        lower(object_name||'.'||decode(a.object_type,'PACKAGE BODY','SQL','PACKAGE','SPC','TRIGGER','TRG','FUNCTION','FNC','PROCEDURE','PRC','VIEW','VW',a.object_type)
        )
        file_name
from    user_objects a
where   object_type in ('SEQUENCE')
and (
(object_name not like 'TRSQ%')
or (object_name like 'TRSQ%' and substr(object_name,6,3) in (select branch_code from sttm_branch where record_stat = 'O'))
)
--and lower(object_name) = 'clvc_account_components'
/
spo off
@@srcvw.spl

