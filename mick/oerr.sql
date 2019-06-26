ACCEPT l1 PROMPT 'Error code: ';
VAR msg VARCHAR2(256)
execute :msg := SQLERRM(-&l1);
PRINT msg 