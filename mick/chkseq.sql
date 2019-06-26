set head off
spool seq.sql
select 'select '||sequence_name||'.nextval from dual;' from user_sequences;
spool off
@seq