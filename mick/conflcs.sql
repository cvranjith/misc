select  	a.contract_Ref_no,
        	d.contract_ccy,
        	b.product_code,
        	a.cif_id ,
        	a.cust_name,
        	d.contract_amt,
        	e.current_availability,
        	d.max_contract_amt,
        	c.contract_status
from    	lctbs_parties a,
        	lctms_product_definition b,
        	cstbs_contract c,
        	lctbs_contract_master d,
        	lctbs_availments e
where	c.module_code = 'LC' 
	and a.party_type = 'COB'
        	and b.product_type in ('I','C','S','G','H')
        	and b.product_code = c.product_code
        	and c.contract_ref_no = a.contract_ref_no
        	and d.contract_ref_no = a.contract_ref_no
        	and e.contract_ref_no = a.contract_ref_no
	and a.event_seq_no = (select max(event_seq_no) from lctbs_parties 
			      where  lctbs_parties.contract_ref_no = a.contract_ref_no and
			      party_type = 'COB')	
	and d.event_seq_no =  (select max(event_seq_no)  from lctbs_contract_master
		  	       where lctbs_contract_master.contract_ref_no = d.contract_ref_no)
	and e.event_seq_no =  (select NVL(max(event_seq_no),1)  from lctbs_availments
		  	       where lctbs_availments.contract_ref_no = e.contract_ref_no)
        	and c.latest_event_seq_no >=
	                (select max(event_seq_no)  from lctbs_contract_master
	  	  where lctbs_contract_master.contract_ref_no = c.contract_ref_no)