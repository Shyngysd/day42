# Architecture Overview

## System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      Flutter App (UI Layer)                  │
│  ┌──────────────────┐         ┌──────────────────┐           │
│  │  LoginScreen     │         │  HomeScreen      │           │
│  │  - email_field   │  ─────→ │  - items_list    │           │
│  │  - password_field│         │  - add_button    │           │
│  │  - login_button  │         │  - logout_button │           │
│  └────────┬─────────┘         └────────┬─────────┘           │
│           │                            │                     │
└───────────┼────────────────────────────┼─────────────────────┘
            │                            │
            │      (get_it Service      │
            │       Locator)            │
            │                            │
┌───────────▼────────────────────────────▼─────────────────────┐
│          UserRepository (Business Logic Layer)                │
│  - login(email, password): Future<User>                       │
│  - getItems(): Future<List<Item>>                             │
│  - addItem(title, desc): Future<Item>                         │
│  - logout(): Future<void>                                     │
└───────────┬────────────────────────────────────────────────────┘
            │
            │ (Dependency Injection)
            │
┌───────────▼────────────────────────────────────────────────────┐
│              ApiClient Interface (Abstraction)                  │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  + login(email, password): Future<User>                │   │
│  │  + getItems(): Future<List<Item>>                      │   │
│  │  + addItem(title, desc): Future<Item>                  │   │
│  │  + logout(): Future<void>                              │   │
│  │  + setAuthToken(token): void                           │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────┬──────────────────────────┬───────────────────────┘
              │                          │
              │                          │
    ┌─────────▼─────────┐      ┌────────▼────────┐
    │ HttpApiClient     │      │ FakeApiClient   │
    │ (Real HTTP)       │      │ (Test Stub)     │
    │                   │      │                 │
    │ - Uses http pkg   │      │ - In-memory     │
    │ - Real network    │      │ - Fixed data    │
    │ - Production      │      │ - Testing only  │
    └────────┬──────────┘      └────────┬────────┘
             │                          │
      ┌──────▼──────────────────────────▼──────┐
      │  Data Models                            │
      │  ┌─────────────────────────────────┐   │
      │  │ User (id, email, name, token)   │   │
      │  │ Item (id, title, desc, userId)  │   │
      │  └─────────────────────────────────┘   │
      └─────────────────────────────────────────┘
```

## Testing Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Unit Tests                            │
│  test/user_repository_test.dart                         │
│                                                         │
│  Repository → mocktail Mock ApiClient → Assertions     │
│                                                         │
│  ✓ No network calls                                    │
│  ✓ Fast execution                                      │
│  ✓ Isolated testing                                    │
└─────────────────────────────────────────────────────────┘

                        vs

┌─────────────────────────────────────────────────────────┐
│               Integration Tests                          │
│  integration_test/app_test.dart                         │
│                                                         │
│  App → Repository → FakeApiClient → UI Assertions      │
│                                                         │
│  ✓ No network calls (uses FakeApiClient)               │
│  ✓ Tests full flow                                      │
│  ✓ Tests UI interaction                                │
└─────────────────────────────────────────────────────────┘
```

## Dependency Injection Flow

```
Development/Test Setup:
┌──────────────────────────────────────────────────────────┐
│  setupServiceLocator(mockApiClient: FakeApiClient())    │
│                                                          │
│  getIt.registerSingleton<ApiClient>(FakeApiClient())    │
│  getIt.registerSingleton<UserRepository>(...)           │
│                                                          │
│  Screens ────→ getIt<UserRepository>() ────→            │
│              ────→ getIt<ApiClient>() ────→ FakeClient  │
└──────────────────────────────────────────────────────────┘

Production Setup:
┌──────────────────────────────────────────────────────────┐
│  setupServiceLocator()                                   │
│                                                          │
│  getIt.registerSingleton<ApiClient>(HttpApiClient())    │
│  getIt.registerSingleton<UserRepository>(...)           │
│                                                          │
│  Screens ────→ getIt<UserRepository>() ────→            │
│              ────→ getIt<ApiClient>() ────→ HttpClient  │
└──────────────────────────────────────────────────────────┘
```

## Data Flow: Login Scenario

### Unit Test with Mock:
```
Test Code
   │
   ├─→ when(() => mockApiClient.login(...)).thenAnswer(...)
   │
   ├─→ userRepository.login(email, password)
   │
   ├─→ mockApiClient.login(email, password)  [Mocked - returns immediately]
   │
   └─→ assert(result == expectedUser)
```

### Integration Test with Fake:
```
UI: LoginScreen
   │
   ├─→ User enters email/password
   │
   ├─→ Tap login button
   │
   ├─→ userRepository.login(email, password)
   │
   ├─→ fakeApiClient.login(email, password)
   │   - Checks credentials in memory
   │   - Simulates 500ms delay
   │   - Returns User object
   │
   ├─→ Update UI with logged-in state
   │
   └─→ Navigate to HomeScreen
```

## Test Data Flow

```
┌─────────────────────────┐
│  Test Execution         │
└────────────┬────────────┘
             │
             ├──→ Create Mock/Fake API
             │
             ├──→ Setup Service Locator with Mock/Fake
             │
             ├──→ Create Repository with mocked API
             │
             ├──→ Execute repository methods
             │
             ├──→ Verify mock was called
             │
             └──→ Assert results
```

## CI/CD Pipeline

```
┌─ GitHub Push ─────────────────────────────────┐
│                                               │
└──────────┬────────────────────────────────────┘
           │
           ├─→ GitHub Actions Workflow Triggered
           │
           ├─→ ┌────────────────────────────┐
           │   │ Flutter Setup Job          │
           │   │ ├─ Install Flutter         │
           │   │ ├─ Get dependencies        │
           │   │ └─ Setup environment       │
           │   └────────────────────────────┘
           │
           ├─→ ┌────────────────────────────┐
           │   │ Analysis & Format Job      │
           │   │ ├─ flutter analyze         │
           │   │ ├─ dart format check       │
           │   │ └─ Lint checks             │
           │   └────────────────────────────┘
           │
           ├─→ ┌────────────────────────────┐
           │   │ Unit Tests Job             │
           │   │ ├─ flutter test --coverage │
           │   │ ├─ Upload to Codecov       │
           │   │ └─ Generate report         │
           │   └────────────────────────────┘
           │
           ├─→ ┌────────────────────────────┐
           │   │ Integration Tests Job      │
           │   │ ├─ Enable Linux Desktop    │
           │   │ ├─ flutter test integration│
           │   │ └─ Report results          │
           │   └────────────────────────────┘
           │
           └─→ ✅ All Tests Passed or ❌ Failed
```

## Component Interactions

```
┌─────────────────────────────────────────────┐
│ Models Layer                                │
│ ┌──────────────┐        ┌──────────────┐   │
│ │ User         │        │ Item         │   │
│ │ • id         │        │ • id         │   │
│ │ • email      │        │ • title      │   │
│ │ • name       │        │ • description│   │
│ │ • token      │        │ • userId     │   │
│ │              │        │ • createdAt  │   │
│ └──────────────┘        └──────────────┘   │
└─────────────────────────────────────────────┘
          △          △           △
          │          │           │
   [JSON serialization]
          │          │           │
┌─────────┴──────────┴───────────┴───────────┐
│ Data Layer - ApiClient Interface           │
│ ┌──────────────────────────────────────┐   │
│ │ • login()                            │   │
│ │ • getItems()                         │   │
│ │ • addItem()                          │   │
│ │ • logout()                           │   │
│ │ • setAuthToken()                     │   │
│ └──────────────────────────────────────┘   │
│              ▲              ▲               │
│              │              │               │
│    ┌─────────┴┐  ┌──────────┴──────┐      │
│    │ HttpAPI  │  │ FakeApiClient  │      │
│    │ Client   │  │ (for tests)     │      │
│    └──────────┘  └─────────────────┘      │
└─────────────────────────────────────────────┘
          △          △           △
          │          │           │
    [Dependency Injection]
          │          │           │
┌─────────┴──────────┴───────────┴───────────┐
│ Repository Layer                           │
│ ┌──────────────────────────────────────┐   │
│ │ UserRepository                       │   │
│ │ • login()                            │   │
│ │ • getItems()                         │   │
│ │ • addItem()                          │   │
│ │ • logout()                           │   │
│ │ • currentUser state                  │   │
│ └──────────────────────────────────────┘   │
└─────────────────────────────────────────────┘
          △          △           △
          │          │           │
    [Service Locator - getIt]
          │          │           │
┌─────────┴──────────┴───────────┴───────────┐
│ Presentation Layer (Screens)               │
│ ┌────────────────┐    ┌─────────────────┐ │
│ │ LoginScreen    │    │ HomeScreen      │ │
│ │ • UI widgets   │    │ • items list    │ │
│ │ • user input   │    │ • add form      │ │
│ │ • navigation   │    │ • logout button │ │
│ └────────────────┘    └─────────────────┘ │
└─────────────────────────────────────────────┘
```

## Testing Pyramid

```
                    Integration Tests
                  (Full User Flows)
                     (2 tests)
                   /            \
                 /                \
               /                    \
    Unit Tests (Repository Logic)
         (8 tests with mocks)
     ──────────────────────────
        No Real Network Calls
        Fast & Reliable
        Complete Coverage
```

## Execution Flow: Login Button Press

```
User taps login button
        │
        ▼
LoginScreen._handleLogin() called
        │
        ├─→ setState(isLoading = true)
        │
        ├─→ Get repository from service locator
        │    repository = getIt<UserRepository>()
        │
        ├─→ Call repository.login(email, password)
        │
        └─→ Repository delegates to API client:
             │
             ├─→ HttpApiClient.login() [in production]
             │    └─→ Makes HTTP POST request
             │
             └─→ FakeApiClient.login() [in tests]
                  └─→ Checks in-memory data
                      └─→ Returns User object
        │
        ├─→ setState(isLoading = false)
        │
        └─→ Navigate to HomeScreen
```

---

This architecture ensures:
- ✅ **Testability** - Easy to mock dependencies
- ✅ **Separation of Concerns** - Each layer has single responsibility
- ✅ **Flexibility** - Easy to swap implementations
- ✅ **Maintainability** - Clear structure and patterns
- ✅ **Scalability** - Easy to add new features
