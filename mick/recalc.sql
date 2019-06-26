
declare
    l_acc           varchar2(200) := '&acc';
    l_brn           varchar2(100) := substr(l_acc,1,3);
    l_dt            date;
    l_err_code      varchar2(255);
    l_err_param     varchar2(255);
begin
    global.pr_init(l_brn, 'SYSTEM');
    l_dt := global.application_date;
    clpkss_batch.g_commit_freq := 1000;
    update cltb_account_master
    set calc_reqd = 'Y',
    recalc_action_code = 'E'
    where branch_code = l_brn AND ACCOUNT_NUMBER = l_acc
	returning value_date into l_dt;
    if not clpkss_recalc.fn_recalc_for_an_account
                (
                  l_acc
                , l_brn
                , l_dt
                , l_err_code
                , l_err_param
                )
    then
                raise_application_error(-20001,'failure ' || l_err_code||':'||l_err_param);
    end if;
end;
/


