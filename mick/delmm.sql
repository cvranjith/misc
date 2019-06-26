select 'DROP ' || object_type || ' ' || object_name || ';' from all_objects
where owner = 'FBMEDATA'
and object_type in ('TABLE','PACKAGE')
minus select 'DROP ' || object_type || ' ' || object_name || ';' from all_objects
where owner = 'TRAINTEST'
and object_type in ('TABLE','PACKAGE')
/
