declare
e varchar2(1000);
p varchar2(1000);
begin
global.pr_init(global.head_office,'SYSTEM');
if not CLPKS_PRD_RULEGEN.FN_CREATE_RULES('&prod',e,p) then raise_application_error(-20001,'Err'||p); end if;
end;
/
