select name, type, dependency_type from user_dependencies
where REFERENCED_NAME = upper('&object')
/
