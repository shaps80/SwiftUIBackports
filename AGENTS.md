# AGENTS.md

When talking to the user, sacrifice grammar for concision.

## First Reads

Before code work, read `CONTEXT.md`. It defines project terms, API-shape expectations, availability rules, and release policy. If an ADR exists under `docs/adr/` for the area you touch, read it too.

When implementing a SwiftUI API backport, check `refs/swiftui-*.ref` and `refs/swiftuicore-*.ref` for Xcode SwiftUI/SwiftUICore module interface references. Use the newest versioned refs to confirm native signatures, overload sets, generics, availability, and hidden helper types before shaping public API.

If the available SwiftUI max version is newer than the newest ref version in `refs/`, tell the user the ref files may need updating before relying on them.

## Project Rules

- This is a SwiftPM library, not an app.
- Main target is `SwiftUIBackports`.
- Preserve Apple SwiftUI API parity for backports: names, overloads, behavior, docs, and availability should match native APIs where practical.
- Use the refs to discover official API introduction versions. Backport APIs should be deprecated on each platform at the version where the native API was introduced for that platform. Example: if `presentationBackgroundInteraction` is officially introduced on iOS 16.3, the iOS deprecation for the backport should be 16.3.
- When a full SwiftUI type is backported, usually put native-availability deprecation on the backported type itself, not every initializer, method, or extension on that type. Add member-level deprecations only when needed, such as a member whose native API was introduced in a different version. This does not apply to modifiers, environment values, or other non-type API backports.
- Prefer `.backport` modifiers for view/transition APIs and `Backport<Any>` for pure namespace types.
- Keep UIKit/AppKit bridge details internal/private unless public API parity demands exposure.
- Use `@available` and `#if os(...)` deliberately. Minimum floors are iOS 13, tvOS 13, watchOS 6, macOS 10.15.
- Do not move deprecated APIs casually. Deprecation shims are source-compatibility promises.
- Use `backport/<api-name>` for branches that implement SwiftUI API backports.
- PRs need exactly one release label: `release:major` or `release:minor`.

## Verification

- Prefer `swift build` for package-level validation.
- No broken builds on any supported platform. Before handing back source changes, verify all affected code at least compiles for every supported platform: iOS, macOS, tvOS, watchOS, and visionOS. Use generic `xcodebuild` destinations when simulator/device hardware is not needed.
- If changing platform-specific bridges, compile the supported platforms instead of only reasoning through unsupported platforms and compile gates.
- If adding public API, include header docs matching the style of neighboring files.

## Agent skills

### Issue tracker

Issues and PRDs live in GitHub Issues for `shaps80/SwiftUIBackports`. See `docs/agents/issue-tracker.md`.

### Triage labels

Triage labels use the default five-role vocabulary; missing GitHub labels should be created before automated triage. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context repo: root `CONTEXT.md` plus optional ADRs under `docs/adr/`. See `docs/agents/domain.md`.
