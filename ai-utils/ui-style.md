Premium Dashboard Style: "Build a high-end dashboard using shadcn components. Focus on clean white-space, subtle shadows (shadow-sm), and a professional Hebrew font (Heebo/Assistant). Use a fixed sidebar and a responsive top navigation."

Smart Forms Style: "Create a multi-step booking form with real-time Zod validation. RTL aligned, consistent vertical spacing (space-y-6)."

Dashboard Cards Style: "Create a dashboard card with a title, description, and a status indicator. The card should have a subtle shadow (shadow-sm) and a premium look."

## Layout Rules
- All pages use `dir="rtl"` on the root element.
- Main content sits inside a `max-w-7xl mx-auto px-4` container.
- Section headings use `text-2xl font-bold` with `mb-6` spacing below.
- Cards use `rounded-xl border bg-card shadow-sm p-6`.
- Spacing between cards in a grid: `gap-4` (compact) or `gap-6` (airy).

## Color Palette
- Background: `bg-background` (white / slate-50 in light mode)
- Surface: `bg-card` with `border` and `shadow-sm`
- Primary text: `text-foreground`
- Muted text: `text-muted-foreground` (captions, labels)
- Accent: `text-primary` / `bg-primary` (used sparingly for CTAs)
- Destructive: `text-destructive` (errors, delete actions)

## Typography
- Headings: `font-bold` (700), sizes `text-xl` to `text-3xl`
- Body: `font-normal` (400), `text-sm` or `text-base`
- Labels in forms: `text-sm font-medium text-foreground`
- Use `font-['Heebo']` or `font-['Assistant']` via Tailwind `fontFamily` config

## Component Patterns
- Buttons: always use `<Button>` from shadcn. Prefer `variant="default"` for primary, `variant="outline"` for secondary, `variant="destructive"` for delete.
- Inputs: always use `<Input>` / `<Textarea>` from shadcn with a wrapping `<FormField>` (React Hook Form).
- Confirmations: always use `<AlertDialog>` from shadcn. Never `window.confirm()`.
- Tables: use `<Table>` from shadcn with sticky headers on long lists.
- Empty states: show a centered icon + Hebrew message when a list is empty.