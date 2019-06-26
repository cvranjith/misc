declare
x number;
function fn_bal_cust_dly_log(
	pm_branch 	sttms_branch.branch_code%TYPE) return integer as

/*
New program added by GSUP for KESPRM for updating cust gl balances properly
This is the glpks_balance.fn_bal_cust of FCC3.0 version
*/


cursor glbals is
SELECT 	sttms_cust_account.branch_code, 
		decode (sign(acy_curr_balance), -1, dr_gl, 
							   0, (decode(sttms_account_class.natural_gl_sign, 'D', dr_gl, 'C', cr_gl)), 
							   1, cr_gl) bal_gl, 
		ccy, 
		sum(decode(sttms_cust_account.ccy, global.lcy, 0, acy_curr_balance)) acy_bal, 
		sum(lcy_curr_balance) lcy_bal, 
		sum(acy_uncollected) uncol_bal, 
		sign(acy_curr_balance) sgn
from sttms_cust_account, sttms_account_class
WHERE 
	sttms_cust_account.branch_code = pm_branch AND
	sttms_cust_account.account_class = sttms_account_class.account_class 
group by 
	sttms_cust_account.branch_code, 
	decode (sign(acy_curr_balance), -1, dr_gl, 
						   0, (decode(sttms_account_class.natural_gl_sign, 'D', dr_gl, 'C', cr_gl)), 1, cr_gl), 
							 ccy, sign(acy_curr_balance);

cursor past_acc(parm_fin varchar2, parm_per varchar2) is
SELECT ac_no, decode(sign(acy_curr_balance), -1, dr_gl, cr_gl) acc_gl, financial_cycle, period_code, fcy_amount, lcy_amount, drcr_ind, ccy
from actbs_daily_log, sttms_cust_account
WHERE
	(financial_cycle <> parm_fin or period_code <> parm_per) AND
	ac_branch = pm_branch AND
	ac_no = sttms_cust_account.cust_ac_no AND
	ac_branch = sttms_cust_account.branch_code 
	/* USDFBME - GURU - Regarding Untanked entries of 
		Past Period in DAILY LOG */
	AND txn_init_date = GLOBAL.application_date
	 --KWDKFC SFR NO 38 check for delete stat   
	and delete_stat <> 'D';
	
	
cursor past_per(from_dt date, to_dt date) is 
SELECT sttms_fin_cycle.fin_cycle financial_cycle, period_code
from sttms_fin_cycle, sttms_period_codes
WHERE sttms_fin_cycle.fin_cycle = sttms_period_codes.fin_cycle
AND pc_start_date >= from_dt
AND pc_start_date < to_dt
ORDER BY pc_start_date;

dr_tover	gltbs_gl_bal.dr_bal%TYPE := 0;
cr_tover	gltbs_gl_bal.dr_bal%TYPE := 0;
dr_tover_lcy	gltbs_gl_bal.dr_bal%TYPE := 0;
cr_tover_lcy	gltbs_gl_bal.dr_bal%TYPE := 0;
gl_dr_bal	gltbs_gl_bal.dr_bal%TYPE := 0;
gl_cr_bal	gltbs_gl_bal.dr_bal%TYPE := 0;
gl_dr_lcy	gltbs_gl_bal.dr_bal%TYPE := 0;
gl_cr_lcy	gltbs_gl_bal.dr_bal%TYPE := 0;

cur_gl		gltms_glmaster.gl_code%TYPE;
upd_cnt		integer;
sdt		date;
edt		date;

pgl		gltms_glmaster.parent_gl%TYPE;
leaf_flag	gltms_glmaster.leaf%TYPE;
categ		gltms_glmaster.category%TYPE;
cur_fin		sttms_branch.current_cycle%TYPE;
cur_per		sttms_branch.current_period%TYPE;
lStr		VARCHAR2(32000); -- USDFBME GURU Untanking Related
begin

	SELECT current_cycle, current_period into cur_fin, cur_per
	from sttms_branch
	WHERE branch_code = pm_branch;

	debug.pr_debug('AC','Select cur period');

	update gltbs_gl_bal
	set
		dr_bal = 0,
		cr_bal = 0,
		dr_bal_lcy = 0,
		cr_bal_lcy = 0,
		dr_mov = open_dr_mov,
		cr_mov = open_cr_mov,
		dr_mov_lcy = open_dr_mov_lcy,
		cr_mov_lcy = open_cr_mov_lcy,
            acy_today_tover_dr =0,
            lcy_today_tover_dr =0,
            acy_today_tover_cr =0,
            lcy_today_tover_cr =0
		where
		gl_code in (select gl_code from gltms_glmaster where customer = 'C') AND
		branch_code = pm_branch AND
		fin_year = cur_fin AND
		period_code = cur_per;
	debug.pr_debug('AC','zeros updated');

	for glrec in glbals loop

		debug.pr_debug('AC','Pre SELECT ' || glrec.bal_gl);

		begin

		SELECT decode(sttms_account_class.natural_gl_sign, 'D', sttms_cust_account.dr_gl, 
 								  'C', sttms_cust_account.cr_gl) tover_gl, 
					sum(decode(sttms_cust_account.ccy, global.lcy,0,acy_today_tover_dr)), 
					sum(decode(sttms_cust_account.ccy, global.lcy,0,acy_today_tover_cr)), 
				--KWDKFC MOVEMENTS INCORRECT sfr no 110 . dr_mov AND  CR_MOV ARE NON ZERO ONLY FOR 
				--FCY GL'S.COMMENTED THE 2 LINES BELOW
					--sum(acy_today_tover_dr), 
					--sum(acy_today_tover_cr), 
					sum(lcy_today_tover_dr), 
					sum(lcy_today_tover_cr) 
			into 		cur_gl, 
					dr_tover, 
					cr_tover, 
					dr_tover_lcy, 
					cr_tover_lcy
			from 		sttms_cust_account, 
					sttms_account_class
			WHERE 
					sttms_cust_account.branch_code = pm_branch AND
					sttms_cust_account.account_class = sttms_account_class.account_class AND
					decode(sttms_account_class.natural_gl_sign, 'D', sttms_cust_account.dr_gl, 'C', sttms_cust_account.cr_gl) = glrec.bal_gl AND
					sttms_cust_account.ccy = glrec.ccy
			group by 	decode(sttms_account_class.natural_gl_sign, 'D', sttms_cust_account.dr_gl, 'C', sttms_cust_account.cr_gl) ;

	debug.pr_debug('GL','DONE '||cur_gl|| 
					'DR' || TO_CHAR(dr_tover)|| 
					'CR' || TO_CHAR(cr_tover)||
					'DR lcy' || TO_CHAR(dr_tover_lcy)||
					'CR lcy' || TO_CHAR(cr_tover_lcy) );		
	exception
			when others then
				cur_gl := glrec.bal_gl;
				dr_tover := 0;
				cr_tover := 0;
				dr_tover_lcy := 0;
				cr_tover_lcy := 0;
		end;

		debug.pr_debug('AC','Select tur');
	/* USDFBME  - 140798 */

		debug.pr_debug('AC','GL = '||glrec.bal_gl);
		debug.pr_debug('AC','acy_bal = '||glrec.acy_bal);
		debug.pr_debug('AC','lcy_bal = '||glrec.lcy_bal);

		IF glrec.acy_bal <> 0  THEN
			IF glrec.acy_bal < 0 THEN
				gl_dr_bal := -glrec.acy_bal;
				gl_dr_lcy := -glrec.lcy_bal;
				gl_cr_bal := 0;
				gl_cr_lcy := 0;
			ELSE
				gl_cr_bal := glrec.acy_bal;
				gl_cr_lcy := glrec.lcy_bal;
				gl_dr_bal := 0;
				gl_dr_lcy := 0;
			END IF;
		ELSE
			IF glrec.lcy_bal < 0 THEN
				gl_dr_bal := -glrec.acy_bal;
				gl_dr_lcy := -glrec.lcy_bal;
				gl_cr_bal := 0;
				gl_cr_lcy := 0;
			ELSE
				gl_cr_bal := glrec.acy_bal;
				gl_cr_lcy := glrec.lcy_bal;
				gl_dr_bal := 0;
				gl_dr_lcy := 0;
			END IF;
		END IF;
	/* End of Addition */
/*
-- KWDKFC SFR No 38 added check for Lcy coz Lcy Bals report incorrect  
		if glrec.acy_bal <= 0 and glrec.lcy_bal <= 0 
		then
			gl_dr_bal := -glrec.acy_bal;
			gl_dr_lcy := -glrec.lcy_bal;
			gl_cr_bal := 0;
			gl_cr_lcy := 0;
		else
			gl_cr_bal := glrec.acy_bal;
			gl_cr_lcy := glrec.lcy_bal;
			gl_dr_bal := 0;
			gl_dr_lcy := 0;
		end if;
*/
	 	debug.pr_debug('AC','Breanch : ' || pm_branch);
	 	debug.pr_debug('AC','check upd or ins');
	 	debug.pr_debug('AC','Cr bal : ' || gl_cr_bal);
	 	debug.pr_debug('AC','Dr bal : ' || gl_dr_bal);
	 	debug.pr_debug('AC','Cr bal LCY : ' || gl_cr_lcy);
	 	debug.pr_debug('AC','Dr bal LCY : ' || gl_dr_lcy);

		UPDATE 	gltbs_gl_bal 
		set		dr_bal = dr_bal + gl_dr_bal,
				cr_bal = cr_bal + gl_cr_bal,
				dr_bal_lcy = dr_bal_lcy + gl_dr_lcy,
				cr_bal_lcy = cr_bal_lcy + gl_cr_lcy,
				uncollected = glrec.uncol_bal,
				dr_mov = open_dr_mov + dr_tover,
				cr_mov = open_cr_mov + cr_tover,
				dr_mov_lcy = open_dr_mov_lcy + dr_tover_lcy,
				cr_mov_lcy = open_cr_mov_lcy + cr_tover_lcy,
				acy_today_tover_dr =acy_today_tover_dr+dr_tover,
            		lcy_today_tover_dr =lcy_today_tover_dr+dr_tover_lcy,
		            acy_today_tover_cr =acy_today_tover_cr+cr_tover,
      		      lcy_today_tover_cr =lcy_today_tover_cr+cr_tover_lcy
				WHERE		branch_code = pm_branch AND
				gl_code = glrec.bal_gl AND
				ccy_code = glrec.ccy AND
				period_code = cur_per AND
				fin_year = cur_fin;

	 	debug.pr_debug('AC','post UPDATE');
		if SQL%NOTFOUND
		then
			SELECT 	parent_gl, 
					leaf, 
					category
			into 		pgl, 
					leaf_flag, 
					categ
			from 		gltms_glmaster
			WHERE 	gl_code = glrec.bal_gl;

			INSERT into gltbs_gl_bal (
			BRANCH_CODE,GL_CODE,CCY_CODE,FIN_YEAR,PERIOD_CODE,PARENT_GL,LEAF,
			CATEGORY,DR_MOV,CR_MOV,DR_MOV_LCY,CR_MOV_LCY,DR_BAL,CR_BAL,DR_BAL_LCY,
			CR_BAL_LCY,UNCOLLECTED,OPEN_DR_BAL,OPEN_CR_BAL,OPEN_DR_BAL_LCY,OPEN_CR_BAL_LCY,
			OPEN_DR_MOV,OPEN_CR_MOV,OPEN_DR_MOV_LCY,OPEN_CR_MOV_LCY,DR_MOV_OLD,CR_MOV_OLD,
			DR_MOV_LCY_OLD,CR_MOV_LCY_OLD,HAS_TOV,ACY_TODAY_TOVER_DR,LCY_TODAY_TOVER_DR,
			ACY_TODAY_TOVER_CR,LCY_TODAY_TOVER_CR)
			values
			(pm_branch, glrec.bal_gl, glrec.ccy, cur_fin, cur_per, pgl, leaf_flag, 
			 categ, dr_tover, cr_tover, dr_tover_lcy, cr_tover_lcy, gl_dr_bal, 
			 gl_cr_bal, gl_dr_lcy, gl_cr_lcy, glrec.uncol_bal, 0, 0, 0, 0, 0, 0, 0, 
			 0, 0, 0, 0, 0,'Y',dr_tover,dr_tover_lcy,cr_tover,cr_tover_lcy);

	 		debug.pr_debug('AC','post INSERT');

		end if;
	end loop;

	SELECT pc_start_date into edt from sttms_period_codes
	WHERE fin_cycle = cur_fin AND
	period_code = cur_per;	

	for accrec in past_acc(cur_fin, cur_per) loop

		debug.pr_debug('AC','Fin : ' || accrec.financial_cycle);
		debug.pr_debug('AC','Per : ' || accrec.period_code);
		debug.pr_debug('AC','GL : ' || accrec.acc_gl);

		SELECT pc_start_date into sdt from sttms_period_codes
		WHERE fin_cycle = accrec.financial_cycle AND
		period_code = accrec.period_code;	

		debug.pr_debug('AC','drcr : ' || accrec.drcr_ind);

		for past in past_per(sdt, edt) loop

			debug.pr_debug('AC','Fin : ' || past.financial_cycle);
			debug.pr_debug('AC','Per : ' || past.period_code);
			debug.pr_debug('AC','GL : ' || accrec.acc_gl);
			debug.pr_debug('AC','CCY : ' || accrec.ccy);
			debug.pr_debug('AC','Branch : ' || pm_branch);

			IF INSTR(lStr,accrec.acc_gl ||accrec.ccy) = 0 -- USDFBME GURU
			THEN			
			UPDATE gltbs_gl_bal
			set 
				dr_bal = open_dr_bal,
				cr_bal = open_cr_bal,
				dr_bal_lcy = open_dr_bal_lcy,
				cr_bal_lcy = open_cr_bal_lcy,
				dr_mov = open_dr_mov,
				cr_mov = open_cr_mov,
				dr_mov_lcy = open_dr_mov_lcy,
				cr_mov_lcy = open_cr_mov_lcy,
				dr_mov_old = 0,
				cr_mov_old = 0,
				dr_mov_lcy_old = 0,
				cr_mov_lcy_old = 0
			WHERE
				branch_code = pm_branch AND
				fin_year = past.financial_cycle AND
				period_code = past.period_code AND
				gl_code = accrec.acc_gl AND
				ccy_code = accrec.ccy;

			lstr:= accrec.acc_gl ||accrec.ccy; -- USDFBME GURU
			END IF; -- USDFBME GURU
			if accrec.drcr_ind = 'D'
			then

				debug.pr_debug('AC','UPDATE :  dr ' || accrec.fcy_amount );
				UPDATE gltbs_gl_bal
				set
					dr_bal = dr_bal + nvl(accrec.fcy_amount,0),
					dr_bal_lcy = dr_bal_lcy + accrec.lcy_amount,
					dr_mov_old = dr_mov_old + nvl(accrec.fcy_amount,0),
					dr_mov_lcy_old = dr_mov_lcy_old + accrec.lcy_amount
				WHERE
					branch_code = pm_branch AND
					fin_year = past.financial_cycle AND
					period_code = past.period_code AND
					gl_code = accrec.acc_gl AND
					ccy_code = accrec.ccy;
			end if;

			if accrec.drcr_ind = 'C'
			then
				debug.pr_debug('AC','UPDATE :  cr' );
				UPDATE gltbs_gl_bal
				set
					cr_bal = cr_bal + nvl(accrec.fcy_amount,0),
					cr_bal_lcy = cr_bal_lcy + accrec.lcy_amount
				WHERE
					branch_code = pm_branch AND
					fin_year = past.financial_cycle AND
					period_code = past.period_code AND
					gl_code = accrec.acc_gl AND
					ccy_code = accrec.ccy;
			end if;

		end loop;
	end loop;

--	commit;

	return (0);

exception
	when others then
		debug.pr_debug('AC',sqlerrm);
		debug.pr_debug('AC',sqlcode);
		return (1);
end;
begin

GLOBAL.pr_init('801','SYSTEM');
x:= fn_bal_cust_dly_log('801');

end;
/
