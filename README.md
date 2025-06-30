# 📱 Pocket Tasks

A beautifully designed Flutter task management app with sorting, filtering, light/dark theme, local storage using Hive, and animations.

## ✨ Features

- 📝 Add, edit, delete tasks
- 📆 Set due dates
- ✅ Mark tasks as completed
- 🔍 Filter by status (All / Active / Completed)
- 📊 Sort by creation or due date
- 🌗 Light & dark theme toggle
- 💾 Local storage with Hive
- 💡 Riverpod for state management
- 🎨 Responsive, clean UI

## 📸 Screenshots

| Light Mode | Dark Mode |
|------------|-----------|
| ![Light](pocket_tasks/screenshots/light_mode.jpeg) | ![Dark](pocket_tasks/screenshots/dark_mode.jpeg) |

## 📽️ Demo

<!-- Upload your demo video (e.g., `demo.mp4`) to the repo or a hosting service -->

If you have a demo video:

```html
<video src="/pocket_tasks/demo.mp4" width="100%" controls></video>
```

Or link from YouTube or Google Drive:

- [Watch on YouTube](https://youtu.be/your-video-id)
- [Download from Google Drive](https://drive.google.com/file/d/your-id/view)

## 🚀 Getting Started

### Prerequisites
- Flutter SDK
- Dart SDK

### Run the App
```bash
flutter pub get
flutter run
```

### Run Tests
```bash
flutter test
```

## 📦 APK Location
The built APK can be found at:
```
build/app/outputs/flutter-apk/app-release.apk
```

## 📂 Project Structure
```bash
lib/
├── main.dart
├── features/
│   └── task/
│       ├── domain/
│       ├── provider/
│       └── presentation/
│           ├── pages/
│           └── widgets/
```

## 📚 Packages Used
- flutter_riverpod
- hive & hive_flutter
- uuid
- intl

## 🧪 Testing
Unit and widget tests included in the `test/` directory:
```
test/
├── unit/
│   └── task_model_test.dart
├── widget/
│   ├── add_task_page_test.dart
│   ├── task_list_filter_test.dart
│   └── widget_test.dart
```

## 👨🏽‍💻 Author
**Etim Essang**  
Flutter Developer

## 📄 License
MIT
