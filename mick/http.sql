
declare
    l_file_name varchar2(100) := '&1';
    l_debug     varchar2(100) := lower('&2');
    l_file      utl_file.file_type;
    l_line      varchar2(32767);
    l_num       number := 0;
    l_tb_err    cspks_http_upload.tb_err;
    l_cols      varchar2(32767) :=  'branch_code~batch_no~instrument_no~fin_cycle~period_code~rel_cust~addl_text~'||
                                    'txn_mis_1~txn_mis_2~related_account~ccy_cd~initiation_date~amount~account~'||
                                    'account_branch~txn_code~dr_cr~lcy_equivalent~exch_rate~value_date~external_ref_no~'||
                                    'field_val_1~field_val_2~field_val_3~field_val_4~field_val_5~field_val_6~field_val_7~'||
                                    'field_val_8~field_val_9~field_val_10~field_val_11~field_val_12~field_val_13~'||
                                    'field_val_14~field_val_15~field_val_16~field_val_17~field_val_18~field_val_19~field_val_20~'||
                                    'field_val_21~field_val_22~field_val_23~field_val_24~field_val_25~field_val_26~field_val_27~'||
                                    'field_val_28~field_val_29~field_val_30';
    procedure pr_chk_err
    is
        l_err   varchar2(32767) := chr(10);
    begin
        if l_tb_err.count > 0
        then
            for i in l_tb_err.first .. l_tb_err.last
            loop
                l_err := l_err||'['||l_tb_err(i).curr_no||']['||l_tb_err(i).flds||']'||l_tb_err(i).err_code||'-'||l_tb_err(i).err||chr(10);
            end loop;
            raise_application_error(-20001,l_err);
        end if;
    end;
begin
    global.pr_init(global.head_office,'SYSTEM');
    if l_debug = 'debug'
    then
        debug_addon.pr_dbg_on;
        debug_addon.pr_set_log_file
          (
         'TMP',
          to_char(sysdate,'YYYY-MM-DD')||'_FLC_SQL_'||nvl(cspks_os_param.get_param_val('SITE_COUNTRY'),substr(user,-3))||'_DAH_EXPENSES.log'
          );
    end if;
    l_file := utl_file.fopen('WORK_AREA',l_file_name,'r',32767);
    begin
        loop
            utl_file.get_line(l_file,l_line);
            if l_num > 0 and trim(l_line) is not null
            then
                cspks_http_upload.pr_ins_det(replace(l_line,'"'),l_cols,l_num,',','DE',l_tb_err);
                pr_chk_err;
            end if;
            l_num := l_num + 1;
        end loop;
    exception
        when no_data_found
        then
            utl_file.fclose(l_file);
            cspks_http_upload.pr_batch_upload(l_tb_err,'Y');
            pr_chk_err;
    end;
    commit;
end;
/




