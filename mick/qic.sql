select count(1), next_accr_dt, next_calc_dt from
ictb_acc_pr
group by next_accr_dt, next_calc_dt
/
select count(1) from ictbs_is_vals
where frm_dt = (select today from sttm_dates)
/
