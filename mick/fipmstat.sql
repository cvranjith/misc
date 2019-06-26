set line 9999
col time_difference form a30
col file_name form a50
col start_time form a20
col end_time form a20
select  to_char(start_time,'DD-MON-RRRR HH24:MI:SS') start_time,
        to_char(end_time,'DD-MON-RRRR HH24:MI:SS') end_time,
        decode(floor((end_time-start_time)*24),0,null,1,'1 Hour ', floor((end_time-start_time)*24)|| ' Hours ') ||
        decode(mod(floor((end_time-start_time)*24*60),60),0,null,1,'1 Minute ',mod(floor((end_time-start_time)*24*60),60)|| ' Minutes ') ||
        decode(mod(floor((end_time-start_time)*24*60*60),60),1,'1 Second',mod(floor((end_time-start_time)*24*60*60),60)|| ' Seconds') time_difference,
file_name from iftb_fipm_run_time where trunc(start_time) = trunc(sysdate)

/

