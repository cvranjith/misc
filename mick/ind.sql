select a.table_name,b.uniqueness,a.index_name,a.column_name 
from all_ind_columns a, user_indexes b
where a.table_name = upper('&TABLE')
and a.index_name = b.index_name
order by index_name
/
