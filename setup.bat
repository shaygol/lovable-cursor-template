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

:: Get clone URL
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
echo.

:: Step 1: Clone project to temp folder
echo [1/8] Cloning project...
if exist ".setup-temp" rmdir /S /Q ".setup-temp"
git clone "!CLONE_URL!" ".setup-temp"
if errorlevel 1 (
    echo ERROR: Git clone failed.
    goto :cleanup
)
echo       Done.

:: Step 2: Copy config files
echo [2/8] Copying config files...
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
echo       Done.

:: Step 3: Copy source directories
echo [3/8] Copying src/ and public/ directories...
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
echo       Done.

:: Step 4: Set project title in README files
echo [4/8] Setting project title in README files...
powershell -Command "(Get-Content 'README.md' -Encoding UTF8) -replace '<TITLE>', '!PROJECT_TITLE!' | Set-Content 'README.md' -Encoding UTF8"
powershell -Command "(Get-Content 'README_he.md' -Encoding UTF8) -replace '<TITLE>', '!PROJECT_TITLE!' | Set-Content 'README_he.md' -Encoding UTF8"
echo       Done.

:: Step 5: Create .env from example if it doesn't exist
echo [5/8] Setting up .env...
if not exist ".env" (
    if exist ".env.example" (
        copy /Y ".env.example" ".env" >nul
        echo       Created .env from .env.example — fill in your Supabase credentials.
    ) else (
        echo VITE_SUPABASE_URL=https://your-project.supabase.co > .env
        echo VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9... >> .env
        echo       Created .env placeholder — fill in your Supabase anon key ^(eyJ...^).
    )
) else (
    echo       .env already exists, skipping.
)

:: Step 6: Clean up temp folder
echo [6/8] Cleaning up temp files...
rmdir /S /Q ".setup-temp"
echo       Done.

:: Step 7: Initialize fresh git repository
echo [7/8] Initializing fresh git repository...
if exist ".git" rmdir /S /Q ".git"
git init >nul
echo       Done.

:: Step 8: Install dependencies
echo [8/8] Installing dependencies...
call npm install --legacy-peer-deps
echo       Done.

echo.
echo ============================================
echo   Setup complete!
echo ============================================
echo.
echo Your project "!PROJECT_TITLE!" is ready at: %CD%
echo.
echo Next steps:
echo   1. Fill in your Supabase credentials in .env
echo      - URL:      Supabase Dashboard ^> Project Settings ^> API ^> Project URL
echo      - ANON KEY: Supabase Dashboard ^> Project Settings ^> API ^> anon public ^(eyJ...^)
echo.
echo   2. Run the database schema in Supabase SQL Editor:
echo      supabase\init-schema.sql  ^(roles, profiles, storage policies^)
echo.
echo   3. Populate the db-schema reference for the AI:
echo      Run this query and paste results into ai-utils\db-schema.md:
echo      SELECT table_name, column_name, data_type
echo      FROM information_schema.columns
echo      WHERE table_schema = 'public';
echo.
echo   4. Create a new GitHub repo and push:
echo      git remote add origin ^<YOUR_REPO_URL^>
echo      git add .
echo      git commit -m "Initial commit: !PROJECT_TITLE!"
echo      git push -u origin main
echo.
echo   5. Run the dev server:
echo      npm run dev
echo.
echo   6. Open in Cursor and start building!
echo      Read ai-utils\supabase-patterns.md before touching auth or storage.
echo.
goto :end

:cleanup
if exist ".setup-temp" rmdir /S /Q ".setup-temp"

:end
endlocal
pause
