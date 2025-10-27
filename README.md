# todo_app

A Flutter TODO application by TajutechGh.

## Repository
- Remote: https://github.com/tajutechgh/todo_app.git
- Branch: `main`

## Key files and folders
- `lib/` — Flutter application source (Dart).
- `pubspec.yaml` — Dart/Flutter dependencies.
- `android/` — Android platform code (Kotlin/Java, Gradle).
- `ios/` — iOS platform code (Swift/Obj-C).
- `README.md` — This file.

## Requirements
- macOS (development machine)
- Flutter SDK (stable)
- Dart SDK (bundled with Flutter)
- Xcode (for iOS builds)
- Android SDK / Android Studio (for Android builds)
- CocoaPods (for iOS native deps)

## Setup
1. Clone the repo:
    - `git clone https://github.com/tajutechgh/todo_app.git`
    - `cd todo_app`
2. Install Dart/Flutter deps:
    - `flutter pub get`
3. iOS setup (macOS):
    - `cd ios && pod install && cd ..`
4. Run on a connected device or simulator:
    - `flutter run`

## Build
- Android release: `flutter build apk --release`
- iOS release: `flutter build ipa` (requires Xcode signing)

## Tests
- Run unit/widget tests: `flutter test`

## Notes
- Native modules may include Kotlin/Java for Android and Swift/Obj-C for iOS.
- If native C++ code is present, ensure proper NDK/Gradle configuration for Android builds.
- Use `flutter doctor` to diagnose environment issues.

## Contributing
- Fork, create a feature branch, make changes, add tests, and open a PR against `main`.

## License
- License @TajutechGh