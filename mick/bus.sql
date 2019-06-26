

select  distinct  trn_ref_no
from
(
select
trn_ref_no,
bopks.FN_MIS_VAL
                     (
                     'BUSLINE',
                     eachrec.trn_ref_no,
                     eachrec.cust_gl,
                     eachrec.ac_no,
                     eachrec.ac_branch,
                     eachrec.related_Reference,
                     eachrec.related_account,
                     eachrec.related_customer
                     ) bus
from acvw_all_ac_entries eachrec
where event != 'REVL'
and trn_Ref_no not like '%ACPO%'
)
where bus is null
/

