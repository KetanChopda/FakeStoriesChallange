# Decisions

Architecture and UI choices for the product catalogue, recorded before implementation. Each entry gives the choice, the reason, and the alternatives we rejected.

## 1. Client: native iOS in Swift and SwiftUI, iOS 17 minimum

- **Why:** SwiftUI gives adaptive layout that reacts to window size, which the iPhone Duo and multitasking need. `@Observable`, `NavigationStack`, and the iOS 17 APIs keep the code modern without legacy shims.
- **Rejected:** React web (the brief allows it, but the team chose native iOS), and UIKit (more boilerplate for no gain in a proof of concept).

## 2. Architecture: pragmatic Clean Architecture in one app target

- **Why:** the brief says the data source, look and feel, and email provider will all change. The dependency rule keeps those details behind boundaries, so the core catalogue logic survives the change.
- **Shape:** `Domain` (models, rules, use cases, protocols) depends on nothing. `Data` implements the protocols. `Presentation` (SwiftUI views and view models) depends on `Domain`. `App` is the only place that wires concrete types together.
- **Rejected:** separate Swift packages per layer. They enforce boundaries at compile time but add setup cost. We will split into packages only when the team or the build needs it.

## 3. Only two protocols

- `ProductRepository` and `EnquiryService` are protocols because each has two known implementations: a fake for tests and the backend for the app.
- Everything else is concrete. `APIManager` is a concrete actor, and tests use a `URLProtocol` stub instead of a mock type.
- **Rejected:** a protocol for every type. Protocols without a second implementation add indirection and no value.

## 4. Use cases only where there is policy

- `LoadHome` (top five by rating), `LoadCategory` (top three, then the rest), and `SubmitEnquiry` (validation before sending) hold rules.
- Search and product detail have no policy beyond fetching, so view models call the repository directly. We add a use case when a rule appears.

## 5. Concurrency: only UI runs on the main actor

- View models are `@MainActor` because they hold UI state. Use cases, repositories, the API manager, sorting, filtering, validation, and mapping are not, so they run off the main thread.
- **Why:** keeps scrolling and typing responsive as the catalogue grows.

## 6. Data source: the backend, not Fake Store

- The app reads products and sends enquiries only through the backend (`BackendProductRepository` and `BackendEnquiryService`). The backend fetches from Fake Store and caches the result.
- The earlier direct Fake Store repository (a deviation from the brief, first in Phase 1) was removed once the backend was wired in.

## 7. Adaptive layout for iPhone Duo and resizable windows

- Layout reacts to available width and size class, never to device, idiom, orientation, or `UIScreen`. We use adaptive grids, `ViewThatFits`, and safe-area-aware modifiers.
- The SwiftUI App lifecycle is used throughout, with no `AppDelegate`.
- **Verify:** the iPhone Duo simulator in closed, half-open, and open poses, and iPad split view as a proxy.

## 8. Testing: Swift Testing first, tests written before code

- Swift Testing for all new tests, with parameterized cases where inputs vary. No new XCTest unit tests.
- Network tests use a `URLProtocol` stub, so no test touches the real network. They run serialized because the stub handler is shared.

## 9. Code graph for navigation

- The `codegraph` MCP server indexes the repo so agents can find symbols, callers, and call paths without broad grep reads. See CLAUDE.md.

## 10. Product images load through one configured session

- **Choice:** product images use `AsyncImage` through a single `URLSession` built in `Data/Network/ImageSession.swift`. The session has explicit memory and disk `URLCache` sizes, set in `NetworkConfig.ImageCache`.
- **Why:** the default shared cache has small limits we don't control. An explicit session makes image memory use visible, and a single session is the one place to change caching later.
- **Caching:** on iOS 27+, `AsyncImage(request:)` uses `returnCacheDataElseLoad`, so an image shows from cache first. On earlier iOS, `AsyncImage(url:)` uses standard HTTP caching through the same session.
- **Wiring:** `AppContainer` owns the session and `RootView` applies it with `.imageSession(_:)`, so views never create their own.
- **Rejected:** a third-party image library. It adds a dependency we don't need for a proof of concept.
- **Known gap:** images load straight from `fakestoreapi.com`. The brief forbids direct product-data calls from the client, and images are a grey area. We either proxy images through the backend in Phase 2 or record the exception here.

## 11. Search: on the client, live, scoped by a query value

- **Why client-side:** Fake Store has no search. We checked: `?q=` is ignored and returns the full list, and `/products/search` is not valid JSON. The catalogue is 20 products, so filtering in the app is cheap.
- **Matching:** case-insensitive text match on title, description, and category (`ProductSearch`).
- **Live search:** results update as the user types. Each keystroke restarts a 300 ms wait (`Timing.searchDebounce`), so quick typing sends one request. A search cancelled by a newer keystroke never overwrites newer results.
- **Scope:** `ProductQuery` carries the term and an optional category. Home search has no category; each category page searches only inside its category. New filters such as price or sort go into `ProductQuery`, not new parameters.
- **Blank query:** matches nothing and sends no request.
- **Phase 2:** move matching to the backend (`GET /products?category=&q=`), which also lets the category endpoint be used instead of loading everything.

## 12. Errors: classified, explained, and never a blank screen

- **Classification:** the network layer turns failures into `CatalogueError`: `offline` for lost or unreachable connections, `server` for 5xx responses or bodies that cannot be decoded, and `unknown` for everything else. Repositories translate `APIError` before it reaches the app.
- **States:** every screen shows loading, loaded, empty, or failed. A failed first load shows a `ContentUnavailableView` with a retry button, with a message that matches the error.
- **Refresh:** a failed refresh keeps the data already on screen.
- **Forms:** a failed enquiry keeps what the user typed and says what went wrong next to the send button.
- **Raw errors:** never shown. Messages come from `Copy`.
- **Limit:** the server message is only unit-tested. The live API always responds, so it cannot be seen on the simulator.

## 13. Enquiries: validated locally, emailed by the backend

- The enquiry form validates locally (name, email format, message) and sends through `EnquiryService` to `POST /enquiries`, implemented by `BackendEnquiryService`.
- The backend emails the sales inbox through SMTP (Mailpit locally).
- A sending indicator replaces the button label while a send is in flight, and the button is disabled.

## 14. Assumptions where the brief was unclear

- **Top rated:** highest `rating.rate`; ties go to the higher `rating.count`, then the lower id so the order is stable.
- **Home:** the five top-rated products across the whole catalogue (Fake Store has no curation flag).
- **Category page:** the top three by rating, then the rest in the same order.
- **Categories on home:** taken from the products themselves, sorted alphabetically.
- **Enquiry fields:** name, email, and message are required; phone is optional and is sent as nil when blank. There is no sign-in, so enquiries are anonymous.
- **Products shown on refresh:** the latest successful load replaces the old data; a failed refresh keeps the old data.

## 15. What we cut or simplified, and why

- **Category browsing from the API:** we load the catalogue and filter it, because the catalogue is small and the category endpoint would only add a second code path for now.
- **Pagination, sorting controls, accounts, and wishlists:** not in the brief's acceptance criteria.
- **Visual checks on iPad and iPhone Duo:** still to do. The layout is built to adapt to width, but it has not been checked on those devices yet.

## 16. How the design supports growth

- **Data source:** `ProductRepository` and `EnquiryService` are the two swap points. `AppContainer.live()` is the only place that chooses them.
- **Look and feel:** colours, spacing, symbols, and copy live in `Theme`, `Theme.Symbol`, and `Copy`. Screens hold no literals.
- **Rules:** thresholds (`CatalogueRules`), ranking (`ProductRanking`), search matching (`ProductSearch`), timing (`Timing`), and error messages (`ErrorCopy`) each have one home.
- **Concurrency:** the business logic and network calls run off the main actor, so adding heavier work later does not block the UI.

## 17. Next steps with another day

1. Move search and category filtering to the backend, and use the category endpoint.
2. Proxy product images through the backend, or keep the exception recorded in section 6.
3. Show an in-progress state while a category or product loads, not only on the first load.
4. Distinguish "no connection" from "server down" in the UI test plan with a fake network layer on the simulator.
5. Visual checks on iPad and iPhone Duo in every pose, then a snapshot test for the key screens.

## 18. Pagination: not in this phase or in Phase 2

- **Decision:** the app loads the whole catalogue in one request and shows it in full. There is no paging, no "load more", and no infinite scroll. This stays true for Phase 2 unless the decision is revisited.
- **Why:** the Fake Store catalogue has 20 products, and the brief's acceptance criteria only ask for top-rated, category, search, and detail views. Paging would add loading and cursor state to every screen for no visible benefit.
- **Where it was considered:** the cut is listed in section 15. This section records the reasoning so it isn't mistaken for an oversight.
- **Revisit when:** the catalogue is large enough that loading everything is slow. Until then, the backend returns the full list.
- **Growth path:** if paging is ever needed, it fits behind `ProductRepository`. Screens would call a repository method that returns a page, so the view models and screens change only where they show "load more".

## 19. Backend: built with AI, without automated tests

- **Decision:** the Node.js backend in `backend/` has no automated test suite. The rule of test-first development applies to the iOS client only.
- **Why:** the owner is an iOS developer. The backend is built with AI tools, and checking it through the running API and the iOS app is the review we can actually do.
- **What replaces tests:** every endpoint is exercised by hand against the running server (curl or the iOS app) before it is merged, and the results go in `backend/README.md`.
- **Risk we accept:** regressions in the backend are caught by the iOS app, not by a backend suite. We revisit this if the backend gains logic beyond the catalogue and enquiry endpoints.

## 20. Authentication and rate limiting: not in this phase

- **Decision:** the backend has no authentication and no rate limiting. Anyone who can reach the API can read the catalogue and send enquiries.
- **Why:** the brief doesn't require either. The app is the only intended client, and it runs against a local stack for this demo. The enquiry endpoint sends email to the sales inbox, so this is the risk to watch.
- **Accepted risk:** a caller could flood the sales inbox with enquiries. Anyone who finds the address could also read the catalogue without limit.
- **Revisit when:** the API is deployed publicly. Before that, add rate limiting on `POST /enquiries` and a shared key or sign-in for the app.

## 21. Insecure HTTP allowed for localhost only

- **Decision:** the iOS app allows plain HTTP to `localhost` (App Transport Security exception in `ios/Info.plist`).
- **Why:** the local backend has no TLS certificate.
- **Risk:** localhost traffic is unencrypted. Before a deployed build, use HTTPS and remove the exception.
