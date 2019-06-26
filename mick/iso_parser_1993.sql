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


xx number;

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



p('Message Type' ,'1' ,'NUMERIC' ,'4'  );
p('Primary, Account Number' ,'2' ,'LLVAR' ,'19'  );
p('Processing Code' ,'3' ,'NUMERIC' ,'6'  );
p('Amount transaction' ,'4' ,'NUMERIC' ,'12'  );
p('Amount reconciliation' ,'5' ,'NUMERIC' ,'12'  );
p('Amount cardholder billing' ,'6' ,'NUMERIC' ,'12'  );
p('Date and time transmission' ,'7' ,'NUMERIC' ,'10'  );
p('amount, cardholder billing fee' ,'8' ,'NUMERIC' ,'8'  );
p('Conversion rate, reconciliation' ,'9' ,'NUMERIC' ,'8'  );
p('Conversion rate, cardholder billing' ,'10' ,'NUMERIC' ,'8'  );
p('Systems trace audit number' ,'11' ,'NUMERIC' ,'6'  );
p('Date and time, local transaction' ,'12' ,'NUMERIC' ,'12'  );
p('Date, effective' ,'13' ,'NUMERIC' ,'4'  );
p('Date, expiration' ,'14' ,'NUMERIC' ,'4'  );
p('Date, settlement' ,'15' ,'NUMERIC' ,'6'  );
p('Date, conversion' ,'16' ,'NUMERIC' ,'4'  );
p('Date, capture' ,'17' ,'NUMERIC' ,'4'  );
p('Merchant type' ,'18' ,'NUMERIC' ,'4'  );
p('Country code, acquiring institution' ,'19' ,'NUMERIC' ,'3'  );
p('Country code, primary account number' ,'20' ,'NUMERIC' ,'3'  );
p(' Country code, forwarding institution' ,'21' ,'NUMERIC' ,'3'  );
p('Point of service data code' ,'22' ,'ALPHA' ,'12'  );
p('card sequence number' ,'23' ,'NUMERIC' ,'3'  );
p('Function code' ,'24' ,'NUMERIC' ,'3'  );
p('Message reason code' ,'25' ,'NUMERIC' ,'4'  );
p('card scceptor business code' ,'26' ,'NUMERIC' ,'4'  );
p('approval code length' ,'27' ,'NUMERIC' ,'1'  );
p('date, reconciliation' ,'28' ,'NUMERIC' ,'6'  );
p('reconciliation indicator' ,'29' ,'NUMERIC' ,'3'  );
p('amounts, original' ,'30' ,'NUMERIC' ,'24'  );
p('acquirer reference data' ,'31' ,'LLVAR' ,'99'  );
p('acquirer institution identification code' ,'32' ,'LLVAR' ,'11'  );
p('forwarding institution identification code' ,'33' ,'LLVAR' ,'11'  );
p('primary account number, extended' ,'34' ,'LLVAR' ,'28'  );
p('track 2 data' ,'35' ,'LLVAR' ,'37'  );
p('track 3 data' ,'36' ,'LLLVAR' ,'104'  );
p('retrieval reference number' ,'37' ,'ALPHA' ,'12'  );
p('approval code' ,'38' ,'ALPHA' ,'6'  );
p('action code' ,'39' ,'NUMERIC' ,'3'  );
p('service code' ,'40' ,'NUMERIC' ,'3'  );
p('card acceptor terminal identification' ,'41' ,'ALPHA' ,'8'  );
p('card acceptor identification code' ,'42' ,'ALPHA' ,'15'  );
p('card acceptor name/location' ,'43' ,'LLVAR' ,'99'  );
p('additional response data' ,'44' ,'LLVAR' ,'99'  );
p('track 1 data' ,'45' ,'LLVAR' ,'76'  );
p('amounts, fees' ,'46' ,'LLLVAR' ,'204'  );
p('additional data - national' ,'47' ,'LLLVAR' ,'999'  );
p('additional data - private' ,'48' ,'LLLVAR' ,'999'  );
p('currency code, transaction' ,'49' ,'ALPHA' ,'3'  );
p('currency code, reconciliation' ,'50' ,'ALPHA' ,'3'  );
p('currency code, cardholder billing' ,'51' ,'ALPHA' ,'3'  );
p('amounts, additional' ,'54' ,'LLLVAR' ,'120'  );
p('original data elements' ,'56' ,'LLVAR' ,'35'  );
p('authorization life cycle code' ,'57' ,'NUMERIC' ,'3'  );
p('authorizing agent institution identification code' ,'58' ,'LLVAR' ,'11'  );
p('transport data' ,'59' ,'LLLVAR' ,'999'  );
p('Message authentication code (MAC)' ,'64' ,'ALPHA' ,'16' );
p('amounts, original fees' ,'66' ,'LLLVAR' ,'204'  );
p('extended payment data' ,'67' ,'NUMERIC' ,'2'  );
p('country code, receiving institution' ,'68' ,'NUMERIC' ,'3'  );
p('country code, settlement institution' ,'69' ,'NUMERIC' ,'3'  );
p('country code, authorizing agent institution' ,'70' ,'NUMERIC' ,'3'  );
p('message number' ,'71' ,'NUMERIC' ,'8'  );
p('data record' ,'72' ,'LLLVAR' ,'999'  );
p('date, action' ,'73' ,'NUMERIC' ,'6'  );
p('credits, number' ,'74' ,'NUMERIC' ,'10'  );
p('credits, reversal number' ,'75' ,'NUMERIC' ,'10'  );
p('debits, number' ,'76' ,'NUMERIC' ,'10'  );
p('debits, reversal number' ,'77' ,'NUMERIC' ,'10'  );
p('transfer, number' ,'78' ,'NUMERIC' ,'10'  );
p('transfer, reversal number' ,'79' ,'NUMERIC' ,'10'  );
p('inquiries, number' ,'80' ,'NUMERIC' ,'10'  );
p('authorizations, number' ,'81' ,'NUMERIC' ,'10'  );
p('inquiries, reversal number' ,'82' ,'NUMERIC' ,'10'  );
p('payments, number' ,'83' ,'NUMERIC' ,'10'  );
p('payments, reversal number' ,'84' ,'NUMERIC' ,'10'  );
p('fee collections, number' ,'85' ,'NUMERIC' ,'10'  );
p('credits, amount -' ,'86' ,'NUMERIC' ,'16'  );
p('credits, reversal amount' ,'87' ,'NUMERIC' ,'16'  );
p('debits, amount' ,'88' ,'NUMERIC' ,'16'  );
p('debits, reversal amount' ,'89' ,'NUMERIC' ,'16'  );
p('authorizations, reversal number' ,'90' ,'NUMERIC' ,'10'  );
p('country code, transaction destination institution' ,'91' ,'NUMERIC' ,'3'  );
p('country code, transaction originator institution' ,'92' ,'NUMERIC' ,'3'  );
p('transaction destination institution identification code' ,'93' ,'LLVAR' ,'11'  );
p('transaction originator institution identification code' ,'94' ,'LLVAR' ,'11'  );
p('card issuer reference data' ,'95' ,'LLVAR' ,'99'  );
p('amount, net reconciliation' ,'97' ,'AMOUNT' ,'16'  );
p('payee' ,'98' ,'ALPHA' ,'25'  );
p('settlement institution identification code' ,'99' ,'LLVAR' ,'11'  );
p('receiving institution identification code' ,'100' ,'LLVAR' ,'11'  );
p('file name' ,'101' ,'LLVAR' ,'17'  );
p('account identification 1' ,'102' ,'LLVAR' ,'28'  );
p('account identification 2' ,'103' ,'LLVAR' ,'28'  );
p('transaction description' ,'104' ,'LLLVAR' ,'100'  );
p('credits, chargeback amount' ,'105' ,'NUMERIC' ,'16'  );
p('debits, chargeback amount' ,'106' ,'NUMERIC' ,'16'  );
p('credits, chargeback number' ,'107' ,'NUMERIC' ,'10'  );
p('debits, chargeback number' ,'108' ,'NUMERIC' ,'10'  );
p('credits, fee amounts' ,'109' ,'LLVAR' ,'84'  );
p('debits, fee amounts' ,'110' ,'LLVAR' ,'84'  );
p('ORFT Details' ,'123' ,'LLLVAR' ,'999'  );
p('Reconciliation Details ' ,'125' ,'LLLVAR' ,'999'  );
p('Additional data' ,'126' ,'LLLVAR' ,'999'  );
p('Reserved Private: Mini-statement Details.' ,'127' ,'LLLVAR' ,'999'  );
p('Message Authentication code' ,'128' ,'ALPHA' ,'16' );


--iso_str := '05700210a22240810a808000000000001000000980802011281113038903311128250000080309000000002289033100cnaps2  15608141365304462013080512345678                           12345676                        123456789 1                                  12345678                           123456789                          12345678                                                                                                                                                                                                                                                        CFAFDDB2';
--iso_str := '18330200a222408108C08800000000001000004980801011261627310284871126250000083617010000028487    101     YYPTSIM        15620000000000000000803090000768??                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            ??                                                                                                                                                                                                                                                            909320405601016   9998        9997        20131126123456234567                          A1000210200099        99                                20131126666666                          666666                                                                920131126666666                          666666                                                      666666                                                      666666                                                      01666666                          666666                                                      666666                                                      320535704018  ????????????????                                      0                              0                                                                                                                                                                       BDC1AA8A';
--iso_str := '18330200a222408108C08800000000001000004980801011261627310284871126250000083617010000028487    101     YYPTSIM        15620000000000000000803090000768testing                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            hello                                                                                                                                                                                                                                                            909320405601016   9998        9997        20131126123456234567                          A1000210200099        99                                20131126666666                          666666                                                                920131126666666                          666666                                                      666666                                                      666666                                                      01666666                          666666                                                      666666                                                      320535704018  湖北汉川农银村镇银行有限责任公司                                      0                              0                                                                                                                                                                       BDC1AA8A';
iso_str := 'xxxx1200E632C40188E5A000000000000400000119621015880000013816631000000000000000002100527430113211402101327431412110211  601121100121002208010211110430000102110087171234567812345678901234556CHN29000CHINA UNIONPAY SIMULATOR     \\\             15601401156D000000000071001000156156194103061059300030203';


dbms_output.put_line('[ 1  ]['||rpad(tb_iso(1).fld_descr,45,' ')||']['|| rpad(tb_iso(1).fld_type||'('||tb_iso(1).fld_len||')',15)||']['||substrb(iso_str,5,4)||']');

          
l_bitmap := substr(iso_str,9,32);
iso_str := substr(iso_str,41);

for i in 1..16
loop
    l_binary := l_binary||lpad(nvl(hex2bin(substr(l_bitmap, (i*2-1),2)),'0'),8,'0');
end loop;

dbms_output.put_line(l_bitmap||':'||l_binary);


for i in 2..length(l_binary)
loop
    if tb_iso.exists(i)
    then
        xx := i;
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
exception when others then
dbms_output.put_line(xx||':'||tb_iso(xx).fld_type||':'||tb_iso(xx).fld_descr||':'||iso_str);
raise;
end;
/
