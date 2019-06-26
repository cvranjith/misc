set trimspo on line 9999
col spofn new_value spofn form a20
select global_name||'.'||user spofn from global_name;
spo /tmp/&spofn..&1..log
