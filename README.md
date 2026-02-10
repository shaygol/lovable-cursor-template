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

The `setup.bat` script is the fastest way to turn this template into a working project. It performs an automatic merge between the code generated in Lovable and the template's professional infrastructure.

### Requirements

- [Git](https://git-scm.com/) installed and available in PATH
- [Node.js](https://nodejs.org/) (v18 or above)
- A Lovable GitHub repository URL

### Usage

```bash
setup.bat <LOVABLE_GITHUB_URL>
```

Or alternatively, run without parameters - the script will ask for details interactively:

```bash
setup.bat
```

### What the Script Does (9 Steps)

| Step | Action |
|------|--------|
| 1 | Clones the Lovable project to a temporary folder |
| 2 | Saves the original Lovable README as `README_lovable.md` |
| 3 | Merges configuration files (`package.json`, `vite.config.ts`, `tailwind.config.ts`, etc.) |
| 4 | Copies source directories (`src/`, `public/`, `supabase/`) |
| 5 | Replaces `<TITLE>` with the entered project name in README files |
| 6 | Cleans up the temporary folder |
| 7 | Resets Git - removes the template history and initializes a fresh repo |
| 8 | Installs all dependencies (`npm install`) |
| 9 | Creates a base commit marking the starting point for development |

The script deletes the template's `.git` folder and initializes a brand new repository. This way your project starts with a clean history, completely disconnected from the original template.

### After Setup

```bash
# Create a new repo on GitHub and connect it
git remote add origin <YOUR_REPO_URL>
git push -u origin main

# Run the project
npm run dev

# Update the database schema in ai-utils/db-schema.md
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
<TITLE>/
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