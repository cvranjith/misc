                            set linesize 9999  pages 0 trimout on

                         
                         
                         
                        select listagg                                 (chr(27)
                    ||decode(substr(l,c, 1)                    ,' ',          '[0m',
                '[48;5;'||      ((c*r)-1)||'m')              || substr(l,c,1))  within 
             group (order        by r,c) ||chr(27)         ||'[0m' from         (select r, 
           replace(l,'#',         decode((mod(r,2))       ,0,'>' ,'<'))           l from(select 
          r,rpad(rpad             (' ',5,' ')||          rpad (' ',               (a-1),' ')
          ||rpad('#',             (b-a),'#')||          rpad(' ' ,                   (c-b),' ') 
                                   ||rpad ('#',(d       -c),'#')||                     rpad (' ',
                                   (e-d),' ')         ||rpad('#',                      (f- e),'#'),100
                                  ,' ')l from         (select  r,                        substr(x,1,2)                     
                                  a, substr(x,       3,2)b,substr                         (x,5,2) c,
                                 substr(x,7,         2) d,substr                           (x,9,2) e,
                                 substr(x,          11,    2)                               f  from  (
                                select              rownum r,                               column_value
                               x   from             table(sys.                             odcivarchar2list
                            ( '5261' ,              '10174965' ,                           '07204'||'671',
                           '05091722'||             '447'||'4',                            '0'|| '30'||
                        '718244276'                  ,'0206192'||                         '53979','010'
                      ||'518243680'                   ,'19243581',                        '16223484' ,
                      '14203385',                      '12183286' ,                     '09153088',
                    '071330657089',                    '061229637289',                 '04102961'
                    ||'7390','03'                       ||'0929617'||                 '289','0107'
                  ||'29627188',                           '020730646986',         '0208'||'142632'
               ||'83','03263'                                ||'680','05264078','4175','4571' ,
               '4'||'8'||'6'||'7','5'||'462')                     ) ) ) ) ) a, ( select
               rownum c from dual connect by 
               level <  =  100  ) group by r;

			   