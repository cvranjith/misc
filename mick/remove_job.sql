begin
for i in (select job from dba_jobs where what like 'ifpks_aspa_upload%')
loop
dbms_job.remove(i.job);
end loop;
end;
/
