select TABLE_NAME, COLUMN_NAME, DATA_LENGTH, substr(DATA_TYPE,1,length(data_type)) data_type from user_tab_columns
where column_name like upper('%&ColName%')
/
