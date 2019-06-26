
set feed off verify off pages 0 line 999 trimspo on long 2000000000
exec dbms_metadata.set_transform_param(dbms_metadata.session_transform,'SQLTERMINATOR',true);
exec dbms_metadata.set_transform_param(dbms_metadata.session_transform,'STORAGE',false);
exec dbms_metadata.set_transform_param(dbms_metadata.session_transform,'PRETTY',true);
exec dbms_metadata.set_transform_param(dbms_metadata.session_transform,'TABLESPACE',false);
exec dbms_metadata.set_transform_param(dbms_metadata.session_transform,'SEGMENT_ATTRIBUTES',false)

spo src.spl

select  '@srcspool '||
        object_name  ||' '||
        replace(object_type,' ')||' '||
        lower(object_name||'.'||decode(a.object_type,'PACKAGE BODY','SQL','PACKAGE','SPC','TRIGGER','TRG','FUNCTION','FNC','PROCEDURE','PRC','VIEW','VW',a.object_type)
        )
        file_name
from    user_objects a
where   object_type in ('FUNCTION','PACKAGE','PACKAGE BODY','PROCEDURE','VIEW')
/
spo off
@@src.spl

