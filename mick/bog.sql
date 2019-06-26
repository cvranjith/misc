undef table_owner read_only_schema
set pages 0 line 9999 trimspo on
spo tmp.tmp
select 'grant select on '||table_owner||'.'||synonym_name||' to &&read_only_role ;'
from all_synonyms a
where a.table_owner = '&&table_owner'
and exists (select 1 from all_objects b where b.owner = a.table_owner and b.object_type in ('TABLE','VIEW'))
union all
select 'grant select on '||owner||'.'||object_name||' to &&read_only_role ;'
from all_objects
where owner = '&&table_owner'
and object_type in ('TABLE','VIEW')
/
spo off
--@tmp.tmp
/
