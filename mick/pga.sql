select name, decode(unit,'bytes', round(value/1024/1024),value) v, decode(unit,'bytes','MB',unit) u from v$pgastat
/
