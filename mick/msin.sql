SET SERVEROUT ON SIZE 10000
DECLARE
	e	VARCHAR2(1000);
	r	VARCHAR2(1000);
	s	VARCHAR2(1000);
	m	MSTB_DLY_MSG_IN.message%TYPE;
BEGIn	

		GLOBAL.pr_init('000','SYSTEM');

		IF NOT TRPKS.fn_get_process_refno
			(
			GLOBAL.current_branch,
			'MSIN',
			GLOBAL.application_date,
			s,
			r,
			e
			)
		THEN
			DBMS_OUTPUT.put_line('Something wrong in generating DCN');
			RETURN;
		END IF;

		DBMS_OUTPUT.put_line('DCN   '||r);
		DBMS_OUTPUT.put_line('REFNO '||s);

		m := 
'{1:F01BSNSNLASAXXX4702467114}
{2:O1031701011001FLORNL2AADEV249937201031}
{3:{108:0110012109395409}}
{4:
:20:'||s||'
:23B:SPRI
:32A:991201EUR1000,
:33B:EUR1001,
:50K:ARUBA BANK N.V.
P.O. BOX 192
ORANJESTAD
:52A://NLVOSTNL01XXXRE02070411732
VPSTNL02
:57A:BSNSNLAS
:59:/NL79IBAN9110002
:71A:BEN
:71F:EUR1,
:72:/TOP/+DEV+1++LND+NL+
/NOTE/NL
:77B:/ORDERRES/BE
/BENEFRES/NL
-}';

		INSERT INTO mstb_dly_msg_in
			(
			branch,
			dcn,
			reference_no,
			sender,
			serial_no,
			media,
			swift_msg_type,
			mcs,
			node,
			name,
			address1,
			address2,
			address3, 
			address4,
			location,
			msg_status,
			testword,
			testing_status,
			print_status,
			branch_date,
			maker_id,
			maker_dt_stamp, 
			message,
			repair_reason,
			running_no,
			generated_ref_no,
			queue,
			process_status,
			repair_reason_params,
			auth_status, 
			checker_dt_stamp,
			checker_id,
			latest_version_no,
			once_auth,
			mir,
			remarks,
			reject_reason,
			status,
			force_release_fund, 
			force_cover_match,
			ccy,
			amount,
			value_date,
			suppress_message,
			receiver,
			instr_ccy,
			instr_amount
			)
		VALUES 
			(
			'000',
			r,
			s,
			'FLORNL2ADEV',
			1,
			'SWIFT',
			'103',
			'SWIFT',
			GLOBAL.node,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			'I',
			NULL,
			NULL,
			'N',
			GLOBAL.application_date,
			GLOBAL.user_id,
			GLOBAL.application_date,
			m,
			NULL,
			1,
			NULL,
			'SWIFT',
			'U',
			NULL,
			'A',
			GLOBAL.application_date,
			GLOBAL.user_id,
			1,
			'Y',
			'011001FLORNL2AADEV2499372010',
			NULL,
			NULL,
			'P',
			NULL,
			NULL,
			'EUR',
			1000,
			GLOBAL.application_date,
			'N',
			'BSNSNLAS',
			'EUR',
			1001
			);
		DBMS_OUTPUT.put_line('Inserted '||SQL%ROWCOUNT||' row(s) into Incoming Browser');
		COMMIT;
EXCEPTION
	WHEN OTHERS
	THEN
		DBMS_OUTPUT.put_line('ORAERR '||SQLERRM);

END;
/
