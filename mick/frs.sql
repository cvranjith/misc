set termout off
create table frs_tmp as select * from iftm_report_files_maint where rownum = 0;
set termout on
declare
l_err varchar2(1000);
begin
delete frs_tmp;
insert into frs_tmp select * from iftm_report_files_maint;
delete iftm_report_files_maint where file_name != '&FILE';
global.pr_init(global.head_office,'SYS');
ifpks_extract.pr_extract('FRSASIA',l_err);
delete iftm_report_files_maint;
insert into iftm_report_files_maint select * from frs_tmp; 
commit;
if l_err is not null then raise_application_error(-20001,'er - '||l_err); end if;
end;
/
