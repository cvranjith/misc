@perf
undef snap
ACCEPT snap CHAR PROMPT 'Do you want to take snap now ==> '
declare
s varchar2(100) := '&&snap';
begin
if upper(s)='Y'
then	
	dbms_output.put_line('going to snap');
	statspack.snap;
else
	dbms_output.put_line('skipping snap');
end if;
end;
/
@spreport
