## ETL Decisions

### Decision 1 — Standardising Inconsistent Date Formats
Problem: The `date` column contained three different formats in the same column — `DD/MM/YYYY` (e.g. `29/08/2023`), `DD-MM-YYYY` (e.g. `20-02-2023`), and `YYYY-MM-DD` (`2023-02-05`). This makes the column impossible to sort, compare, or partition correctly as a plain string. A query filtering for August 2023 would silently miss rows stored in a different format.

Resolution: Applied `dateutil.parser.parse()` with `dayfirst=True` during the transform stage to handle all three formats in a single pass. `dayfirst=True` is critical — without it, `05/02/2023` would be misread as May 2nd instead of February 5th, corrupting the month attribute of every `DD/MM` row. All dates were then written to `dim_date` and `fact_sales` in `YYYY-MM-DD`, which sorts alphabetically and chronologically identically.

### Decision 2 — Normalising Category Values to a Controlled Vocabulary
Problem: The `category` column had five distinct raw values for what should be three categories: `Electronics`, `electronics`, `Clothing`, `Grocery`, and `Groceries`. The casing inconsistency (`electronics` vs `Electronics`) and synonym inconsistency (`Grocery` vs `Groceries`) meant GROUP BY queries on category would silently split one category into two rows, understating revenue for both.

Resolution: Applied an explicit mapping dictionary rather than a generic `.str.title()` call — `{'electronics': 'Electronics', 'Electronics': 'Electronics', 'Grocery': 'Grocery', 'Groceries': 'Grocery', 'Clothing': 'Clothing'}`. A generic title-case fix would have silently passed through any new misspelling undetected. The explicit map raises a `NaN` for any unmapped value, making future dirty data visible rather than quietly absorbed.

### Decision 3 — Imputing NULL Store Cities from Store Name
Problem: 19 rows had `NULL` in the `store_city` column despite having a valid `store_name`. Leaving these NULL values would cause those transactions to be excluded from any `GROUP BY store_city` query, making city-level revenue incorrect— particularly for Chennai, Delhi, Mumbai, and Pune, all of which had affected rows.

Resolution: Rather than dropping the 19 rows or flagging them as unknown, a deterministic lookup dictionary was applied — `{'Chennai Anna': 'Chennai', 'Mumbai Central': 'Mumbai', ...}` — to derive `store_city` from `store_name` for the entire dataset. This is safe because `store_name` uniquely determines `store_city` with no exceptions in the data (a functional dependency, as established during normalisation). The imputation is documented here rather than applied silently, so any future store with a genuinely ambiguous city cannot be incorrectly auto-filled.