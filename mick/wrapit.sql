@storeset

set trimspo on pages 0 line 9999 feed off verify off echo off termout off

undef wrapped
col wrapped new_value wrapped

select  'Y'  wrapped
from    user_source a
where   lower(name) = lower('&1')
and	type in ('FUNCTION','PROCEDURE','PACKAGE BODY')
and     upper(text) like '%WRAPPED%'
and     line = 1;

spo /tmp/&1..unwr

select   decode(line,1,'CREATE OR REPLACE ',null)||rtrim(text,chr(10))
from     user_source a
where    lower(name) = lower('&1')
and	 type in ('FUNCTION','PROCEDURE','PACKAGE BODY')
and      nvl('&wrapped','N') = 'N'
order by line;

select '/' from dual where nvl('&wrapped','N') = 'N';

spo off

undef wrapped
@restoreset

!wrap iname=/tmp/&1..unwr oname=/tmp/&1..wrap
@/tmp/&1..wrap

