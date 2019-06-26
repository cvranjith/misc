Select Substr(object_Name, 1, length(object_name)) object_name, object_Type, status from
obj where object_name like upper('%&Object%')
/
