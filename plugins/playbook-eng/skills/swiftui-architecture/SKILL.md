---
name: swiftui-architecture
description: Use when structuring a SwiftUI app or choosing state management, navigation, or view composition - the MVVM and data flow conventions
---

# SwiftUI architecture

## Application Architecture
* **MVVM with @Observable:** ViewModels are `@Observable` classes (the
  Observation framework), not `ObservableObject`/`@Published`. Views stay
  free of business logic.
* **Project structure:** Feature-first layout with a shared core:

  ```
  App/                    # Entry point, app lifecycle
  Features/
    <FeatureName>/
      Views/              # SwiftUI views
      ViewModels/         # @Observable classes
      Models/             # Feature data models
  Core/
    Extensions/
    Services/
    Networking/
  Resources/              # Assets, localizations
  Tests/
  ```

## State Management
* **@State is view-local only:** Use `@State` strictly for state owned by a
  single view (toggles, text fields, animation flags). Anything shared or
  business-relevant lives in a ViewModel.
* **@Bindable for ViewModel bindings:** Bind into `@Observable` objects with
  `@Bindable`, not `@ObservedObject`.
* **@Environment for dependency injection:** Inject shared services through
  the environment rather than passing them down long initializer chains.

## Navigation
* **NavigationStack with typed routes:** Use `NavigationStack` driven by a
  `Hashable` route enum and `navigationDestination`. Never the deprecated
  `NavigationView`.

  ```swift
  enum Route: Hashable {
      case detail(Item)
      case settings
  }

  NavigationStack(path: $router.path) {
      ContentView()
          .navigationDestination(for: Route.self) { route in
              // switch on route
          }
  }
  ```
* **Sheets via optional child ViewModels:** The parent ViewModel owns an
  optional child ViewModel. Non-nil presents the sheet; setting it to nil
  dismisses. This keeps modal state testable without touching the view.

  ```swift
  @Observable
  final class ParentViewModel {
      var detailViewModel: DetailViewModel?

      func showDetail(for item: Item) {
          detailViewModel = DetailViewModel(item: item)
      }
  }
  ```

## View Composition
* **Compose small views:** Break large `body` properties into small, named
  subview structs. Extract a subview when a section is reusable or when
  `body` no longer reads at a glance — no monolithic views.
* **Subview structs over helper methods:** Prefer small private `View`
  structs to private `func makeX() -> some View` helpers; structs get
  identity and better diffing.
* **Modern APIs only:** Prefer SwiftUI over UIKit unless SwiftUI genuinely
  cannot do the job. Don't use deprecated APIs.

## Testing
* **ViewModels are the unit-test surface:** Every ViewModel gets unit tests.
  UI tests cover critical user flows only. Mocking rules come from
  `testing-standards`.
