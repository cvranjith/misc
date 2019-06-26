select a.constraint_name, a.column_name from user_cons_columns a,
user_constraints b where
a.constraint_name = b.constraint_name and
b.table_name = upper('&table') and
b.constraint_type = 'P'
/
