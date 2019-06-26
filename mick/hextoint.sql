CREATE OR REPLACE FUNCTION hextointeger (h VARCHAR2)
   RETURN PLS_INTEGER
IS
BEGIN
   IF NVL (LENGTH (h), 1) = 1
   THEN
      RETURN INSTR ('0123456789ABCDEF', h) - 1;
   ELSE
      RETURN 16 * hextointeger (SUBSTR (h, 1, LENGTH (h) - 1)) +
             INSTR ('0123456789ABCDEF', SUBSTR (h, -1)) -
             1;
   END IF;
END hextointeger;
/

