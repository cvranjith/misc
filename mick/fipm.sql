
drop table tmp_fipm;
create table tmp_fipm as select * from iftm_fipm_files_maint;
delete iftm_fipm_files_maint where file_name != '&FILE_NAME';
declare
l_err VARCHAR2(1000);
begin
global.pr_init(global.head_office,'SYSTEM');
ifpks_extract.pr_extract('FIPM',l_err);
if l_err is not null then raise_application_error(-20001,'Err '||l_err); end if;
END;
/
delete iftm_fipm_files_maint;
insert into iftm_fipm_files_maint select * from tmp_fipm;
drop table tmp_fipm;

