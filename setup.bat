@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ============================================
echo   Lovable to Cursor - Project Setup
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
    set /p "CLONE_URL=Enter the Lovable GitHub clone URL: "
) else (
    set "CLONE_URL=%~1"
)

if "!CLONE_URL!"=="" (
    echo ERROR: No URL provided.
    goto :end
)

:: Ask for project title
set /p "PROJECT_TITLE=Enter project title: "

echo.
echo Clone URL: !CLONE_URL!
echo Project title: !PROJECT_TITLE!
echo Working directory: %CD%
echo.

:: Step 1: Clone to a temp folder
echo [1/9] Cloning Lovable project...
if exist ".lovable-temp" rmdir /S /Q ".lovable-temp"
git clone "!CLONE_URL!" ".lovable-temp"
if errorlevel 1 (
    echo ERROR: Git clone failed.
    goto :cleanup
)
echo       Done.

:: Step 2: Save Lovable's original README
echo [2/9] Saving Lovable README as README_lovable.md...
if exist ".lovable-temp\README.md" (
    copy /Y ".lovable-temp\README.md" "README_lovable.md" >nul
)
echo       Done.

:: Step 3: Copy Lovable files into current folder (skip template files)
echo [3/9] Merging Lovable files into project...
for %%F in (
    ".lovable-temp\package.json"
    ".lovable-temp\package-lock.json"
    ".lovable-temp\bun.lockb"
    ".lovable-temp\vite.config.ts"
    ".lovable-temp\tailwind.config.ts"
    ".lovable-temp\tsconfig.json"
    ".lovable-temp\tsconfig.app.json"
    ".lovable-temp\tsconfig.node.json"
    ".lovable-temp\components.json"
    ".lovable-temp\postcss.config.js"
    ".lovable-temp\eslint.config.js"
    ".lovable-temp\index.html"
) do (
    if exist "%%~F" copy /Y "%%~F" "." >nul 2>nul
)
echo       Done.

:: Step 4: Copy source directories from Lovable
echo [4/9] Copying src/ and public/ directories...
if exist ".lovable-temp\src" (
    if not exist "src" mkdir "src"
    xcopy ".lovable-temp\src\*" "src\" /E /Y /Q >nul
)
if exist ".lovable-temp\public" (
    if not exist "public" mkdir "public"
    xcopy ".lovable-temp\public\*" "public\" /E /Y /Q >nul
)
if exist ".lovable-temp\supabase" (
    if not exist "supabase" mkdir "supabase"
    xcopy ".lovable-temp\supabase\*" "supabase\" /E /Y /Q >nul
)
echo       Done.

:: Step 5: Replace <TITLE> in README files
echo [5/9] Setting project title in README files...
powershell -Command "(Get-Content 'README.md' -Encoding UTF8) -replace '<TITLE>', '!PROJECT_TITLE!' | Set-Content 'README.md' -Encoding UTF8"
powershell -Command "(Get-Content 'README_he.md' -Encoding UTF8) -replace '<TITLE>', '!PROJECT_TITLE!' | Set-Content 'README_he.md' -Encoding UTF8"
echo       Done.

:: Step 6: Clean up temp folder
echo [6/9] Cleaning up temp files...
rmdir /S /Q ".lovable-temp"
echo       Done.

:: Step 7: Reset git - remove template history and create a fresh repo
echo [7/9] Initializing fresh git repository...
if exist ".git" rmdir /S /Q ".git"
git init >nul
echo       Done.

:: Step 8: Install dependencies
echo [8/9] Installing dependencies...
call npm install
echo       Done.

:: Step 9: Create base commit
echo [9/9] Creating base commit...
git add .
git commit -m "Base: !PROJECT_TITLE! — Lovable project merged with Cursor template" >nul
echo       Done.

echo.
echo ============================================
echo   Setup complete!
echo ============================================
echo.
echo Your project "!PROJECT_TITLE!" is ready at: %CD%
echo.
echo Next steps:
echo   1. Create a new repo on GitHub for your project
echo   2. Connect it:  git remote add origin ^<YOUR_REPO_URL^>
echo   3. Push:        git push -u origin main
echo   4. Run:         npm run dev
echo   5. Open Supabase SQL Editor and run the query from ai-utils/db-schema.md
echo   6. Paste the schema results into ai-utils/db-schema.md
echo   7. Open in Cursor and start building!
echo.
goto :end

:cleanup
if exist ".lovable-temp" rmdir /S /Q ".lovable-temp"

:end
endlocal
pause
