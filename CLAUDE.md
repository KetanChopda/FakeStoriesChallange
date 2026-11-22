# CLAUDE.md

Guidance for AI agents working in this repository.

## Project

Product catalogue take-home (AI-Native Engineer challenge). Phase 1 is an iOS client in Swift and SwiftUI (iOS 17+). Phase 2 adds a Node.js + TypeScript backend, which is not started yet.

Acceptance criteria: home shows 5 top-rated products; category page shows top-rated then the rest; search filters by text; tile opens product detail; Enquire form submits and shows a thank-you.

## Hard constraints from the brief

- The client must not call the Fake Store API directly in the final design. Phase 1 has one temporary `FakeStoreProductRepository` behind the `ProductRepository` protocol. Record this deviation in DECISIONS.md. Phase 2 replaces it with a backend-backed repository.
- No secrets committed. Use an example env file for configuration.
- No paid services or accounts the reviewer must create.

## Architecture

Follow `.claude/skills/clean-architecture-ios/SKILL.md`. Summary:

- Dependency rule: Views -> ViewModels -> (Use Cases where policy exists) -> Repository/Service protocols -> concrete implementations.
- Concrete types by default. A protocol needs a visible reason. Current justified protocols: `ProductRepository` and `EnquiryService`. Do not add protocols for mocking alone; use `URLProtocol` stubs or in-memory implementations.
- Use cases only for policy: `LoadHome`, `LoadCategory`, `SubmitEnquiry`. Search and product detail call the repository directly.
- Domain imports Foundation only. No SwiftUI, UIKit, or networking types in Domain.
- Composition happens only in `App/` (`AppContainer` and feature factories). No infrastructure built in Views, ViewModels, or Use Cases. No service locator.
- Folders: `App/`, `Domain/`, `Data/`, `Presentation/`, and `FakeStoriesChallangeTests/`. One app target and one test target.

## SwiftUI

Follow `.claude/skills/swiftui-specialist` and `.claude/skills/swiftui-whats-new-27`. Key rules:

- ViewModels: `@MainActor @Observable final class` because they hold UI state. Stored property types should be `Equatable`.
- Use `NavigationStack`. Do not use `NavigationView`, `ObservableObject`, or the old `onChange`.
- `@State` properties are `private`. Views receive only the fields they read.
- `ForEach` and `List` use stable identifiers, such as the product id. No `id: \.self`, no indices, no filtering or sorting in `body`.
- Use `LocalizedStringKey` in views and `LocalizedStringResource` on non-view types.
- iOS 27 APIs are guarded with `#available`. The deployment target stays iOS 17.

- Empty, error, and no-result states use SwiftUI's native `ContentUnavailableView` (iOS 17+), never a custom view. Search uses `ContentUnavailableView.search(text:)`. Error states add a retry action. Symbol names live in `Theme.Symbol`.

## Error handling

Errors are handled gracefully on every screen, with no blank screens and no crashes.

- Every screen covers loading, loaded, empty, and failed states.
- A failed first load shows `ContentUnavailableView` with a retry action.
- A failed refresh keeps the data already on screen.
- A failed form submission keeps what the user typed and says what went wrong next to the action, so they can retry without re-entering anything.
- Repositories and use cases throw typed errors. User-facing messages come from `Copy`; raw error text is never shown.
- Each failure path has a test, using the fakes in `Support/`.

## Adaptive layout (iPhone Duo and resizable windows)

Follow `.claude/skills/app-resizability`. Layout reacts to available width and size class, never to device, idiom, orientation, or `UIScreen`. Use `horizontalSizeClass`, adaptive grids, and `ViewThatFits`. Use the SwiftUI App lifecycle only, with no `AppDelegate`.

Verify on the iPhone Duo simulator in closed, half-open, and open poses, following `.claude/skills/device-interaction`.

## Testing

- Use Swift Testing: `import Testing`, `@Test`, `#expect`, `#require`, `@Suite` structs, and `@Test(arguments:)`. Do not write new XCTest unit tests. Follow `.claude/skills/modernize-tests`.
- Write tests first for each layer, then implement.
- Test doubles are small concrete types or stubs, not generated mocks.

## Conventions

- Every new Swift file starts with the Xcode default header:

  ```swift
  //
  //  FileName.swift
  //  FakeStoriesChallange
  //
  //  Created by Ketan on 22/11/26.
  //
  ```

- Concurrency: only UI code runs on the main actor. Any non-UI work (sorting, filtering, ranking, search matching, validation, mapping, networking) runs off the main thread, in `nonisolated` functions or actors. Do not mark use cases, repositories, mappers, or the API manager `@MainActor`.
- Do not mark a type `@MainActor` just to silence a concurrency warning. Pass the result back to the ViewModel instead.
- One `APIManager` (a single actor or final class) owns all network calls. Repositories depend on it; nothing else calls `URLSession`.
- Endpoints are an enum (`APIEndpoint`) with cases for path, method, and query. The enum is the only place paths are built, so every endpoint goes through the same manager.
- No inline string or number literals in logic. Put them in named constants or enums in a meaningful folder, such as `Data/Network/` for URLs and headers, `Domain/Rules/` for thresholds like the top-5 count, and `Presentation/Theme/` for layout values.
- Comments are crisp: one or two lines, explaining why, not what. No multi-paragraph doc blocks.
- Write code testable by default: pure functions where possible, dependencies passed in through initializers or parameters, no hidden singletons, no `Date()`/`UUID()`/`URLSession.shared` calls inside logic (inject a clock, id source, or `HTTPClient`).
- Commits are split by layer on the feature branch. Do not add `Co-Authored-By` trailers.
- Do not commit secrets. Do not push or open a PR unless asked.

## Code navigation

The `codegraph` MCP server is configured (`codegraph serve --mcp`). Prefer its tools (`codegraph_explore`, `query`, `node`, `context`) to find symbols, callers, and call paths before broad grep reads. Use Read and Grep for exact text. Run `codegraph init` once per clone and `codegraph sync` after large changes. The `.codegraph/` index is gitignored.

## Build and test

```bash
xcodebuild test -project ios/FakeStoriesChallange.xcodeproj -scheme FakeStoriesChallange -destination 'platform=iOS Simulator,name=iPhone 17'
```
