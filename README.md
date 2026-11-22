# Product Catalogue (iOS)

A small product catalogue: browse featured products, browse categories, search as you type, open a product, and send an enquiry. This is the iOS client (Phase 1). It is built in Swift and SwiftUI for iOS 17 and later, and it loads product data from the public Fake Store API through a temporary data source.

Design decisions, assumptions, and known gaps are in [DECISIONS.md](DECISIONS.md). How AI tools were used is in [AI_USAGE.md](AI_USAGE.md).

## What you need

- A Mac with Xcode 27, the version this was built and tested with. Other Xcode versions were not tried.
- An iOS Simulator (iPhone 17 was used for testing).
- An internet connection. The app reads products from `fakestoreapi.com`.

No accounts, API keys, or other configuration are needed.

## Run the app

1. Open `ios/FakeStoriesChallange.xcodeproj` in Xcode.
2. Choose the **FakeStoriesChallange** scheme and an iPhone simulator.
3. Press **Run** (Cmd+R).

## Run the tests

```bash
xcodebuild test -project ios/FakeStoriesChallange.xcodeproj -scheme FakeStoriesChallange -destination 'platform=iOS Simulator,name=iPhone 17'
```

The tests run without the network. Network behaviour is tested with a stubbed `URLProtocol`.

## What to try

- **Home:** the five top-rated products, and category links.
- **Search:** type on the home page. Results update as you type, with no submit step.
- **Category:** open a category to see its top-rated products and the rest. Its search field only looks inside that category.
- **Product:** tap a product for its details, then **Enquire** to send an enquiry.
- **Offline or failed loads:** each screen shows a message and a **Try again** button. Products already on screen stay visible when a refresh fails.

## How the code is organised

```
ios/FakeStoriesChallange/
  App/            app entry point and AppContainer (the only place concrete types are wired)
  Domain/         models, protocols, rules, and use cases; imports Foundation only
  Data/           API manager, endpoints, DTOs, and repositories; the network boundary
  Presentation/   view models, SwiftUI screens, components, theme, and copy
FakeStoriesChallangeTests/
  Domain/ Data/ Presentation/ Support/   Swift Testing suites and test doubles
```

Dependencies point inward: screens depend on view models, view models on use cases, use cases on protocols, and only `App/` knows the concrete types.

## Changing the data source

The product source sits behind the `ProductRepository` protocol, and enquiries sit behind `EnquiryService`. To switch sources, change the two lines in `AppContainer.live()`. No screen or use case needs to change. The planned backend replaces the temporary Fake Store repository this way.

## Known limits

- Product data comes straight from Fake Store, which the brief forbids for the final design. This is a temporary, recorded deviation.
- Enquiries are accepted but no email is sent yet. The sales-inbox email needs the backend.
- Search runs on the client, because Fake Store has no search endpoint.
- The layout has been checked on iPhone only so far. iPad and iPhone Duo checks are still to do.

## Agent instructions

`CLAUDE.md` holds the rules that AI coding tools follow in this repo. The Apple and architecture skills they use are in `.claude/skills/`.
