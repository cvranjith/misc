declare
l_record_line varchar2(32767);
l_output_file utl_file.file_type;
l_seperator			CHAR(1) := ' ' ;
l_Trend_Date_Format varchar2(1000):='DD-MM-RRRR';
function fn_cust(p_cust in varchar2)
return varchar2 is
l_cust  varchar2(100) := p_cust;
begin
    /*
    if p_cust = '999999'
    then
        l_cust := '257722';
    elsif p_cust like 'V%'
    */
    if p_cust like 'V%'
    then
        l_cust := '999999';
    end if;
    return l_cust;
end;
begin
l_output_file := utl_file.fopen(global.work_area,'LC_CURRENT_AVAILABILITY_01SEP.TXT','w','32767');
				FOR rep IN ( SELECT *
						   FROM LCVWS_CONTRACT_SUMMARY_tmp
						  WHERE contract_status = 'A' )
				LOOP
					l_record_line :=	rpad(nvl(rep.CONTRACT_REF_NO, ' '), 16, ' ')	|| l_seperator ||
								rpad(nvl(substr(rep.USER_REF_NO, 1, 16), ' '), 16, ' ')|| l_seperator ||
								rpad(nvl(rep.CUST_TYPE, ' '), 3, ' ')		|| l_seperator ||
								rpad(nvl(fn_cust(rep.CIF_ID), ' '), 9, ' ')			|| l_seperator ||
								rpad(nvl(rep.CUST_REF_NO, ' '), 35, ' ')		|| l_seperator ||
								rpad(nvl(to_char(rep.CUST_REF_DATE, l_Trend_Date_Format), ' '), 11, ' ')	|| l_seperator ||	--EURNAT RETRO changes 04-JAN-2007
								rpad(nvl(rep.CONTRACT_CCY, ' '), 3, ' ')			|| l_seperator ||
								lpad(nvl(to_char(rep.CONTRACT_AMT), ' '), 38, ' ')	|| l_seperator ||
								lpad(nvl(to_char(rep.MAX_CONTRACT_AMT), ' '), 38, ' ')	|| l_seperator ||
								lpad(nvl(to_char(rep.MAX_LIABILITY_AMT), ' '), 38, ' ')	|| l_seperator ||
								lpad(nvl(to_char(rep.CURRENT_AVAILABILITY), ' '), 38, ' ')	|| l_seperator ||
								lpad(nvl(to_char(rep.OS_LIABILITY), ' '), 38, ' ')		|| l_seperator ||
								rpad(nvl(to_char(rep.ISSUE_DATE, l_Trend_Date_Format), ' '), 11, ' ')	|| l_seperator || 	--EURNAT RETRO changes 04-JAN-2007
								rpad(nvl(to_char(rep.EXPIRY_DATE, l_Trend_Date_Format), ' '), 11, ' ')	|| l_seperator || 	--EURNAT RETRO changes 04-JAN-2007
								rpad(nvl(to_char(rep.CLOSURE_DATE, l_Trend_Date_Format), ' '), 11, ' ')	|| l_seperator ||	--EURNAT RETRO changes 04-JAN-2007
								nvl(rep.SETTLEMENT_METHOD, ' ')						|| l_seperator ||
								rpad(nvl(to_char(rep.LATEST_SHIPMENT_DATE, l_Trend_Date_Format), ' '), 11, ' ')	|| l_seperator ||	--EURNAT RETRO changes 04-JAN-2007
								nvl(rep.AUTH_STATUS, ' ')		|| l_seperator ||
								nvl(rep.CONTRACT_STATUS, ' ')	;
					utl_file.put_line( l_output_file, l_record_line );
					utl_file.fflush( l_output_file );
				END LOOP;
end;
/
