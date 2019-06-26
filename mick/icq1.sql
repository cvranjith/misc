select count(1), next_accr_dt, next_calc_dt, next_liq_dt from
ictb_acc_pr
group by next_accr_dt, next_calc_dt, next_liq_dt
/
