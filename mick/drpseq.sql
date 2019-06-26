spool tmp.tmp
select 'drop sequence '||sequence_name||';' from user_sequences
where sequence_name like 'TRSQ%'
/
@tmp.tmp