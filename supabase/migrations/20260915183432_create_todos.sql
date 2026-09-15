create table public.todos (
  id bigint generated always as identity primary key,
  name text not null,
  created_at timestamptz not null default now()
);

grant select on table public.todos to anon, authenticated;
grant select, insert, update, delete on table public.todos to service_role;

alter table public.todos enable row level security;

create policy todos_select_public
on public.todos
for select
to anon, authenticated
using (true);
