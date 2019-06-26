CREATE OR REPLACE FUNCTION integertohex (n pls_integer)
   RETURN VARCHAR2
IS
BEGIN
   IF n > 0
   THEN
      RETURN integertohex (TRUNC (n / 16)) ||
             SUBSTR ('0123456789ABCDEF', MOD (n, 16) + 1, 1);
   ELSE
      RETURN NULL;
   END IF;
END integertohex;
/



