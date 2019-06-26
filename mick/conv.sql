UNDEF TNAME
SET VERIFY OFF
select 'NOT PRESENT IN COLS' X, TABLE_NAME,COLUMN_NAME from ufj_conv_fmt a
where table_name = '&&TNAME'
and column_name not in
(
select  column_name
from    COLS
where table_name = a.table_name
)
UNION ALL
select 'NOT PRESENT IN UFJ_CONV_FMT' X, TABLE_NAME,COLUMN_NAME  from COLS a
where table_name = '&&TNAME'
and column_name not in
(
select  column_name
from    UFJ_CONV_FMT
where table_name = a.table_name
)
/
UNDEF TNAME
