undefine num
set verify off
accept num number prompt 'Enter the number ==> '
select decode( sign( &num ), -1, 'Negative ', 0, 'Zero', NULL ) ||
       decode( sign( abs(&num) ), +1, to_char( to_date( abs(&num),'J'),'Jsp') ) words
from dual
/
undefine num
