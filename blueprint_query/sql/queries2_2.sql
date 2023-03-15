select line_id, b_price, b_amount, b_id from `123`.consigment_lines cl
join `123`.consignment_note cn on cn.cn_id = cl.cons_id
where cn_id = '$cn_id' and supplier_id = '$supplier_id'