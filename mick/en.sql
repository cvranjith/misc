@storeset
set trimspool on pages 0 line 9999 feed off
spool tmp.tmp
SELECT 'ALTER TABLE '||TABLE_NAME||' enable CONSTRAINT '||CONSTRAINT_NAME||';'
FROM USER_CONSTRAINTS
where status = 'DISABLED';
SELECT 'ALTER trigger '||trigger_name||' ENABLE ;' from user_triggers where STATUS = 'DISABLED';
SPOOL OFF
@restoreset
