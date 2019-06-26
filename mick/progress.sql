
set line 9999
col reason form a30
col elapsed form a30
col process form a10
col start_time form a20
col end_time form a20
select  esn,
        to_char(starttime,'DD-MON-RRRR HH24:MI:SS') start_time,
        to_char(endtime,'DD-MON-RRRR HH24:MI:SS') end_time,
        decode(floor((nvl(endtime,sysdate)-starttime)*24),0,null,1,'1 Hour ', floor((nvl(endtime,sysdate)-starttime)*24)|| ' Hours ') ||
        decode(mod(floor((nvl(endtime,sysdate)-starttime)*24*60),60),0,null,1,'1 Minute ',mod(floor((nvl(endtime,sysdate)-starttime)*24*60),60)|| ' Minutes ') ||
        decode(mod(floor((nvl(endtime,sysdate)-starttime)*24*60*60),60),1,'1 Second',mod(floor((nvl(endtime,sysdate)-starttime)*24*60*60),60)|| ' Seconds') elapsed,
branch,process,status,errcode,reason from aetb_process_progress order by endtime,starttime
/

