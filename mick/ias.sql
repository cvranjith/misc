select  ac_branch,
        cat,
        subcategory,
        sum(decode(drcr_ind,'D',-1,1)*lcy_amount) sum
from
(
select a.*,
(select subcategory from gltm_glmaster where gl_code =gl) subcategory
from
(
select  trn_Ref_no,
        ac_branch,
        ac_no,
        drcr_ind,
        ac_ccy,
        fcy_amount,
        lcy_amount,
        (decode(cust_gl,'G', ac_no,
 (select decode(sign(acy_curr_balance),-1,dr_gl,cr_gl) from sttms_cust_account where cust_ac_no = ac_no and branch_code = ac_branch))) gl,
        decode(category,'1','R','2','R','3','R','4','R','5','C','6','C','7','M','8','P','9','P') cat
from acvw_all_ac_entries
) a
)
group by ac_branch,subcategory,cat
/

