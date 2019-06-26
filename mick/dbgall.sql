
insert into cstb_Debug (module,debug)
select distinct module,'Y'
from cstb_debug_users u
where not exists (select 1 from cstb_debug d where d.module = u.module)
/
insert into cstb_Debug (module,debug)
select module_id ,'Y' from smtb_modules u
where not exists (select 1 from cstb_debug d where d.module = u.module_id)
/

insert into cstb_debug_users(module,debug,user_id)
select distinct module,'Y',user_id
from cstb_debug a,
     smtb_user b
where b.user_id not like 'SYS%'
and not exists (select 1 from cstb_debug_users u
where u.user_id = b.user_id and u.module = a.module)
/


