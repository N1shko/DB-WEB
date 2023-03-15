SELECT MONTH(cn_date_of_supply), Nomen_blank_id, b_amount from `123`.consignment_note
    join `123`.consigment_lines line on consignment_note.cn_id = line.cons_id
    join `123`.nomenklatura nom on nom.Nomen_blank_id = line.b_id
    where YEAR(cn_date_of_supply) = '$input_year'