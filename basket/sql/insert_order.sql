insert into consignment_note (cn_id, cn_date_of_supply, cn_summary, supplier_id)
	values(NULL,
            curdate(),
            '$all',
			'$user_id'
            );