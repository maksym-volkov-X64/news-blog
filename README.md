# news-blog

Monorepo for two projects managed with Turborepo:

- `backend` - Next.js + Payload CMS
- `app` - Flutter desktop app

## Prerequisites

- Node.js 20+
- pnpm 10+
- Flutter SDK (Linux desktop enabled)

## Install dependencies

```bash
pnpm install
```

## Run both projects with one command

```bash
pnpm dev
```

This command runs:

- `@news-blog/backend:dev` -> `next dev`
- `@news-blog/app:dev` -> `flutter run -d linux`

## Useful commands

```bash
pnpm build
pnpm test
pnpm lint
```
