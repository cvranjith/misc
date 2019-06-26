disc
conn flxohcm/flxohcm
set time on timing on echo on serverout on size 1000000

drop table plch_test;
create table plch_test(a number, b number);
begin
insert into plch_test values (1,0);
insert into plch_test values (2,0);
commit;
end;
/

declare
b number;
begin
set transaction isolation level serializable;
dbms_lock.sleep(10);
select b into b from plch_test where a = 1 for update;
dbms_output.put_line('b= '||b);
exception
when others
then
dbms_output.put_line('Er '||sqlerrm);
end;
/

