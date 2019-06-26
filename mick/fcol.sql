select table_name,column_name from user_tab_columns 
where column_name like upper('%&ColName%');
