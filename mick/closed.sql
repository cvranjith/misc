store set store.set
set trimspo on pages 0 line 9999 feed off
spo tmp.tmp
select 'select * from '||table_name||' where record_stat = ''C'';' from cols where column_name = 'RECORD_STAT'
/
spo off
set pages 100 echo on  feed on
spo closed.log
@tmp.tmp
spo off
@restoreset
