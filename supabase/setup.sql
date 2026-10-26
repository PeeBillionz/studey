-- Run this script once in Supabase SQL Editor for the Studey project.
-- The browser uses only the publishable key; row-level security scopes data to auth.uid().

create table if not exists public.studey_user_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  payload jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.studey_user_data enable row level security;
revoke all on table public.studey_user_data from anon, authenticated;
grant select, insert, update, delete on table public.studey_user_data to authenticated;

drop policy if exists "Users can read their own Studey data" on public.studey_user_data;
drop policy if exists "Users can create their own Studey data" on public.studey_user_data;
drop policy if exists "Users can update their own Studey data" on public.studey_user_data;
drop policy if exists "Users can delete their own Studey data" on public.studey_user_data;

create policy "Users can read their own Studey data"
  on public.studey_user_data for select to authenticated
  using ((select auth.uid()) = user_id);
create policy "Users can create their own Studey data"
  on public.studey_user_data for insert to authenticated
  with check ((select auth.uid()) = user_id);
create policy "Users can update their own Studey data"
  on public.studey_user_data for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);
create policy "Users can delete their own Studey data"
  on public.studey_user_data for delete to authenticated
  using ((select auth.uid()) = user_id);

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('studey-private-files', 'studey-private-files', false, 52428800, array['application/json'])
on conflict (id) do update set public = false, file_size_limit = 52428800, allowed_mime_types = array['application/json'];

drop policy if exists "Users can read their own Studey files" on storage.objects;
drop policy if exists "Users can upload their own Studey files" on storage.objects;
drop policy if exists "Users can update their own Studey files" on storage.objects;
drop policy if exists "Users can delete their own Studey files" on storage.objects;

create policy "Users can read their own Studey files"
  on storage.objects for select to authenticated
  using (bucket_id = 'studey-private-files' and (storage.foldername(name))[1] = (select auth.uid()::text));
create policy "Users can upload their own Studey files"
  on storage.objects for insert to authenticated
  with check (bucket_id = 'studey-private-files' and (storage.foldername(name))[1] = (select auth.uid()::text));
create policy "Users can update their own Studey files"
  on storage.objects for update to authenticated
  using (bucket_id = 'studey-private-files' and (storage.foldername(name))[1] = (select auth.uid()::text))
  with check (bucket_id = 'studey-private-files' and (storage.foldername(name))[1] = (select auth.uid()::text));
create policy "Users can delete their own Studey files"
  on storage.objects for delete to authenticated
  using (bucket_id = 'studey-private-files' and (storage.foldername(name))[1] = (select auth.uid()::text));
