# Rubric: Astro sites (JavaScript)

Primary lens: Astro's own model. Content-first, static by default, zero client JS unless
it earns its place, islands only where interaction is real. JavaScript (.js/.mjs, JSDoc
types if needed); if the project already uses TypeScript, respect it and do not flag it.
Secondary lens: component design principles (single responsibility, composition over
configuration). When they conflict with simplicity, simplicity wins: report under "Tensions".

Do not recommend frameworks, UI libraries or patterns because they are popular. Recommend a
change only when it removes a concrete problem. Adding abstractions is a cost, not a win.

## Slices

| Slice | Paths |
|---|---|
| pages | src/pages, src/layouts, routing and middleware (src/middleware.*) |
| components | src/components (including framework islands) |
| content | src/content, content config / collections, data files |
| scripts-styles | client scripts, src/scripts, src/styles, Tailwind/CSS config |
| config | astro.config.*, package.json, lockfile, integrations, adapters, env handling, public/ |

## Rules

### A. Astro model

- A1. Zero JS by default. Flag framework components (React, Vue, Svelte, Preact) used for static markup that could be a .astro component. Flag islands with no real interactivity.
- A2. Hydration directives. Flag `client:load` where `client:visible`, `client:idle` or `client:media` would do. Flag large islands that could be split so only the interactive part hydrates.
- A3. Small scripts over frameworks: simple interactions (menus, tabs, accordions, carousels) should be a `<script>` in the .astro component or a small custom element, not a framework island.
- A4. Content collections with a schema for structured content (projects, listings, apartments, posts). Flag content hardcoded in pages or duplicated across files.
- A5. Images through `astro:assets` (`<Image>` / `<Picture>`) with width, height and alt. Flag raw `<img>` for local images, oversized files in public/, missing alt text.
- A6. Layouts and SEO: one base layout with title, description, canonical, Open Graph, lang attribute; per-page values passed as props. Flag pages missing them.
- A7. Rendering mode: static unless a page truly needs on-demand rendering. Flag SSR/adapter usage without a reason, and pages marked `prerender = false` that could be static.
- A8. Dependencies. Flag packages used once for trivial things, unused integrations, and duplicated UI libraries.

### C. Components

- C1. Single responsibility: flag components that mix data fetching, layout and several unrelated UI pieces.
- C2. Props over duplication: flag near-identical components that differ only in text or style; suggest props or slots.
- C3. Accessibility: semantic HTML, headings in order, labels on form fields, focus states, keyboard-operable interactive elements, sufficient contrast where detectable.

### X. Cross-cutting

- X1. Security: secrets in client code; env vars with the `PUBLIC_` prefix (or exposed via `import.meta.env` in client scripts) that should be private; form endpoints without validation, spam protection or rate limiting; `set:html` with untrusted content.
- X2. Performance: render-blocking fonts or scripts, unoptimized third-party embeds (maps, video, analytics) loaded eagerly, missing `loading="lazy"` where applicable.
- X3. Dead code: unused components, styles, pages, assets.

## Review focus (for a single change)

Client JS added where static HTML would do; wrong hydration directive; images not going through astro:assets; missing alt/labels; private env vars exposed to the client; SEO props missing on new pages.

## Verification

1. `npx astro check` if configured
2. `npm run build` (must succeed with no new warnings)
3. `npm test` only if a test script exists
