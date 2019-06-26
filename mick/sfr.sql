@sho

set verify off feed off line 9999 pages 1000 serverout on size 1000000

declare
x           varchar2(32767) := '&sfr_numbers';
type t      is table of sfr%rowtype index by binary_integer;
sfrs        t;
y           varchar2(32767);
l           varchar2(32767);
txt         dbms_sql.varchar2_table;
m           number;
type        tu is table of varchar2(100) index by varchar2(1000);
un          tu;
db          boolean := false;
begin
x := x||',';
for i in 1..length(x)
loop
y := substr(x,i,1);
if y in (' ',',')
then
if l is not null
then
begin
select *
into   sfrs(sfrs.count+1)
from   sfr
where  sr_no =l;
exception when no_data_found then null; end;
l := null;
end if;
elsif ascii(y) between 48 and 57
then
l := l||y;
end if;
end loop;
if sfrs.count > 0
then
for i in sfrs.first .. sfrs.last
loop
txt(txt.count+1) := '['||i||'] '||sfrs(i).sfr_no||':';
if sfrs(i).units is not null
then
l := sfrs(i).units||'|';
y := null;
for i in 1..length(l)
loop
if substr(l,i,1) = '|'
then
if substr(y,1,3) = 'APP'
then
un(substr(y,instr(y,';',1,2)+1)) := 1;
elsif substr(y,1,2) ='DB'
then
db := true;
end if;
y := null;
else
y := y||substr(l,i,1);
end if;
end loop;
end if;

l := sfrs(i).problem ||' ';
for qq in 1..20 loop
m := 50;
y := substr(l,1,m);
if y is null then exit; end if;
if substr(l,m,1) not in (chr(10),' ') and substr(l,(m+1),1) not in (chr(10),' ')
then
if instr(y,' ',-1) > 0 then m := instr(y,' ',-1)-1; end if;
end if;
y := substr(y,1,m);
l := substr(l,m+1);
y := ltrim(y);
y := replace(y,chr(10),chr(10)||'|                |       ');
txt(txt.count+1) := '      '||y;
end loop;
end loop;
end if;
if txt.count > 0
then
dbms_output.put_line('Hi,');
dbms_output.put_line('Please execute the below CR');
dbms_output.put_line('.');
dbms_output.put_line('+----------------+--------------------------------------------------------------');
for i in txt.first .. txt.last
loop
if i = 1 then
dbms_Output.put_line('|Purpose         | '||txt(i));
else
dbms_Output.put_line('|                | '||txt(i));
end if;
end loop;
dbms_output.put_line('+----------------+--------------------------------------------------------------');
dbms_output.put_line('|Site            | ALL');
dbms_output.put_line('+----------------+--------------------------------------------------------------');
dbms_output.put_line('|Environment     | ALL');
dbms_output.put_line('+----------------+--------------------------------------------------------------');
if un.count > 0 and db
then
dbms_output.put_line('|Servers         | Application Server/Database Server');
elsif un.count > 0
then
dbms_output.put_line('|Server          | Application Server');
elsif db
then
dbms_output.put_line('|Server          | Database Server');
end if;
dbms_output.put_line('+----------------+--------------------------------------------------------------');
dbms_output.put_line('|Change Type     | Fix');

dbms_output.put_line('+----------------+--------------------------------------------------------------');
dbms_output.put_line('|Rollback        | Database Server:');
dbms_output.put_line('|Procedure       |    Please save the /tmp/*before*.sql files created at the time of');
dbms_output.put_line('|                |    Patch. These are backup of the existing units.');
dbms_output.put_line('|                |    In case rollback is required these sqls can be applied using');
dbms_output.put_line('|                |    sql*plus');
dbms_output.put_line('|                | Application Server:');
dbms_output.put_line('|                |    Please take the backup of *.fmx file before copying ');
dbms_output.put_line('|                |    In case rollback is required this .fmx can be restored');
dbms_output.put_line('+----------------+--------------------------------------------------------------');


dbms_output.put_line('|Steps           |');
if un.count > 0
then
dbms_output.put_line('|                | Application server:');
dbms_output.put_line('|                |      Copy the following file(s) from $dev/fmx/eng ');
dbms_output.put_line('|                |      to other env''s fmx/ENG area');
dbms_output.put_line('|                |');
y := un.first;
loop
dbms_output.put_line('|                |      ==> '||replace(y,'fmb','fmx'));
if y = un.last then exit; end if;
y := un.next(y);
end loop;
if db then
dbms_output.put_line('|                |');
dbms_output.put_line('|                |--------------------------------------------------------------');
end if;
end if;
if db then
dbms_output.put_line('|                | Database server:');
dbms_output.put_line('|                |      Extract the attached zip file, and run the file run1.sql');
dbms_output.put_line('|                |      after connecting to FLEXCUBE schema using sql*plus');
end if;
end if;
end;
/






