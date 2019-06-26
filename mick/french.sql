select sum(decode(drcr_ind,'D',-1,1)*lcy_amount),
trn_Ref_no,subc
from
(
select a.*
,
(select subcategory from gltm_glmaster where gl_Code =gl) subc
from
(
select ac_no,drcr_ind,ac_ccy,lcy_amount,trn_ref_no,
decode(cust_gl,'G',ac_no, (select dr_gl from sttm_cust_account where cust_ac_no = ac_no and branch_code = ac_branch) )gl
from actb_daily_log
where ac_branch = 'ACU'
and delete_stat != 'D'
) a
)
group by trn_ref_no,subc
having sum(decode(drcr_ind,'D',-1,1)*lcy_amount) != 0
/
