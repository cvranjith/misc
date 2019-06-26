BEGIN
FOR Q IN
(
select * from mstm_adv_format_det where format_line is not null
)
LOOP
DECLARE
X VARCHAR2(1000) := Q.FORMAT_LINE;
B BOOLEAN := FALSE;
TG VARCHAR2(1000);
BEGIN
FOR I IN 1.. LENGTH(X)
LOOP
    IF SUBSTR(X,I,1) = '_'
    THEN
        IF B THEN B := FALSE;
        --DBMS_OUTPUT.PUT_LINE('TAG '||TAG);
        INSERT INTO TAGS VALUES (Q.FORMAT,TG);
        TG := NULL;
        ELSE B := TRUE; END IF;
    END IF;
    IF B THEN 
        TG := TG||SUBSTR(X,I,1);
    END IF;
END LOOP;
END;
END LOOP;
END;
/
