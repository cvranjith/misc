select 
substr(host_name, 1, length(host_name)) Host, 
substr(username, 1, length(username)) UserName
from v$instance, user_users
/
