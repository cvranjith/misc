begin
for i in (select branch_code from sttm_branch where record_stat= 'O')
loop
eipks_misc.pr_pre_eod(i.branch_code);
end loop;
end;
/
