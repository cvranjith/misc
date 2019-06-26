select 'Drop ' || object_type || ' ' || object_name || decode(object_type, 'TABLE', ' cascade constraints;',';')
from user_objects
where object_type not in ('PACKAGE BODY','INDEX','TRIGGER')
/
