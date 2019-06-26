select constraint_name, substr(column_name,1,30) column_name, position from user_cons_columns
where constraint_name = (select constraint_name from user_constraints
where constraint_type = 'P' and table_name = upper('&Table'))
order by position
/
