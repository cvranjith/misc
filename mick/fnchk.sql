create or replace
function fn_check_int_gls (p_brn varchar2 , p_per varchar2 , p_fin varchar2)
return boolean is 
cursor cr_gl is
select a.* from gltb_gl_bal a , gltm_glmaster b
where 
branch_code = p_brn
and
period_code = p_per
and
fin_year = p_fin 
and
a.gl_code = b.gl_code
and
a.leaf = 'Y'
and
b.customer = 'I';
l_lcy		varchar2(3);
l_bal 	number;
l_bal_lcy 	number;
l_dt		date;
l1 number;
l2 number;
l3 number;
l4 number;
begin
select bank_lcy into l_lcy from sttms_bank;
delete gltb_mismatch where branch_code = p_brn and
period_code = p_per and fin_year = p_fin;
dbms_output.put_line('111');
delete gltb_mismatch_mov where branch_code = p_brn and
period_code = p_per and fin_year = p_fin;

select pc_end_date into l_dt from sttms_period_codes
where 
period_code = p_per
and
fin_cycle = p_fin;
dbms_output.put_line('222');

for c1 in cr_gl loop
	if 	(
		(c1.category in ('1','2','5','6')) or	
	    	(c1.category in ('3','4') and c1.ccy_code <> l_lcy) 
		) then		
		select
		nvl(sum(decode(drcr_ind,'D',-1,1) * fcy_amount),0) fcy,		
	      	nvl(sum(decode(drcr_ind,'D',-1,1) * lcy_amount),0) lcy
		into
		l_bal ,
		l_bal_lcy 
		from acvws_all_ac_entries a , sttms_period_codes b
		where
		ac_branch 	= c1.branch_code 
		and
		ac_no	 	= c1.gl_code
		and
		ac_ccy		= c1.ccy_code
		and
		a.period_code	= b.period_code
		and
		a.financial_cycle = b.fin_cycle
		and
		b.pc_start_date < l_dt ;
		if (
			((c1.cr_bal - c1.dr_bal) <> l_bal )
			or
			((c1.cr_bal_lcy - c1.dr_bal_lcy) <> l_bal_lcy )
			) then
			insert into gltb_mismatch
			(branch_code, gl_code, ccy_code,period_code,fin_year,category,
			bal, bal_lcy, actual_bal, actual_bal_lcy)
			values
			(c1.branch_code , c1.gl_code , c1.ccy_code , 
			p_per , p_fin , c1.category ,
			c1.cr_bal - c1.dr_bal , c1.cr_bal_lcy - c1.dr_bal_lcy ,
			l_bal , l_bal_lcy );	
		end if;
		select
		nvl(SUM(DECODE(DRCR_IND,'D',LCY_AMOUNT,0)),0) dr_amt,
		nvl(SUM(DECODE(DRCR_IND,'C',LCY_AMOUNT,0)),0) cr_amt ,
		nvl(SUM(DECODE(DRCR_IND,'D',fCY_AMOUNT,0)),0) dr_fcy_amt,
		nvl(SUM(DECODE(DRCR_IND,'C',fCY_AMOUNT,0)),0) cr_fcy_amt
		into
		l1,l2,l3,l4 
		from acvws_all_ac_entries a 
		where
		ac_branch 	= p_brn
		and
		ac_no	 	= c1.gl_code
		and
		ac_ccy		= c1.ccy_code
		and
		a.period_code	= p_per
		and
		a.financial_cycle = p_fin;

		If
			c1.dr_mov_lcy <>l1 or c1.dr_mov <>l3
			or c1.cr_mov_lcy <>l2 or 	c1.cr_mov <> l4 then
 			insert into gltb_mismatch_mov
			(branch_code, gl_code, ccy_code,period_code,fin_year,category,
			 dr_mov,cr_mov,dr_mov_lcy,cr_mov_lcy,
			 dr_mov_act,cr_mov_act,dr_mov_lcy_act,cr_mov_lcy_act)
			values
			(c1.branch_code , c1.gl_code , c1.ccy_code ,
			 p_per , p_fin , c1.category ,c1.dr_mov ,c1.cr_mov,c1.dr_mov_lcy,c1.cr_mov_lcy,
			 l3,l4,l1,l2
			 );	
		End if;


	else				
		select
	      	nvl(sum(decode(drcr_ind,'D',-1,1) * lcy_amount),0) lcy
		into 
		l_bal_lcy 
		from acvws_all_ac_entries a, sttms_period_codes b
		where
		ac_branch 	= c1.branch_code 
		and
		ac_no	 	= c1.gl_code
		and
		a.period_code	= b.period_code
		and
		a.financial_cycle = b.fin_cycle
		and
		b.pc_start_date < l_dt ;
		dbms_output.put_line('333');

		if 	((c1.cr_bal_lcy - c1.dr_bal_lcy) <> l_bal_lcy ) 
			then
			insert into gltb_mismatch
			(branch_code, gl_code, ccy_code,period_code,fin_year,category,
			bal, bal_lcy, actual_bal, actual_bal_lcy)
			values
			(c1.branch_code , c1.gl_code , c1.ccy_code ,
			 p_per , p_fin , c1.category ,
			 c1.cr_bal - c1.dr_bal , c1.cr_bal_lcy - c1.dr_bal_lcy ,
			 c1.cr_bal - c1.dr_bal , l_bal_lcy );	
		end if;	
		select
	            nvl(SUM(DECODE(DRCR_IND,'D',LCY_AMOUNT,0)),0) dr_amt,
			nvl(SUM(DECODE(DRCR_IND,'C',LCY_AMOUNT,0)),0) cr_amt 
		into 
		l1,l2	
		from acvws_all_ac_entries a
		where
		ac_branch 	= p_brn
		and
		ac_no	 	= c1.gl_code
		and
		a.period_code	= p_per
		and
		a.financial_cycle = p_fin;
		If
			c1.dr_mov_lcy <>l1 
			or c1.cr_mov_lcy <>l2  then
 			insert into gltb_mismatch_mov
			(branch_code, gl_code, ccy_code,period_code,fin_year,category,
			 dr_mov,cr_mov,dr_mov_lcy,cr_mov_lcy,
			 dr_mov_act,cr_mov_act,dr_mov_lcy_act,cr_mov_lcy_act)
			values
			(c1.branch_code , c1.gl_code , c1.ccy_code ,
			 p_per , p_fin , c1.category ,c1.dr_mov ,c1.cr_mov,c1.dr_mov_lcy,c1.cr_mov_lcy,
			 0,0,l1,l2
			 );	
		End if;
	end if;
end loop;
commit;
return true;
exception when others then
	rollback;
	dbms_output.put_line ('Error in Mickey was ' || SQLERRM);
	return false;
end;
/
sho err;
