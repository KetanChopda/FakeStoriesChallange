# Catalogue backend

Node.js 24 and TypeScript backend for the product catalogue and enquiries. The full README (run steps, endpoints, and the check log) is written in module B6; see [BUILD_PLAN.md](BUILD_PLAN.md) for the plan.

## Run locally (B1)

```bash
cd backend
cp .env.example .env
npm install
npm start          # http://localhost:3000/health
npm run lint
npm run typecheck
```
