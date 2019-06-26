declare
x varchar2(1000);
begin
x := MSPKS.hostcmd('touch /tmp/ranj.txt' ,'/tmp');
end;
/
