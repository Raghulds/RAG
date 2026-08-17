# Retrieval, Reranking, and Production Concerns

## Retrieval and reranking

Vector search alone optimizes for recall: it pulls back many candidate chunks
that are roughly similar to the query. A second **reranking** stage then
optimizes for precision, re-scoring those candidates — often with a stronger
model or a cross-encoder — and keeping only the best few for the final prompt.
This recall-then-precision pattern consistently beats single-stage retrieval.

## The document registry

Vector databases do not natively track which chunk IDs belong to which document.
A registry — typically a Postgres table mapping document IDs to their chunk
vectors, plus a content hash — makes safe updates and deletions possible. When a
document changes, you compute a hash of its content; if the hash matches what is
in the registry, you skip re-embedding it entirely, saving time and money.

## Observability

Production RAG needs tracing. Each query should emit nested spans capturing
embedding latency, retrieval scores, reranking decisions, prompt assembly, and
generation latency. The chunk_retrieved events — which chunks came back and with
what score — are what make a bad answer debuggable after the fact.

## Evaluation

Quality is measured with an LLM-as-judge that scores two things: faithfulness
(did the answer stay within the retrieved context, or did it hallucinate?) and
relevance (did the answer actually address the question?). Linking traces to
index versions lets you catch quality regressions when the corpus changes.
