# What is Retrieval-Augmented Generation (RAG)?

Retrieval-Augmented Generation is a technique for grounding a large language
model's answers in an external knowledge base instead of relying only on the
knowledge baked into the model's weights. At query time, the system retrieves
relevant passages from a document store and passes them to the model as context.

## Why RAG?

Large language models have two well-known problems: they hallucinate facts, and
their knowledge is frozen at training time. RAG addresses both. By retrieving
fresh, authoritative passages and instructing the model to answer only from that
context, the system produces answers that are current and traceable to a source.

## The two pipelines

A production RAG system is really two pipelines. The offline **indexing
pipeline** ingests raw documents, splits them into chunks, embeds each chunk into
a dense vector, and stores the vectors in a vector database. The online **query
pipeline** embeds the user's question, performs a vector similarity search to
find the closest chunks, assembles them into a prompt, and asks the model to
answer.

The single biggest mistake teams make is treating RAG as only the query pipeline.
The indexing pipeline, document lifecycle management, and observability are where
most production failures silently occur.
