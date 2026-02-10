# Database Schema Instructions
To enable AI database awareness and prevent syntax errors in Supabase queries:
1. Run this in Supabase SQL Editor:
   `select table_name, column_name, data_type from information_schema.columns where table_schema = 'public';`
2. Paste the raw results below.
3. Explicitly define foreign key relationships to help the AI perform joins (e.g., "Orders table connects to Users via user_id field").
