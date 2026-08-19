# CIWYWT

A private, cross-platform mobile decision assistant application built with Flutter, designed for two predefined users to collaboratively manage suggestions, make decisions, and keep track of their history.

## 🌟 Features

*   **Private & Secure Access**: Firebase Authentication with Google Sign-In, utilizing strict email validation to restrict access only to two predefined users.
*   **Real-Time Data Sync**: Instantaneous updates and synchronization of suggestions and picks across devices using Cloud Firestore.
*   **"Pick for Us" Engine**: Core decision-making feature to select options from user-provided suggestions.
*   **History Tracking**: Maintains a complete, synchronized history of past decisions.
*   **Premium UI/UX**: Clean, highly responsive user interface with fluid micro-animations powered by `flutter_animate`.
*   **Robust Architecture**: Scalable, feature-first clean architecture approach combined with `Riverpod` for state management.

## 🛠 Tech Stack

*   **Framework**: [Flutter](https://flutter.dev/)
*   **State Management**: [Riverpod](https://riverpod.dev/) (`flutter_riverpod`)
*   **Backend & Infrastructure**: [Firebase](https://firebase.google.com/)
    *   Authentication (`firebase_auth`, `google_sign_in`)
    *   Database (`cloud_firestore`, `firebase_core`)
*   **UI/Styling**: 
    *   Typography: `google_fonts`
    *   Animations: `flutter_animate`
    *   Localization/Formatting: `intl`

## 📁 Project Structure

The project follows a clean, feature-driven architectural pattern to ensure scalability and separation of concerns:

```text
lib/
├── core/               # Shared utilities, themes, constants, and extensions
├── data/               # Repositories, data models, and Firebase data sources
├── domain/             # Core business logic and entities
├── presentation/       # UI layer
│   ├── screens/        # Main application screens (e.g., HomeScreen)
│   ├── widgets/        # Reusable UI components
│   └── controllers/    # Riverpod state providers/controllers
└── main.dart           # Application entry point & Firebase initialization
```

## 🚀 Getting Started

### Prerequisites

*   [Flutter SDK](https://docs.flutter.dev/get-started/install) (version ^3.11.4)
*   An IDE like VS Code or Android Studio with Flutter/Dart plugins installed.
*   A configured Firebase project with Authentication (Google Sign-In) and Firestore enabled.

### Installation

1.  **Clone the repository**
    ```bash
    git clone <repository_url>
    cd CIWYWT
    ```

   2.  **Install dependencies**
       ```bash
       flutter pub get
       ```

3.  **Configure Firebase**
    Make sure your environment contains the necessary Firebase configuration files:
    *   `google-services.json` (Android: `android/app/`)
    *   `GoogleService-Info.plist` (iOS: `ios/Runner/`)
    *   Verify `firebase.json` and `firestore.rules` are set up according to your environment.

4.  **Run the application**
    ```bash
    flutter run
    ```

## 🧪 Development & Testing

*   **Code Quality**: This project uses `flutter_lints` to enforce Dart best practices.
*   **Testing**: Run the test suite with:
    ```bash
    flutter test
    ```
