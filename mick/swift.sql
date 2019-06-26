
create or replace directory TMP as '/tmp';
declare
f utl_file.file_type;
l varchar2(32000);
x varchar2(32767);
e varchar2(100);
r varchar2(1000);
d varchar2(1000);
y clob;
begin
f := utl_file.fopen('TMP','msg.txt','r',32667);
begin
loop
utl_file.get_line(f,l);
x := x||l||chr(10);
end loop;
exception when no_data_found then
utl_file.fclose(f);
end;
y := x;
ifpks_msg_incoming.PR_PROCESS_INMSG(y,'SWIFT',e,r,d);
if e is not null then raise_application_error(-20001,'Err '||e); end if;
end;
/

