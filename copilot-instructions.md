# Copilot Instructions for DSH Frontend

## Guidelines
- You are an expert frontend developer using React, TypeScript, Vite, and modern web development practices.
- Follow best practices for code quality, testing, and architecture.
- Ensure code is maintainable, well-documented, and adheres to the project's coding standards
- Think step-by-step and provide detailed, thoughtful answers.
- Double-check your work before providing an answer.
- When explaining concepts, provide clear examples and references to relevant documentation when applicable.
- Obey biome linting and formatting rules.
- Use absolute imports with the `~` alias for project files.
- Functions/methods should have at max 4 parameters and be under 20 lines where possible.
- Be concise and minimize extraneous prose.
- If you don't know the answer, say so instead of guessing.
- Always ensure tests, type checks, and linting pass before finalizing code. This is a golden rule and cannot be broken.
- When working with React, React Router 7, and Typescript use context7.
- When writing or refactoring, use the instructions at .github/prompts/use-test-driven-development.prompt.md for test-driven development.
- Follow WCAG 2.1 AA accessibility standards for all UI components and interactions.

## Common Development Commands

### Testing
- `npm test -- --no-watch` - Run unit tests with Vitest
- `npm run test:coverage` - Run tests with coverage report

### Code Quality
- `npm run typecheck` - Run TypeScript type checking (includes React Router typegen)
- `npm run lint` - Run Biome linter and import sorter (read-only)
- `npm run lint-fix` - Auto-fix Biome linter and import issues
- `npm run format` - Check code formatting with Biome (read-only)
- `npm run format-fix` - Auto-fix code formatting
- `npm run biome` - Run all Biome fixes (linter, formatter, imports)

## Architecture Overview

### Tech Stack
- **Framework**: React Router v7 with Server-Side Rendering (SSR)
- **Build Tool**: Vite with TypeScript
- **Styling**: CSS Modules for component-scoped styles
- **Auth**: Auth0 with React integration
- **Form Handling**: Formik + Yup for validation
- **Testing**: Vitest + Testing Library + jsdom
- **Linting**: Biome (replaces ESLint/Prettier)
- **Telemetry**: spe-telemetry SDK with Jaeger tracing
- **Module Federation**: @elilillyco/unex-federation-utils for shared components

### Project Structure
- `app/` - Main application code (uses `~` alias)
    - `root.tsx` - App shell with loader, layout, Auth0 setup
    - `routes.ts` - Route configuration
    - `routes/` - File-based routing with loaders/actions/components
    - `components/` - Shared UI components
    - `contexts/` - React contexts (UserDataContext)
    - `providers/` - Auth0Provider wrapper
    - `utils/` - Utilities (cookies, logger, federation registry)
    - `server/` - Server-side environment configuration
    - `css/` - Global styles and theme tokens
- `public/` - Static assets
- `documents/` - Project documentation

### Key Concepts

#### Authentication & Environment
- Environment variables read via `app/server/environment.ts`

#### SSR & Routing
- SSR enabled with React Router v7
- Route data loaded via loaders, accessed with useLoaderData/useRouteLoaderData
- Global config (auth, federation) available from root loader

### Development Guidelines

#### Coding Standards
- Follow SOLID principles
- Functions under 20 lines preferred
- Add JSDoc to public/exported functions and components
- Avoid implementation comments explaining code
- Use TypeScript strict mode, avoid `any`
- Use types to interfaces unless necessary
- Use explicit function signatures for exports

#### Component Development
- Use @elilillyco/design-system-react for Typography, Buttons, form fields
- Check `app/components/Form/` for custom form implementations first
- Colocate component-specific styles as `*.module.css`
- Keep route-specific logic within route modules
- Use absolute imports with `~` path alias
- Run `npm run lint-fix` and `npm run format-fix` after completing changes

#### Testing
- Use Vitest + @testing-library/react + @testing-library/user-event
- Colocate tests as `*.spec.tsx` next to components
- Test observable behavior, not implementation details
- Query by role/name/label, avoid testids when possible
- Use `app/setupTests.ts` for shared test configuration

#### Styling
- CSS Modules for component-scoped styles
- Global styles in `app/css/app.css`
- Theme tokens in `app/css/theme/`
- Prefer semantic HTML with accessibility attributes

#### Authentication
- Use `useAuth` hook for authentication state
- Wrap components requiring auth with `withAuthenticationRequired` HOC
- Auth0 configuration managed via Auth0Provider wrapper
- Access user data via UserDataContext

## Accessibility Guidelines

### WCAG 2.1 AA Compliance
All components and features must meet WCAG 2.1 Level AA standards.

#### When Generating React Components:

**Semantic HTML:**
- Use semantic HTML elements (`<button>`, `<nav>`, `<main>`, `<article>`, etc.)
- Avoid non-semantic divs for interactive elements
- Use `<button>` for actions, `<a>` for navigation

**ARIA Labels and Roles:**
- Add `aria-label` or `aria-labelledby` for interactive elements without visible text
- Use `aria-describedby` for additional context
- Include proper `role` attributes when semantic HTML isn't sufficient
- Avoid redundant ARIA (e.g., `role="button"` on `<button>`)

**Images and Media:**
- Always include meaningful `alt` text for images
- Use `alt=""` for decorative images
- Provide captions or transcripts for video/audio content
- Use `aria-hidden="true"` for decorative icons

**Heading Hierarchy:**
- Maintain logical heading order (h1 → h2 → h3, don't skip levels)
- Only one h1 per page (usually the page title)
- Use headings to structure content, not for styling

**Focus Management:**
- Ensure visible focus indicators on all interactive elements
- Don't remove outline without providing alternative focus style
- Trap focus in modals and dialogs
- Return focus to trigger element when closing modals
- Use `useRef` and `.focus()` for programmatic focus management

**Dynamic Content:**
- Use `aria-live` regions for dynamic updates (alerts, notifications)
- Announce loading states with `aria-busy` and `aria-live="polite"`
- Provide text alternatives for icon-only buttons
- Use `aria-expanded` for collapsible content

**Testing Requirements:**
- Verify ARIA attributes are correctly applied
- Test with screen reader guidelines in mind

#### Resources:
- WCAG 2.1 Guidelines: https://www.w3.org/WAI/WCAG21/quickref/
- ARIA Authoring Practices: https://www.w3.org/WAI/ARIA/apg/
- React Accessibility Docs: https://react.dev/learn/accessibility

## Environment Requirements
- Node.js >= 22.13 < 23
- Backend API at DSH_API_BASE_URL (default: http://localhost:3001)
