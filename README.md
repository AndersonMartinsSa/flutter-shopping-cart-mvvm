# Flutter Shopping Cart MVVM

This project demonstrates a shopping cart application built with Flutter using the MVVM (Model-View-ViewModel) architectural pattern.

## Requirements

*   **Flutter SDK**: ^3.0.0 or higher
*   **Dart SDK**: ^2.17.0 or higher

To check your Flutter and Dart versions, run:
```bash
flutter --version
```

## Getting Started

Follow these instructions to get the project up and running on your local machine.

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/AndersonMartinsSa/flutter-shopping-cart-mvvm.git
    cd flutter-shopping-cart-mvvm
    ```
2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Run the application:**
    ```bash
    flutter run
    ```
    This will launch the application on an available device or emulator.

### Build Instructions

To build the application for a specific platform, use the following commands:

*   **Android:**
    ```bash
    flutter build apk
    # or for a release build
    flutter build appbundle
    ```
*   **iOS:**
    ```bash
    flutter build ios
    ```
*   **Web:**
    ```bash
    flutter build web
    ```

## Project Structure

The project follows the MVVM architectural pattern, with a clear separation of concerns:

*   `lib/data`: Contains data models, repositories, and service integrations.
*   `lib/domain`: Defines entities, exceptions, abstract repositories, and business logic (stores).
*   `lib/ui`: Holds the user interface components (pages, widgets) and their corresponding ViewModels.
*   `lib/config`: Dependency injection setup.
*   `lib/routing`: Application navigation.
*   `lib/utils`: Utility functions and classes.

## Key Architectural Patterns and Libraries

### Standard Flutter Navigation

This project utilizes Flutter's standard `Navigator` for handling page transitions and managing the navigation stack. The `AppRouter` class (in `lib/routing/app_router.dart`) centralizes route definitions and logic, making navigation predictable and easy to manage.

### Provider for State Management

`Provider` is used as the primary state management solution. It allows for efficient and simple dependency injection and state exposure to the widget tree. `ChangeNotifierProvider` is extensively used to expose `ViewModel` instances to the UI, enabling widgets to react to state changes.

### Command Pattern

The Command pattern is implemented to encapsulate actions or operations as objects. This is particularly useful for decoupling the UI from the business logic, allowing for more flexible and testable code. You'll find `Command` implementations in `lib/utils/command.dart` and used within ViewModels to trigger specific actions.

### Result Pattern

To handle operations that can either succeed with a value or fail with an error, the Result pattern is employed. This pattern provides a clear and functional way to represent outcomes, improving error handling and readability. The `Result` class (in `lib/utils/result.dart`) helps in propagating success or failure states throughout the application.

## Running Tests

To execute all unit and widget tests, use the Flutter test command:

```bash
flutter test
```

This command will run all tests located in the `test/` directory.

## Commit Guidelines

This project follows the Conventional Commits specification. Please adhere to the following types:

*   `feat`: A new feature
*   `fix`: A bug fix
*   `docs`: Documentation only changes
*   `style`: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
*   `refactor`: A code change that neither fixes a bug nor adds a feature
*   `perf`: A code change that improves performance
*   `test`: Adding missing tests or correcting existing tests
*   `build`: Changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)
*   `ci`: Changes to our CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)
*   `chore`: Other changes that don't modify src or test files
*   `revert`: Reverts a previous commit