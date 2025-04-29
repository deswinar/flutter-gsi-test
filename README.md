# Keanggotaan App

This project is a Flutter-based mobile application following **Feature-Driven Development** with a **clean architecture** and a consistent **Atomic Design pattern** for UI components.

---

## 📦 Project Structure

```
lib/
├── core/                   # Core services, API clients, network info
├── features/               # Feature-driven modules
│   ├── auth/               # Authentication (login, register, etc.)
│   ├── identity/           # Identity-related logic (eKTP, address, etc.)
│   └── profile/            # User profile logic
├── shared/                 # Shared resources across features
│   └── widgets/            # UI components using Atomic Design
│       ├── atoms/          # Basic UI elements (buttons, text fields, icons)
│       ├── molecules/      # Grouped atoms (e.g. labeled form field)
│       ├── organisms/      # More complex combinations (e.g. forms)
│       └── templates/      # Page-level layout structures
├── bootstrap.dart          # Entry point logic shared across flavors
├── main_development.dart  # Entry point for development flavor
├── main_staging.dart      # Entry point for staging flavor
└── main_production.dart   # Entry point for production flavor
```

---

## 🚀 Technologies Used

- **Dio**: For making HTTP requests.
- **GoRouter**: Declarative routing and navigation.
- **Dartz**: Functional programming utilities including `Either` type for error handling.
- **Injectable** + **GetIt**: For dependency injection and service location.
- **Bloc (Cubit)**: Lightweight state management using Cubit from `flutter_bloc`.

---

## 🧩 Architecture Overview

The application embraces **modular feature-first development**. Each feature (such as `auth`, `identity`, and `profile`) is self-contained and handles its own:

- Presentation logic (screens/pages)
- Business logic (cubits)
- Data sources (local/remote)
- Models/entities

### UI: Atomic Design System
All widgets are designed using the Atomic Design principle:

- **Atoms**: Basic building blocks like `PrimaryButton`, `CustomTextField`.
- **Molecules**: Groups of atoms such as `DropdownField` with label and icon.
- **Organisms**: Complex reusable parts like login forms or profile sections.
- **Templates**: Define page-level layout structures and arrangements.
- **Pages**: Combine templates and logic specific to a single screen.

This hierarchy encourages **reuse**, **readability**, and **scalability**.

---

## 🧪 Flavors Setup

The app supports multiple environments through **Flavors**:

- `main_development.dart`
- `main_staging.dart`
- `main_production.dart`

All entry points delegate to `bootstrap.dart`, which handles initialization and configuration per environment.

---

## 📂 Shared Layer

The `shared/` folder contains:
- Common UI components (using Atomic Design)
- Constants and themes
- Utility extensions/helpers

---

## 🔧 Getting Started

To run with a specific flavor:
```bash
flutter run -t lib/main_development.dart
flutter run -t lib/main_staging.dart
flutter run -t lib/main_production.dart
```

---

## 🧼 Dependency Injection

Using `injectable` and `get_it`:
- Configure dependencies in `injection.dart`
- Use `@injectable` and `@LazySingleton` annotations in services
- Generate dependencies with:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 📡 Network

- All network calls go through `core/network/` using **Dio**.
- `NetworkInfo` checks for connectivity before requests.

---

## 📘 Features Summary

- **Auth**: Login, Register, Forgot Password
- **Identity**: KTP input, photo upload, address update
- **Profile**: Edit full name, gender, status

---