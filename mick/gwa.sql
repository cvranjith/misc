select global.work_area from dual WHERE INSTR(GLOBAL.WORK_AREA,'/',1) != 0 or INSTR(GLOBAL.WORK_AREA,'\',1) != 0
UNION
SELECT DIRECTORY_PATH ||chr(10)||CHR(10)||'** Oracle Directory '||global.work_area||' has been used '
FROM ALL_DIRECTORIES WHERE DIRECTORY_NAME = GLOBAL.WORK_AREA
/

