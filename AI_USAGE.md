# AI usage

How AI tools were used on this challenge: which tools, which instruction files, the plan, the moments that shaped the solution, and where the AI got things wrong.

## Tools and models

- **Claude Code** in the Claude desktop app. The session started on Sonnet 5.5 and switched to Haiku 5.5 part-way through.
- **Codegraph** MCP server, for code navigation over the indexed repo.
- **Xcode** and the iOS Simulator, to build, run, and check the app. The simulator checks were driven from Claude Code.

## Instruction files and skills

- `CLAUDE.md` at the repo root holds the rules the AI follows: challenge constraints, the architecture rules, SwiftUI and testing conventions, the Xcode file header, the commit rules, the error-handling rules, and how to build and test.
- `.claude/skills/` holds six skills copied into the repo: `swiftui-specialist`, `swiftui-whats-new-27`, `app-resizability`, `modernize-tests`, `device-interaction`, and `clean-architecture-ios`. They were supplied by the author and are reviewed by the author.
- `DECISIONS.md` holds the architecture and UI decisions. It was written before the implementation and extended as decisions were made.

## The plan

Plan mode was used once at the start to lay out the phases, the architecture, the assumptions, and the verification steps. The plan was then revised as the skills were added. It is not committed, but its decisions are in `DECISIONS.md`.

## Key prompts and moments that shaped the solution

1. **Choosing the stack.** The AI asked three questions (UI framework, data-source approach, and structure) before writing the plan. Choosing SwiftUI on iOS 17 with one app target made the rest of the design simpler.
2. **Adding the skills and the rules.** Each rule (one-line comments, testable code by default, one API manager, no literals, main actor for UI only, graceful errors, `ContentUnavailableView` for empty and error states) was given as a prompt and written into `CLAUDE.md` before the code that depended on it.
3. **Building one module at a time.** The author asked for a view model, its test, and its screen in turn. The AI had first written all five view models at once, and the author rejected that batch. The batch commit was discarded and the work was redone module by module.
4. **Checking the search API before building search.** The AI assumed Fake Store had a search endpoint and was about to build on it. The author asked whether the category API supports search. Checking with `curl` showed it does not, so search was built on the client, live, with a debounce.
5. **Keeping network errors in the network layer.** The author asked for offline and server messages and for the classification to sit next to the data layer. The commit was moved to sit directly after the Data commit.

## Where the AI got things wrong, and how it was caught

- **Hand-written Xcode project.** The first test build failed because `ENABLE_TESTABILITY` was missing. The build output showed it, and it was added.
- **Swift 6 concurrency.** A stored `Regex` in a static property was not `Sendable`. The compiler flagged it, and it became a computed property.
- **Shared test stub.** Two test suites shared one `URLProtocol` handler and ran in parallel, so one overwrote the other, and a repository test received a 500 response meant for another suite. The suites were nested under one serialized parent suite.
- **Batched view models.** Described above: five view models were built together, against the agreed rhythm. Caught by the author; the commit was discarded.
- **Unverified claims.** The AI said the sending indicator was tested before the test existed. The test was written afterwards and passed at once, because the view model already reported the sending state. The test locks in that behaviour, but it was not written first.
- **Nearly-applied edit.** A search refactor was half-applied when the author interrupted it. The AI checked the files on disk before continuing, and confirmed what had changed.
- **Simulator taps.** Several taps landed on the wrong element because the coordinates were estimated from screenshots. Each mistake was caught by a follow-up screenshot, and the taps were corrected.
- **Test-file brace.** A test edit left an extra closing brace and broke the build. The compiler error pointed at it.
- **Xcode reformatting.** Xcode rewrites the project file on each build, which blocked rebases until the cosmetic change was discarded. The AI now checks for it before any history rewrite.

## How the output was reviewed

- Every change was built, and the test suite was run before each commit. The suite was 64 tests in 16 suites at the last check.
- Behaviour was checked on the simulator with screenshots: happy paths, offline and failure states, the sending indicator, live search, and category scoping.
- Claims about external APIs were checked against the live API, not taken from memory.
- The author reviewed the commit history and asked for changes to it, including a rebase to put commits in the right order.

## What the AI did not do

- It did not push to a remote or open a pull request. Those wait for the author.
- It did not decide the product rules. Those came from the brief and the author's choices, and are listed in `DECISIONS.md` section 14.
