select substr(INDEX_NAME, 1, 30) INDEXNAME, 
substr(COLUMN_NAME,1,30) COLUMN_NAME, COLUMN_POSITION from user_ind_columns
where TABLE_NAME = upper('&TableName')
order by INDEXNAME, COLUMN_POSITION
/
