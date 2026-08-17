# Chunking and Embeddings

## Chunking strategies

Fixed-size chunking — cutting text every N characters — fails in production
because it slices sentences and ideas in half, destroying meaning. Better
approaches include:

- **Recursive splitting**: try to split on large boundaries first (paragraphs),
  then progressively smaller ones (lines, sentences, characters) until each
  chunk fits the size budget. This keeps semantically related text together.
- **Semantic chunking**: insert boundaries where the embedding similarity
  between adjacent sentences drops sharply.
- **Structure-aware splitting**: respect the document's own structure — code
  functions, markdown headings, or legal clauses.

Overlap between adjacent chunks (a shared window of text) helps preserve context
that would otherwise be cut off at a boundary.

## Choosing an embedding model

Selecting an embedding model is a long-term commitment: switching models forces
you to re-embed the entire corpus, because vectors from different models are not
comparable. Common production choices include OpenAI's text-embedding-3-large,
Cohere's embed-v3, and open models like BAAI's bge-large-en-v1.5.

The embedding dimension (for example, 1536 for text-embedding-3-small) is fixed
by the model and must match the vector column width in your database.
