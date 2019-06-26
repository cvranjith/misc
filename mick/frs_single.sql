
declare
  l_err_code    varchar2(1000);
  l_report_name varchar2(1000) := '&FRS_FILE';
begin
  global.pr_init(global.head_office,'SYSTEM');
  if not ifpks_frsasia_handoff.fn_handoff
      (
      l_err_code,
      l_report_name
      )
  then
      raise_application_error(-20001,'Failed to generate FRS Report '||l_report_name||': Error is :'||l_err_code||':');
  end if;
end;
/


