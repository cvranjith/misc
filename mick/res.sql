declare
p_brn		varchar2(100) := '&BRN';
maint_err_code	varchar2(1000);
maint_err_param	varchar2(1000);
begin
global.pr_init(p_brn,'SYSTEM');

IF NOT ICPKSS_RESOLVE_MAINT.fn_resolve_brn
	(
	p_brn,
	maint_err_code,
	maint_err_param
	)
THEN
	dbms_output.put_line(maint_err_code);
END IF;
icpks_ude.pr_make_ude_row;
end;
/
