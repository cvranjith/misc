@storeset
col value form a50
col name form a30
set line 9999
select name,value,isses_modifiable,issys_modifiable from v$parameter where lower(name) like nvl(replace(lower('%&par%'),' ','%'),'%')
/
@restoreset

