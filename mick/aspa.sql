@storeset
set feed off
col aspa_log form a4500
select to_char(sys_dt,'DD-MON-RRRR HH24:MI:SS')||' '||dbg_msg aspa_log from iftb_aspa_dbg_log order by sys_dt
/
@restoreset

