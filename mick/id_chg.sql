
store set /tmp/store.set
set trimspo on pages 0 line 9999  feed off termout off
spo /tmp/tmp.tmp
select distinct 'alter table '||table_name ||' disable all triggers;' from user_triggers a
where exists (select 1 from cols b where column_name in 
            (
            'COD_USER',
            'COD_USERID',
            'COD_USER_ID',
            'CUBE_USER_ID',
            'FC_USER',
            'LOG_USER',
            'USERID',
            'USER_ID',
            'USER_ID1',
            'USER_ID2',
            'MAKER',
            'MAKERID',
            'MAKER_ID',
            'VW_MAKER_ID',
            'CHECKER',
            'CHECKERID',
            'CHECKER_ID',
            'CHECKER_ID1',
            'CHECKER_ID2',
            'COD_CHECKER',
            'GI_CHECKER_ID',
            'AUTH_ID',
            'LAST_AUTH_ID',
            'ONLINE_AUTH_ID',
            'AUTH_BY'
            )
            and a.table_name = b.table_name
            );
spo off
@/tmp/store.set
@/tmp/tmp.tmp
set serverout on size 1000000
spo id_chg.log
declare
procedure p
    (
    p_old_id varchar2,
    p_new_id varchar2,
    p_pwd in varchar2
    )
is
    l_sql       varchar2(1000);
    l_cnt       number;
begin
    dbms_output.put_line(p_old_id||'=>'||p_new_id);
    if p_old_id is null or p_new_id is null or length(p_new_id) > 12
    then
        raise_application_error(20001,'Invalid id '||p_old_id||' : '||p_new_id);
    end if;
    select count(1)
    into   l_cnt
    from   smtb_user
    where  user_id = p_new_id;
    if l_cnt > 0
    then
        return;
    end if;
    delete SMTB_PASSWORD_HISTORY where user_id in (p_old_id,p_new_id);
    for i in 
        (
        select  a.table_name,
                a.column_name
        from    cols a,user_tables b
        where   a.table_name = b.table_name
        and     column_name in
            (
            'COD_USER',
            'COD_USERID',
            'COD_USER_ID',
            'CUBE_USER_ID',
            'FC_USER',
            'LOG_USER',
            'USERID',
            'USER_ID',
            'USER_ID1',
            'USER_ID2',
            'MAKER',
            'MAKERID',
            'MAKER_ID',
            'VW_MAKER_ID',
            'CHECKER',
            'CHECKERID',
            'CHECKER_ID',
            'CHECKER_ID1',
            'CHECKER_ID2',
            'COD_CHECKER',
            'GI_CHECKER_ID',
            'AUTH_ID',
            'LAST_AUTH_ID',
            'ONLINE_AUTH_ID',
            'AUTH_BY'
            )

        and     data_type like '%CHAR%'
        )
    loop
        l_sql := 'begin update '||i.table_name||' set '||i.column_name||'=:1 where '||i.column_name||'=:2;end;';
        execute immediate l_sql using upper(p_new_id),upper(p_old_id);
    end loop;
    if p_pwd is not null
    then
        update smtb_user set user_password = smpks.fn_encrypt_password(upper(p_pwd),user_id),force_passwd_change=1 where user_id = upper(p_new_id);
    end if;
end;
begin
p('BOURGEOISMA','MBOURGEOIS','PASSWORD');
p('ALDINGERAU','AALDINGER','PASSWORD');
p('MOUGENEZVI','VMOUGENEZ','PASSWORD');
p('BRAJZBLATVA','VBRAJZBLAT','PASSWORD');
p('MARIOUEL','EMARIOU','PASSWORD');
p('JAQUESVI','VJAQUES','PASSWORD');
p('DEBENEDETJO','JDEBENEDETTO','PASSWORD');
p('MEDAGLIACA','CMEDAGLIA','PASSWORD');
p('THOUMIEUXJA','JTHOUMIEUX','PASSWORD');
p('BOUCHERJA','JBOUCHER','PASSWORD');
p('TANGEI','ETANG','PASSWORD');
p('DIBENEDETJO','JDIBENEDETTO','PASSWORD');
p('BOURGEOIS2','MBOURGEOIS2','PASSWORD');
p('BOURGEOIS3','MBOURGEOIS3','PASSWORD');
p('MEDAGLIA2','CMEDAGLIA2','PASSWORD');
p('MEDAGLIA3','CMEDAGLIA3','PASSWORD');
p('ARMANDNI','NARMAND','PASSWORD');
p('ALDINGER2','AALDINGER','PASSWORD');
p('DAUBINSSE','SDAUBINS','PASSWORD');
p('MONORYST','SMONORY','PASSWORD');
p('DAUBINSSE2','SDAUBINS2','PASSWORD');
p('ARMANDNI2','NARMAND2','PASSWORD');
p('MONORYST2','SMONORY2','PASSWORD');
p('BRAJZBLATV2','VBRAJZBLAT2','PASSWORD');
p('LERAYVI','VLERAY','PASSWORD');
p('ALDINGERAU2','AALDINGER3','PASSWORD');
p('AUDIBERTLO','LAUDIBERT','PASSWORD');
p('TRANTH','TTRAN','PASSWORD');
p('WALTERJE','JWALTER','PASSWORD');
p('SAMEESA','SSAMEE','PASSWORD');
p('GODARTVI','VGODART','PASSWORD');
p('SAMEE2','SSAMEE2','PASSWORD');
end;
/
set trimspo on pages 0 line 9999  feed off termout off
spo /tmp/tmp.tmp
select distinct 'alter table '||table_name ||' enable all triggers;' from user_triggers where status = 'DISABLED';
spo off
@/tmp/store.set
@/tmp/tmp.tmp

