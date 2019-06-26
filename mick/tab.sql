UNDEF TNAME

set verify off
select tname from tab where tname like REPLACE(upper('%&TNAME%'),' ','%')
and tabtype = 'TABLE'
/
set verify on

UNDEF TNAME
