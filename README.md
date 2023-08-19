# Fitness App

<div style="display: flex; align-items: center;">
    <img style="margin-right: 20px;" src="frontend/res/logo/foreground.png" alt="Image" width="128" height="128" />
    <p> The Fitness App is a mobile application built to help users track their fitness goals, plan workouts, and maintain a healthy lifestyle. The app has been developed using the Flutter framework for the frontend and Firebase for the backend. This README provides an overview of the project structure, setup instructions, and key features of the app. </p>
</div>

## Table of Contents

- [Project Overview](#project-overview)
- [Features](#features)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Project Overview

The Fitness App is designed to provide users with an intuitive interface for managing their fitness routines. It allows users to create and customize workout plans, track their progress, and access a library of exercises. The app's frontend is developed using Flutter, a popular open-source UI framework, to ensure a consistent and responsive user experience. The backend is powered by Firebase, which provides real-time data synchronization and authentication services.

## Features

- User registration and authentication
- Personalized user profiles
- Create and manage custom workout plans
- Explore a wide range of exercise options
- Track workout history and progress
- Real-time data synchronization
- User-friendly and visually appealing design

## Project Structure

The project is structured in the following way:

```
fitnessapp/
|-- backend/
|   |--firestore/
|   |--functions/
|   |--playground/
|   |--scripts/
|   |--storage/
|   |--.firebaserc
|   |--docker-compose.yml
|   |--Dockerfile
|   |--firebase.json
|   |--serviceAccountKey.json
|-- frontend/
|   |-- android/
|   |-- ios/
|   |-- lib/
|   |   |-- models/
|   |   |-- screens/
|   |   |-- widgets/
|   |-- res/
|   |-- pubspec.yaml
|   |-- README.md
```

- **android/** and **ios/**: Native code and configuration for Android and iOS platforms.
- **lib/models/**: Contains data models used throughout the app.
- **lib/screens/**: Holds different app screens and their corresponding UI logic.
- **lib/widgets/**: Custom widgets used to build UI components.
- **assets/**: Stores static assets like images and fonts.
- **pubspec.yaml**: Configuration file for Flutter dependencies and assets.
- **README.md**: This README file.

## Getting Started

Follow these steps to get the Fitness App up and running on your local machine.

### Prerequisites

- Flutter: Make sure you have Flutter installed. You can download it from [here](https://flutter.dev/docs/get-started/install).
- Firebase Account: You need a Firebase account to set up the backend. Create one at [Firebase Console](https://console.firebase.google.com/).

### Installation

1. Clone this repository:

   ```bash
   git clone https://github.com/yourusername/fitnessapp.git
   ```

2. Navigate to the project directory:

   ```bash
   cd fitnessapp
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

## Configuration

1. Firebase Setup:
   - Create a new Firebase project in the [Firebase Console](https://console.firebase.google.com/).
   - Follow the instructions to add your Flutter app to the Firebase project.
   - Download the `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) configuration files and place them in the respective platform folders.

2. Firebase Authentication:
   - Enable the authentication methods you want to use (e.g., Email/Password, Google Sign-In) in the Firebase Console.

## Usage

1. Launch the app on an emulator or physical device:

   ```bash
   flutter run
   ```

2. Sign up or log in using the authentication methods you configured in Firebase.

3. Explore the app, create workout plans, and start tracking your fitness journey!

## Contributing

We welcome contributions to the Fitness App project. Feel free to open issues and pull requests for bug fixes, features, or improvements.

## License

This project is licensed under the [MIT License](LICENSE).

---

Feel free to customize this README according to your project's specific details and branding. Good luck with your Fitness App development!
