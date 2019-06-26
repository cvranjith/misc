
declare
d date;
l_seperator			CHAR(1) := ' ' ;
procedure p(p_dt in date)
is
l_record_line varchar2(10000);
l_output_file utl_file.file_type;
function fn_cust(p_cust in varchar2)
return varchar2 is
l_cust  varchar2(100) := p_cust;
begin
    if p_cust like 'V%'
    then
        l_cust := '999999';
    end if;
    return l_cust;
end;
begin
l_output_file := utl_file.fopen
(
global.work_area,
'INCOME_AND_EXPENSE_YEARLY_' || TO_CHAR(p_dt,'YYYYMMDD')||'_'||to_char(sysdate,'DDMMYYYYHH24MISS') || '.' || 'DAT',
'w',32767);
				FOR rep IN ( SELECT ac_branch,
							  substr(trn_ref_no, 4, 4) product_code,
							  trn_code,
							  value_dt,
							  ac_no,
							  ac_ccy,
                              -- DBSLONDON 20/FEB/04 START
							  --related_customer,
                              NVL(related_customer,c.walkin_customer) related_customer,
                              -- DBSLONDON 20/FEB/04 END
							  b.country,
							  b.exposure_country,
							  nationality,
							  sum(decode(drcr_ind, 'D', -1, 1)*fcy_amount) fcy_amount,
							  sum(decode(drcr_ind, 'D', -1, 1)*lcy_amount) lcy_amount
						   FROM acvws_all_ac_entries a, sttms_customer b
                           -- DBSLONDON 20/FEB/04 START
                           ,sttm_branch c
                           -- DBSLONDON 20/FEB/04 END
						  WHERE category in ( '3', '4' )
						    --AND value_dt between l_year_start_date and l_year_end_date
                            -- DBSLONDON 20/FEB/04 START
						    -- AND related_customer	= b.customer_no
                            AND NVL(related_customer,c.walkin_customer)	= b.customer_no
                            --eurnsg 20-oct
                            and ac_branch = c.branch_code
                            --eurnsg 20-oct
                            and trn_dt <= p_dt
                            -- DBSLONDON 20/FEB/04 END
						   --AND ac_branch			= p_branch_code  --EURNSG0066
				    -- GBPBOTFCC0055 changes for lrsupp
						   -- AND c.branch_code		= p_branch_code  --EURNSG0066
						  GROUP BY 	ac_branch,
								substr(trn_ref_no, 4, 4),
								trn_code,
								value_dt,
								ac_no,
								ac_ccy,
								-- DBSLONDON 20/FEB/04 START
								-- related_customer,
                                NVL(related_customer,c.walkin_customer),
                                -- DBSLONDON 20/FEB/04 end
								b.country,
								b.exposure_country,
								nationality )
				LOOP
					l_record_line :=	rpad(nvl(rep.product_code, ' '), 4, ' ')		|| l_seperator ||
								rpad(nvl(rep.trn_code, ' '), 3, ' ')		|| l_seperator ||
								rpad(nvl(to_char(rep.value_dt, 'DD-MM-RRRR'), ' '), 11, ' ')|| l_seperator || -- FILE 60 impsupp changes 26-Dec-2006
								rpad(nvl(rep.ac_no, ' '), 20, ' ')			|| l_seperator ||
								rpad(nvl(rep.ac_ccy, ' '), 3, ' ')			|| l_seperator ||
								rpad(nvl(fn_cust(rep.related_customer), ' '), 9, ' ')	|| l_seperator ||
								rpad(nvl(rep.country, ' '), 3, ' ')			|| l_seperator ||
								rpad(nvl(rep.exposure_country, ' '), 3, ' ')	|| l_seperator ||
								rpad(nvl(rep.nationality, ' '), 3, ' ')		|| l_seperator ||
								lpad(nvl(to_char(rep.fcy_amount), ' '), 38, ' ')|| l_seperator ||
                                -- EURNSG0066
                                /*
								lpad(nvl(to_char(rep.lcy_amount), ' '), 38, ' ') ;
                                */
								lpad(nvl(to_char(rep.lcy_amount), ' '), 38, ' ') || l_seperator ||lpad(nvl(rep.ac_branch,' '),3,' ');
                                -- EURNSG0066

					utl_file.put_line( l_output_file, l_record_line );
					utl_file.fflush( l_output_file );
				END LOOP ;
    utl_file.fclose(l_output_file);
end;
begin
d := to_date('01-09-2009','DD-MM-YYYY');
for i in 1..100
loop
if to_char(d,'D') not in ('7','1')
then
p(d);
end if;
d:=d+1;
if d>=trunc(sysdate)
then
exit;
end if;
end loop;
end;
/




