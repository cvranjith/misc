set feed off pages 0 line 999
undef filename
accept filename prompt "file name: "
set termout off
spool c:\tmp.bat
prompt echo create or replace view ranj$xyz as > c:\tmp.vw
prompt type tmp.sql >> c:\tmp.vw
spo off
host c:\tmp.bat
@c:\tmp.vw
HOST DEL C:\TMP.BAT
HOST DEL C:\TMP.VW
set feed on pages 100


set echo off feedback off timing off pause off verify off
set pagesize 0 linesize 4000 trimout on trimspool on
set termout off
spool tmp.tmp
prompt set echo off feedback off timing off pause off verify off termout off
prompt spool &&filename..csv
select	decode(column_id,1,'SELECT','')||chr(9)||
	decode(column_id,1,'','||'',''||')||
	decode(data_type,
		'CHAR', '''"''||',
		'VARCHAR2', '''"''||',
		'NCHAR', '''"''||',
		'NVARCHAR2', '''"''||''||',
		'LONG', '''"''||',
		'CLOB', '''"''||',
			'')||
	column_name||
	decode(data_type,
		'CHAR', '||''"''',
		'VARCHAR2', '||''"''',
		'NCHAR', '||''"''',
		'NVARCHAR2', '||''"''',
		'LONG', '||''"''',
		'CLOB', '||''"''',
			'') txt
from	user_tab_columns
where	table_name = upper('ranj$xyz')
order by column_id;
prompt from	ranj$xyz
prompt /
prompt spool off
set termout on
spool off
@tmp.tmp
set termout on
prompt file "&&filename..csv";  please check...
set feedback 6 verify on
