# AI Rules for FreshSave Application

This document outlines the core technologies and libraries used in the FreshSave application, along with guidelines for their usage.

## Tech Stack Overview

*   **Frontend Framework:** React
*   **Language:** TypeScript
*   **Build Tool:** Vite
*   **Styling:** Tailwind CSS
*   **UI Component Library:** shadcn/ui (built on Radix UI)
*   **Routing:** React Router DOM
*   **State Management / Data Fetching:** React Query
*   **Icons:** Lucide React
*   **Backend / Database:** Supabase
*   **Form Handling & Validation:** React Hook Form with Zod
*   **Notifications:** Sonner and Radix UI Toast

## Library Usage Guidelines

To maintain consistency and best practices, please adhere to the following rules when developing:

*   **UI Components:**
    *   Always prioritize using components from `shadcn/ui`. These are located in `src/components/ui/`.
    *   If a required component is not available in `shadcn/ui` or needs significant customization, create a new component in `src/components/` using Tailwind CSS for styling. Avoid modifying existing `shadcn/ui` component files directly.
*   **Styling:**
    *   All styling must be done using **Tailwind CSS** classes. Avoid inline styles or separate CSS modules unless absolutely necessary for a very specific, isolated case (and only after discussion).
    *   Ensure designs are responsive by utilizing Tailwind's responsive utility classes.
*   **Icons:**
    *   Use icons exclusively from the `lucide-react` library.
*   **Routing:**
    *   Implement all client-side routing using `react-router-dom`.
    *   Define all main application routes within `src/App.tsx`.
*   **State Management & Data Fetching:**
    *   For server state management and data fetching (e.g., fetching deals, reservations, profile data), use `@tanstack/react-query`.
    *   For simple, local component state, use React's built-in `useState` or `useReducer` hooks.
*   **Authentication:**
    *   All authentication logic (sign-up, sign-in, sign-out, session management) must utilize the existing `AuthContext` (`src/contexts/AuthContext.tsx`) and the Supabase client (`src/integrations/supabase/client.ts`).
*   **Internationalization (i18n):**
    *   Use the `LanguageContext` (`src/contexts/LanguageContext.tsx`) for all text translations and currency formatting.
*   **Form Handling:**
    *   For complex forms, use `react-hook-form` to manage form state and validation.
    *   For schema validation, use `zod` in conjunction with `@hookform/resolvers`.
*   **Notifications:**
    *   For general, non-blocking notifications (e.g., "Reservation confirmed!"), use `sonner`.
    *   For more persistent or interactive toasts (e.g., error messages that might require user action), use the `useToast` hook which leverages `@radix-ui/react-toast`.
*   **Date & Time:**
    *   Use `date-fns` for all date and time manipulation, formatting, and parsing.
*   **Utility Functions:**
    *   For common utility functions, such as merging Tailwind classes, use `src/lib/utils.ts`.
*   **File Structure:**
    *   New components should be created in `src/components/`.
    *   New pages should be created in `src/pages/`.
    *   Hooks should be in `src/hooks/`.
    *   Contexts should be in `src/contexts/`.
    *   All directory names must be lowercase.