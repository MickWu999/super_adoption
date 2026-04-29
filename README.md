# Super Adoption

Flutter app for pet adoption browsing.

## Dev Guide

This project currently follows a small-to-medium feature-based architecture.
The goal is to keep code easy to change without introducing too much abstraction.

## Core Principles

1. UI only reads data from provider/state, not directly from network code.
2. Repository is the boundary between app logic and remote/local data.
3. External API response models stay in `dto/`.
4. App-facing business models stay in `model/`.
5. Conversion from API data to app data must go through `mapper/`.
6. Feature loading UI and page skeletons stay inside each feature.
7. Base reusable widgets live in `lib/core/widgets/`.

## Feature Folder Workflow

Recommended feature structure:

```text
lib/features/<feature>/
  data/
    dto/
    mapper/
    query/
    repository/
  model/
  state/
  ui/
    widgets/
```

Meaning of each layer:

- `data/dto/`: raw backend or government API response shape
- `data/query/`: request/filter/paging params sent to repository
- `data/mapper/`: converts DTO into app model
- `data/repository/`: fetches data source and returns app model
- `model/`: domain model used by UI and state
- `state/`: Riverpod provider/notifier + state objects
- `ui/`: page widgets
- `ui/widgets/`: feature-specific reusable UI blocks

## DTO / Mapper / Domain Model Flow

Current expected flow:

```text
Remote API JSON
  -> DTO
  -> Mapper
  -> Domain Model
  -> State
  -> UI
```

Example from `animals`:

```text
Gov API response
  -> GovAnimalDto
  -> GovAnimalMapper.toDomain()
  -> Animal
  -> AnimalListState
  -> AnimalListScreen / HomeScreen
```

Rules:

1. DTO should match remote response shape as closely as possible.
2. Domain model should match app usage, not backend naming.
3. UI should never depend on DTO directly.
4. Repository should return domain model, not DTO.

## Current State Workflow

For Riverpod feature state, the current pattern is:

```text
UI
  -> Provider / Notifier
  -> Repository
  -> Repository returns domain models
  -> Notifier updates state
  -> UI rebuilds
```

Example:

- `AnimalNotifier` owns loading, refresh, filter, and load-more logic
- `AnimalRepository` owns API fetching
- `AnimalListState` is the only state UI should read

Recommended rule:

1. Put async orchestration in notifier/provider.
2. Put data fetching in repository.
3. Put API parameter rules in `query/`.
4. Put state shape in `state/..._state.dart`.

## Home Feature Workflow

`home` is now its own feature and should not directly assemble data inside UI.

Current flow:

```text
HomeScreen
  -> homeProvider
  -> HomeNotifier
  -> HomeRepository
  -> AnimalRepository + fake HomeBanner data
  -> HomeState
```

Current responsibility split:

- `HomeRepository`: prepares home page data
- `HomeBanner`: banner domain model
- `HomeState`: home page state shape
- `HomeNotifier`: loading and refresh entry point
- `HomeScreen`: only renders `AsyncValue`

Banner note:

- `HomeBanner` currently uses fake data
- future backend should provide:
  - `imageUrl`
  - `websiteUrl`
- when backend is ready, replace data source in `HomeRepository`

## Theme / UI Rules

Current UI rules:

1. UI should use `Theme.of(context)`, `colorScheme`, and `textTheme`.
2. UI should not directly use `AppColors`.
3. Do not hardcode color hex values inside feature pages unless truly one-off.
4. Shared base widgets go in `lib/core/widgets/`.
5. Feature-specific widgets stay in the feature folder.

## Skeleton / Loading Rules

Skeletons are shared in two layers:

### 1. Base Skeleton

In `lib/core/widgets/`:

- `SkeletonShimmer`
- `SkeletonBox`

These are global reusable building blocks.

### 2. Feature Skeleton

In each feature:

- `home/ui/widgets/home_loading_view.dart`

Rules:

1. Core layer provides base skeleton capability.
2. Feature layer owns skeleton layout.
3. Page widget only switches state, it should not contain large skeleton layout details.

## Logging Rules

Current debug logging is installed with `logger`.

Main usage:

- `lib/core/log/app_logger.dart`
- Dio request/response logging in `lib/core/network/dio_provider.dart`
- feature-level debug logs can be added in notifier/repository

Rules:

1. Log request URL, query params, and response count in repository/network layer.
2. Log load / refresh / loadMore flow in notifier when debugging feature issues.
3. Avoid leaking DTO details into UI logs.

## Adding a New Remote Feature

Suggested workflow:

1. Create domain model in `model/`
2. Create DTO in `data/dto/`
3. Create mapper in `data/mapper/`
4. Create repository in `data/repository/`
5. Create state object in `state/`
6. Create provider/notifier in `state/`
7. Build page UI in `ui/`
8. Add feature skeleton in `ui/widgets/` if needed

## Commands

Useful commands during development:

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
```

## Notes

- Generated files such as `*.g.dart` and `*.freezed.dart` are expected.
- If model/provider signatures change, rerun `build_runner`.
- Prefer small, explicit architecture over premature abstraction.
