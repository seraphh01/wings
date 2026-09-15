# ADR-001: Core Application Architecture

- **Status:** Accepted
- **Date:** 2026-09-15
- **Decision owners:** Wings maintainers
- **Scope:** Wings mobile application and supporting backend
- **Related documents:**
  - [`../Wings_Product_Foundation_v0.1.md`](../Wings_Product_Foundation_v0.1.md)
  - [`../Wings_Founder_Experiment_6_Week_v0.1.md`](../Wings_Founder_Experiment_6_Week_v0.1.md)

## Context

Wings is a mobile-first calisthenics progression and training community for iOS and Android. Its first product loop is:

> Assess → choose a goal → follow a path → train → record evidence → validate progress → unlock the next step.

The MVP must support:

- Athlete accounts and profiles.
- A branching exercise and skill-progression graph.
- Structured assessments, goals, workouts, sessions, sets, and personal records.
- Attempted versus valid repetitions and append-only performance evidence.
- Deterministic, explainable progression recommendations.
- Offline-capable workout logging.
- Training invitations, shared sessions, and attendance.
- Private progress videos and other media.
- Push notifications.
- A small initial team, with Serafim as founder, developer, and first longitudinal test case.

The architecture must optimize for rapid product validation without creating a dead end for future community, coaching, media, or AI features.

## Decision drivers

1. One maintainable codebase for iOS and Android.
2. Fast delivery by a developer already experienced with Flutter and Supabase.
3. Strong relational integrity for progression and training data.
4. Secure user-to-user and private-athlete data access.
5. Reliable operation in parks and gyms with poor connectivity.
6. Transparent domain rules before probabilistic AI recommendations.
7. Minimal infrastructure and operational overhead during the MVP.
8. A clear path to native platform APIs when necessary.
9. Testability of progression logic and authorization rules.
10. Avoidance of premature microservices and duplicated backend systems.

## Decision

Wings will use a **Flutter mobile client backed by Supabase**, organized as a feature-first modular monolith.

### Technology summary

| Area | Decision |
|---|---|
| Mobile framework | Flutter and Dart |
| Application architecture | Feature-first modular monolith |
| State management | Riverpod |
| Navigation | `go_router` |
| API and backend platform | Supabase |
| Primary database | PostgreSQL |
| Authentication | Supabase Auth |
| Authorization | PostgreSQL Row Level Security policies |
| Server-side domain operations | PostgreSQL functions/RPC |
| Privileged and external integrations | Supabase Edge Functions using TypeScript/Deno |
| Live updates | Supabase Realtime |
| Media | Private Supabase Storage buckets and signed URLs |
| Local persistence | Drift on SQLite |
| Offline synchronization | Application-owned transactional outbox |
| Push notifications | Firebase Cloud Messaging, including APNs delivery on iOS |
| Crash and performance monitoring | Sentry |
| Product analytics | PostHog, with an explicit event schema |
| Client testing | Dart unit tests, Flutter widget tests, and Flutter integration tests |
| Database testing | Supabase local development, migration tests, and pgTAP where valuable |
| Continuous integration | GitHub Actions |
| Store delivery | Fastlane, introduced when release automation is needed |

## Mobile-client architecture

### Feature-first organization

The Flutter application will be grouped by product capability rather than by global technical type.

```text
lib/
  app/
    app.dart
    bootstrap.dart
  core/
    auth/
    database/
    errors/
    networking/
    routing/
    sync/
    theme/
    widgets/
  features/
    onboarding/
    today/
    journey/
    training/
    progression/
    together/
    learning/
    profile/
```

Substantial features may contain:

```text
feature/
  data/
  domain/
  application/
  presentation/
```

These layers are introduced when they isolate real complexity. Simple screens must not receive empty abstraction layers merely for architectural symmetry.

### Dependency direction

- Presentation depends on application use cases and immutable view state.
- Application code coordinates domain rules and repositories.
- Domain code must not depend directly on Flutter widgets, Supabase, or Drift.
- Data implementations may depend on Supabase and Drift.
- Feature-to-feature access occurs through explicit public interfaces, not imports into another feature's internal folders.

### State management

Riverpod will provide dependency injection, asynchronous state, and feature workflow state.

- Widget-local and ephemeral UI state stays inside the widget when appropriate.
- Shared or persisted workflows use Riverpod providers and notifiers.
- Side effects are initiated from application-layer operations, not widget build methods.
- Supabase clients, repositories, clocks, UUID generators, and analytics clients are injected so tests can replace them.
- Global mutable singleton state is prohibited except for immutable platform configuration created during bootstrap.

### Navigation

`go_router` will define typed or centrally named routes, authentication redirects, and deep-link handling.

Initial top-level destinations are:

1. Today
2. Journey
3. Train
4. Together
5. Profile

Learning content may initially open contextually from exercises and progressions rather than occupy a permanent navigation destination.

## Backend architecture

### PostgreSQL as the source of truth

Supabase PostgreSQL is authoritative for accounts, progression state, training history, relationships, and media metadata.

Core data includes:

- Exercises, variations, prerequisites, and progression edges.
- Assessments and assessment results.
- Athlete goals and exercise states.
- Workouts, exercises, targets, sessions, and sets.
- Performance evidence and personal records.
- Training sessions, participants, invitations, and attendance.
- Learning resources and content provenance.

Historical training and performance evidence is append-only. Corrections create an auditable correction or superseding record rather than silently rewriting the athlete's history.

### Client access versus server-side operations

The Flutter client may access Supabase tables directly when an operation is simple, protected by Row Level Security, and does not require a multi-table invariant.

Examples:

- Read exercise and progression content.
- Read the current athlete's history.
- Update non-sensitive profile preferences.
- Subscribe to authorized session changes.

PostgreSQL functions/RPC will own transactional domain operations such as:

- `complete_workout_session`
- `record_performance_evidence`
- `evaluate_progression_state`
- `accept_training_invitation`
- `join_training_session`
- `leave_training_session`
- `record_session_attendance`

Edge Functions will be used when an operation:

- Requires a secret unavailable to the client.
- Calls an external service.
- Sends notifications or email.
- Performs privileged administrative work.
- Processes media asynchronously.
- Generates natural-language summaries or future AI guidance.

Edge Functions must not become a second generic CRUD API over PostgreSQL.

### Progression engine

MVP progression decisions will be deterministic and explainable.

- Rules and thresholds live in versioned database data or tested domain code.
- Every state transition records the prior state, new state, rule version, triggering evidence, timestamp, and explanation.
- AI may later summarize evidence or suggest alternatives, but it does not silently mutate progression state.
- A recommendation must be reproducible from stored evidence and the rule version that evaluated it.

## Offline architecture

Workout execution must remain usable without a reliable connection.

Drift/SQLite will store:

- The active workout.
- Downloaded exercise and progression definitions needed by the current plan.
- Locally created sessions and sets awaiting synchronization.
- Pending media-upload metadata.
- The synchronization outbox.

### Synchronization rules

1. Every client-created entity receives a UUID before synchronization.
2. Local changes are written to the domain table and outbox in one local transaction.
3. The outbox records operation type, aggregate identifier, payload version, creation time, attempt count, and last error.
4. Server operations are idempotent by operation or entity UUID.
5. Successful synchronization marks the outbox item complete; it does not delete the local workout history.
6. Retries use bounded exponential backoff.
7. Authentication, validation, or authorization failures are surfaced to the user rather than retried forever.
8. Conflicts use domain-specific policies; a generic last-write-wins strategy is not used for performance evidence.

The MVP does not attempt full bidirectional offline collaboration. Offline support is initially scoped to the athlete's workout execution and deferred uploads.

## Media architecture

- Media bytes are stored in Supabase Storage, not PostgreSQL.
- PostgreSQL stores ownership, evidence relationship, visibility, processing state, and storage-object metadata.
- Athlete progress media uses private buckets by default.
- Authorized access uses short-lived signed URLs.
- Videos are compressed on the client before upload when practical.
- Uploads use resumable or retryable flows where supported.
- A failed upload must not invalidate the associated locally saved workout.
- Automated video-form analysis is outside the MVP.

## Notification architecture

Firebase Cloud Messaging will deliver push notifications to Android and through APNs to iOS.

- Device tokens are stored per installation, not as one token directly on the athlete profile.
- Token rotation and invalid-token cleanup are supported.
- Edge Functions select recipients and construct notification payloads.
- Notification preferences are enforced server-side.
- Notification taps use app deep links.

Initial notification categories are:

- Training invitation.
- Invitation response.
- Upcoming shared session.
- Planned workout reminder.
- Weekly progress summary.

## Security and privacy

### Required controls

- Row Level Security is enabled on every user or community data table exposed through the Supabase Data API.
- Policies are deny-by-default and tested for owner, participant, public, and unauthorized cases.
- The mobile application contains only the Supabase publishable key; privileged service credentials remain server-side.
- Storage policies mirror the authorization model of the related database record.
- Exact athlete location is not publicly exposed. Discovery uses an intentionally reduced precision or defined meeting location.
- Private evidence stays private unless the athlete explicitly changes visibility.
- Account deletion, data export, reporting, and blocking are designed before public community launch.
- Logs and analytics must not contain access tokens, raw private media URLs, or sensitive free-text health notes.

### Trust boundaries

The client is untrusted. UI restrictions improve usability but never replace database or server-side authorization.

## Observability and analytics

Sentry will capture application errors, crashes, release identifiers, and selected performance traces. Personally sensitive workout notes and media URLs must be scrubbed.

PostHog will capture a small, documented product-event vocabulary. Initial events include:

- `assessment_completed`
- `goal_selected`
- `progression_path_viewed`
- `workout_started`
- `workout_completed`
- `performance_evidence_recorded`
- `progression_state_changed`
- `training_session_created`
- `training_session_joined`

Event properties must use stable identifiers and categories rather than copying arbitrary user-entered text.

## Testing strategy

### Client

- Unit-test domain calculations and application use cases.
- Widget-test critical states: loading, empty, populated, validation failure, offline, and retry.
- Integration-test onboarding, the first workout, offline completion, synchronization, and progression unlock.
- Use fakes for repositories in feature tests; use a local Supabase environment for integration tests.

### Database

- Apply all schema changes through versioned migrations.
- Test Row Level Security for every exposed table.
- Test RPC invariants and idempotency.
- Test progression state transitions against fixed evidence fixtures.
- Seed development data through repeatable scripts rather than manual dashboard changes.

### Definition of done for domain operations

A domain operation is not complete until its success path, validation failures, authorization behavior, idempotent retry, and observable error behavior are tested.

## Continuous integration and delivery

GitHub Actions will initially run:

1. Dart formatting verification.
2. Static analysis.
3. Unit and widget tests.
4. Supabase migration validation.
5. Database and Row Level Security tests.
6. Android debug build.

iOS builds require a macOS runner. Store signing and delivery automation through Fastlane will be added when TestFlight and Play internal-testing releases become frequent enough to justify it.

Dependencies are pinned through lockfiles. Flutter and database migrations are upgraded deliberately, with generated code and tests updated in the same pull request.

## Alternatives considered

### React Native with Expo

**Advantages:** TypeScript ecosystem, strong web-team familiarity, broad package ecosystem, and potential conceptual reuse with React web applications.

**Reason not selected:** The current developer already has relevant Flutter and Supabase experience. React Native does not provide a product advantage large enough to justify changing the mobile stack and rebuilding that experience.

**Revisit when:** The permanent product team becomes predominantly React/TypeScript, substantial React Native code is acquired, or web/mobile UI reuse becomes a primary business constraint.

### Fully native Swift and Kotlin

**Advantages:** Maximum platform control, immediate access to native APIs, and independently optimized native experiences.

**Reason not selected:** Two clients would multiply implementation and testing work before product-market fit. Current MVP features do not require that cost.

**Revisit when:** Core experiences depend on platform capabilities poorly served by Flutter, measured performance is unacceptable, or independent platform teams exist.

### Kotlin Multiplatform

**Advantages:** Shared domain logic with flexible native integration and the option of shared or native UI.

**Reason not selected:** It introduces additional architectural and tooling decisions without improving the present founder-development path.

**Revisit when:** Native UI becomes required while substantial business logic still benefits from sharing.

### ASP.NET Core backend

**Advantages:** Strong domain modeling, mature tooling, explicit APIs, and alignment with existing .NET experience.

**Reason not selected:** For the MVP it would duplicate managed capabilities already provided by Supabase and add deployment, authentication integration, API maintenance, and operational work.

**Revisit when:** Domain workflows outgrow database functions and Edge Functions, background processing becomes substantial, enterprise integrations appear, or independent backend scaling is required.

### Firebase as the primary backend

**Advantages:** Mature mobile services, notifications, analytics, and real-time capabilities.

**Reason not selected:** Wings data is strongly relational. PostgreSQL better represents branching prerequisites, workouts, evidence, attendance, and transactional progression rules. Firebase remains in scope only for push-notification delivery.

**Revisit when:** There is measured evidence that the selected Supabase capability cannot meet a critical product requirement.

### Microservices

**Advantages:** Independent deployment and scaling boundaries.

**Reason not selected:** Wings does not yet have team or scale boundaries that justify distributed transactions, service ownership, observability overhead, or operational complexity.

**Revisit when:** Measured scale, reliability, deployment cadence, or team ownership creates a clear service boundary.

## Consequences

### Positive

- One iOS and Android application codebase.
- High founder productivity using familiar technologies.
- Relational data integrity and transactional domain operations.
- Low initial infrastructure burden.
- Direct support for authentication, storage, realtime updates, and server functions.
- An explicit offline path for workout logging.
- A clear boundary between deterministic progression and future AI assistance.
- Native Swift or Kotlin escape hatches remain available through Flutter platform integration.

### Negative and accepted trade-offs

- Flutter-specific UI and Dart skills are required from future mobile contributors.
- Some device or platform integrations may require native Swift/Kotlin code.
- Offline synchronization is application work; Supabase does not remove domain-specific conflict decisions.
- Combining Supabase, FCM, Sentry, and PostHog introduces several service configurations.
- PostgreSQL functions can become difficult to maintain if too much application behavior is placed in them.
- Direct client-to-database access requires disciplined, thoroughly tested Row Level Security.

### Risk controls

- Keep external services behind small application interfaces.
- Prefer portable PostgreSQL schema and migrations.
- Keep deterministic progression rules independently testable.
- Treat Edge Functions as integration boundaries rather than the whole backend.
- Monitor build size, startup time, synchronization failures, and database-query performance.
- Add architectural complexity only in response to measured product needs.

## Implementation sequence

1. Bootstrap Flutter with environment configuration, Riverpod, routing, and theme tokens.
2. Establish the Supabase local-development and migration workflow.
3. Implement authentication, profile creation, and tested Row Level Security.
4. Model exercises, variations, prerequisites, and progression edges.
5. Implement assessments, goals, and deterministic progression evaluation.
6. Implement workout planning and online workout logging.
7. Add Drift and the synchronization outbox before field testing in unreliable connectivity.
8. Add private evidence uploads.
9. Add shared training sessions and notifications.
10. Add monitoring, analytics, and release automation before external alpha expansion.

## Validation criteria

This decision is validated when the first private alpha can:

- Run on physical iOS and Android devices from the same Flutter project.
- Complete a workout without connectivity and synchronize it later without duplicates.
- Enforce profile, workout, evidence, and shared-session access through tested policies.
- Reconstruct the Founder Athlete experiment from append-only records.
- Explain every progression-state change from stored evidence and a rule version.
- Upload private evidence without blocking workout completion.
- Send a training invitation notification and deep-link to the correct session.

## Review policy

This ADR remains accepted until a replacement ADR explicitly supersedes it. Individual technologies should not be replaced because another option is fashionable; replacement requires a measured limitation, a product requirement the current stack cannot reasonably satisfy, or a material change in team composition.

Review this decision after the first external alpha or earlier if one of the documented revisit conditions occurs.

## References

- [Flutter supported deployment platforms](https://docs.flutter.dev/reference/supported-platforms)
- [Flutter platform-specific integration](https://docs.flutter.dev/platform-integration/platform-channels)
- [Supabase Flutter quickstart](https://supabase.com/docs/guides/getting-started/quickstarts/flutter)
- [Supabase Dart reference](https://supabase.com/docs/reference/dart/introduction)
- [Firebase Cloud Messaging for Flutter](https://firebase.google.com/docs/cloud-messaging/flutter/get-started)
