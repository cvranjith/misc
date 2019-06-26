
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
    if not clpkss_accr.fn_accr_for_an_account
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



