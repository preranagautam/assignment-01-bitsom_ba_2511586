## Storage Systems

Rather than using one database for everything, I picked storage systems based on what each goal actually needs.
For monthly management reports, a Data Warehouse made the most sense. The queries here are structured and repeatable — total costs per department, bed occupancy by ward, monthly trends. A warehouse is built for exactly this kind of read-heavy, aggregation-focused workload. It also keeps reporting separate from live hospital systems, ensuring enough resources for both.
For readmission risk prediction, the ML model pulls from a Feature Store sitting on top of the Data Lake. The lake stores everything raw — years of treatment history, lab results, vitals. The feature store sits in between and serves pre-cleaned, pre-computed versions of that data to the model. Without it, every training run would reprocess the same raw records from scratch, which gets slow and expensive quickly.
For plain-English patient queries, a Vector Database is the right call. Doctor notes and clinical summaries are unstructured — you can't write a SQL query to find out whether a patient had a cardiac event. Instead, documents get converted into embeddings and stored in the vector database, which matches a doctor's question to relevant records by meaning rather than exact keywords.
For real-time ICU vitals, data streams through Kafka directly into a time-series store feeding a live dashboard. This path skips the batch ETL entirely — a nightly pipeline job would make real-time monitoring useless.

## OLTP vs OLAP Boundary

The boundary sits at the Data Lake. Everything above it is OLTP — the EHR, billing systems, ICU devices, lab systems. These are live operational systems recording events as they happen, one transaction at a time, where accuracy and availability matter more than anything else.
Once data crosses into the lake, the character changes. The lake doesn't process individual updates — it stores bulk historical data for downstream consumption. The warehouse, feature store, and vector database below it are all OLAP: designed for reading large volumes of data and running analytical workloads, not handling live transactions.
The batch ETL and real-time streaming pipeline are essentially the handoff point — they pull from operational systems and deposit data into the analytical layer without touching the systems running the hospital day to day.

## Trade-offs

The biggest trade-off is routing everything through the Data Lake as a central hub. The flexibility is genuinely useful — a lake accepts structured records, unstructured notes, images, and streaming data without enforcing a rigid schema upfront. But that flexibility cuts both ways. Without careful management, inconsistent or unvalidated data flows downstream, and the warehouse, feature store, and vector database quietly start producing unreliable outputs.
The mitigation is a medallion architecture inside the lake — raw data lands in a bronze layer, gets cleaned into silver, and only validated data reaches gold, which is what downstream systems actually read. Paired with a basic data catalogue tracking where data came from and when it was last updated, this keeps the lake from turning into a swamp as the system grows.