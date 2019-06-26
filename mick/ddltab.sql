UNDEFINE TABLE
SET TRIMSPOOL ON
SELECT Z DDL FROM
(
select  table_name y,
        0 x,
        'create table ' ||
        rtrim(table_name) Z
from    dba_tables
where     owner = 'FCCLIVE'
and    table_name = upper('&&TABLE')
UNION
select  tc.table_name y,
        column_id x,
        rtrim(decode(column_id,1,'('||CHR(10),','))||
        RPAD(rtrim(column_name),20,' ')|| ' ' ||
        rtrim(data_type) ||
        rtrim(decode(data_type,'DATE',null,'LONG',null,
               'NUMBER',decode(to_char(data_precision),null,null,'('),
               '(')) ||
        rtrim(decode(data_type,
               'DATE',null,
               'CHAR',data_length,
               'VARCHAR2',data_length,
               'NUMBER',decode(to_char(data_precision),null,null,
                 to_char(data_precision) || ',' || to_char(data_scale)),
               'LONG',null,
               '******ERROR')) ||
        rtrim(decode(data_type,'DATE',null,'LONG',null,
               'NUMBER',decode(to_char(data_precision),null,null,')'),
               ')')) || ' ' ||
        rtrim(decode(nullable,'N','NOT NULL',null))
from    dba_tab_columns tc,
        dba_objects o
where   o.owner = tc.owner
and     o.object_name = tc.table_name
and     o.object_type = 'TABLE'
and     o.owner = 'FCCLIVE'
and    tc.table_name = upper('&&TABLE')
UNION
select  table_name y,
        999999 x,
        ')'  || chr(10)
        ||' STORAGE'||CHR(10)
        ||'('                   || chr(10)
        ||RPAD(' INITIAL ',20,' ')    || initial_extent      || chr(10)
        ||RPAD(' NEXT ',20,' ')    || next_extent         || chr(10)
        ||RPAD(' MINEXTENTS ',20,' ')    || min_extents         || chr(10)
        ||RPAD(' MAXEXTENTS ',20,' ')    || max_extents         || chr(10)
        ||RPAD(' PCTINCREASE ',20,' ')    || pct_increase        || CHR(10)||')' ||chr(10)
        ||RPAD(' INITRANS ',20,' ')    || ini_trans         || chr(10)
        ||RPAD(' MAXTRANS ',20,' ')    || max_trans         || chr(10)
        ||RPAD(' PCTFREE ',20,' ')    || pct_free          || chr(10)
        ||RPAD(' PCTUSED ',20,' ')    || pct_used          || chr(10)
        ||' PARALLEL (DEGREE ' || DEGREE || ') ' || chr(10)
        ||' TABLESPACE ' || rtrim(tablespace_name) ||chr(10)
        ||'/'||chr(10)||chr(10)
from    dba_tables
where   owner = 'FCCLIVE'
and    table_name = upper('&TABLE')
order by 1,2
)
/
UNDEFINE TABLE
