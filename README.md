# Studey

A private, phone-friendly nutrition and dietetics study companion. Studey includes course notebooks, source-grounded study, course-topic recommendations, reading plans, and opportunity links.

## Run locally

Open `index.html` in a modern browser and choose **Continue on this device**. Local mode keeps information in that browser only.

## Enable sign-up, sign-in, and cross-device sync

1. Create a Supabase project.
2. In the Supabase SQL Editor, run [`supabase/setup.sql`](supabase/setup.sql). This creates the user data table, private source-file bucket, and row-level/storage policies so signed-in users can access only their own data.
3. Copy your project URL and **publishable key** into [`supabase-config.js`](supabase-config.js). The publishable key is designed for browser use; never put a `service_role` or secret key in this app.
4. In Supabase Auth, enable email/password sign-in and configure the site URL and allowed redirect URLs for the deployed site.
5. Serve the app over HTTPS (for example, with GitHub Pages) and sign up. Existing local profile, notebook, and progress data on the first signed-in browser is copied into the new account.

After sign-in, profile details, schedules, plans, notebook metadata, course outlines, and extracted source text sync to the account. Source files use a private Supabase Storage bucket. Changes sync automatically when the browser is online; signing in on another device loads the account data there.

PDF and DOCX text extraction uses browser libraries from a CDN. TXT, Markdown, and CSV are also supported. Scanned image-only PDFs are not indexed.
