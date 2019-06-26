select 
 *
from
( 
select 
  a.ac_branch, 
  a.ac_no, 
  a.ac_ccy,
  sum(decode(a.drcr_ind,'D',-1,1)* a.lcy_amount) lcy_amount,
  (select lcy_bal from actb_vd_Bal sa
   where
     sa.brn=a.ac_branch
     and sa.acc=a.ac_no
     and sa.ccy=a.ac_ccy 
     and sa.val_dt = (select max(wsa.val_dt) from actb_vd_bal wsa 
        where wsa.brn=sa.brn and wsa.acc=sa.acc and wsa.ccy=sa.ccy and wsa.val_dt<= 
	(select today from sttms_dates where branch_code = sa.brn)
)) lcy_bal_val_dt 
from 
  acvw_all_ac_entries  a
where
  a.value_dt<= 	(select today from sttms_dates where branch_code = a.ac_branch)
and auth_stat = 'A'
group by
  a.ac_branch, a.ac_no, a.ac_ccy  
) a
where
  lcy_amount<>lcy_bal_val_dt
/
