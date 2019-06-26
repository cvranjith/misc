select otype, mth, count(*)
from (select object_type otype, object_id oid, to_char(CREATED,'mmyyyy [MON-YYYY]') mth
from user_objects) akp1
group by cube(otype, mth)
having (otype is not null and mth is not null)
order by 2
/
