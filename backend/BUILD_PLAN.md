# Backend build plan (Phase 2)

Node.js and TypeScript backend for the catalogue and enquiries. Built one module at a time, the same way as the iOS client. There are no automated tests for this backend, by decision (DECISIONS.md section 19); each module is checked by running it and calling its endpoints by hand, and the results are recorded in `backend/README.md`.

## Goals

- The backend is the only caller of Fake Store. The iOS client stops calling it directly, which resolves the deviation in DECISIONS.md section 6.
- Enquiries reach the sales inbox by email, which the brief requires.
- Runs locally in one command (`docker compose up`) and can be deployed to AWS later.

## Prerequisites (not installed on this Mac yet)

- **Node.js 22 or later** (native TypeScript type stripping, as in the `node` skill). Node is not installed here.
- **Docker Desktop** with Compose, for the mail catcher and the containerised run. Docker is not installed here.
- Installing these needs your go-ahead, because it installs software on the machine.

## Stack

| Concern | Choice | Why |
|---|---|---|
| Runtime | Node.js 22+, TypeScript run with type stripping | No build step in development; matches the `node` skill |
| HTTP | Fastify | Named in the `fastify` skill; JSON Schema validation and fast serialisation |
| Lint | neostandard on ESLint 9 flat config | Named in the `linting-neostandard-eslint9` skill |
| Email | SMTP through a `Mailer` interface (nodemailer) | Locally Mailpit catches mail; in AWS, SES over SMTP. The interface keeps the provider swappable |
| Mail catcher (local) | Mailpit in Docker Compose | Shows the sales email in a web UI on port 8025 |
| Product data | Fake Store, fetched by the backend and cached in memory | Keeps the Fake Store call on the server side |
| Config | Environment variables; `.env.example` committed, `.env` ignored | No secrets in the repo |

## Endpoints

| Method | Path | Purpose |
|---|---|---|
| GET | `/health` | Liveness check |
| GET | `/products` | All products (see DECISIONS.md section 18: no paging) |
| GET | `/products/:id` | One product |
| GET | `/categories` | Unique category names, sorted |
| POST | `/enquiries` | Validate an enquiry and email it to the sales inbox; returns 201 |

Errors use one JSON shape: `{ "error": { "code": "...", "message": "..." } }`. Validation failures are 400, unknown products are 404, and an unreachable Fake Store is 502, which the iOS client already shows as a server error.

## Module order

Each module is one commit, and each is checked before the next starts.

| # | Module | Contents | How it is checked |
|---|---|---|---|
| B1 | Scaffold and tooling | `backend/package.json`, `tsconfig.json`, `eslint.config.mjs`, `.env.example`, `.gitignore`, server entry with `/health` | `npm run lint` passes; `/health` returns 200 |
| B2 | Catalogue | Fake Store client, in-memory cache with a time limit, `/products`, `/products/:id`, `/categories`, error mapping | Curl each endpoint; stop the network and check 502 |
| B3 | Enquiries and mail | `POST /enquiries` with validation, `Mailer` interface, SMTP mailer to Mailpit | Curl a valid and an invalid enquiry; the email appears in Mailpit at `localhost:8025` |
| B4 | Containers | Multi-stage `Dockerfile`, `docker-compose.yml` (api and Mailpit), healthcheck | `docker compose up`; repeat the B2 and B3 checks against the containers |
| B5 | iOS switch | `BackendProductRepository` and `BackendEnquiryService` in `ios/`, base URL set in `AppContainer.live()`, Fake Store client removed from the app | Run the app in the simulator against the backend; the iOS test suite still passes after its Fake Store tests are replaced |
| B6 | Documentation | `backend/README.md` (run steps, endpoints, check log), DECISIONS.md section 6 updated, AI_USAGE.md updated | Read-through; the README steps are run from a clean checkout |

## Decisions to confirm before B1

1. **Node version:** 22 LTS, or 24 if you prefer the newest.
2. **Sales inbox address:** a placeholder in `.env.example` (for example `sales@example.com`) that you replace locally.
3. **iOS switch (B5):** I suggest doing it on this branch, as the last code module, so the Fake Store deviation is removed in the same change that adds the backend. The iOS tests change at that point, so B5 is reviewed separately.
4. **Install Node and Docker:** tell me to go ahead, or install them yourself and tell me when they're ready.

## Out of scope for this phase

- Authentication, rate limiting, and CORS (the iOS client is native and doesn't need CORS).
- Database. The catalogue is cached in memory; enquiries are emailed, not stored.
- Server-side search and category filtering. The iOS client keeps filtering on the client until the catalogue grows.
- Pagination (DECISIONS.md section 18).
- The AWS deployment itself. The containers are built so that deployment is a later step.
