set serverout on size 1000000
select * from smtb_current_users
/

declare
u varchar2(100) := '&User';
begin
    for i in
        (
        select  user_id
        from    smtbs_current_users
        where   user_id = decode(u,'ALL',user_id,u)
        )
    loop
        if not  smpkss.fn_clear_users
            (
            i.user_id,
            '@',
            null
            )
        then
            raise_application_error(-20001,'error in smpkss.fn_clear_users');
        end if;
    end loop;
    commit;
end;
/



