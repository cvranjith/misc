with acvw_bal_rebuild as
 (select ac_branch,
         ac_no,
         ac_ccy,
         sum(decode(drcr_ind, 'D', -1, 1) * nvl(lcy_amount, 0)) lcy_amount,
         sum(decode(drcr_ind, 'D', -1, 1) * nvl(fcy_amount, 0)) fcy_amount
    from acvw_all_ac_entries
   where balance_upd = 'U'
   group by ac_no, ac_branch, ac_ccy),
acvw_gl_bal_rebuild as
 (select a.ac_branch branch_code,
         a.ac_no gl_code,
         a.ac_ccy ccy_code,
         c.current_cycle fin_year,
         c.current_period period_code,
         b.parent_gl,
         b.leaf,
         b.category,
         nvl(a.fcy_amount, 0) fcy_bal,
         nvl(a.lcy_amount, 0) lcy_bal
    from acvw_bal_rebuild a, gltms_glmaster b, sttms_branch c
   where a.ac_no = b.gl_code
     and a.ac_branch = c.branch_code
     and (b.category not in ('3', '4') or
         (b.category in ('3', '4') and a.ac_ccy != c.branch_lcy))
  union all
  select a.ac_branch branch_code,
         a.ac_no gl_code,
         c.branch_lcy ccy_code,
         c.current_cycle fin_year,
         c.current_period period_code,
         b.parent_gl,
         b.leaf,
         b.category,
         0,
         sum(a.lcy_amount) lcy_bal
    from acvw_bal_rebuild a, gltms_glmaster b, sttms_branch c
   where a.ac_no = b.gl_code
     and a.ac_branch = c.branch_code
     and b.category in ('3', '4')
   group by a.ac_branch,
            a.ac_no,
            c.branch_lcy,
            c.current_cycle,
            c.current_period,
            b.parent_gl,
            b.leaf,
            b.category),
acvw_bal_mismatch as
 (select *
    from (select 'A' ac_or_gl,
                 c.current_cycle fin_year,
                 c.current_period period_code,
                 a.branch_code,
                 a.cust_ac_no ac_gl_no,
                 a.ccy,
                 nvl(a.acy_curr_balance, 0) acy_bal_t,
                 nvl(a.lcy_curr_balance, 0) lcy_bal_t,
                 nvl(decode(a.ccy, c.branch_lcy, b.lcy_amount, b.fcy_amount),
                     0) acy_bal_r,
                 nvl(b.lcy_amount, 0) lcy_bal_r,
                 a.rowid rid
            from sttms_cust_account a, acvw_bal_rebuild b, sttms_branch c
           where a.cust_ac_no = b.ac_no(+)
             and a.branch_code = b.ac_branch(+)
             and a.branch_code = c.branch_code
          union all
          select 'G',
                 b.fin_year,
                 b.period_code,
                 b.branch_code,
                 b.gl_code,
                 b.ccy_code,
                 nvl(b.cr_bal, 0) - nvl(b.dr_bal, 0) acy_bal_t,
                 nvl(b.cr_bal_lcy, 0) - nvl(b.dr_bal_lcy, 0) lcy_bal_t,
                 nvl(a.fcy_bal, 0) acy_bal_r,
                 nvl(a.lcy_bal, 0) lcy_bal_r,
                 b.rowid rid
            from acvw_gl_bal_rebuild a,
                 gltb_gl_bal         b,
                 sttm_branch         c,
                 gltms_glmaster      d
           where a.gl_code(+) = b.gl_code
             and a.branch_code(+) = b.branch_code
             and a.ccy_code(+) = b.ccy_code
             and a.fin_year(+) = b.fin_year
             and a.period_code(+) = b.period_code
             and b.fin_year = c.current_cycle
             and b.period_Code = c.current_period
             and b.branch_code = c.branch_code
             and d.gl_code = b.gl_code
             and d.customer = 'I'
             and b.leaf = 'Y')
   where (acy_bal_t != acy_bal_r or lcy_bal_t != lcy_bal_r))
select * from acvw_bal_mismatch;