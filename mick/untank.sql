


declare
e varchar2(1000);
p varchar2(1000);
begin
global.pr_init('&branch','SYSTEM');
if glpks_balance.fn_bal_int(global.current_branch) != 0 then
raise_application_error(-200001,'Err in Bal int');
end if;

if glpks_balance.fn_bal_cust(global.current_branch) != 0 then
raise_application_error(-200001,'Err in Bal cust');
end if;

if not acpks_eod.FN_UNTANK_PARENT(
 global.current_branch,
 global.lcy,
 e,
 global.application_date,
 p)
then
raise_application_error(-20001,'Err in untank '||e||':'||p);
end if;
end;
/


