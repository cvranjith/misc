declare
j number;
begin
dbms_job.submit(j, 'ifpks_aspa_upload.pr_upload;', INTERVAL => 'SYSDATE+(1/24/60)');
end;
/
