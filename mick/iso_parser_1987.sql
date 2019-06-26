declare

type rec_iso is record(fld_descr varchar2(200), fld_type varchar2(50), fld_len number);
type ty_iso is table of rec_iso index by binary_integer;

l_bitmap varchar2(32);
l_binary varchar2(1000);
l_bin    varchar2(8);
tb_iso   ty_iso;
l_llvar  number;
l_len    number;
l_fld    varchar2(1000);
iso_str varchar2(32767);


function hex2bin (hexval in char) return varchar2
is
FUNCTION hex2dec (hexval IN CHAR) RETURN NUMBER IS
  i                 NUMBER;
  digits            NUMBER;
  result            NUMBER := 0;
  current_digit     CHAR(1);
  current_digit_dec NUMBER;
BEGIN
  digits := LENGTH(hexval);
  FOR i IN 1..digits LOOP
     current_digit := SUBSTR(hexval, i, 1);
     IF current_digit IN ('A','B','C','D','E','F') THEN
        current_digit_dec := ASCII(current_digit) - ASCII('A') + 10;
     ELSE
        current_digit_dec := TO_NUMBER(current_digit);
     END IF;
     result := (result * 16) + current_digit_dec;
  END LOOP;
  RETURN result;
END hex2dec;

FUNCTION dec2bin (N IN NUMBER) RETURN VARCHAR2 IS
  binval VARCHAR2(64);
  N2     NUMBER := N;
BEGIN
  WHILE ( N2 > 0 ) LOOP
     binval := MOD(N2, 2) || binval;
     N2 := TRUNC( N2 / 2 );
  END LOOP;
  RETURN binval;
END dec2bin;
begin
return dec2bin(hex2dec(upper(hexval)));
end;

procedure p(p_descr in varchar2, p_num in number, p_type in varchar2, p_len in number)
is
begin
tb_iso(p_num).fld_descr := p_descr;
tb_iso(p_num).fld_type := p_type;
tb_iso(p_num).fld_len := p_len;
end;

begin
p('Message Type' , '1' , 'NUMERIC' , '4' );
p('Primary Account Number(Card Number)' , '2' , 'LLVAR' , '19' );
p('Processing Code' , '3' , 'NUMERIC' , '6' );
p('Transaction Amount' , '4' , 'NUMERIC' , '12' );
p('Settlement Amount' , '5' , 'NUMERIC' , '12' );
p('Billing Amount' , '6' , 'NUMERIC' , '12' );
p('Transmission Date / Time' , '7' , 'NUMERIC' , '10' );
p('Amount, Cardholder Billing Fee' , '8' , 'ALPHA' , '8' );
p('Conv Rate Settlement' , '9' , 'NUMERIC' , '8' );
p('Conv Rate Billing' , '10' , 'NUMERIC' , '8' );
p('System Trace Audit Number' , '11' , 'NUMERIC' , '6' );
p('Local Transaction Time' , '12' , 'NUMERIC' , '6' );
p('Date, Effective' , '13' , 'NUMERIC' , '4' );
p('Expiry Date' , '14' , 'NUMERIC' , '4' );
p('Settlement Date' , '15' , 'NUMERIC' , '4' );
p('Date Conversion' , '16' , 'NUMERIC' , '4' );
p('Capture date' , '17' , 'NUMERIC' , '4' );
p('Merchant Type' , '18' , 'NUMERIC' , '4' );
p('Acquiring institution country code' , '19' , 'NUMERIC' , '3' );
p('PAN Extended, country code' , '20' , 'NUMERIC' , '3' );
p('Forwarding institution. country code' , '21' , 'NUMERIC' , '3' );
p('POS Entry Mode' , '22' , 'ALPHA' , '3' );
p('Card Sequence Number' , '23' , 'NUMERIC' , '3' );
p('Function Code' , '24' , 'NUMERIC' , '3' );
p('POS Condition Code' , '25' , 'NUMERIC' , '2' );
p('Point of service capture code' , '26' , 'NUMERIC' , '2' );
p('Authorising identification response length' , '27' , 'NUMERIC' , '1' );
p('Amount, Transaction Fee' , '28' , 'ALPHA' , '9' );
p('Amount, Settlement Fee' , '29' , 'ALPHA' , '9' );
p('Amounts Original' , '30' , 'ALPHA' , '9' );
p('Amount, Settlement Processing Fee' , '31' , 'ALPHA' , '9' );
p('Acquirer Institution Identification Code' , '32' , 'LLVAR' , '11' );
p('Forwarding Institution Identification Code' , '33' , 'LLVAR' , '11' );
p('Primary Account Number Extended' , '34' , 'LLVAR' , '28' );
p('Track 2 data' , '35' , 'LLVAR' , '37' );
p('Track 3 Data' , '36' , 'LLLVAR' , '104' );
p('Retrieval Reference Number' , '37' , 'ALPHA' , '12' );
p('Authorization code' , '38' , 'ALPHA' , '6' );
p('Response Code' , '39' , 'ALPHA' , '2' );
p('Service restriction code' , '40' , 'ALPHA' , '3' );
p('Card Acceptor Terminal Identification code' , '41' , 'ALPHA' , '8' );
p('Card Acceptor Idcode' , '42' , 'ALPHA' , '15' );
p('Card Acceptor Name and address' , '43' , 'ALPHA' , '40' );
p('Additional response data' , '44' , 'LLVAR' , '25' );
p('Trak1 Data' , '45' , 'LLVAR' , '76' );
p('Additional data - ISO' , '46' , 'LLLVAR' , '999' );
p('Additional data - National' , '47' , 'LLLVAR' , '999' );
p('Reserved private' , '48' , 'LLLVAR' , '999' );
p('Transaction Currency code' , '49' , 'ALPHA' , '3' );
p('Settlement currency code' , '50' , 'ALPHA' , '3' );
p('Billing currency code' , '51' , 'ALPHA' , '3' );
p('PIN Block' , '52' , 'ALPHA' , '16' );
p('Security related control information' , '53' , 'NUMERIC' , '18' );
p('Additional Amounts/ Cashback amount' , '54' , 'LLLVAR' , '120' );
p('Reserved ISO' , '55' , 'LLLVAR' , '999' );
p('Reserved ISO' , '56' , 'LLLVAR' , '999' );
p('Reserved National' , '57' , 'LLLVAR' , '999' );
p('Reserved National' , '58' , 'LLLVAR' , '999' );
p('Reserved for national use' , '59' , 'LLLVAR' , '999' );
p('Reserved private' , '60' , 'LLLVAR' , '999' );
p('POS Card Issue' , '61' , 'LLLVAR' , '999' );
p('IVR Customer Id' , '62' , 'LLLVAR' , '999' );
p('NYCE Data' , '63' , 'LLLVAR' , '999' );
p('Message authentication code (MAC)' , '64' , 'ALPHA' , '16' );
p('Bit map, tertiary' , '65' , 'ALPHA' , '16' );
p('Settlement code' , '66' , 'ALPHA' , '1' );
p('Extended payment code' , '67' , 'ALPHA' , '2' );
p('Receiving institution country code' , '68' , 'ALPHA' , '3' );
p('Settlement institution county code' , '69' , 'ALPHA' , '3' );
p('Network Management Information Code' , '70' , 'NUMERIC' , '3' );
p('Message number' , '71' , 'NUMERIC' , '4' );
p('Message number, last' , '72' , 'NUMERIC' , '4' );
p('Date, Action' , '73' , 'NUMERIC' , '6' );
p('Credits, number' , '74' , 'NUMERIC' , '10' );
p('Credits, reversal number' , '75' , 'NUMERIC' , '10' );
p('Debits, number' , '76' , 'NUMERIC' , '10' );
p('Debits, reversal number' , '77' , 'NUMERIC' , '10' );
p('Transfer number' , '78' , 'NUMERIC' , '10' );
p('Transfer, reversal number' , '79' , 'NUMERIC' , '10' );
p('Inquiries number' , '80' , 'NUMERIC' , '10' );
p('Authorisations, number' , '81' , 'NUMERIC' , '10' );
p('Credits, processsing fee amount' , '82' , 'NUMERIC' , '12' );
p('Credits, transaction fee amount' , '83' , 'NUMERIC' , '12' );
p('Debits, processing fee amount' , '84' , 'NUMERIC' , '12' );
p('Debits, transaction fee amount' , '85' , 'NUMERIC' , '12' );
p('Credits, amount' , '86' , 'NUMERIC' , '15' );
p('Credits, reversal amount' , '87' , 'NUMERIC' , '15' );
p('Debits, amount' , '88' , 'NUMERIC' , '15' );
p('Debits, reversal amount' , '89' , 'NUMERIC' , '15' );
p('Original Data Elements' , '90' , 'ALPHA' , '42' );
p('File update code' , '91' , 'ALPHA' , '1' );
p('File security code' , '92' , 'NUMERIC' , '2' );
p('Response indicator' , '93' , 'NUMERIC' , '5' );
p('Service indicator' , '94' , 'ALPHA' , '7' );
p('Replacement Amounts' , '95' , 'ALPHA' , '42' );
p('Message security code' , '96' , 'ALPHA' , '8' );
p('Amount, net settlement' , '97' , 'NUMERIC' , '16' );
p('Payee' , '98' , 'ALPHA' , '25' );
p('Settlement institution identification code' , '99' , 'LLVAR' , '11' );
p('Receiving Institution Identification Code' , '100' , 'LLVAR' , '11' );
p('File name' , '101' , 'ALPHA' , '17' );
p('From Account Number' , '102' , 'LLVAR' , '28' );
p('To Account number' , '103' , 'LLVAR' , '28' );
p('Transaction description' , '104' , 'LLLVAR' , '100' );
p('Reserved for ISO use' , '105' , 'LLLVAR' , '999' );
p('Reserved for ISO use' , '106' , 'LLLVAR' , '999' );
p('Reserved for ISO use' , '107' , 'LLLVAR' , '999' );
p('Reserved for ISO use' , '108' , 'LLLVAR' , '999' );
p('Reserved for ISO use' , '109' , 'LLLVAR' , '999' );
p('Reserved for ISO use' , '110' , 'LLLVAR' , '999' );
p('Reserved for ISO use' , '111' , 'LLLVAR' , '999' );
p('Reserved for national use' , '112' , 'LLLVAR' , '999' );
p('Authorising agent institution id code' , '113' , 'LLVAR' , '11' );
p('Reserved for national use' , '114' , 'LLLVAR' , '999' );
p('Reserved for national use' , '115' , 'LLLVAR' , '999' );
p('Reserved for national use' , '116' , 'LLLVAR' , '999' );
p('Reserved for national use' , '117' , 'LLLVAR' , '999' );
p('Reserved for national use' , '118' , 'LLLVAR' , '999' );
p('Reserved for national use' , '119' , 'LLLVAR' , '999' );
p('Reserved for private use' , '120' , 'LLLVAR' , '999' );
p('Reserved for private use' , '121' , 'LLLVAR' , '999' );
p('Reserved for private use' , '122' , 'LLLVAR' , '999' );
p('Reserved for private use' , '123' , 'LLLVAR' , '999' );
p('Batch and ShiftData' , '124' , 'LLLVAR' , '255' );
p('Network management information' , '125' , 'LLLVAR' , '50' );
p('Pre-Auth and Charge back data' , '126' , 'LLLVAR' , '6' );
p('Ministatement data' , '127' , 'LLLVAR' , '999' );
p('Message Authentication code' , '128' , 'ALPHA' , '16' );


--iso_str := '05700210a22240810a808000000000001000000980802011281113038903311128250000080309000000002289033100cnaps2  15608141365304462013080512345678                           12345676                        123456789 1                                  12345678                           123456789                          12345678                                                                                                                                                                                                                                                        CFAFDDB2';
--iso_str := '18330200a222408108C08800000000001000004980801011261627310284871126250000083617010000028487    101     YYPTSIM        15620000000000000000803090000768测试                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            你好                                                                                                                                                                                                                                                            909320405601016   9998        9997        20131126123456234567                          A1000210200099        99                                20131126666666                          666666                                                                920131126666666                          666666                                                      666666                                                      666666                                                      01666666                          666666                                                      666666                                                      320535704018  湖北汉川农银村镇银行有限责任公司                                      0                              0                                                                                                                                                                       BDC1AA8A';
iso_str := '18330200a222408108C08800000000001000004980801011261627310284871126250000083617010000028487    101     YYPTSIM        15620000000000000000803090000768testing                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            hello                                                                                                                                                                                                                                                            909320405601016   9998        9997        20131126123456234567                          A1000210200099        99                                20131126666666                          666666                                                                920131126666666                          666666                                                      666666                                                      666666                                                      01666666                          666666                                                      666666                                                      320535704018  ºþ±±ºº´¨Å©Òø´åÕòÒøÐÐÓÐÏÞÔðÈÎ¹«Ë¾                                      0                              0                                                                                                                                                                       BDC1AA8A';



dbms_output.put_line('[ 1  ]['||rpad(tb_iso(1).fld_descr,45,' ')||']['|| rpad(tb_iso(1).fld_type||'('||tb_iso(1).fld_len||')',15)||']['||substrb(iso_str,5,4)||']');
          
l_bitmap := substr(iso_str,9,32);
iso_str := substr(iso_str,41);

for i in 1..16
loop
    l_binary := l_binary||lpad(nvl(hex2bin(substr(l_bitmap, (i*2-1),2)),'0'),8,'0');
end loop;

--dbms_output.put_line(l_bitmap||':'||l_binary);


for i in 2..length(l_binary)
loop
    if tb_iso.exists(i)
    then
        if substrb(l_binary,i,1) = '1'
        then
          if tb_iso(i).fld_type like '%LVAR'
          then
             l_llvar := instrb(tb_iso(i).fld_type,'VAR')-1;
             l_len   := substrb(iso_str,1,l_llvar);
          else
             l_llvar := 0;
             l_len   := tb_iso(i).fld_len;
          end if;
          l_fld := substrb(iso_str,1,(l_len+l_llvar));
          
          dbms_output.put_line('[ '||rpad(i,3,' ')||']['||rpad(tb_iso(i).fld_descr,45,' ')||']['|| rpad(tb_iso(i).fld_type||'('||l_len||')',15)||']['||l_fld||']');
          
          iso_str := substrb(iso_str,(l_len+l_llvar+1));
        end if;    
    end if;
end loop;
end;
