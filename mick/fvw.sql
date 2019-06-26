set pages 999
set head on
set feedback on

Select Substr(view_Name, 1, length(view_name)) Vname from
user_views where view_name like upper('%&view%')
/
