set feed off trimspo on pages 0 line 9999
spo tmp.tmp
prompt begin
select 'begin dbms_mview.refresh('''||name||'''); exception when others then dbms_output.put_line(sqlerrm);end;'
from USER_SNAPSHOTS;
/
prompt end;;
prompt /
spo off
set feed on pages 100
set serverout on size 1000000
@tmp.tmp
