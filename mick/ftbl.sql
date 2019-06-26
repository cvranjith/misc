set pages 999
set head on
set feedback on

Select Substr(Table_Name, 1, length(Table_name)) Tname from
user_tables where table_name like upper('%&Table%')
/
