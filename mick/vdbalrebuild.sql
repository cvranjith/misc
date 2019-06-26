DECLARE

function fn_rebuild_gl_vdbal (p_brn in sttms_branch.branch_code%type,
					p_commit_flag in varchar2,
					p_lcy in cytms_ccy_defn.ccy_code%type)
return boolean as --ST40R2
curr_brn 	 sttms_branch.branch_code%type := p_brn;
obal		 gltbs_gl_bal.cr_bal_lcy%type;
cbal 		 gltbs_gl_bal.cr_bal_lcy%type;
obal_lcy	 gltbs_gl_bal.cr_bal_lcy%type;
cbal_lcy	 gltbs_gl_bal.cr_bal_lcy%type;
--l_lcy	 cytms_ccy_defn.ccy_code%type;
commit_count number :=1; --GSUP 24.10.2001
--10-Oct-2002	FCC5.1-IMF Changes 3 .Added new variables.
obal_ic	 gltbs_gl_bal.cr_bal_lcy%type;
cbal_ic 	 gltbs_gl_bal.cr_bal_lcy%type;
obal_lcy_ic	 gltbs_gl_bal.cr_bal_lcy%type;
cbal_lcy_ic	 gltbs_gl_bal.cr_bal_lcy%type;

begin


	curr_brn := p_brn;
	--l_lcy:=global.lcy;
	--dbg ('Processing ..... ' || curr_brn);
	for x in
	( select distinct a.ac_branch brn, TRIM(a.ac_no) acc, a.ac_ccy ccy --GSUP FOR FMB-Malawi 30.04.2002
	  from acvws_all_ac_entries a
	  where ac_branch = curr_brn
	  AND AC_NO IN ('804711001','904712001','000008640001','000008640002')
	)
	loop

		-- Initialise balances

		obal 		 :=0;
		obal_lcy 	 :=0;
		cbal 		 :=0;
		cbal_lcy 	 :=0;
		obal_ic  	 :=0; --10-Oct-2002	FCC5.1-IMF Changes 3
		cbal_ic	 :=0; --10-Oct-2002	FCC5.1-IMF Changes 3
		obal_lcy_ic  :=0; --10-Oct-2002	FCC5.1-IMF Changes 3
		cbal_lcy_ic  :=0; --10-Oct-2002	FCC5.1-IMF Changes 3


		-- First get rid of existing records in actbs_vd_val

		-- Changed where for performnace --GSUP 24.10.2001
		delete from actbs_vd_bal h
		where h.acc = x.acc and
			h.ccy = x.ccy AND
			h.brn = x.brn ;

		if commit_count > 1000 then
			--dbg('in first loop of vdbal');
			--commit;
			NULL;
			commit_count :=1;
		end if;
		-- Changed where for performnace --GSUP 24.10.2001
		for y in (select ah.value_dt,
			      sum(decode(ah.drcr_ind,'C',0,
 				           decode(x.ccy,p_lcy,nvl(lcy_amount,0),
					     nvl(fcy_amount,0)))) acy_dr_tur,
				sum(decode(ah.drcr_ind,'D',0,
 				           decode(x.ccy,p_lcy,nvl(lcy_amount,0),
					     nvl(fcy_amount,0)))) acy_cr_tur,
				--10-Oct-2002	FCC5.1-IMF Changes 3 Start. Take only balances of
				--the transaction codes of which have ic_bal_inclusion ='Y'
				sum(decode(ah.ic_bal_inclusion,'N',0,decode(ah.drcr_ind,'C',0,
 				           decode(x.ccy,p_lcy,nvl(lcy_amount,0),
					     nvl(fcy_amount,0))))) acy_dr_tur_ic,
				sum(decode(ah.ic_bal_inclusion,'N',0,decode(ah.drcr_ind,'D',0,
 				           decode(x.ccy,p_lcy,nvl(lcy_amount,0),
					     nvl(fcy_amount,0))))) acy_cr_tur_ic,
				sum(decode(ah.ic_bal_inclusion,'N',0,decode(ah.drcr_ind,'C',0,nvl(lcy_amount,0)))) lcy_dr_tur_ic,
				sum(decode(ah.ic_bal_inclusion,'N',0,decode(ah.drcr_ind,'D',0,nvl(lcy_amount,0)))) lcy_cr_tur_ic ,
				--10-Oct-2002	FCC5.1-IMF Changes 3 End
				sum(decode(ah.drcr_ind,'C',0,nvl(lcy_amount,0))) lcy_dr_tur,
				sum(decode(ah.drcr_ind,'D',0,nvl(lcy_amount,0))) lcy_cr_tur
				from acvws_all_ac_entries ah
				where ah.ac_no	 = x.acc and
					ah.ac_ccy		= x.ccy and
					ah.ac_branch = x.brn  and
					ah.balance_upd ='U'  --22.03.2002 GSUP FOR FCRBRNIT
				group by ah.value_dt
				order by ah.value_dt
			   )
		loop
			cbal     	:= obal + nvl(y.acy_cr_tur,0) - nvl(y.acy_dr_tur,0);
			cbal_lcy 	:= obal_lcy + nvl(y.lcy_cr_tur,0) - nvl(y.lcy_dr_tur,0);
			--10-Oct-2002	FCC5.1-IMF Changes 3
			cbal_ic  	:= obal_ic + nvl(y.acy_cr_tur_ic,0) - nvl(y.acy_dr_tur_ic,0);
			cbal_lcy_ic := obal_lcy_ic + nvl(y.lcy_cr_tur_ic,0) - nvl(y.lcy_dr_tur_ic,0);

			insert into actbs_vd_bal
			(brn,acc,val_dt,bal,dr_tur,cr_tur, ccy,lcy_bal,ic_bal,ic_lcy_bal) --10-Oct-2002	FCC5.1-IMF Changes 3
			 values
			(x.brn,x.acc,y.value_dt,
			 cbal,
			 nvl(y.acy_dr_tur,0),nvl(y.acy_cr_tur,0), x.ccy,cbal_lcy,cbal_ic,cbal_lcy_ic); --10-Oct-2002	FCC5.1-IMF Changes 3

			 commit_count:= commit_count +1;

			 obal		 := cbal;
			 obal_lcy 	 := cbal_lcy;
			 obal_ic	 := cbal_ic; 	--10-Oct-2002	FCC5.1-IMF Changes 3
			 obal_lcy_ic := cbal_lcy_ic;  --10-Oct-2002	FCC5.1-IMF Changes 3



			--GSUP FOR INM 14.11.2001
			update actbs_daily_log
			set VDBAL_UPDATE_FLAG='Y'
			where ac_branch=x.brn
			and ac_no=x.acc
			and ac_ccy=x.ccy
			and value_dt=y.value_dt
			and balance_upd='U'
			and nvl(delete_stat,'?')<>'D';


	    end loop;
	end loop;
	commit_count :=1;

	if nvl(p_commit_flag,'N')='Y' then
		--commit;
		NULL;
	end if;--ST40R2

	return true;

exception when others then
	--dbg('Failed'||sqlerrm);
	return false;
end fn_rebuild_gl_vdbal;--ST40R2

BEGIN
GLOBAL.PR_INIT('035','SYSTEM');
IF NOT fn_rebuild_gl_vdbal ( GLOBAL.CURRENT_BRANCH,
'N',
'VND')
THEN
DBMS_OUTPUT.PUT_LINE('FAILED');
END IF;
END;
/
