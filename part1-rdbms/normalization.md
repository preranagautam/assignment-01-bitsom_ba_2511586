## Anomaly Analysis

1. An Insert Anomaly: 
A new product cannot be added without creating a fake order.
All product information (product_id, product_name, category, unit_price) is embedded inside order rows. There is no standalone product table. So if a new product is added to the catalog, there is no way to create a record for it unless anyone orders it, or we will have to create a dummy/fake order.
Example, P001 exists in 27 rows because of 27 orders created, but not a single row exists without Order Id that stores Product P001 information.
Rows - 
ORD1061	C006	Neha Gupta	neha@gmail.com	Delhi	P001	Laptop	Electronics	55000
ORD1098	C007	Arjun Nair	arjun@gmail.com	Bangalore	P001	Laptop	Electronics	55000
ORD1131	C008	Kavya Rao	kavya@gmail.com	Hyderabad	P001	Laptop	Electronics	55000
ORD1054	C002	Priya Sharma	priya@gmail.com	Delhi	P001	Laptop	Electronics	55000
ORD1095	C001	Rohan Mehta	rohan@gmail.com	Mumbai	P001	Laptop	Electronics	55000
ORD1125	C004	Sneha Iyer	sneha@gmail.com	Chennai	P001	Laptop	Electronics	55000
ORD1025	C008	Kavya Rao	kavya@gmail.com	Hyderabad	P001	Laptop	Electronics	55000
ORD1144	C005	Vikram Singh	vikram@gmail.com	Mumbai	P001	Laptop	Electronics	55000
ORD1048	C002	Priya Sharma	priya@gmail.com	Delhi	P001	Laptop	Electronics	55000
ORD1167	C005	Vikram Singh	vikram@gmail.com	Mumbai	P001	Laptop	Electronics	55000
ORD1149	C006	Neha Gupta	neha@gmail.com	Delhi	P001	Laptop	Electronics	55000
ORD1146	C004	Sneha Iyer	sneha@gmail.com	Chennai	P001	Laptop	Electronics	55000
ORD1109	C006	Neha Gupta	neha@gmail.com	Delhi	P001	Laptop	Electronics	55000
ORD1062	C003	Amit Verma	amit@gmail.com	Bangalore	P001	Laptop	Electronics	55000
ORD1177	C005	Vikram Singh	vikram@gmail.com	Mumbai	P001	Laptop	Electronics	55000
ORD1135	C003	Amit Verma	amit@gmail.com	Bangalore	P001	Laptop	Electronics	55000
ORD1064	C007	Arjun Nair	arjun@gmail.com	Bangalore	P001	Laptop	Electronics	55000
ORD1138	C008	Kavya Rao	kavya@gmail.com	Hyderabad	P001	Laptop	Electronics	55000
ORD1069	C002	Priya Sharma	priya@gmail.com	Delhi	P001	Laptop	Electronics	55000
ORD1174	C008	Kavya Rao	kavya@gmail.com	Hyderabad	P001	Laptop	Electronics	55000
ORD1078	C005	Vikram Singh	vikram@gmail.com	Mumbai	P001	Laptop	Electronics	55000
ORD1042	C004	Sneha Iyer	sneha@gmail.com	Chennai	P001	Laptop	Electronics	55000
ORD1171	C008	Kavya Rao	kavya@gmail.com	Hyderabad	P001	Laptop	Electronics	55000
ORD1175	C008	Kavya Rao	kavya@gmail.com	Hyderabad	P001	Laptop	Electronics	55000
ORD1008	C002	Priya Sharma	priya@gmail.com	Delhi	P001	Laptop	Electronics	55000
ORD1074	C002	Priya Sharma	priya@gmail.com	Delhi	P001	Laptop	Electronics	55000
ORD1000	C002	Priya Sharma	priya@gmail.com	Delhi	P001	Laptop	Electronics	55000

2. An Update Anamoly: 
Sales rep SR01 (Deepak Joshi) has two different office_address values across rows.
SR01	Deepak Joshi	deepak@corp.com	Mumbai HQ, Nariman Pt, Mumbai - 400021
SR01	Deepak Joshi	deepak@corp.com	Mumbai HQ, Nariman Point, Mumbai - 400021
A partial update ( updating some rows but not all) on office address value creates inconsistensy because the office address is repeated on every order row. You can't tell which one is correct.

3. A Delete Anamoly: 
Deleting all orders for customer C001 (Rohan Mehta) permanently destroys his record.
Rohan's customer details exist only inside his 20 order rows. If those orders are deleted (e.g. cancelled, archived, or purged), all knowledge of this customer vanishes from the database.

ORD1044	C001	Rohan Mehta	rohan@gmail.com	Mumbai
ORD1140	C001	Rohan Mehta	rohan@gmail.com	Mumbai
ORD1176	C001	Rohan Mehta	rohan@gmail.com	Mumbai
ORD1158	C001	Rohan Mehta	rohan@gmail.com	Mumbai
ORD1065	C001	Rohan Mehta	rohan@gmail.com	Mumbai
ORD1004	C001	Rohan Mehta	rohan@gmail.com	Mumbai
ORD1182	C001	Rohan Mehta	rohan@gmail.com	Mumbai
ORD1116	C001	Rohan Mehta	rohan@gmail.com	Mumbai
ORD1091	C001	Rohan Mehta	rohan@gmail.com	Mumbai
ORD1012	C001	Rohan Mehta	rohan@gmail.com	Mumbai
ORD1114	C001	Rohan Mehta	rohan@gmail.com	Mumbai
ORD1006	C001	Rohan Mehta	rohan@gmail.com	Mumbai
ORD1111	C001	Rohan Mehta	rohan@gmail.com	Mumbai
ORD1034	C001	Rohan Mehta	rohan@gmail.com	Mumbai
ORD1089	C001	Rohan Mehta	rohan@gmail.com	Mumbai
ORD1019	C001	Rohan Mehta	rohan@gmail.com	Mumbai
ORD1095	C001	Rohan Mehta	rohan@gmail.com	Mumbai
ORD1133	C001	Rohan Mehta	rohan@gmail.com	Mumbai
ORD1050	C001	Rohan Mehta	rohan@gmail.com	Mumbai
ORD1060	C001	Rohan Mehta	rohan@gmail.com	Mumbai




## Normalization Justification
The "one table is simpler" argument can seem true when designing the schema, as one only has to add a column for every attribute, without giving it much thought. But when it comes to creation of records as per business data, the complexity becomes clearer. And if even then it is paid no heed, it most likely ends up causing real damage e.g. records getting destroyed, information getting irrevocably lost.
The `orders_flat.csv` dataset demonstrates this concretely. SR01 (Deepak Joshi) has his office address recorded across 83 rows. Two of those rows spell it differently — `Nariman Point` vs `Nariman Pt`. That inconsistency already exists in the raw data. In the flat table, fixing it means hunting down and updating 83 rows atomically, and hoping no application logic writes a new row with the old spelling in the meantime. In the 3NF schema, it is a single `UPDATE` on one row in `tbl_offices`. The "simpler" table created a data integrity problem that the normalized schema makes structurally impossible.
The insert anomaly makes the problem even more visible. The flat table cannot record a new product — say a Printer at ₹12,000 — until someone places an order for it. The product catalog cannot exist independent of order history. The so-called "simplicity" would give rise to complexity of creating fake order history if a new unordered product has to be added to the table.
The delete anomaly is probably the most dangerous. Sneha Iyer (C004) has exactly 22 orders. If those are deleted for some reason, every record of her is gone. In the normalized schema, `DELETE FROM orders WHERE customer_id = 'C004'` leaves her customer record still available.
To conclude, a flat table does not deliver simplicity. It trades schema complexity for data corruption risk, update overhead, and unenforceable business rules.