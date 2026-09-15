# Wings

Calisthenics progression and training — Flutter client with a Supabase backend.

The first product loop is: assess → choose a goal → follow a path → train → record evidence → validate progress → unlock the next step.

## App setup

Keys live in `.env` (gitignored):

```
SUPABASE_URL=https://YOUR_PROJECT.supabase.co
SUPABASE_PUBLISHABLE_KEY=YOUR_PUBLISHABLE_KEY
```

Copy `.env.example` if you do not have a file yet.

Then run (Chrome is the reliable desktop target; Windows desktop may fail without Developer Mode):

```sh
flutter run -d chrome
```

`flutter analyze` should stay clean.

## What this draft is

The app boots Flutter, loads `.env`, initializes Supabase, then shows a navigable mock of the five core destinations from the architecture decision record:

1. **Today** — what to train today (founder-athlete fixture: Ten and Ten)
2. **Journey** — goals, path, unofficial prior PRs
3. **Train** — this week's sessions and a draft active logger
4. **Together** — partners empty state + Saturday bars placeholder
5. **Profile** — local draft identity

Onboarding, assessment, learning, and progression detail screens are reachable from those tabs. Feature data is **local mock data**. Supabase is initialized but not queried. The starter `todos` table remains in migration history unused.

## Database migrations

Create a new migration (do not invent filenames):

```sh
npx supabase migration new your_change_description
```

Apply to a linked remote project:

```sh
npx supabase login
npx supabase link --project-ref YOUR_PROJECT_REF
npx supabase db push
```

Local stack (Docker required):

```sh
npx supabase start
npx supabase db reset
```

Do not change the remote schema in the Dashboard. Add a migration file, then push it.

## Brand assets

Temporary fonts and a placeholder mark live under `assets/`. See `assets/brand/PLACEHOLDERS.txt` for what still needs to be supplied (logomark, store icons, splash).
