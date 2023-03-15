select cn_id, cn_date_of_supply, cn_summary, supplier_id, sup_name, sup_city, sup_date, sup_phone
from `123`.consignment_note join `123`.supplier sup on consignment_note.supplier_id = sup.sup_id
where supplier_id = '$input_id'