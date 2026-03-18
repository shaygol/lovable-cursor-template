# Lovable to Cursor: <TITLE>

> [README in Hebrew](README_he.md) | [Original Lovable README](README_lovable.md)

A premium Hebrew (RTL) web application built with cutting-edge 2026 technologies. Powered by a robust React foundation, designed to premium standards, and optimized for intensive AI-assisted development. The goal of this template is to bridge the gap between rapid prototyping and building a stable, standards-compliant, and long-term maintainable application.

## What is this Template?

[Lovable](https://lovable.dev) is an AI-powered tool that generates full React applications in minutes - but the generated code is only the starting point. Once you begin serious development in Cursor, you need a professional foundation: clear AI rules, design guides, database mapping, and a folder structure the agent can navigate.

**This template does exactly that.** It provides the entire "awareness" layer that needs to wrap the Lovable-generated code:

- **`.cursorrules`** — Development rules that prevent the AI from making mistakes and guide it toward high standards.
- **`ai-utils/`** — Context files that enable the AI to understand the project's design, database, and visual elements.
- **Detailed READMEs** — Bilingual documentation (Hebrew and English) that guides both the developer and the AI agent.

## New Project Setup (setup.bat)

The `setup.bat` script merges the Lovable-generated code into this template's professional infrastructure.

### Step 1 — Create your project repo from this template

On GitHub, click **"Use this template" > "Create a new repository"**, name it, and clone it to your machine.

> This gives you a fresh repo already connected to your GitHub - no manual `git remote` needed.

### Step 2 — Run setup.bat

```bash
setup.bat <LOVABLE_GITHUB_URL>
```

Or without parameters for interactive mode:

```bash
setup.bat
```

### Choose your work mode

The script asks you to choose between two modes:

| | Mode 1: Cursor only | Mode 2: Cursor + Lovable |
|---|---|---|
| **Git** | Fresh history, disconnected from Lovable | Keeps GitHub connection, Lovable stays in sync |
| **Lovable deps** | Removed (`lovable-tagger`, `cloud-auth-js`) | Kept as-is |
| **After setup** | Create new GitHub repo and push | `git push` — Lovable syncs automatically |
| **Best for** | Full Cursor development | Using both tools in parallel |

> **Tip for mode 2:** Avoid editing the same file from both Cursor and Lovable simultaneously to prevent merge conflicts.

### What the Script Does (11 Steps)

| Step | Action |
|------|--------|
| 1 | Clones the Lovable project to a temporary folder |
| 2 | Copies configuration files (`package.json`, `vite.config.ts`, etc.) — skips `index.html` in mode 2 |
| 3 | Copies source directories (`src/`, `public/`, `supabase/`) — protects `src/integrations/` in mode 2 |
| 4 | Saves the original Lovable README as `README_lovable.md` |
| 5 | Replaces `<TITLE>` with the entered project name in README files |
| 6 | Removes Lovable-specific dependencies (mode 1 only) |
| 7 | Adds Cursor-only entries to `.gitignore` (prevents template files from being pushed to GitHub) |
| 8 | Creates `.env` from `.env.example` |
| 9 | Cleans up the temporary folder |
| 10 | Git setup (fresh repo for mode 1 / commit + push for mode 2) |
| 11 | Installs all dependencies (`npm install --legacy-peer-deps`) |

### Step 3 — After Setup

```bash
# Run the project
npm run dev

# Run supabase/init-schema.sql in Supabase SQL Editor

# Update the database schema reference for the AI
# Run in Supabase SQL Editor and paste into ai-utils/db-schema.md:
# SELECT table_name, column_name, data_type
# FROM information_schema.columns
# WHERE table_schema = 'public';

# Add environment variables in Vercel:
# VITE_SUPABASE_URL and VITE_SUPABASE_ANON_KEY

# Open in Cursor and start building!
```

## The Stack

Carefully selected for maximum performance, easy maintenance, and a smooth user experience:

- **Framework:** React 18+ with Vite for fast builds and TypeScript for code quality and compile-time error prevention.
- **Styling:** Tailwind CSS combined with shadcn/ui for a modular, consistent, and accessible UI.
- **Icons:** Lucide React - lightweight, flexible vector icon library with easy customization.
- **Data:** TanStack Query for state management with Supabase (Backend-as-a-Service), including automatic cache management and data synchronization.
- **Forms:** Complex form management with React Hook Form and strict Schema Validation using Zod.
- **Charts:** Recharts for dynamic, responsive data visualization.
- **Animations:** Framer Motion for subtle UI animations, smooth transitions, and a premium user experience.
- **Dates:** date-fns for complex date handling, calculations, and full Hebrew localization support.

## Getting Started

### Prerequisites

- [Node.js](https://nodejs.org/) (v18 or above)
- Modern package manager (npm, pnpm, or bun)

### Installation & Running

```bash
# Install all project dependencies
npm install

# Run the project in local development mode with Hot Reload
npm run dev

# Build an optimized production release
npm run build
```

## Project Structure

Designed for easy navigation by both human developers and AI agents, with a clear separation between logic, design, and configuration:

```
<project-name>/
├── ai-utils/             # The operational brain: AI agent configuration and guidance files
│   ├── db-schema.md      # Database schema definitions - the single source of truth for data
│   ├── ui-style.md       # Visual style guide for design consistency (Design System)
│   └── visual-assets.md  # Mapping of icons, statuses, and fixed visual elements
├── src/
│   ├── components/
│   │   └── ui/           # Atomic core shadcn/ui components
│   ├── pages/            # Main application pages (Views)
│   ├── hooks/            # Reusable logic and state management (Custom Hooks)
│   ├── lib/              # Third-party configurations (Supabase client, utils)
│   └── types/            # Global TypeScript definitions and Interfaces
├── .cursorrules          # "House rules" defining AI-assisted development practices
└── package.json          # Package management, scripts, and versions
```

## RTL & Hebrew

The application is designed from the ground up for full right-to-left (RTL) support:

- **Logical Properties:** Exclusive use of properties like `ms-*` (Margin Start) and `pe-*` (Padding End) instead of fixed sides (Left/Right) to ensure flexibility and automatic adaptation to all writing directions.
- **Typography:** Modern fonts optimized for digital Hebrew such as 'Heebo' or 'Assistant', with proper weight hierarchy (Bold for headings, Regular for body text).
- **Localization:** All user-facing text, error messages, and form labels are written in professional, standard Hebrew.

## The Rules File (.cursorrules)

The `.cursorrules` file is the beating heart of Cursor-based development. It defines the AI's professional "personality" and ensures the generated code is high-quality and consistent:

- **Standards Enforcement:** Prevents the AI from using dangerous shortcuts (like the `any` type), and enforces functional, clean, and modular code.
- **Automatic RTL Management:** The AI receives explicit instructions to use Logical Properties, preventing Hebrew interface breakage when adding new components.
- **No Guessing:** Creates a safety protocol - if database information is missing, the AI must stop and request clarification instead of "inventing" table names.
- **Lovable Continuity:** The AI automatically detects projects originating from Lovable and respects their coding conventions (such as the Tagger and Aliases), preventing code conflicts.

## AI-Assisted Development

The `ai-utils/` folder is the hub where the project's context is stored. It ensures the AI deeply understands the system:

- **`ui-style.md`** — The design DNA: defines what a premium dashboard looks like, how smart forms behave, and what the correct spacing between info cards should be. This is the "Style Guide" that directs the AI to maintain the Premium look.
- **`visual-assets.md`** — Visual consistency: ensures that an "active" status is always green with the same icon, and that the navigation bar uses the same symbols on every new page created.
- **`db-schema.md`** — The query roadmap: enables the AI to write accurate server-side (Supabase) code by understanding table relationships (Foreign Keys) and data types.

## Lovable Detection

The project includes a smart detection mechanism that identifies if the source was created in Lovable. When detected, the AI is instructed to respect the `lovable-tagger`, the existing Components structure, and the use of `@` as a shortcut path to the `src` folder, maintaining seamless integration between the design tool and the local codebase.

## AI Configuration & Maintenance

To get the most out of the Cursor development experience and minimize errors:

### 1. Indexing & Docs

It is recommended to add the following links in Cursor Settings > Docs so the AI can reference the most up-to-date official documentation:

- **Supabase:** https://supabase.com/docs
- **Tailwind:** https://tailwindcss.com/docs
- **shadcn/ui:** https://ui.shadcn.com/docs

### 2. Schema Updates

Every time the table structure changes in Supabase, update the `ai-utils/db-schema.md` file. Run the following query in the Supabase SQL Editor and paste the result:

```sql
select table_name, column_name, data_type 
from information_schema.columns 
where table_schema = 'public';
```

### 3. Using Effective Prompts

For the AI to perform at its best, explicitly reference the context files using `@`:
`"Create a new customer management page based on @ui-style.md and the data tables in @db-schema.md."`

---
