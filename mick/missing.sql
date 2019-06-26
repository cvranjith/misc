select * from tmp11
where not exists (select 1 from user_objects where t=object_type and n= object_name)
and t != 'INDEX'
/
