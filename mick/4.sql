

disc
conn flxohcm/flxohcm
set time on timing on echo on serverout on size 1000000

declare
a number;
begin
select a into a
from plch_test
where a = 2
for update;
commit;
end;
/


