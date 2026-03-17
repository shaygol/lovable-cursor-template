@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ============================================
echo   Cursor Project Setup
echo ============================================
echo.

:: Check if git is available
where git >nul 2>nul
if errorlevel 1 (
    echo ERROR: Git is not installed or not in PATH.
    goto :end
)

:: Check if node/npm is available
where npm >nul 2>nul
if errorlevel 1 (
    echo ERROR: npm is not installed or not in PATH.
    goto :end
)

:: -----------------------------------------------
:: Step 0: Choose work mode
:: -----------------------------------------------
echo Work mode:
echo   [1] Cursor only     ^(disconnects from Lovable, fresh git history^)
echo   [2] Cursor + Lovable ^(keeps GitHub connection, can push from both^)
echo.
set /p "WORK_MODE=Enter 1 or 2: "

if "!WORK_MODE!"=="1" (
    echo.
    echo Mode: Cursor only
) else if "!WORK_MODE!"=="2" (
    echo.
    echo Mode: Cursor + Lovable
) else (
    echo ERROR: Invalid choice. Enter 1 or 2.
    goto :end
)

echo.

:: -----------------------------------------------
:: Get clone URL
:: -----------------------------------------------
if "%~1"=="" (
    set /p "CLONE_URL=Enter the GitHub clone URL: "
) else (
    set "CLONE_URL=%~1"
)

if "!CLONE_URL!"=="" (
    echo ERROR: No URL provided.
    goto :end
)

:: Ask for project title
set /p "PROJECT_TITLE=Enter project title (Hebrew or English): "

echo.
echo Clone URL:    !CLONE_URL!
echo Project:      !PROJECT_TITLE!
echo Directory:    %CD%
echo Mode:         !WORK_MODE!
echo.

:: -----------------------------------------------
:: Step 1: Clone project to temp folder
:: -----------------------------------------------
echo [1] Cloning project...
if exist ".setup-temp" rmdir /S /Q ".setup-temp"
git clone "!CLONE_URL!" ".setup-temp"
if errorlevel 1 (
    echo ERROR: Git clone failed.
    goto :cleanup
)
echo     Done.

:: -----------------------------------------------
:: Step 2: Copy config files
:: -----------------------------------------------
echo [2] Copying config files...
for %%F in (
    ".setup-temp\package.json"
    ".setup-temp\package-lock.json"
    ".setup-temp\bun.lockb"
    ".setup-temp\vite.config.ts"
    ".setup-temp\tailwind.config.ts"
    ".setup-temp\tsconfig.json"
    ".setup-temp\tsconfig.app.json"
    ".setup-temp\tsconfig.node.json"
    ".setup-temp\components.json"
    ".setup-temp\postcss.config.js"
    ".setup-temp\eslint.config.js"
    ".setup-temp\index.html"
) do (
    if exist "%%~F" copy /Y "%%~F" "." >nul 2>nul
)
echo     Done.

:: -----------------------------------------------
:: Step 3: Copy source directories
:: -----------------------------------------------
echo [3] Copying src/ public/ supabase/ directories...
if exist ".setup-temp\src" (
    if not exist "src" mkdir "src"
    xcopy ".setup-temp\src\*" "src\" /E /Y /Q >nul
)
if exist ".setup-temp\public" (
    if not exist "public" mkdir "public"
    xcopy ".setup-temp\public\*" "public\" /E /Y /Q >nul
)
if exist ".setup-temp\supabase" (
    if not exist "supabase" mkdir "supabase"
    xcopy ".setup-temp\supabase\*" "supabase\" /E /Y /Q >nul
)
echo     Done.

:: -----------------------------------------------
:: Step 4: Save original Lovable README
:: -----------------------------------------------
echo [4] Saving original Lovable README...
if exist ".setup-temp\README.md" (
    copy /Y ".setup-temp\README.md" "README_lovable.md" >nul
    echo     Saved as README_lovable.md
) else (
    echo     No README found in source, skipping.
)

:: -----------------------------------------------
:: Step 5: Set project title in template README files
:: -----------------------------------------------
echo [5] Setting project title in README files...
powershell -Command "(Get-Content 'README.md' -Encoding UTF8) -replace '<TITLE>', '!PROJECT_TITLE!' | Set-Content 'README.md' -Encoding UTF8"
powershell -Command "(Get-Content 'README_he.md' -Encoding UTF8) -replace '<TITLE>', '!PROJECT_TITLE!' | Set-Content 'README_he.md' -Encoding UTF8"
echo     Done.

:: -----------------------------------------------
:: Step 6: Remove Lovable-specific dependencies (mode 1 only)
:: -----------------------------------------------
if "!WORK_MODE!"=="1" (
    echo [6] Removing Lovable-specific dependencies...
    powershell -Command "$p = Get-Content 'package.json' -Raw | ConvertFrom-Json; $p.dependencies.PSObject.Properties.Remove('@lovable.dev/cloud-auth-js'); $p.devDependencies.PSObject.Properties.Remove('lovable-tagger'); $p | ConvertTo-Json -Depth 10 | Set-Content 'package.json' -Encoding UTF8"
    echo     Removed lovable-tagger and cloud-auth-js from package.json
) else (
    echo [6] Keeping Lovable dependencies ^(mode 2^)...
    echo     Skipped.
)

:: -----------------------------------------------
:: Step 7: Create .env from example
:: -----------------------------------------------
echo [7] Setting up .env...
if not exist ".env" (
    if exist ".env.example" (
        copy /Y ".env.example" ".env" >nul
        echo     Created .env from .env.example - fill in your Supabase credentials.
    ) else (
        echo VITE_SUPABASE_URL=https://your-project.supabase.co > .env
        echo VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9... >> .env
        echo     Created .env placeholder - fill in your Supabase credentials.
    )
) else (
    echo     .env already exists, skipping.
)

:: -----------------------------------------------
:: Step 8: Clean up temp folder
:: -----------------------------------------------
echo [8] Cleaning up temp files...
rmdir /S /Q ".setup-temp"
echo     Done.

:: -----------------------------------------------
:: Step 9: Git setup
:: -----------------------------------------------
if "!WORK_MODE!"=="1" (
    echo [9] Initializing fresh git repository...
    if exist ".git" rmdir /S /Q ".git"
    git init >nul
    git add .
    git commit -m "Initial commit: !PROJECT_TITLE!" >nul
    echo     Fresh git repo initialized with base commit.
    echo     Next: create a GitHub repo and run:
    echo       git remote add origin ^<YOUR_REPO_URL^>
    echo       git push -u origin master
) else (
    echo [9] Keeping existing git connection to Lovable...
    git add .
    git commit -m "Add Cursor template files: .cursorrules, ai-utils, vercel.json" >nul
    echo     Committed template files. Remote stays connected to Lovable/GitHub.
)

:: -----------------------------------------------
:: Step 10: Install dependencies
:: -----------------------------------------------
echo [10] Installing dependencies...
call npm install --legacy-peer-deps
echo     Done.

echo.
echo ============================================
echo   Setup complete!
echo ============================================
echo.
echo Your project "!PROJECT_TITLE!" is ready at: %CD%
echo.

if "!WORK_MODE!"=="1" (
    echo Next steps:
    echo   1. Fill in your Supabase credentials in .env
    echo      - URL:      Supabase Dashboard ^> Project Settings ^> API ^> Project URL
    echo      - ANON KEY: Supabase Dashboard ^> Project Settings ^> API ^> anon public
    echo.
    echo   2. Run the database schema in Supabase SQL Editor:
    echo      supabase\init-schema.sql
    echo.
    echo   3. Update AI database context:
    echo      Run this in Supabase SQL Editor and paste results into ai-utils\db-schema.md:
    echo      SELECT table_name, column_name, data_type
    echo      FROM information_schema.columns
    echo      WHERE table_schema = 'public';
    echo.
    echo   4. Create a GitHub repo and push:
    echo      git remote add origin ^<YOUR_REPO_URL^>
    echo      git push -u origin master
    echo.
    echo   5. Add environment variables in Vercel:
    echo      VITE_SUPABASE_URL and VITE_SUPABASE_ANON_KEY
    echo.
    echo   6. npm run dev - and start building!
) else (
    echo Next steps:
    echo   1. Fill in your Supabase credentials in .env
    echo      - URL:      Supabase Dashboard ^> Project Settings ^> API ^> Project URL
    echo      - ANON KEY: Supabase Dashboard ^> Project Settings ^> API ^> anon public
    echo.
    echo   2. Run the database schema in Supabase SQL Editor:
    echo      supabase\init-schema.sql
    echo.
    echo   3. Update AI database context:
    echo      Run this in Supabase SQL Editor and paste results into ai-utils\db-schema.md:
    echo      SELECT table_name, column_name, data_type
    echo      FROM information_schema.columns
    echo      WHERE table_schema = 'public';
    echo.
    echo   4. Push to GitHub ^(Lovable will sync automatically^):
    echo      git push
    echo.
    echo   5. Add environment variables in Vercel:
    echo      VITE_SUPABASE_URL and VITE_SUPABASE_ANON_KEY
    echo.
    echo   6. npm run dev - and start building from Cursor or Lovable!
    echo.
    echo   NOTE: Avoid editing the same file from both Cursor and Lovable
    echo         at the same time to prevent merge conflicts.
)

goto :end

:cleanup
if exist ".setup-temp" rmdir /S /Q ".setup-temp"

:end
endlocal
pause
