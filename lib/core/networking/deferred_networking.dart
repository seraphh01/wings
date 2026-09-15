/// There is no generic REST layer. The Flutter client talks to Supabase
/// directly (RLS) or through PostgreSQL RPC / Edge Functions when invariants
/// require it. This file exists so the ADR `core/networking/` module is
/// present without inventing a second API client.
library;
