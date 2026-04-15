# 📱 UniSphere — Flutter

A modern, feature-rich **university campus management app** built with Flutter. Designed with a premium UI/UX featuring glassmorphism, smooth animations, dark mode support, and a cohesive design system.

> ✅ **Status**: Complete & Production Ready

---

## 🎨 Design System

| Element | Value |
| --- | --- |
| Primary Color | #63003C (Deep Plum/Maroon) |
| Primary Light | #8B1A5E |
| Primary Dark | #3E0026 |
| Font Family | Inter (Sans-serif) |
| Border Radius | 14–24px (generous rounding) |
| Shadows | Soft, subtle drop shadows |
| Theme | Light + Dark mode with toggle |

---

## ✨ Features

### 🔐 Authentication

- **Sign In** — Email/password with validation, social login (Google, Apple)
- **Sign Up** — Full registration with confirm password, terms checkbox
- **Glassmorphism** cards with backdrop blur
- **Floating animated shapes** background
- **3D press-effect** buttons with gradient
- **Dark mode toggle** on auth screens

### 🏠 Home Screen

- **Category cards** — Horizontal scrollable with images (Computer Science, Mathematics, etc.)
- **Today's Classes** — Quick view with time, location, teacher
- **News tab** — Tap any card → **draggable bottom sheet** with full article, source, date badge, Share & Read buttons
- **Events tab** — Tap any card → **bottom sheet** with hero image, date/location/organizer meta rows, Register CTA

### 📚 Courses

- **Searchable course list** with staggered animations
- Tap any course → **Course Detail Page** with:
    - Progress bar + percentage
    - Stats pills (Lessons, Duration, Credits)
    - Instructor card with email icon
    - Numbered **Syllabus** with status icons (✅ completed, ▶️ current, 🔒 locked)
    - Downloadable **Resources** section
    - "Continue Learning" / "Start Course" CTA

### 📅 Schedule

- **Week day selector** with animated date highlight
- **Color-coded schedule cards** (green, yellow, gray)
- Tap any card → **Class Details bottom sheet** with colored banner, time/room/instructor, Join Class CTA

### 📊 Result / Grades

- **Grades: Final Grades** header with dropdown filter (Final Grades, Midterm, Quizzes)
- **Overall CGPA** + **Credits earned** display
- **Semester dropdown** filter
- Grade cards with color-coded badges (A+ primary, F red)

### 👤 Profile

- **Avatar** with plum border
- **Stats row** — Credits, GPA, Year student
- **Statistics card** — Attendance 90%, Task & Work 70%, Quiz 85% with Mark Attend button
- **Dashboard** → Setting, Achievement, Privacy (with navigation)

### 📍 Location

- **Interactive map** showing campus locations
- **Campus landmarks** and facilities with detailed information
- **Real-time navigation** to discover campus buildings and services
- **Location-based notifications** for nearby events and classes

### ⚙️ Settings

- **Profile edit** — Editable avatar with camera badge, name & email input fields
- **Preferences** — Push Notifications, Email Notifications, Dark Mode toggles
- **Security** — Change Password, Biometric Login, Active Sessions
- **About** — App Version, Terms of Service, Log Out
- **Save Changes** CTA button

### 🔒 Privacy

- **Visibility** — Profile Visible, Show Email, Activity Status toggles
- **Data & Storage** — Data Sharing toggle, Download My Data, Clear Cache
- **Danger Zone** — Deactivate Account, Delete Account (red-bordered card)

### 🔔 Notifications

- **Bell icon** with unread badge counter (primary color, "9+" cap)
- **Pop-out panel** positioned below bell with:
    - "Notifications" header + "3 new" badge + "Mark all read"
    - Type-colored icons (🟢 schedule, 🟣 announcement, 🟠 assignment, 🔵 system)
    - Unread dot indicator + tinted background
    - Relative timestamps ("5 min ago", "2h ago")
    - "View all notifications" footer link
    - Empty state with icon

### 🌙 Dark Mode

- **Global toggle** available on every screen (moon/sun icon beside notification bell)
- All screens, cards, modals, and bottom sheets fully adapt
- Smooth instant theme switch via `onToggleTheme` callback from `main.dart`

### 🧭 Navigation

- **Bottom navigation bar** — Home, Courses, Schedule, Result, Profile
- **Centralized `nav_helper.dart`** — handles navigation from any screen to any screen
- Clean nav stack: always `Home → Screen` (pops to Home first, then pushes)

---

## 📁 Project Structure

```jsx
lib/
├── main.dart
├── theme/
│   └── app_theme.dart
├── helpers/
│   ├── nav_helper.dart
│   ├── notification_data.dart
│   └── course_detail_data.dart
├── models/
│   ├── category_model.dart
│   ├── class_model.dart
│   ├── news_model.dart
│   ├── event_model.dart
│   ├── course_model.dart
│   ├── course_detail_model.dart
│   ├── schedule_model.dart
│   ├── grade_model.dart
│   └── notification_model.dart
├── widgets/
│   ├── glass_card.dart
│   ├── custom_input.dart
│   ├── primary_button.dart
│   ├── social_button.dart
│   ├── floating_shapes.dart
│   ├── category_card.dart
│   ├── class_card.dart
│   ├── news_card.dart
│   ├── news_detail_sheet.dart
│   ├── event_card.dart
│   ├── event_detail_sheet.dart
│   ├── schedule_detail_sheet.dart
│   ├── bottom_nav_bar.dart
│   ├── notification_bell.dart
│   └── notification_panel.dart
├── screens/
│   ├── sign_in_screen.dart
│   ├── sign_up_screen.dart
│   ├── home_screen.dart
│   ├── courses_screen.dart
│   ├── course_detail_screen.dart
│   ├── schedule_screen.dart
│   ├── result_screen.dart
│   ├── profile_screen.dart
│   ├── settings_screen.dart
│   └── privacy_screen.dart
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.10+ installed
- Dart 3.0+
- Android Studio / VS Code with Flutter extensions

### Installation

```jsx
# Clone the repository
git clone https://github.com/your-username/campus-app.git
cd campus-app

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Optional: Add Inter Font

Add `google_fonts` to `pubspec.yaml` for the Inter font family:

```jsx
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.1.0
```

---

## 📱 Screens Overview

| Screen | Description | Nav Index |
| --- | --- | --- |
| Sign In | Email/password login with social auth | — |
| Sign Up | Registration with validation | — |
| Home | Categories, classes, news, events | 0 |
| Courses | Searchable course list | 1 |
| Course Detail | Syllabus, progress, resources | — |
| Schedule | Weekly calendar with class cards | 2 |
| Result | Grades with CGPA and filters | 3 |
| Profile | Stats, attendance, dashboard | 4 |
| Settings | Profile edit, preferences, security | — |
| Privacy | Visibility, data, danger zone | — |

---

## 🛠 Tech Stack

| Technology | Purpose |
| --- | --- |
| Flutter 3.10+ | Cross-platform UI framework |
| Dart 3.0+ | Programming language |
| Material 3 | Design components |
| Custom Widgets | Reusable UI component library |

---

## 🎯 Architecture Highlights

- **No external state management** — Uses `StatefulWidget` + callbacks for simplicity
- **Theme toggle** via `onToggleTheme` callback from root `MyApp` → all screens
- **Centralized navigation** via `helpers/nav_helper.dart` — handles all 5 tabs + popUntil logic
- **Reusable components** — `NotificationBell`, `BottomNavBar`, `GlassCard`, `PrimaryButton`, etc.
- **Bottom sheets** for News, Events, and Schedule details — consistent `DraggableScrollableSheet` pattern
- **Full dark mode** — Every screen, card, modal, and bottom sheet adapts

---

## 📄 License

This project is for educational purposes. Feel free to use and modify for your own projects.

---

## 👨‍💻 Author

**Abdelilah Wail NEDJAR**

- University of Constantine 2
- Built with ❤️ and Flutter
