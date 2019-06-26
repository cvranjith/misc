set verify off
define Prompt = "SQL> "
column prompt new_value Prompt

--set termout off
select
  user || '@' || instance_name || '>' prompt
from
  sys.v_$instance
/
set termout on
set sqlprompt "&Prompt"

set feedback 1
clear buffer
set line 100
clear screen
