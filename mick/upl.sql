declare
    e varchar2(1000);
    p varchar2(1000);
begin
    global.pr_init('904','SYSTEM');
    if not stpks_cust_upload.fn_stupload
        (
        'CONVERSION',
        e,
        p
        )
    then
        raise_application_error(-20001,'failed in stpks_cust_upload.fn_stupload '||e||' -> '||p);
    end if;
end;
/

