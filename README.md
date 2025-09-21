# Paystack Transaction App

A mobile application built with Flutter that integrates with the Paystack payment gateway to initialize transactions. The project follows the Clean Architecture principles and uses the BLoC pattern for state management.

## Features

- Initialize a Paystack transaction.
- Clear and well-structured project architecture.
- Separation of concerns between UI, business logic, and data layers.
- Dependency injection with `get_it`.
- State management with `flutter_bloc`.

## Project Structure

The project is divided into two main parts: a `frontend` application built with Flutter and a `backend` server built with Node.js and Express.

### Frontend

The Flutter application follows a feature-based structure, with each feature organized into three layers:

- **Domain:** Contains the core business logic, including entities, use cases, and repository interfaces.
- **Data:** Implements the repository interfaces and handles data fetching from the backend.
- **Presentation:** Contains the UI (pages) and state management (BLoC).

```
frontend/lib/
├── core/
│   ├── common/
│   ├── error/
│   ├── injector/
│   └── network/
└── features/
    └── intialize_payment/
        ├── data/
        │   ├── datasource/
        │   ├── model/
        │   └── repository/
        ├── domain/
        │   ├── entity/
        │   ├── repository/
        │   └── usecase/
        └── presentation/
            ├── bloc/
            └── page/
```

### Backend

The backend is a simple Node.js application using Express.js. It has a single endpoint to initialize a Paystack transaction.

```
backend/
├── index.js
├── package.json
└── .env
```

## Architecture & Design Patterns

- **Clean Architecture:** The project is structured into `data`, `domain`, and `presentation` layers, promoting a separation of concerns and making the codebase more maintainable and testable.
- **BLoC Pattern:** The `flutter_bloc` package is used for state management, which helps to separate the UI from the business logic and manage the state of the application in a predictable way.
- **Dependency Injection:** The `get_it` package is used as a service locator to inject dependencies into different parts of the application, which improves modularity and testability.
- **Repository Pattern:** The repository pattern is used to abstract the data sources, so the domain layer is independent of the data layer.

## Setup & Installation Instructions

### Backend

1.  Navigate to the `backend` directory:
    ```bash
    cd backend
    ```
2.  Install the dependencies:
    ```bash
    npm install
    ```
3.  Create a `.env` file in the `backend` directory and add your Paystack secret key:
    ```
    PAYSTACK_SECRET_KEY=your_paystack_secret_key
    ```
4.  Start the server:
    ```bash
    npm run dev
    ```

### Frontend

1.  Navigate to the `frontend` directory:
    ```bash
    cd frontend
    ```
2.  Install the dependencies:
    ```bash
    flutter pub get
    ```
3.  Run the code generator:
    ```bash
    flutter pub run build_runner build
    ```
4.  Run the application:
    ```bash
    flutter run
    ```

## Code Quality & Observations

The project is well-structured and follows the best practices of Clean Architecture. The use of `flutter_bloc` for state management and `get_it` for dependency injection makes the code clean, readable, and maintainable. The feature-based project structure is also a good choice for scalability.

## Rating

- **Architecture:** 9/10
- **Code Quality:** 8/10
- **Maintainability:** 9/10

**Overall Rating:** 8.7/10
