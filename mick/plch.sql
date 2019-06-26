
drop table plch_employees;
create table plch_employees
(
employee_id integer,last_name varchar2(100), salary number
)
/
begin
insert into plch_employees values (100,'Jobs',1000000);
insert into plch_employees values (200,'Ellison',1000000);
insert into plch_employees values (300,'Gates',1000000);
commit;
end;
/


plch_employees.employee_id%type;
plch_employees.last_name%type;
plch_employees.salary%type;
plch_employees%rowtype;

@dop

drop table plch_parts;

CREATE TABLE plch_parts
(
   partnum    INTEGER primary key
 , partname   VARCHAR2 (10) unique
)
/

BEGIN
   INSERT INTO plch_parts
        VALUES (1, 'Mouse');
   INSERT INTO plch_parts
        VALUES (100, 'Keyboard');
   INSERT INTO plch_parts
        VALUES (500, 'Monitor');
   COMMIT;
END;
/

plch_parts.partnum%type;
plch_parts.partname%type;
plch_parts%rowtype;

