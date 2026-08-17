-- Canonical schema, embedded into the binary (see store.go go:embed) and applied
-- automatically on startup via EnsureSchema. The copy at the repo root is a
-- convenience for running manually with `psql -f`; keep the two in sync.

CREATE EXTENSION IF NOT EXISTS vector;

CREATE TABLE IF NOT EXISTS documents (
    id            SERIAL PRIMARY KEY,
    source        TEXT NOT NULL UNIQUE,
    content_hash  TEXT NOT NULL,
    index_version INT  NOT NULL DEFAULT 1,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS chunks (
    id             SERIAL PRIMARY KEY,
    doc_id         INT NOT NULL REFERENCES documents(id) ON DELETE CASCADE,
    chunk_index    INT NOT NULL,
    content        TEXT NOT NULL,
    embedding      VECTOR(__DIM__) NOT NULL,  -- __DIM__ is substituted at startup from EMBED_DIM
    token_estimate INT NOT NULL DEFAULT 0,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS chunks_embedding_hnsw
    ON chunks USING hnsw (embedding vector_cosine_ops);

CREATE INDEX IF NOT EXISTS chunks_doc_id_idx ON chunks (doc_id);
