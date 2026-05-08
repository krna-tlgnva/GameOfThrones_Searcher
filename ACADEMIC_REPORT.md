# Assignment 6 Report: Local Data Persistence and Firebase Cloud Firestore in Flutter

## 1. Introduction

This report presents the design and implementation of a Flutter mobile application developed for the Cross-platform Mobile Development course. The purpose of the assignment was to demonstrate how a Flutter application can store meaningful data locally on the device while also integrating cloud-based storage through Firebase Cloud Firestore. In addition to persistence and cloud connectivity, the assignment emphasized clean project organization, asynchronous state handling, and a clear user interface.

The completed application is a character management app named **Character Builder App**. It uses data from a public Harry Potter API to provide initial content, allows users to create their own custom wizard characters, saves these custom records locally using SQLite through the `sqflite` package, and uploads the same custom records to a shared Firestore collection. This combination makes the project suitable for demonstrating both device-level persistence and cloud-based data sharing in a single coherent application.

From an architectural perspective, the project follows a clean and readable structure. Data models, services, repositories, screens, and reusable widgets are separated into dedicated files rather than being placed inside one monolithic widget tree. This decision improves maintainability, supports separation of concerns, and makes the project easier to explain, test, and extend.

## 2. Project Overview

The main idea of the application is to allow users to explore characters from the Harry Potter universe and then create their own custom wizard profiles. The app has three main functional areas. First, it shows API-based characters on the home screen to ensure that the interface is populated with meaningful content from the moment the app starts. Second, it provides a local “My Wizards” section where user-created records are stored on the device and remain available after restarting the application. Third, it includes a “Shared Wizards” section where the same custom records can be viewed from Firebase Cloud Firestore.

This topic was chosen because it provides a natural way to combine three different data sources in one application:

- Remote API data for initial content
- Local database storage for personal records
- Cloud Firestore for shared records

Using this combination creates a more realistic cross-platform application than an app that depends on only one source of data. It also demonstrates that local and cloud persistence can work together instead of being treated as separate, unrelated features.

[Insert Screenshot: Main Screen]

The main screen introduces the user to the application by displaying Harry Potter characters fetched from an external API. This screenshot should show that the app contains meaningful content rather than empty placeholder widgets. It also demonstrates the app’s overall visual style and the presence of the bottom navigation structure.

## 3. Project Setup

The project was built as a Flutter application using Dart SDK 3.4 or later. The `pubspec.yaml` file defines the main dependencies required for this assignment: `http` for external API access, `sqflite` for local persistence, `path` for database path handling, `firebase_core` for Firebase initialization, and `cloud_firestore` for Firestore operations. These libraries were selected because they are widely used, well-documented, and appropriate for a university-level project focused on persistence and cloud integration.

The entry point of the app is `main.dart`. In this file, `WidgetsFlutterBinding.ensureInitialized()` is called before any asynchronous setup occurs. This is an important Flutter best practice because services such as Firebase must be initialized before the UI is launched. After that, a `FirestoreService` instance is created using `DefaultFirebaseOptions.currentPlatform`, and then all required data services are injected into a `CharacterRepository`. Finally, the repository is passed into the root widget, `CharacterBuilderApp`.

This setup reflects an intentional architectural decision. Instead of constructing services deep inside the widget tree, the application prepares its dependencies at startup and passes them downward. This makes the project easier to reason about and reduces hidden coupling between interface code and infrastructure code.

The app was also configured for multiple Flutter targets, including Android, iOS, macOS, Linux, Windows, and web, as shown by the standard platform folders in the project. Even though the assignment only requires the app to run successfully on at least one target, the project structure remains cross-platform by design, which aligns with the goals of the course.

### 3.1 Dependency Summary

The main dependencies used in the project are:

- `http`: fetches character data from an external REST API
- `sqflite`: stores custom character records in a local SQLite database
- `path`: constructs a valid file path for the SQLite database
- `firebase_core`: initializes Firebase in Flutter
- `cloud_firestore`: performs Firestore read and write operations

### 3.2 Firebase Configuration

Firebase integration is handled through `lib/firebase_options.dart`, which contains platform-specific configuration values accessed through `DefaultFirebaseOptions.currentPlatform`. In a complete deployment workflow, these values are normally generated using the FlutterFire CLI. In the provided codebase, the initialization flow is already implemented and the Firestore service is designed to work immediately once valid Firebase project values are supplied.

[Insert Screenshot: Firebase Setup File]

This screenshot should show the `firebase_options.dart` configuration or the Firebase connection setup used in the project. Its purpose is to demonstrate that the application is structured to initialize Firebase in a platform-aware manner. It also supports the explanation that cloud features are isolated from the UI and prepared during application startup.

## 4. Local Data Persistence

Local persistence is implemented through the `LocalCharacterService` class in `lib/services/local_service.dart`. This service uses SQLite through the `sqflite` package and creates a database named `character_builder.db`. Inside that database, the application creates a table called `local_characters`, which stores the following fields:

- `id`
- `name`
- `type`
- `ability`
- `imageUrl`

These fields represent meaningful structured records rather than a trivial preference flag, which satisfies the assignment requirement that local storage should contain real application data. The decision to store custom characters locally is appropriate because these records represent the user’s own collection and should remain available even if the app is restarted or the device is temporarily offline.

The local database is initialized lazily. The `database` getter checks whether a database instance already exists; if not, it opens the database and creates the table through the `onCreate` callback. This approach improves efficiency because the database is prepared only when it is actually needed.

The service provides three core operations: `createCharacter`, `getCharacters`, and `deleteCharacter`. Together, these methods satisfy the assignment requirement for visible local create and delete actions. The use of a dedicated service class instead of direct SQL inside widgets improves separation of concerns and keeps the interface code focused on rendering and interaction.

[Insert Screenshot: Local Service File]

This screenshot should show the `LocalCharacterService` implementation, especially the database creation logic and CRUD methods. It proves that the project uses a real local persistence layer instead of temporary in-memory state. It also illustrates the separation between storage logic and presentation logic.

[Insert Screenshot: Local Data Example]

This screenshot should display the “My Wizards” screen with one or more saved records. It demonstrates that meaningful data is being stored locally and displayed back to the user in a readable format. If possible, the screenshot should include multiple cards so that the persistence feature is visually clear.

[Insert Screenshot: Local Data After Restart]

This screenshot should be taken after the app has been closed and reopened, while the previously saved local records are still visible. Its purpose is to prove persistence across app restarts, which is one of the core functional requirements of the assignment. This evidence is especially important because it distinguishes a true local database from temporary runtime memory.

## 5. Firebase and Firestore Integration

Cloud functionality is implemented through the `FirestoreService` class in `lib/services/firestore_service.dart`. This class is responsible for Firebase initialization, Firestore access, and cloud-specific error reporting. The service defines a collection named `custom_characters`, which stores user-created wizard data in the cloud.

Firestore was chosen because it is a practical and widely used NoSQL cloud database that integrates well with Flutter. It also supports real-time updates, which makes it appropriate for the “Shared Wizards” screen in this application. Instead of waiting for manual refresh only, the interface can subscribe to live Firestore snapshots and update automatically when new records appear.

The service is created asynchronously through the factory method `FirestoreService.create(...)`. This method attempts to initialize Firebase and returns a service object that contains either a usable `FirebaseFirestore` instance or an initialization error state. This is a strong design decision because it avoids application crashes during startup and allows the UI to degrade gracefully if Firebase is not yet configured properly.

Another important design choice is the explicit `isFirebaseReady` flag. The home screen uses this information to show a user-friendly message when Firebase is unavailable. This improves usability because the app communicates the problem clearly instead of failing silently.

[Insert Screenshot: Firestore Collection]

This screenshot should show the `custom_characters` collection in the Firebase Console with several documents stored in it. It confirms that cloud persistence is not only configured in code but also functioning in practice. The screenshot should make it clear that each document contains meaningful character-related fields.

[Insert Screenshot: Firestore Service File]

This screenshot should display the Firestore service class, especially the initialization method and collection access logic. It demonstrates that the cloud layer is separated from the widget tree and follows a service-based design. This supports the assignment requirement to avoid placing all Firestore code directly inside UI widgets.

## 6. Firestore Read and Write Operations

The application performs both write and read operations with Firestore. The write operation happens when the user creates a new wizard in the `CreateCharacterScreen`. After the form is validated, a `Character` object is created and passed to `CharacterRepository.saveCharacter(...)`. The repository first saves the character locally through `LocalCharacterService`, then attempts to upload the same record to Firestore through `FirestoreService.addCharacter(...)`.

This sequence is significant because it prioritizes local persistence. Even if Firestore upload fails, the user’s record is still preserved on the device. The repository then returns a `SaveCharacterResult` object that indicates whether the cloud upload succeeded. This is a thoughtful design decision because it separates the result of the local save from the result of the cloud upload and allows the interface to respond more precisely.

The Firestore write method adds a document to the `custom_characters` collection and also appends a `createdAt` field using `FieldValue.serverTimestamp()`. Adding a server timestamp is a best practice because it creates a reliable ordering field that is generated by the backend rather than the device clock.

Reading from Firestore is implemented through the `getCharacters()` method in `FirestoreService`. This method returns a `Stream<List<Character>>` built from Firestore snapshots. The data is ordered by `createdAt` in descending order so that newly added shared characters appear first. In the UI, the `CloudCharactersScreen` listens to this stream through a `StreamBuilder`, allowing records to be displayed reactively.

[Insert Screenshot: Successful Cloud Data Load]

This screenshot should show the “Shared Wizards” screen after one or more documents have been loaded successfully from Firestore. It proves that the application can retrieve and present cloud data in a user-visible way. Ideally, the screenshot should include multiple items to show that the stream is returning a list of real records.

## 7. Data Modeling and Architecture

The core data model in the application is the `Character` class defined in `lib/models/character.dart`. This model includes the fields `id`, `name`, `type`, `ability`, and `imageUrl`. It also contains `fromJson`, `toJson`, and `copyWith` methods. These methods reduce duplication and make it easier to map data between the REST API, SQLite, and Firestore.

The architecture of the project is intentionally layered:

- **Model layer**: represents structured application data through the `Character` class
- **Service layer**: handles infrastructure concerns such as API communication, SQLite storage, and Firestore operations
- **Repository layer**: coordinates multiple services and provides a single interface to the UI
- **Presentation layer**: contains screens and widgets responsible for rendering and user interaction

This structure reflects clean architecture principles, even though the project remains lightweight. The application does not implement an overly complex enterprise architecture, but it still separates concerns in a meaningful way. For a student project, this is an effective compromise between clarity and maintainability.

### 7.1 Models

The `Character` model is shared across all data sources. This consistency reduces conversion complexity and makes the data flow easier to understand. For example, API data is mapped into the same model used for SQLite records and Firestore documents.

### 7.2 Services

The application contains three service classes:

- `ApiService`: fetches Harry Potter characters from a REST endpoint
- `LocalCharacterService`: manages local SQLite persistence
- `FirestoreService`: manages Firebase initialization and Firestore operations

Each service has a single clear responsibility. This is good practice because it limits duplication and keeps infrastructure logic isolated from the interface.

### 7.3 Repository

The `CharacterRepository` acts as a coordinator between the UI and the underlying services. This is particularly valuable in the `saveCharacter` workflow because one user action triggers both local and cloud persistence. Centralizing this logic in the repository keeps screens simple and makes future extension easier.

### 7.4 Providers and State Ownership

The assignment prompt mentions models, services, and providers. In this project, a dedicated Provider package is not used. Instead, dependency injection is handled manually by creating the repository in `main.dart` and passing it into screens through constructors. State ownership is managed locally inside widgets using `StatefulWidget`, `FutureBuilder`, and `StreamBuilder`.

This approach is still valid for a project of this size because it keeps the dependency graph explicit and avoids unnecessary abstraction. If the project became larger, a Provider-based or Riverpod-based solution could reduce prop drilling and centralize state access further. However, for this assignment, the chosen method remains readable, correct, and proportionate to the app’s complexity.

## 8. Async State Management

Asynchronous state handling is a key strength of this project. Because the app depends on a remote API, a local database, and Firestore, it must handle loading, success, and error states clearly instead of assuming that data is always instantly available.

On the home screen, `FutureBuilder<List<Character>>` is used to load API data. While the request is pending, the UI shows a `CircularProgressIndicator`. If the request fails, the user sees a readable error message. If the request succeeds but no data is available, the user sees an empty-state message. This covers the required loading, success, and error states.

The “My Wizards” screen also uses `FutureBuilder<List<Character>>` to load local data asynchronously from SQLite. Even though local storage is faster than a cloud request, reading from a database is still asynchronous and should be handled properly. The screen shows loading feedback, error feedback, and an empty-state message when no local records exist.

The “Shared Wizards” screen uses `StreamBuilder<List<Character>>` instead of `FutureBuilder` because Firestore provides a live stream of document snapshots. This enables the app to react automatically when cloud data changes. Again, the screen handles waiting, success, error, and empty states in a user-friendly way.

The create screen adds another layer of asynchronous state handling. While a wizard is being saved, the save button is disabled and replaced with an inline progress indicator. After completion, the user receives feedback through a `SnackBar`. If cloud upload fails, the app still informs the user that the record was saved locally. This is a particularly strong example of resilient asynchronous UX because it acknowledges partial success instead of presenting the operation as a complete failure.

## 9. User Interface and App Flow

The UI is intentionally simple, readable, and logically structured. The app uses a `NavigationBar` with three destinations: `Characters`, `My Wizards`, and `Cloud`. This creates a clear separation between external content, personal local content, and shared cloud content.

The user flow is straightforward:

1. The user opens the app and sees Harry Potter characters loaded from the API.
2. The user can press the floating action button labeled “Create Wizard”.
3. The form screen collects the custom wizard’s name, house, and magic skill.
4. On save, the record is stored locally and then uploaded to Firestore.
5. The record appears in “My Wizards” because it is stored in SQLite.
6. The same record appears in “Shared Wizards” because it is also stored in Firestore.

This flow is easy to understand because each tab has a clear purpose. The home tab provides context and inspiration, the local tab represents personal saved content, and the cloud tab represents shared content.

The reusable `CharacterCard` widget contributes to UI consistency by displaying character records in the same visual format across multiple screens. This reduces duplication and keeps the presentation layer cleaner. The custom `AppScaffold` widget also helps standardize app bar and navigation behavior across screens.

[Insert Screenshot: Create Character Screen]

This screenshot should show the form used to create a custom wizard, including the text fields and house selection dropdown. It demonstrates the point at which user-generated data enters the application. It also supports the explanation of validation and asynchronous save behavior.

[Insert Screenshot: My Wizards Screen]

This screenshot should display the local records list, ideally with the delete button visible on at least one card. It shows that local data is presented clearly and that the user can perform an additional operation beyond creation. This directly supports the assignment’s local persistence requirements.

[Insert Screenshot: Shared Wizards Screen]

This screenshot should show records loaded from Firestore in the cloud section of the app. It confirms that shared cloud data is not hidden in the backend but is integrated into the user-facing interface. It also helps illustrate the distinction between local-only and cloud-backed sections of the application.

## 10. Integration of Local and Cloud Data

One of the most important goals of the assignment was to combine local persistence and Firestore meaningfully in the same application. This project achieves that integration through a single save workflow coordinated by the repository layer.

When a user creates a custom wizard, the application does not treat local and cloud storage as two unrelated actions. Instead, the app first saves the record locally so that it becomes part of the user’s personal collection. It then attempts to upload the same record to Firestore so that it becomes part of the shared cloud collection. This means one user action contributes to two different features:

- local ownership and persistence in “My Wizards”
- shared cloud visibility in “Shared Wizards”

This design was chosen because it balances reliability and functionality. Local storage is prioritized so the user does not lose work if the network or Firebase configuration fails. Cloud upload is then treated as an additional synchronization step. This order improves robustness and user trust.

The app also distinguishes the role of each data source clearly. The REST API provides external reference content, SQLite preserves the user’s own records on the device, and Firestore supports cloud-based sharing. Because each source has a separate purpose, the combination feels intentional rather than forced.

## 11. Code Structure

The codebase is organized into logical folders, which supports readability and maintainability:

- `lib/models`: contains the `Character` data model
- `lib/services`: contains `ApiService`, `LocalCharacterService`, and `FirestoreService`
- `lib/repositories`: contains `CharacterRepository`
- `lib/screens`: contains the main screens for navigation and feature presentation
- `lib/widgets`: contains reusable interface components such as `AppScaffold` and `CharacterCard`
- `lib/main.dart`: initializes services and launches the application

This structure follows the assignment requirement to avoid placing the entire app into a single long file. More importantly, it reflects software engineering best practices. Each folder has a distinct purpose, which makes the project easier to navigate and easier to scale.

The code also demonstrates several good practices:

- clear class naming
- constructor-based dependency injection
- separation of UI and data logic
- reusable widgets for consistent presentation
- dedicated model mapping methods
- explicit async error handling

The overall project remains simple enough for academic submission, but it also shows an awareness of maintainable software design principles rather than only aiming for minimal functionality.

## 12. Conclusion

In conclusion, this Flutter project successfully demonstrates the key learning objectives of the assignment: local data persistence, Firebase Cloud Firestore integration, asynchronous state handling, and clean code organization. The application stores meaningful records locally using SQLite, retrieves and displays shared records from Firestore, and combines both storage mechanisms within one clear user flow.

The project is also strong from a design perspective because it explains not only what features were implemented, but why they were structured in this way. Local storage was used to guarantee persistence and resilience, Firestore was used to provide shared cloud access and live updates, and the repository-service-model structure was used to keep responsibilities separate and the codebase maintainable.

Although the app is compact, it reflects sound cross-platform development practice. It uses real asynchronous data sources, presents meaningful content, handles failures gracefully, and organizes code in a way that supports future extension. For these reasons, the project satisfies the assignment requirements and provides a solid demonstration of how Flutter can integrate local and cloud persistence in one coherent application.
