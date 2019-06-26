
drop table tmp_fipm;
create table tmp_fipm as select * from iftm_fipm_files_maint;
delete iftm_fipm_files_maint where file_name != '&FILE_NAME';

declare
e varchar2(10000);
begin
ifpks_extract.pr_extract('FIPM',e);
if e is not null then raise_application_error(-20001,'Err '||e); end if;
end;
/

delete iftm_fipm_files_maint;
insert into iftm_fipm_files_maint select * from tmp_fipm;

