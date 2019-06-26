declare
lprd varchar2(1000);
lfin varchar2(1000);
begin
global.pr_init('ACU','SYS');
lprd := global.gbrnrec.current_period;
lfin := global.gbrnrec.current_cycle;

         	IF not glpkss_rebuild.fn_check_int_gls(global.current_branch,lprd,lfin,global.lcy)
         	THEN
         	   raise_application_error(-2001,'fn chk int gls');
            END IF;
         	IF not glpkss_rebuild.fn_build_int_gls(global.current_branch,lprd,lfin,global.lcy)
         	THEN
         	   raise_application_error(-2001,'fn chk build gls');
            END IF;
end;
/

