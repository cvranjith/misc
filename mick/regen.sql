declare x varchar2(1000); y varchar2(1000);
begin
global.pr_init('868','SYS');
if not ifpks_fipmhandoff_regen.FN_AC_MOVEMENTS(x,y) then raise_application_error(-20001,'x'||x);end if;
fn_fipm_handoff	(	global.current_Branch,
					global.user_id,
					'N',
					x,
					y
					)
 then raise_application_error(-20001,'x'||x);end if;
end;
/
