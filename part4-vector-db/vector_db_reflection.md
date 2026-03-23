## Vector DB Use Case
A traditional keyword-based database search would not suffice for this use case. Keyword search relies on exact or partial word matches, which fails when the query and the document use different phrasing. For example, a lawyer asking “What are the termination clauses?” may miss relevant sections titled “contract cancellation,” “exit conditions,” or “early termination rights.”
Legal documents also contain dense, context-heavy language where meaning depends on semantics rather than specific keywords. As a result, keyword search leads to low recall (missing relevant results) and poor precision (irrelevant matches).

A vector database addresses this limitation by enabling semantic search. Instead of storing text as plain strings, documents (or chunks of them) are converted into embeddings — numerical representations that capture meaning and context. The user’s query is also converted into an embedding, and the system retrieves the most semantically similar sections, even if they don’t share exact words.

In this system, the workflow would be:

1. Split 500-page contracts into smaller chunks
2. Generate embeddings for each chunk
3. Store them in a vector database
4. Convert user queries into embeddings
5. Retrieve the most relevant chunks based on similarity

This allows lawyers to find answers based on intent and meaning, not just wording.

In practice, a hybrid approach works best: keyword search for exact matches (e.g., clause numbers) and vector search for conceptual queries.
