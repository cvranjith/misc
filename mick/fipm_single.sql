
declare
  l_err_code    varchar2(1000);
  l_err_param   varchar2(1000);
  l_report_name varchar2(1000) := '&FIPM_FILE';
begin
  global.pr_init(global.head_office,'SYSTEM');
  if not ifpks_fipmhandoff.fn_fipm_handoff
          (
          global.head_office,
          global.user_id,
          'A',
          l_err_code,
          l_err_param,
          l_report_name
          )
  then
      raise_application_error(-20001,'Failed to generate FIPM Report '||l_report_name||': Error is :'||l_err_code||':');
  end if;
end;
/


