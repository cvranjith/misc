create table tb_branch_change (table_name varchar2(50),column_name varchar2(50),column_value varchar2(1000))
/

delete sttm_branch where branch_Code != '868'
/


column old_brn new_value old_brn
select branch_code old_brn from sttms_branch;
undef new_brn new_lcy

accept new_brn char prompt 'Enter the new Branch code ==> '
accept new_lcy char prompt 'Enter the new Local Currency code ==> '

declare
    l_sql       varchar2(1000);
begin
    for i in 
        (
        select  a.table_name,
                a.column_name
        from    cols a,user_tables b
        where   a.table_name = b.table_name
        and     (column_name like '%BRANCH%' or column_name like '%BRN%' or column_name like '%ACC_BR%' or column_name in ('BR_CODE','LIAB_BR'))
        and     data_type like '%CHAR%'
        )
    loop
        l_sql := 'insert into tb_branch_change select distinct '||chr(39)||i.table_name||chr(39)||','||chr(39)||i.column_name||chr(39)||','||i.column_name||' from '||i.table_name||' where '||i.column_name||' is not null';
        execute immediate l_sql;
        if sql%rowcount > 0
        then
            l_sql := 'begin update '||i.table_name||' set '||i.column_name||'=''&new_brn'' where '||i.column_name||'=''&old_brn'';end;';
            execute immediate l_sql;	
        end if;
    end loop;
end;
/

update sttms_branch set  parent_branch='&new_brn',regional_office='&new_brn',clearing_brn='&new_brn',pc_clearing_brn='&new_brn',branch_lcy = '&new_lcy'
/
update smtbs_parameters set head_office='&new_brn'
/
update sttms_bank set ho_branch = '&new_brn',bank_lcy = '&new_lcy'
/

update sttm_customer set local_branch = '&new_brn',liab_br = '&new_brn'
/
update sttm_branch set swift_addr ='XXXXXXXX';

delete smtb_user_role where branch_code != '&new_brn';
delete CSTM_PROD_BRN_DISALLOW where branch_disallow = '&new_brn';

