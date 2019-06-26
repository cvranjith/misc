set serverout on size 1000000
create  or replace procedure dop(x in varchar2)
is
begin
--dbms_output.enable(1000000);
dbms_output.put_line(x);
end;
/

