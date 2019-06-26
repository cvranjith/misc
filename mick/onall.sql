delete cstb_debug_Users;
insert into cstb_debug_Users select module,'Y',user_Id
from cstb_debug,smtb_user;

