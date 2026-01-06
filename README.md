# Freshflow App

A Flutter starter project created via `flutter create freshflow_app`.

## Prerequisites
- Flutter SDK (stable) installed and on PATH
- Xcode (for iOS) with command line tools
- Android Studio + Android SDK (for Android)

## Quick Start
```bash
cd freshflow_app
flutter run
```

## Platform Tips
- iOS: Ensure a simulator is open (or connect a device). If signing issues occur, open `ios/Runner.xcworkspace` in Xcode and set your team.
- Android: Install Android SDK via Android Studio. Then configure SDK path if needed:
```bash
flutter config --android-sdk "$HOME/Library/Android/sdk"
flutter doctor
```

## Project Structure
- `lib/main.dart`: Entry point with a basic counter app
- `pubspec.yaml`: Dependencies and assets configuration

## Next Steps
- Rename app, package ids, icons
- Add state management (e.g., Provider, Riverpod)
- Set up flavors (dev/staging/prod)
