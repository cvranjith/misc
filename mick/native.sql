SELECT 'ALTER PACKAGE '||OBJECT_NAME||' COMPILE;' fROM user_stored_settings where param_name = 'plsql_compiler_flags'
and param_value = 'INTERPRETED,NON_DEBUG'
and object_type = 'PACKAGE'
and object_name not like '%#%'
/
