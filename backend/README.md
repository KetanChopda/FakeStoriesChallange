# Catalogue backend

Node.js 24 and TypeScript API for the product catalogue and enquiries. It fetches products from Fake Store, caches them, and emails enquiries to the sales inbox through Mailpit (locally) or SMTP (later, Amazon SES).

## Endpoints

| Method | Path | What it does |
|---|---|---|
| GET | `/health` | Health check |
| GET | `/products` | All products |
| GET | `/products/:id` | One product (404 if unknown) |
| GET | `/categories` | Category names, sorted |
| POST | `/enquiries` | Sends an enquiry to the sales inbox; returns `201 {"status":"received"}` |

Errors use one shape: `{ "error": { "code": "...", "message": "..." } }`. The API is open (no sign-in and no rate limit), as recorded in DECISIONS.md sections 19 and 20.

## Option A: run with Docker (recommended)

This starts the API and Mailpit together, the same way the iOS app expects them.

1. Install Docker Desktop for Mac (Apple Silicon) from docker.com, open it, and wait until it reports that it is running.
2. Check it:
   ```bash
   docker compose version
   ```
3. From the `backend/` folder, build and start:
   ```bash
   cd backend
   docker compose up -d --build
   ```
4. Check the API and the mail catcher:
   ```bash
   curl http://localhost:3000/health          # {"status":"ok"}
   curl http://localhost:3000/products        # JSON array of 20 products
   open http://localhost:8025                 # Mailpit web UI
   ```
5. Stop when finished:
   ```bash
   docker compose down
   ```

To change the sales address without editing files, set it in your shell before starting:

```bash
SALES_INBOX=you@example.com docker compose up -d --build
```

## Option B: run Node directly (no Docker)

You still need Mailpit or another SMTP server on port 1025 for enquiries to send (the API returns 502 `enquiry_not_sent` otherwise).

```bash
cd backend
cp .env.example .env     # defaults are fine for local use
npm install
npm start                # http://localhost:3000
```

Other checks: `npm run typecheck` and `npm run lint`. The backend has no automated tests, by decision (DECISIONS.md section 19).

## Mailpit: seeing the sales email

Mailpit catches every email the API sends, and nothing is delivered to a real inbox.

- **Web UI:** http://localhost:8025. Each enquiry shows the sales address as the recipient, the customer's address as Reply-To, the product in the subject, and the name, email, phone, and message in the body.
- **API (optional):** `curl http://localhost:8025/api/v1/messages` lists the messages as JSON.
- **Clear the inbox:** use the trash icon in the web UI.

## Run the iOS app against the backend

1. Start the backend first (Option A or B above). The app calls `http://localhost:3000`.
2. Open the Xcode project:
   ```bash
   open ios/FakeStoriesChallange.xcodeproj
   ```
3. In Xcode, choose the **FakeStoriesChallange** scheme and an iPhone simulator, then press **Run** (Cmd+R).
4. Check the app:
   - The home screen loads the products from the backend.
   - Open a product, tap **Enquire**, fill in the form, and send.
   - Open http://localhost:8025. The enquiry email should be there.

The app uses the same address for Debug and Release (`ios/FakeStoriesChallange/Data/Network/NetworkConfig.swift`). `localhost` only works on this Mac, so a release build for a device needs the deployed backend address first. The app allows plain HTTP to `localhost` only (`ios/Info.plist`).

To run the iOS unit tests from the terminal:

```bash
cd ios
xcodebuild test -project FakeStoriesChallange.xcodeproj -scheme FakeStoriesChallange -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Troubleshooting

- **`docker: command not found` or `docker compose` fails:** make sure your Docker runtime is running. With Docker Desktop, its tools are in `/Applications/Docker.app/Contents/Resources/bin`; add that folder to your PATH, or the credential helper fails when pulling images.
- **`docker compose` says "no configuration file provided":** run it from the `backend/` folder.
- **The app shows "Something went wrong" or "You're offline":** the backend is not running, or `localhost:3000` isn't reachable. Check `curl http://localhost:3000/health`.
- **An enquiry returns 502 `enquiry_not_sent`:** Mailpit isn't running. Check `docker compose ps` and `http://localhost:8025`.
- **Port 3000 or 8025 is already in use:** stop the other program, or change the port mapping in `docker-compose.yml` and the app's `NetworkConfig.baseURL` to match.
- **Changes to the code aren't picked up in Docker:** rebuild with `docker compose up -d --build`.
