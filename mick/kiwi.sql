set colsep |;
set line 9999;
ALTER SESSION SET NLS_LANGUAGE='AMERICAN';
declare
    p_brn                       varchar2(3) := '&1';
    p_source_code               detbs_upload_master.source_code%TYPE:= 'EXCEL';
    p_batch_no                  detbs_batch_master.batch_no%TYPE:= '&2';
    p_mis_required              detbs_upload_master.mis_required%TYPE;
    p_auto_auth                 detbs_upload_master.auto_auth%TYPE;
    p_udf_upload_reqd           detbs_upload_master.batch_no%TYPE;
    p_gl_offset_entry_reqd      detbs_upload_master.gl_offset_entry_reqd%TYPE;
    p_txn_code                  detbs_upload_master.txn_code%TYPE;
    p_offset_gl                 detbs_upload_master.offset_gl%TYPE;
    p_total_ent                 number;
    p_errcode                   ertbs_msgs.err_code%type;
    p_errdata                   varchar2(255);
    p_ent_uploaded              number;
    p_ent_rejected              number;
    p_user                      varchar2(12):='SYSTEM';
    p_position_reqd             varchar2(1);
    type l_ty_err               is table of detb_upload_exceptions%rowtype index by binary_integer;
    l_tb_err                    l_ty_err;
    l_cnt                       number;
begin
if upper('&3') = 'DEBUG'
then
    debug_addon.pr_log_on;
    debug_addon.pr_set_log_file
       (
       'KIWI_LOG_PATH',
        to_char(sysdate,'YYYY-MM-DD')||'_FLC_SQL_'||nvl(cspks_os_param.get_param_val('SITE_COUNTRY'),substr(user,-3))||'_KIW_UPLOAD_DEBUG.log'
        );
end if;
global.pr_init(p_brn,p_user);
select  count(1)
into    l_cnt
from    actbs_daily_log
where   substr(trn_ref_no,1,3) = p_brn
and     delete_stat != 'D'
and     batch_no = p_batch_no;
if l_cnt != 0
then
    raise_application_error (-20001,'Batch Number '||p_batch_no||' has been used already in branch '||p_brn);
end if;
update
(
select txn_mis_2,field_val_50
from detbs_upload_detail a,udtbs_upload_detail b
where a.branch_code = b.branch_code
and a.batch_no = b.batch_no
and a.curr_no =b.curr_no
and a.source_code = b.source_code
and field_val_50 is not null
and a.batch_no = p_batch_no
and a.branch_code = p_brn
)
set txn_mis_2 = field_val_50;
delete detbs_upload_master where batch_no = p_batch_no and branch_code = p_brn;
delete detbs_batch_master where batch_no = p_batch_no and branch_code = p_brn;
delete detbs_upload_exceptions where batch_no = p_batch_no and branch_code = p_brn;
p_mis_required                  := 'Y';
p_auto_auth                     := 'Y';
p_udf_upload_reqd               := 'Y';
p_gl_offset_entry_reqd          := 'N';
p_txn_code                      := 'OTH';
p_position_reqd                 := 'Y';
insert into detbs_upload_master
        (
        branch_code,
        source_code,
        batch_no,
        balancing,
        batch_desc,
        mis_required,
        auto_auth,
        gl_offset_entry_reqd,
        udf_upload_reqd,
        txn_code,
        user_id,
        upload_stat,
        position_reqd,
        upload_date,
        upload_file_name
        )
values
        (
        p_brn,
        'EXCEL',
        p_batch_no,
        --EURNSG 07-JAN-2010 START
        /*
        'N',
        */
        'Y',
        --EURNSG 07-JAN-2010 END
        'GEAC_AUTOMATIC_UPLOAD_'||to_char(SYSDATE,'DD-MM-YYYY HH24:MI:SS'),
        p_mis_required,
        p_auto_auth,
        p_gl_offset_entry_reqd,
        p_udf_upload_reqd,
        p_txn_code,
        p_user,
        'N',
        p_position_reqd,
        global.application_date,
        'GEAC_AUTOMATIC_UPLOAD_'||SYSDATE
        );
debug.pr_debug('DE','First debug msg' );
commit;
savepoint deupload ;
if not depkss_upload.fn_batch_upload
    (
    global.current_branch,
    global.application_date,
    global.user_id,
    p_batch_no,
    p_source_code,
    'N',
    global.lcy,
    global.lang,
    p_mis_required,
    p_auto_auth,
    p_udf_upload_reqd,
    p_gl_offset_entry_reqd,
    p_txn_code,
    p_offset_gl,
    p_total_ent,
    p_ent_uploaded,
    p_ent_rejected,
    p_errcode,
    p_errdata
    )
then
    debug.pr_debug ('DE','Failed in DE Batch Upload');
    debug.pr_debug ('DE','Error '||p_errcode);
    for i in (select * from detbs_upload_exceptions where batch_no = p_batch_no and branch_code = p_brn)
    loop
        l_tb_err(l_tb_err.count+1) := i;
    end loop;
    rollback to deupload;
    if l_tb_err.count > 0
    then
        delete detbs_upload_exceptions where batch_no = p_batch_no and branch_code = p_brn;
        for i in l_tb_err.first .. l_tb_err.last
        loop
            insert into detbs_upload_exceptions values l_tb_err(i);
        end loop;
        commit;
    end if;
    raise_application_error (-20001,'Error in DE Upload '||p_errcode||' :: '||p_errdata);
end if;
commit;
end;
/


